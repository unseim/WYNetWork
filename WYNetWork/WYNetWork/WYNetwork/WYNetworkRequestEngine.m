//
//  WYNetworkRequestManager.m
//  WYNetWork
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "WYNetworkRequestEngine.h"
#import "WYNetworkCacheManager.h"
#import "WYNetworkRequestPool.h"
#import "WYNetworkConfig.h"
#import "WYNetworkUtils.h"
#import "WYNetworkProtocol.h"

@interface WYNetworkRequestEngine()<WYNetworkProtocol>

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) WYNetworkCacheManager *cacheManager;

@end


@implementation WYNetworkRequestEngine
{
    NSFileManager *_fileManager;
    BOOL _isDebugMode;
}


#pragma mark- ============== Life Cycle Methods ==============


- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        //file  manager
        _fileManager = [NSFileManager defaultManager];
        
        //cachec manager
        _cacheManager = [WYNetworkCacheManager sharedManager];
        
        //debug mode or not
        _isDebugMode = [WYNetworkConfig sharedConfig].debugMode;
        
        //AFSessionManager config
        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        _sessionManager.requestSerializer.allowsCellularAccess = YES;
        
        _sessionManager.requestSerializer.timeoutInterval = [WYNetworkConfig sharedConfig].timeoutSeconds;
        
        //securityPolicy
        _sessionManager.securityPolicy = [AFSecurityPolicy defaultPolicy];
        [_sessionManager.securityPolicy setAllowInvalidCertificates:YES];
        _sessionManager.securityPolicy.validatesDomainName = NO;
        
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/xml", @"text/plain", @"application/javascript", @"image/*", nil];
        
        //Queue
        _sessionManager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _sessionManager.operationQueue.maxConcurrentOperationCount = 5;
        
    }
    return self;
}


#pragma mark- ============== Public Methods ==============


- (void)sendRequest:(WYRequestSerializer)serializer
                url:(NSString *)url
             method:(WYRequestMethod)method
         parameters:(id)parameters
          cacheType:(WYNetworkCacheType)cacheType
      cacheDuration:(NSTimeInterval)cacheDuration
            success:(WYSuccessBlock)successBlock
            failure:(WYFailureBlock)failureBlock
{
    if (serializer == WYJSONRequestSerializer){
        
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
    } else if (serializer == WYHTTPRequestSerializer){
        
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
    } else if (serializer == WYJSONHTTPRequestSerializer){
        
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    
    NSString *encodingUrlString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "]];
    //generate complete url string
    NSString *completeUrlStr = [WYNetworkUtils generateCompleteRequestUrlStrWithBaseUrlStr:[WYNetworkConfig sharedConfig].baseUrl
                                                                             requestUrlStr:encodingUrlString];
    
    
    //request method
    NSString *methodStr = [self p_methodStringFromRequestMethod:method];
    
    
    //generate a unique identifer of a certain request
    NSString *requestIdentifer = [WYNetworkUtils generateRequestIdentiferWithBaseUrlStr:[WYNetworkConfig sharedConfig].baseUrl
                                                                          requestUrlStr:encodingUrlString
                                                                              methodStr:methodStr
                                                                             parameters:parameters];
    
    
    if (cacheType == WYNetworkCacheTypeNetworkOnly){
        
        [self p_sendRequestWithCompleteSerializer:serializer
                                           UrlStr:completeUrlStr
                                           method:methodStr
                                       parameters:parameters
                                        cacheType:cacheType
                                    cacheDuration:cacheDuration
                                 requestIdentifer:requestIdentifer
                                          success:successBlock
                                          failure:failureBlock];
        
        
    } else if (cacheType == WYNetworkCacheTypeNetworkOnlyOneOfCache){
        
        //if client wants to load cache
        [_cacheManager loadCacheWithRequestIdentifer:requestIdentifer completionBlock:^(id  _Nullable cacheObject) {
            
            if (cacheObject) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(_isDebugMode){
                        WYNetworkLog(@"=========== Request succeed by loading Cache! \n =========== Request url:%@\n =========== Response object:%@", completeUrlStr,cacheObject);
                    }
                    
                    if(successBlock){
                        
                        //if existence cache, only load cache
                        if (serializer == WYJSONHTTPRequestSerializer){
                            
                            if (![cacheObject isKindOfClass:[NSData class]]) {
                                
                                successBlock(cacheObject, YES);
                                
                            } else
                            {
                                NSString *response = [[NSString alloc] initWithData:cacheObject encoding:NSUTF8StringEncoding];
                                id jsonObject = [NSJSONSerialization JSONObjectWithData:cacheObject
                                                                                options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers
                                                                                  error:nil];
                                if (jsonObject != nil) {
                                    
                                    if ([jsonObject isKindOfClass:[NSDictionary class]]){
                                        successBlock(jsonObject, YES);
                                    }
                                    
                                }else{
                                    
                                    successBlock(response, YES);
                                }
                            }
                            
                            
                        }else{
                            
                            successBlock(cacheObject, YES);
                        }
                    }
                    
                });
                
                
            }else{
                
                //failed to load cache, start to sending network request...
                [self p_sendRequestWithCompleteSerializer:serializer
                                                   UrlStr:completeUrlStr
                                                   method:methodStr
                                               parameters:parameters
                                                cacheType:cacheType
                                            cacheDuration:cacheDuration
                                         requestIdentifer:requestIdentifer
                                                  success:successBlock
                                                  failure:failureBlock];
                
            }
            
        }];
        
        
    } else if (cacheType == WYNetworkCacheTypeCacheNetwork){
        
        //first, sending network request, if generate error, then load cache
        [self p_sendRequestWithCompleteSerializer:serializer
                                           UrlStr:completeUrlStr
                                           method:methodStr
                                       parameters:parameters
                                        cacheType:cacheType
                                    cacheDuration:cacheDuration
                                 requestIdentifer:requestIdentifer
                                          success:successBlock
                                          failure:failureBlock];
        
        
        
    }else{
        
        //      WYNetworkLog(@"=========== Do not need to load cache, start sending network request...");
        [self p_sendRequestWithCompleteSerializer:serializer
                                           UrlStr:completeUrlStr
                                           method:methodStr
                                       parameters:parameters
                                        cacheType:cacheType
                                    cacheDuration:cacheDuration
                                 requestIdentifer:requestIdentifer
                                          success:successBlock
                                          failure:failureBlock];
        
    }
}





#pragma mark- ============== Private Methods ==============


- (void)p_sendRequestWithCompleteSerializer:(WYRequestSerializer)serializer
                                     UrlStr:(NSString *)completeUrlStr
                                     method:(NSString *)methodStr
                                 parameters:(id)parameters
                                  cacheType:(WYNetworkCacheType)cacheType
                              cacheDuration:(NSTimeInterval)cacheDuration
                           requestIdentifer:(NSString *)requestIdentifer
                                    success:(WYSuccessBlock)successBlock
                                    failure:(WYFailureBlock)failureBlock{
    
    //add customed headers
    [self addCustomHeaders];
    
    
    //create corresponding request model
    WYNetworkRequestModel *requestModel = [[WYNetworkRequestModel alloc] init];
    requestModel.requestUrl = completeUrlStr;
    requestModel.method = methodStr;
    requestModel.parameters = parameters;
    requestModel.requestIdentifer = requestIdentifer;
    requestModel.successBlock = successBlock;
    requestModel.failureBlock = failureBlock;
    requestModel.serializer = serializer;
    requestModel.cacheType  = cacheType;
    
    if (cacheType == WYNetworkCacheTypeCacheNetwork || cacheType == WYNetworkCacheTypeNetworkOnlyOneOfCache){
        
        NSInteger duration = cacheDuration <= 0 ? 0 : cacheDuration;
        requestModel.cacheDuration = duration * 86400;
        requestModel.loadCache = YES;
        
    }else{
        
        requestModel.cacheDuration = 0;
        requestModel.loadCache = NO;
        
    }
    
    
    
    //create a session task corresponding to a request model
    NSError * __autoreleasing requestSerializationError = nil;
    NSURLSessionDataTask *dataTask = [self p_dataTaskWithRequestModel:requestModel
                                                    requestSerializer:_sessionManager.requestSerializer
                                                                error:&requestSerializationError];
    
    
    //save task info request model
    requestModel.task = dataTask;
    
    //save this request model into request set
    [[WYNetworkRequestPool sharedPool] addRequestModel:requestModel];
    
    if (_isDebugMode) {
        WYNetworkLog(@"=========== Start requesting...\n =========== url:%@\n =========== method:%@\n =========== parameters:%@",completeUrlStr,methodStr,parameters);
    }
    
    
    //start request
    [dataTask resume];
    
}



- (NSURLSessionDataTask *)p_dataTaskWithRequestModel:(WYNetworkRequestModel *)requestModel
                                   requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                               error:(NSError * _Nullable __autoreleasing *)error{
    
    //create request
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:requestModel.method
                                                              URLString:requestModel.requestUrl
                                                             parameters:requestModel.parameters
                                                                  error:error];
    
    
    
    //create data task
    __weak __typeof(self) weakSelf = self;
    NSURLSessionDataTask * dataTask = [_sessionManager dataTaskWithRequest:request
                                                            uploadProgress:nil
                                                          downloadProgress:nil
                                                         completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
                                       {
                                           //if generate error, load cache
                                           if (error) {
                                               
                                               __weak __typeof(self) weakSelf = self;
                                               if (requestModel.cacheType == WYNetworkCacheTypeCacheNetwork) {
                                                   
                                                   [_cacheManager loadCacheWithRequestIdentifer:requestModel.requestIdentifer completionBlock:^(id  _Nullable cacheObject) {
                                                       
                                                       if (cacheObject)
                                                       {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               
                                                               if (_isDebugMode) {
                                                                   WYNetworkLog(@"=========== Request succeed! \n =========== Request url:%@\n =========== Response object:%@", requestModel.requestUrl,cacheObject);
                                                               }
                                                               
                                                               if (requestModel.successBlock) {
                                                                   requestModel.successBlock(cacheObject, YES);
                                                               }
                                                           });
                                                           
                                                       }else
                                                       {
                                                           //request failed
                                                           [weakSelf requestDidFailedWithRequestModel:requestModel error:error];
                                                       }
                                                       
                                                   }];
                                                   
                                               }else
                                               {
                                                   //request failed
                                                   [self requestDidFailedWithRequestModel:requestModel error:error];
                                               }
                                               
                                               
                                           }else{
                                               
                                               
                                               if (requestModel.serializer == WYJSONHTTPRequestSerializer) {
                                                   
                                                   
                                                   if ([responseObject isKindOfClass:[NSString class]]) {
                                                       
                                                       NSString  *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                                       [weakSelf p_handleRequestModel:requestModel responseObject:response error:error];
                                                       
                                                   }else if ([responseObject isKindOfClass:[NSData class]]) {
                                                       
                                                       NSString  *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                                       id jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                       options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers
                                                                                                         error:nil];
                                                       if (jsonObject != nil && error == nil){
                                                           
                                                           if ([jsonObject isKindOfClass:[NSDictionary class]]) {
                                                               [weakSelf p_handleRequestModel:requestModel responseObject:jsonObject error:error];
                                                           }
                                                           
                                                       }else{
                                                           
                                                           [weakSelf p_handleRequestModel:requestModel responseObject:response error:error];
                                                           
                                                       }
                                                       
                                                   }else{
                                                       
                                                       [weakSelf p_handleRequestModel:requestModel responseObject:responseObject error:error];
                                                   }
                                                   
                                                   
                                               } else
                                               {
                                                   [weakSelf p_handleRequestModel:requestModel responseObject:responseObject error:error];
                                               }
                                               
                                               
                                           }
                                           
                                       }];
    
    return dataTask;
    
}




- (void)p_handleRequestModel:(WYNetworkRequestModel *)requestModel
              responseObject:(id)responseObject
                       error:(NSError *)error{
    
    if (error) {
        
        //request failed
        [self requestDidFailedWithRequestModel:requestModel error:error];
        
    } else {
        
        //request succeed
        requestModel.responseObject = responseObject;
        [self requestDidSucceedWithRequestModel:requestModel];
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self handleRequesFinished:requestModel];
        
    });
    
}




- (NSString *)p_methodStringFromRequestMethod:(WYRequestMethod)method{
    
    switch (method) {
            
        case WYRequestMethodGET:{
            return @"GET";
        }
            break;
            
        case WYRequestMethodPOST:{
            return  @"POST";
        }
            break;
            
        case WYRequestMethodPUT:{
            return  @"PUT";
        }
            break;
            
        case WYRequestMethodDELETE:{
            return  @"DELETE";
        }
            break;
    }
}


#pragma mark- ============== Override Methods ==============


- (void)requestDidSucceedWithRequestModel:(WYNetworkRequestModel *)requestModel{
    
    //write cache
    if (requestModel.cacheDuration > 0) {

        if ([requestModel.responseObject isKindOfClass:[NSString class]])
        {
            requestModel.responseData = [requestModel.responseObject dataUsingEncoding:NSUTF8StringEncoding];

        }else{

            if (requestModel.responseObject)
            {
                requestModel.responseData = [NSJSONSerialization dataWithJSONObject:requestModel.responseObject options:NSJSONWritingPrettyPrinted error:nil];
            }
        }

        if (requestModel.responseData) {
            
            [_cacheManager writeCacheWithReqeustModel:requestModel asynchronously:YES];
            
        }else{
            WYNetworkLog(@"=========== Failded to write cache, since something was wrong when transfering response data");
        }
        
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (_isDebugMode) {
            WYNetworkLog(@"=========== Request succeed! \n =========== Request url:%@\n =========== Response object:%@", requestModel.requestUrl,requestModel.responseObject);
        }
        
        if (requestModel.successBlock) {
            requestModel.successBlock(requestModel.responseObject, NO);
        }
    });
    
}




- (void)requestDidFailedWithRequestModel:(WYNetworkRequestModel *)requestModel error:(NSError *)error{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (_isDebugMode) {
            WYNetworkLog(@"=========== Request failded! \n =========== Request model:%@ \n =========== NSError object:%@ \n =========== Status code:%ld",requestModel,error,(long)error.code);
        }
        
        if (requestModel.failureBlock){
            requestModel.failureBlock(requestModel.task, error, error.code);
        }
        
    });
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


@end
