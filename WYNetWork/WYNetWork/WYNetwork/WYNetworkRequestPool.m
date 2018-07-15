//
//  WYNetworkRequestPool.m
//  WYNetWork
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "WYNetworkRequestPool.h"
#import "WYNetworkUtils.h"
#import "WYNetworkConfig.h"
#import "WYNetworkRequestModel.h"
#import "WYNetworkProtocol.h"

#import "objc/runtime.h"
#import <CommonCrypto/CommonDigest.h>
#import <pthread/pthread.h>


#define Lock() pthread_mutex_lock(&_lock)
#define Unlock() pthread_mutex_unlock(&_lock)

static char currentRequestModelsKey;

@interface WYNetworkRequestModel()<WYNetworkProtocol>

@end

@implementation WYNetworkRequestPool
{
    pthread_mutex_t _lock;
    BOOL _isDebugMode;
}


#pragma mark- ============== Life Cycle ==============

+ (WYNetworkRequestPool *)sharedPool {
    
    static WYNetworkRequestPool *sharedPool = NULL;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedPool = [[WYNetworkRequestPool alloc] init];
    });
    return sharedPool;
}



- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        //lock
        pthread_mutex_init(&_lock, NULL);
        
        //debug mode or not
        _isDebugMode = [WYNetworkConfig sharedConfig].debugMode;
        
    }
    return self;
}

#pragma mark- ============== Public Methods ==============

- (WYCurrentRequestModels *)currentRequestModels {
    
    WYCurrentRequestModels *currentTasks = objc_getAssociatedObject(self, &currentRequestModelsKey);
    if (currentTasks) {
        return currentTasks;
    }
    currentTasks = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, &currentRequestModelsKey, currentTasks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return currentTasks;
}



- (void)addRequestModel:(WYNetworkRequestModel *)requestModel{
    
    Lock();
    [self.currentRequestModels setObject:requestModel forKey:[NSString stringWithFormat:@"%ld",(unsigned long)requestModel.task.taskIdentifier]];
    Unlock();
}



- (void)removeRequestModel:(WYNetworkRequestModel *)requestModel{
    
    Lock();
    [self.currentRequestModels removeObjectForKey:[NSString stringWithFormat:@"%ld",(unsigned long)requestModel.task.taskIdentifier]];
    Unlock();
    
}



- (void)changeRequestModel:(WYNetworkRequestModel *_Nonnull)requestModel forKey:(NSString *_Nonnull)key{
    
    Lock();
    [self.currentRequestModels removeObjectForKey:key];
    [self.currentRequestModels setObject:requestModel forKey:[NSString stringWithFormat:@"%ld",(unsigned long)requestModel.task.taskIdentifier]];
    Unlock();
    
}



- (BOOL)remainingCurrentRequests{
    
    NSArray *keys = [self.currentRequestModels  allKeys];
    if ([keys count]>0) {
        WYNetworkLog(@"=========== There is remaining current request");
        return YES;
    }
    WYNetworkLog(@"=========== There is no remaining current request");
    return NO;
}




- (NSInteger)currentRequestCount{
    
    if(![self remainingCurrentRequests]){
        return 0;
    }
    
    NSArray *keys = [self.currentRequestModels allKeys];
    WYNetworkLog(@"=========== There is %ld current requests",(unsigned long)keys.count);
    return [keys count];
    
}





- (void)logAllCurrentRequests{
    
    if ([self remainingCurrentRequests]) {
        
        [self.currentRequestModels enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, WYNetworkRequestModel * _Nonnull requestModel, BOOL * _Nonnull stop) {
            WYNetworkLog(@"=========== Log current request:\n %@",requestModel);
        }];
        
    }
}





- (void)cancelAllCurrentRequests{
    
    if ([self remainingCurrentRequests]) {
        
        for (WYNetworkRequestModel *requestModel in [self.currentRequestModels allValues]) {
            
        
            if (requestModel.requestType == WYRequestTypeDownload) {
                
                if (requestModel.backgroundDownloadSupport) {
                    
                    NSURLSessionDownloadTask *downloadTask = (NSURLSessionDownloadTask*)requestModel.task;
                    [downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                    }];
                    
                }else{
                    
                    [requestModel.task cancel];
                }
                
            }else{
                
                [requestModel.task cancel];
                [self removeRequestModel:requestModel];
            }
        }
        WYNetworkLog(@"=========== Canceled call current requests");
    }
    
    
}





- (void)cancelCurrentRequestWithUrl:(NSString * _Nonnull)url{
    
    if(![self remainingCurrentRequests]){
        return;
    }
    
    NSMutableArray *cancelRequestModelsArr = [NSMutableArray arrayWithCapacity:2];
    NSString *requestIdentiferOfUrl =  [WYNetworkUtils generateMD5StringFromString: [NSString stringWithFormat:@"Url:%@",url]];
    
    [self.currentRequestModels enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, WYNetworkRequestModel * _Nonnull requestModel, BOOL * _Nonnull stop) {
        
        if ([requestModel.requestIdentifer containsString:requestIdentiferOfUrl]) {
            [cancelRequestModelsArr addObject:requestModel];
        }
    }];
    
    if ([cancelRequestModelsArr count] == 0) {
        
        WYNetworkLog(@"=========== There is no request to be canceled");
        
    }else {
        
        if (_isDebugMode) {
            WYNetworkLog(@"=========== Requests to be canceled:");
            [cancelRequestModelsArr enumerateObjectsUsingBlock:^(WYNetworkRequestModel *requestModel, NSUInteger idx, BOOL * _Nonnull stop) {
                WYNetworkLog(@"=========== cancel request with url[%ld]:%@",(unsigned long)idx,requestModel.requestUrl);
            }];
        }
        
        [cancelRequestModelsArr enumerateObjectsUsingBlock:^(WYNetworkRequestModel *requestModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            
            if (requestModel.requestType == WYRequestTypeDownload) {
                
                if (requestModel.backgroundDownloadSupport) {
                    NSURLSessionDownloadTask *downloadTask = (NSURLSessionDownloadTask*)requestModel.task;
                    
                    if (requestModel.task.state == NSURLSessionTaskStateCompleted) {
                        
                        WYNetworkLog(@"=========== Canceled background support download request:%@",requestModel);
                        NSError *error = [NSError errorWithDomain:@"Request has been canceled" code:0 userInfo:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (requestModel.downloadFailureBlock) {
                                requestModel.downloadFailureBlock(requestModel.task, error,requestModel.resumeDataFilePath);
                            }
                            [self handleRequesFinished:requestModel];
                        });
                        
                    }else{
                        
                        [downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                            
                        }];
                        WYNetworkLog(@"=========== Background support download request %@ has been canceled",requestModel);
                    }
                    
                }else{
                    
                    [requestModel.task cancel];
                    WYNetworkLog(@"=========== Request %@ has been canceled",requestModel);
                }
                
            }else{
                
                [requestModel.task cancel];
                WYNetworkLog(@"=========== Request %@ has been canceled",requestModel);
                if (requestModel.requestType != WYRequestTypeDownload) {
                    [self removeRequestModel:requestModel];
                }
            }
        }];
        
        WYNetworkLog(@"=========== All requests with request url : '%@' are canceled",url);
    }
    
    
}




- (void)cancelCurrentRequestWithUrls:(NSArray * _Nonnull)urls{
    
    if ([urls count] == 0) {
        WYNetworkLog(@"=========== There is no input urls!");
        return;
    }
    
    if(![self remainingCurrentRequests]){
        return;
    }
    
    [urls enumerateObjectsUsingBlock:^(NSString *url, NSUInteger idx, BOOL * _Nonnull stop) {
        [self cancelCurrentRequestWithUrl:url];
    }];
}






- (void)cancelCurrentRequestWithUrl:(NSString * _Nonnull)url
                             method:(NSString * _Nonnull)method
                         parameters:(id _Nullable)parameter{
    
    if(![self remainingCurrentRequests]){
        return;
    }
    
    NSString *encodingUrlString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "]];
    NSString *requestIdentifier = [WYNetworkUtils generateRequestIdentiferWithBaseUrlStr:[WYNetworkConfig sharedConfig].baseUrl
                                                                           requestUrlStr:encodingUrlString
                                                                               methodStr:method
                                                                              parameters:parameter];
    
    [self p_cancelRequestWithRequestIdentifier:requestIdentifier];
}



#pragma mark- ============== Private Methods ==============

- (void)p_cancelRequestWithRequestIdentifier:(NSString *)requestIdentifier{
    
    [self.currentRequestModels enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, WYNetworkRequestModel * _Nonnull requestModel, BOOL * _Nonnull stop) {
        
        if ([requestModel.requestIdentifer isEqualToString:requestIdentifier]) {
            
            if (requestModel.task) {
                
                [requestModel.task cancel];
                WYNetworkLog(@"=========== Canceled request:%@",requestModel);
                if (requestModel.requestType != WYRequestTypeDownload) {
                    [self removeRequestModel:requestModel];
                }
                
            }else {
                WYNetworkLog(@"=========== There is no task of this request");
            }
        }
    }];
}




#pragma mark- ============== WYNetworkProtocol ==============

- (void)handleRequesFinished:(WYNetworkRequestModel *)requestModel{
    
    //clear all blocks
    [requestModel clearAllBlocks];
    
    //remove this requst model from request queue
    [[WYNetworkRequestPool sharedPool] removeRequestModel:requestModel];
    
}





@end
