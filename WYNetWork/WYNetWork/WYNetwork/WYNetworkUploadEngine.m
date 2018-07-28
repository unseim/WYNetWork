//
//  WYNetworkUploadManager.m
//  WYNetWork
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "WYNetworkUploadEngine.h"
#import "WYNetworkRequestPool.h"
#import "WYNetworkConfig.h"
#import "WYNetworkUtils.h"
#import "WYNetworkProtocol.h"
#import "WYImageScaleTool.h"

@interface WYNetworkUploadEngine()<WYNetworkProtocol>

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation WYNetworkUploadEngine
{
     BOOL _isDebugMode;
}

#pragma mark- ============== Life Cycle ==============


- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        //debug mode or not
        _isDebugMode = [WYNetworkConfig sharedConfig].debugMode;
        
        //AFSessionManager config
        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        //RequestSerializer
        _sessionManager.requestSerializer.allowsCellularAccess = YES;
        
        _sessionManager.requestSerializer.timeoutInterval = [WYNetworkConfig sharedConfig].timeoutSeconds;
        

        //securityPolicy
        _sessionManager.securityPolicy = [AFSecurityPolicy defaultPolicy];
        [_sessionManager.securityPolicy setAllowInvalidCertificates:YES];
        _sessionManager.securityPolicy.validatesDomainName = NO;
        
        //ResponseSerializer
        _sessionManager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/xml", @"text/plain", @"application/javascript", @"image/*", nil];
        
        //Queue
        _sessionManager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _sessionManager.operationQueue.maxConcurrentOperationCount = 5;
        
        
    }
    return self;
}


#pragma mark- ============== Public Methods ==============

- (void)sendUploadImagesRequest:(WYRequestSerializer)serializer
                            url:(NSString * _Nonnull)url
                  ignoreBaseUrl:(BOOL)ignoreBaseUrl
                     parameters:(id _Nullable)parameters
                         images:(NSArray<UIImage *> * _Nonnull)images
                   compressSize:(float)compressSize
                   compressType:(WYUploadCompressType)compressType
                           name:(NSString * _Nonnull)name
                       mimeType:(NSString * _Nullable)mimeType
                       progress:(WYUploadProgressBlock _Nullable)uploadProgressBlock
                        success:(WYUploadSuccessBlock _Nullable)uploadSuccessBlock
                        failure:(WYUploadFailureBlock _Nullable)uploadFailureBlock{
    
    //if images count equals 0, then return
    if ([images count] == 0) {
        WYNetworkLog(@"=========== Upload image failed:There is no image to upload!");
        return;
    }

    if (serializer == WYJSONRequestSerializer)
    {
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
    } else if (serializer == WYHTTPRequestSerializer)
    {
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
    } else if (serializer == WYJSONHTTPRequestSerializer)
    {
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
    } else {
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    //default method is POST
    NSString *methodStr = @"POST";
    
    //generate full request url
    NSString *completeUrlStr = nil;
    
    //generate a unique identifer of a spectific request
    NSString *requestIdentifer = nil;
    
    if (ignoreBaseUrl) {
        
        completeUrlStr = (NSString *)
        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  (CFStringRef)url,
                                                                  (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                  NULL,
                                                                  kCFStringEncodingUTF8));
        requestIdentifer = [WYNetworkUtils generateRequestIdentiferWithBaseUrlStr:nil
                                                                   requestUrlStr:url
                                                                       methodStr:methodStr
                                                                      parameters:parameters];
    }else{
        
        NSString *encodingUrlString = (NSString *)
        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  (CFStringRef)url,
                                                                  (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                  NULL,
                                                                  kCFStringEncodingUTF8));
        completeUrlStr   = [[WYNetworkConfig sharedConfig].baseUrl stringByAppendingPathComponent:encodingUrlString];
        requestIdentifer = [WYNetworkUtils generateRequestIdentiferWithBaseUrlStr:[WYNetworkConfig sharedConfig].baseUrl
                                                                   requestUrlStr:url
                                                                       methodStr:methodStr
                                                                      parameters:parameters];
    }
    
    //add custom headers
    [self addCustomHeaders];
    
    //add default parameters
    NSDictionary * completeParameters = [self addDefaultParametersWithCustomParameters:parameters];
    
    //create corresponding request model and send request with it
    WYNetworkRequestModel *requestModel = [[WYNetworkRequestModel alloc] init];
    requestModel.requestUrl = completeUrlStr;
    requestModel.uploadUrl = url;
    requestModel.method = methodStr;
    requestModel.parameters = completeParameters;
    requestModel.uploadImages = images;
    requestModel.imageCompressSize = compressSize;
    requestModel.compressType = compressType;
    requestModel.imagesIdentifer = name;
    requestModel.mimeType = mimeType;
    requestModel.requestIdentifer = requestIdentifer;
    requestModel.uploadSuccessBlock = uploadSuccessBlock;
    requestModel.uploadProgressBlock = uploadProgressBlock;
    requestModel.uploadFailedBlock = uploadFailureBlock;
    
    [self p_sendUploadImagesRequestWithRequestModel:requestModel];
}



#pragma mark- ============== Private Methods ==============

- (void)p_sendUploadImagesRequestWithRequestModel:(WYNetworkRequestModel *)requestModel{
    
    
    if (_isDebugMode) {
        WYNetworkLog(@"=========== Start upload request with url:%@...",requestModel.requestUrl);
    }
    
    __weak __typeof(self) weakSelf = self;
    NSURLSessionDataTask *uploadTask = [_sessionManager POST:requestModel.requestUrl
                                                  parameters:requestModel.parameters
                                   constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                                       
                                       
                                       [requestModel.uploadImages enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
                                           
                                           //image data
                                           NSData *imageData = nil;
                                           
                                           //image type
                                           NSString *imageType = nil;
                                           
                                           if ([requestModel.mimeType isEqualToString:@"png"] || [requestModel.mimeType isEqualToString:@"PNG"]  ) {
                                               
                                               imageData = [self compressOfImageWithImage:image maxSize:requestModel.imageCompressSize compressType:requestModel.compressType];
                                               imageType = @"png";
                                               
                                           }else if ([requestModel.mimeType isEqualToString:@"jpg"] || [requestModel.mimeType isEqualToString:@"JPG"] ){
                                               
                                               imageData = [self compressOfImageWithImage:image maxSize:requestModel.imageCompressSize compressType:requestModel.compressType];
                                               imageType = @"jpg";
                                               
                                           }else if ([requestModel.mimeType isEqualToString:@"jpeg"] || [requestModel.mimeType isEqualToString:@"JPEG"] ){
                                               
                                               imageData = [self compressOfImageWithImage:image maxSize:requestModel.imageCompressSize compressType:requestModel.compressType];
                                               imageType = @"jpeg";
                                               
                                           }else{
                                               imageData = [self compressOfImageWithImage:image maxSize:requestModel.imageCompressSize compressType:requestModel.compressType];
                                               imageType = @"jpg";
                                           }
                                           
                                           
                                           if (imageData) {
                                               
                                               NSString *fileName = [NSString stringWithFormat:@"%@/%@.%@", [self getTodayString], [self randomString:18],imageType];
                                               [formData appendPartWithFileData:imageData
                                                                           name:requestModel.imagesIdentifer
                                                                       fileName:fileName
                                                                       mimeType:[NSString stringWithFormat:@"image/%@", imageType]];
                                               
                                           }
                                           
                                           
                                           
                                       }];
                                       
                                   } progress:^(NSProgress * _Nonnull uploadProgress) {
                                       
                                       if (_isDebugMode){
                                           WYNetworkLog(@"=========== Upload image progress:%@",uploadProgress);
                                       }
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                         if (requestModel.uploadProgressBlock) {
                                             requestModel.uploadProgressBlock(uploadProgress);
                                         }
                                           
                                       });
                                       
                                   } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                       
                                       if (_isDebugMode){
                                          WYNetworkLog(@"=========== Upload image request succeed:%@\n =========== Successfully uploaded images:%@",responseObject,requestModel.uploadImages);
                                       }
                                           
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           
                                         if (requestModel.uploadSuccessBlock) {                                             
                                             requestModel.uploadSuccessBlock(responseObject);
                                         }
                                           
                                         [weakSelf handleRequesFinished:requestModel];
                                           
                                       });
                                       
                                       
                                   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                       
                                       
                                       if (_isDebugMode){
                                           WYNetworkLog(@"=========== Upload images request failed: \n =========== error:%@\n =========== status code:%ld\n =========== failed images:%@:",error,(long)error.code,requestModel.uploadImages);
                                       }
                                       
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                           if (requestModel.uploadFailedBlock) {
                                               requestModel.uploadFailedBlock(task, error,error.code,requestModel.uploadImages);
                                            }
                                           [weakSelf handleRequesFinished:requestModel];
                                            
                                        });
                                      
                                   }];
    
    requestModel.task = uploadTask;
    [[WYNetworkRequestPool sharedPool] addRequestModel:requestModel];

}


#pragma mark- ============== Private Methods ==============

- (NSData *)compressOfImageWithImage:(UIImage *)image maxSize:(float)maxSize compressType:(WYUploadCompressType)compressType{
    
    if (compressType == WYWYUploadCompresArtwork)
    {
        return UIImageJPEGRepresentation(image, 1);
        
    } else if (compressType == WYUploadCompressWeiChat)
    {
        return [WYImageScaleTool compressOfImageWithWeiChat:image maxSize:maxSize];
        
    } else if (compressType == WYUploadCompressEqualProportion)
    {
        return [WYImageScaleTool compressOfImageWithEqualProportion:image maxSize:maxSize];
        
    } else if (compressType == WYUploadCompressTwoPoints)
    {
        return [WYImageScaleTool compressOfImageWithTwoPoints:image maxSize:maxSize];
                
    } else
    {
        return UIImagePNGRepresentation(image);
    }
}



#pragma mark- ============== Override Methods ==============

- (id)addDefaultParametersWithCustomParameters:(id)parameters{
    
    //if there is default parameters, then add them into custom parameters
    id parameters_spliced = nil;
    
    if (parameters && [parameters isKindOfClass:[NSDictionary class]]) {
        
        if ([[[WYNetworkConfig sharedConfig].defailtParameters allKeys] count] > 0) {
            
            NSMutableDictionary *defaultParameters_m = [[WYNetworkConfig sharedConfig].defailtParameters mutableCopy];
            [defaultParameters_m addEntriesFromDictionary:parameters];
            parameters_spliced = [defaultParameters_m copy];
            
        }else{
            
            parameters_spliced = parameters;
        }
        
    }else{
        
        parameters_spliced = [WYNetworkConfig sharedConfig].defailtParameters;
        
    }
    
    return parameters_spliced;
}



- (void)addCustomHeaders{
    
    //add custom header
    NSDictionary *customHeaders = [WYNetworkConfig sharedConfig].customHeaders;
    if ([customHeaders allKeys] > 0) {
        NSArray *allKeys = [customHeaders allKeys];
        if ([allKeys count] >0) {
            [customHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL * _Nonnull stop) {
                [_sessionManager.requestSerializer setValue:value forHTTPHeaderField:key];
                if (_isDebugMode) {
                  WYNetworkLog(@"=========== added header:key:%@ value:%@",key,value);
                }
            }];
        }
    }
}



#pragma mark- ============== WYNetworkProtocol ==============

- (void)handleRequesFinished:(WYNetworkRequestModel *)requestModel{
    
    //clear all blocks
    [requestModel clearAllBlocks];
    
    //remove this requst model from request queue
    [[WYNetworkRequestPool sharedPool] removeRequestModel:requestModel];
}


/** random alphanumeric string */
- (NSString *)randomString:(NSInteger)number {
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < number; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
            
        } else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}

/** get today date YYYYMMdd */
- (NSString *)getTodayString {
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *morelocationString = [dateformatter stringFromDate:senddate];
    return morelocationString;
}

@end
