//
//  WYNetworkManager.m
//  WYNetWork
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "WYNetworkManager.h"

#import "WYNetworkConfig.h"
#import "WYNetworkRequestPool.h"

#import "WYNetworkRequestEngine.h"
#import "WYNetworkUploadEngine.h"
#import "WYNetworkDownloadEngine.h"

@interface WYNetworkManager()

@property (nonatomic, strong) WYNetworkRequestEngine *requestEngine;
@property (nonatomic, strong) WYNetworkUploadEngine *uploadEngine;
@property (nonatomic, strong) WYNetworkDownloadEngine *downloadEngine;

@property (nonatomic, strong) WYNetworkRequestPool *requestPool;
@property (nonatomic, strong) WYNetworkCacheManager *cacheManager;

@end


@implementation WYNetworkManager


#pragma mark- ============== Life Cycle ===========

+ (WYNetworkManager *_Nullable)sharedManager {
    
    static WYNetworkManager *sharedManager = NULL;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[WYNetworkManager alloc] init];
    });
    return sharedManager;
}


- (void)dealloc{
    
    [self cancelAllCurrentRequests];
}

#pragma mark- ============== Public Methods ==============


- (void)addCustomHeader:(NSDictionary *_Nonnull)header{
    
    [[WYNetworkConfig sharedConfig] addCustomHeader:header];
}




- (NSDictionary *_Nullable)customHeaders{
    
    return [WYNetworkConfig sharedConfig].customHeaders;
}




#pragma mark- ============== Request API using GET method ==============


- (void)sendGetRequest:(WYRequestSerializer)serializer
                   url:(NSString * _Nonnull)url
               success:(WYSuccessBlock _Nullable)successBlock
               failure:(WYFailureBlock _Nullable)failureBlock{
    
    
    [self.requestEngine sendRequest:serializer
                                url:url
                             method:WYRequestMethodGET
                         parameters:nil
                          cacheType:WYNetworkCacheTypeCacheNetwork
                      cacheDuration:30
                            success:successBlock
                            failure:failureBlock];
    
}





- (void)sendGetRequest:(WYRequestSerializer)serializer
                   url:(NSString * _Nonnull)url
            parameters:(id _Nullable)parameters
               success:(WYSuccessBlock _Nullable)successBlock
               failure:(WYFailureBlock _Nullable)failureBlock{
    
    
    [self.requestEngine sendRequest:serializer
                                url:url
                             method:WYRequestMethodGET
                         parameters:parameters
                          cacheType:WYNetworkCacheTypeCacheNetwork
                      cacheDuration:30
                            success:successBlock
                            failure:failureBlock];
}




- (void)sendGetRequest:(WYRequestSerializer)serializer
                   url:(NSString * _Nonnull)url
            parameters:(id _Nullable)parameters
             cacheType:(WYNetworkCacheType)cacheType
               success:(WYSuccessBlock _Nullable)successBlock
               failure:(WYFailureBlock _Nullable)failureBlock{
    
    
    [self.requestEngine sendRequest:serializer
                                url:url
                             method:WYRequestMethodGET
                         parameters:parameters
                          cacheType:cacheType
                      cacheDuration:30
                            success:successBlock
                            failure:failureBlock];
}





- (void)sendGetRequest:(WYRequestSerializer)serializer
                   url:(NSString * _Nonnull)url
            parameters:(id _Nullable)parameters
         cacheDuration:(NSTimeInterval)cacheDuration
               success:(WYSuccessBlock _Nullable)successBlock
               failure:(WYFailureBlock _Nullable)failureBlock{
    
    
    [self.requestEngine sendRequest:serializer
                                url:url
                             method:WYRequestMethodGET
                         parameters:parameters
                          cacheType:WYNetworkCacheTypeCacheNetwork
                      cacheDuration:cacheDuration
                            success:successBlock
                            failure:failureBlock];
}





- (void)sendGetRequest:(WYRequestSerializer)serializer
                   url:(NSString * _Nonnull)url
            parameters:(id _Nullable)parameters
             cacheType:(WYNetworkCacheType)cacheType
         cacheDuration:(NSTimeInterval)cacheDuration
               success:(WYSuccessBlock _Nullable)successBlock
               failure:(WYFailureBlock _Nullable)failureBlock{
    
    
    [self.requestEngine sendRequest:serializer
                                url:url
                             method:WYRequestMethodGET
                         parameters:parameters
                          cacheType:cacheType
                      cacheDuration:cacheDuration
                            success:successBlock
                            failure:failureBlock];
}




#pragma mark- ============== Request API using POST method ==============

- (void)sendPostRequest:(WYRequestSerializer)serializer
                    url:(NSString * _Nonnull)url
             parameters:(id _Nullable)parameters
                success:(WYSuccessBlock _Nullable)successBlock
                failure:(WYFailureBlock _Nullable)failureBlock{
    
    
    [self.requestEngine sendRequest:serializer
                                url:url
                             method:WYRequestMethodPOST
                         parameters:parameters
                          cacheType:WYNetworkCacheTypeNetworkOnly
                      cacheDuration:0
                            success:successBlock
                            failure:failureBlock];
}




- (void)sendPostRequest:(WYRequestSerializer)serializer
                    url:(NSString * _Nonnull)url
             parameters:(id _Nullable)parameters
              cacheType:(WYNetworkCacheType)cacheType
                success:(WYSuccessBlock _Nullable)successBlock
                failure:(WYFailureBlock _Nullable)failureBlock{
    
    
    [self.requestEngine sendRequest:serializer
                                url:url
                             method:WYRequestMethodPOST
                         parameters:parameters
                          cacheType:cacheType
                      cacheDuration:30
                            success:successBlock
                            failure:failureBlock];
}



- (void)sendPostRequest:(WYRequestSerializer)serializer
                    url:(NSString * _Nonnull)url
             parameters:(id _Nullable)parameters
          cacheDuration:(NSTimeInterval)cacheDuration
                success:(WYSuccessBlock _Nullable)successBlock
                failure:(WYFailureBlock _Nullable)failureBlock{
    
    
    [self.requestEngine sendRequest:serializer
                                url:url
                             method:WYRequestMethodPOST
                         parameters:parameters
                          cacheType:WYNetworkCacheTypeCacheNetwork
                      cacheDuration:cacheDuration
                            success:successBlock
                            failure:failureBlock];
}




- (void)sendPostRequest:(WYRequestSerializer)serializer
                    url:(NSString * _Nonnull)url
             parameters:(id _Nullable)parameters
              cacheType:(WYNetworkCacheType)cacheType
          cacheDuration:(NSTimeInterval)cacheDuration
                success:(WYSuccessBlock _Nullable)successBlock
                failure:(WYFailureBlock _Nullable)failureBlock{
    
    
    [self.requestEngine sendRequest:serializer
                                url:url
                             method:WYRequestMethodPOST
                         parameters:parameters
                          cacheType:cacheType
                      cacheDuration:cacheDuration
                            success:successBlock
                            failure:failureBlock];
}





#pragma mark- ============== Request API using PUT method ==============

- (void)sendPutRequest:(WYRequestSerializer)serializer
                   url:(NSString * _Nonnull)url
            parameters:(id _Nullable)parameters
               success:(WYSuccessBlock _Nullable)successBlock
               failure:(WYFailureBlock _Nullable)failureBlock{
    
    
    [self.requestEngine sendRequest:serializer
                                url:url
                             method:WYRequestMethodPUT
                         parameters:parameters
                          cacheType:WYNetworkCacheTypeNetworkOnly
                      cacheDuration:0
                            success:successBlock
                            failure:failureBlock];
}




- (void)sendPutRequest:(WYRequestSerializer)serializer
                   url:(NSString * _Nonnull)url
            parameters:(id _Nullable)parameters
             cacheType:(WYNetworkCacheType)cacheType
               success:(WYSuccessBlock _Nullable)successBlock
               failure:(WYFailureBlock _Nullable)failureBlock{
    
    
    [self.requestEngine sendRequest:serializer
                                url:url
                             method:WYRequestMethodPUT
                         parameters:parameters
                          cacheType:cacheType
                      cacheDuration:30
                            success:successBlock
                            failure:failureBlock];
}




- (void)sendPutRequest:(WYRequestSerializer)serializer
                   url:(NSString * _Nonnull)url
            parameters:(id _Nullable)parameters
         cacheDuration:(NSTimeInterval)cacheDuration
               success:(WYSuccessBlock _Nullable)successBlock
               failure:(WYFailureBlock _Nullable)failureBlock{
    
    
    [self.requestEngine sendRequest:serializer
                                url:url
                             method:WYRequestMethodPUT
                         parameters:parameters
                          cacheType:WYNetworkCacheTypeCacheNetwork
                      cacheDuration:cacheDuration
                            success:successBlock
                            failure:failureBlock];
}




- (void)sendPutRequest:(WYRequestSerializer)serializer
                   url:(NSString * _Nonnull)url
            parameters:(id _Nullable)parameters
             cacheType:(WYNetworkCacheType)cacheType
         cacheDuration:(NSTimeInterval)cacheDuration
               success:(WYSuccessBlock _Nullable)successBlock
               failure:(WYFailureBlock _Nullable)failureBlock{
    
    
    [self.requestEngine sendRequest:serializer
                                url:url
                             method:WYRequestMethodPUT
                         parameters:parameters
                          cacheType:cacheType
                      cacheDuration:cacheDuration
                            success:successBlock
                            failure:failureBlock];
    
}



#pragma mark- ============== Request API using DELETE method ==============

- (void)sendDeleteRequest:(WYRequestSerializer)serializer
                      url:(NSString * _Nonnull)url
               parameters:(id _Nullable)parameters
                  success:(WYSuccessBlock _Nullable)successBlock
                  failure:(WYFailureBlock _Nullable)failureBlock{
    
    
    [self.requestEngine sendRequest:serializer
                                url:url
                             method:WYRequestMethodDELETE
                         parameters:parameters
                          cacheType:WYNetworkCacheTypeNetworkOnly
                      cacheDuration:0
                            success:successBlock
                            failure:failureBlock];
}



- (void)sendDeleteRequest:(WYRequestSerializer)serializer
                      url:(NSString * _Nonnull)url
               parameters:(id _Nullable)parameters
                cacheType:(WYNetworkCacheType)cacheType
                  success:(WYSuccessBlock _Nullable)successBlock
                  failure:(WYFailureBlock _Nullable)failureBlock{
    
    
    [self.requestEngine sendRequest:serializer
                                url:url
                             method:WYRequestMethodDELETE
                         parameters:parameters
                          cacheType:cacheType
                      cacheDuration:30
                            success:successBlock
                            failure:failureBlock];
    
}




- (void)sendDeleteRequest:(WYRequestSerializer)serializer
                      url:(NSString * _Nonnull)url
               parameters:(id _Nullable)parameters
            cacheDuration:(NSTimeInterval)cacheDuration
                  success:(WYSuccessBlock _Nullable)successBlock
                  failure:(WYFailureBlock _Nullable)failureBlock{
    
    
    [self.requestEngine sendRequest:serializer
                                url:url
                             method:WYRequestMethodDELETE
                         parameters:parameters
                          cacheType:WYNetworkCacheTypeCacheNetwork
                      cacheDuration:cacheDuration
                            success:successBlock
                            failure:failureBlock];
}




- (void)sendDeleteRequest:(WYRequestSerializer)serializer
                      url:(NSString * _Nonnull)url
               parameters:(id _Nullable)parameters
                cacheType:(WYNetworkCacheType)cacheType
            cacheDuration:(NSTimeInterval)cacheDuration
                  success:(WYSuccessBlock _Nullable)successBlock
                  failure:(WYFailureBlock _Nullable)failureBlock{
    
    
    [self.requestEngine sendRequest:serializer
                                url:url
                             method:WYRequestMethodDELETE
                         parameters:parameters
                          cacheType:cacheType
                      cacheDuration:cacheDuration
                            success:successBlock
                            failure:failureBlock];
}





#pragma mark- ============== Request API using specific parameters ==============


- (void)sendRequest:(WYRequestSerializer)serializer
                url:(NSString * _Nonnull)url
         parameters:(id _Nullable)parameters
            success:(WYSuccessBlock _Nullable)successBlock
            failure:(WYFailureBlock _Nullable)failureBlock{
    
    
    if (parameters) {
        
        [self.requestEngine sendRequest:serializer
                                    url:url
                                 method:WYRequestMethodPOST
                             parameters:parameters
                              cacheType:WYNetworkCacheTypeNetworkOnly
                          cacheDuration:0
                                success:successBlock
                                failure:failureBlock];
        
    }else{
        
        [self.requestEngine sendRequest:serializer
                                    url:url
                                 method:WYRequestMethodGET
                             parameters:nil
                              cacheType:WYNetworkCacheTypeCacheNetwork
                          cacheDuration:30
                                success:successBlock
                                failure:failureBlock];
    }
}



- (void)sendRequest:(WYRequestSerializer)serializer
                url:(NSString * _Nonnull)url
         parameters:(id _Nullable)parameters
          cacheType:(WYNetworkCacheType)cacheType
            success:(WYSuccessBlock _Nullable)successBlock
            failure:(WYFailureBlock _Nullable)failureBlock{
    
    
    if (parameters) {
        
        [self.requestEngine sendRequest:serializer
                                    url:url
                                 method:WYRequestMethodPOST
                             parameters:parameters
                              cacheType:cacheType
                          cacheDuration:30
                                success:successBlock
                                failure:failureBlock];
        
    }else{
        
        [self.requestEngine sendRequest:serializer
                                    url:url
                                 method:WYRequestMethodGET
                             parameters:nil
                              cacheType:cacheType
                          cacheDuration:30
                                success:successBlock
                                failure:failureBlock];
    }
}



- (void)sendRequest:(WYRequestSerializer)serializer
                url:(NSString * _Nonnull)url
         parameters:(id _Nullable)parameters
      cacheDuration:(NSTimeInterval)cacheDuration
            success:(WYSuccessBlock _Nullable)successBlock
            failure:(WYFailureBlock _Nullable)failureBlock{
    
    
    if (parameters) {
        
        [self.requestEngine sendRequest:serializer
                                    url:url
                                 method:WYRequestMethodPOST
                             parameters:parameters
                              cacheType:WYNetworkCacheTypeNetworkOnly
                          cacheDuration:cacheDuration
                                success:successBlock
                                failure:failureBlock];
        
    }else{
        
        
        [self.requestEngine sendRequest:serializer
                                    url:url
                                 method:WYRequestMethodGET
                             parameters:nil
                              cacheType:WYNetworkCacheTypeCacheNetwork
                          cacheDuration:cacheDuration
                                success:successBlock
                                failure:failureBlock];
    }
}



- (void)sendRequest:(WYRequestSerializer)serializer
                url:(NSString * _Nonnull)url
         parameters:(id _Nullable)parameters
          cacheType:(WYNetworkCacheType)cacheType
      cacheDuration:(NSTimeInterval)cacheDuration
            success:(WYSuccessBlock _Nullable)successBlock
            failure:(WYFailureBlock _Nullable)failureBlock{
    
    
    if (parameters) {
        
        [self.requestEngine sendRequest:serializer
                                    url:url
                                 method:WYRequestMethodPOST
                             parameters:parameters
                              cacheType:cacheType
                          cacheDuration:cacheDuration
                                success:successBlock
                                failure:failureBlock];
    }else{
        
        
        [self.requestEngine sendRequest:serializer
                                    url:url
                                 method:WYRequestMethodGET
                             parameters:nil
                              cacheType:cacheType
                          cacheDuration:cacheDuration
                                success:successBlock
                                failure:failureBlock];
    }
}



#pragma mark- ============== Request API using specific request method ==============

- (void)sendRequest:(WYRequestSerializer)serializer
                url:(NSString * _Nonnull)url
             method:(WYRequestMethod)method
         parameters:(id _Nullable)parameters
            success:(WYSuccessBlock _Nullable)successBlock
            failure:(WYFailureBlock _Nullable)failureBlock{
    
    
    [self.requestEngine sendRequest:serializer
                                url:url
                             method:method
                         parameters:parameters
                          cacheType:WYNetworkCacheTypeNetworkOnly
                      cacheDuration:0
                            success:successBlock
                            failure:failureBlock];
}



- (void)sendRequest:(WYRequestSerializer)serializer
                url:(NSString * _Nonnull)url
             method:(WYRequestMethod)method
         parameters:(id _Nullable)parameters
          cacheType:(WYNetworkCacheType)cacheType
            success:(WYSuccessBlock _Nullable)successBlock
            failure:(WYFailureBlock _Nullable)failureBlock{
    
    
    [self.requestEngine sendRequest:serializer
                                url:url
                             method:method
                         parameters:parameters
                          cacheType:cacheType
                      cacheDuration:30
                            success:successBlock
                            failure:failureBlock];
}



- (void)sendRequest:(WYRequestSerializer)serializer
                url:(NSString * _Nonnull)url
             method:(WYRequestMethod)method
         parameters:(id _Nullable)parameters
      cacheDuration:(NSTimeInterval)cacheDuration
            success:(WYSuccessBlock _Nullable)successBlock
            failure:(WYFailureBlock _Nullable)failureBlock{
    
    
    [self.requestEngine sendRequest:serializer
                                url:url
                             method:method
                         parameters:parameters
                          cacheType:WYNetworkCacheTypeNetworkOnly
                      cacheDuration:cacheDuration
                            success:successBlock
                            failure:failureBlock];
}



- (void)sendRequest:(WYRequestSerializer)serializer
                url:(NSString * _Nonnull)url
             method:(WYRequestMethod)method
         parameters:(id _Nullable)parameters
          cacheType:(WYNetworkCacheType)cacheType
      cacheDuration:(NSTimeInterval)cacheDuration
            success:(WYSuccessBlock _Nullable)successBlock
            failure:(WYFailureBlock _Nullable)failureBlock{
    
    
    [self.requestEngine sendRequest:serializer
                                url:url
                             method:method
                         parameters:parameters
                          cacheType:cacheType
                      cacheDuration:cacheDuration
                            success:successBlock
                            failure:failureBlock];
}




#pragma mark- ============== Request API uploading ==============


- (void)sendUploadImageRequest:(WYRequestSerializer)serializer
                           url:(NSString * _Nonnull)url
                    parameters:(id _Nullable)parameters
                         image:(UIImage * _Nonnull)image
                          name:(NSString * _Nonnull)name
                      progress:(WYUploadProgressBlock _Nullable)uploadProgressBlock
                       success:(WYUploadSuccessBlock _Nullable)uploadSuccessBlock
                       failure:(WYUploadFailureBlock _Nullable)uploadFailureBlock{
    
    
    [self.uploadEngine sendUploadImagesRequest:serializer
                                           url:url
                                 ignoreBaseUrl:NO
                                    parameters:parameters
                                        images:@[image]
                                  compressSize:150
                                  compressType:WYUploadCompressWeiChat
                                          name:name
                                      mimeType:@"png"
                                      progress:uploadProgressBlock
                                       success:uploadSuccessBlock
                                       failure:uploadFailureBlock];
}


- (void)sendUploadImageRequest:(WYRequestSerializer)serializer
                           url:(NSString * _Nonnull)url
                    parameters:(id _Nullable)parameters
                  compressType:(WYUploadCompressType)compressType
                         image:(UIImage * _Nonnull)image
                          name:(NSString * _Nonnull)name
                      progress:(WYUploadProgressBlock _Nullable)uploadProgressBlock
                       success:(WYUploadSuccessBlock _Nullable)uploadSuccessBlock
                       failure:(WYUploadFailureBlock _Nullable)uploadFailureBlock{
    
    
    [self.uploadEngine sendUploadImagesRequest:serializer
                                           url:url
                                 ignoreBaseUrl:NO
                                    parameters:parameters
                                        images:@[image]
                                  compressSize:150
                                  compressType:compressType
                                          name:name
                                      mimeType:@"png"
                                      progress:uploadProgressBlock
                                       success:uploadSuccessBlock
                                       failure:uploadFailureBlock];
}



- (void)sendUploadImageRequest:(WYRequestSerializer)serializer
                           url:(NSString * _Nonnull)url
                 ignoreBaseUrl:(BOOL)ignoreBaseUrl
                    parameters:(id _Nullable)parameters
                         image:(UIImage * _Nonnull)image
                          name:(NSString * _Nonnull)name
                      progress:(WYUploadProgressBlock _Nullable)uploadProgressBlock
                       success:(WYUploadSuccessBlock _Nullable)uploadSuccessBlock
                       failure:(WYUploadFailureBlock _Nullable)uploadFailureBlock{
    
    
    [self.uploadEngine sendUploadImagesRequest:serializer
                                           url:url
                                 ignoreBaseUrl:ignoreBaseUrl
                                    parameters:parameters
                                        images:@[image]
                                  compressSize:150
                                  compressType:WYUploadCompressWeiChat
                                          name:name
                                      mimeType:@"png"
                                      progress:uploadProgressBlock
                                       success:uploadSuccessBlock
                                       failure:uploadFailureBlock];
    
}



- (void)sendUploadImageRequest:(WYRequestSerializer)serializer
                           url:(NSString * _Nonnull)url
                 ignoreBaseUrl:(BOOL)ignoreBaseUrl
                    parameters:(id _Nullable)parameters
                  compressType:(WYUploadCompressType)compressType
                         image:(UIImage * _Nonnull)image
                          name:(NSString * _Nonnull)name
                      progress:(WYUploadProgressBlock _Nullable)uploadProgressBlock
                       success:(WYUploadSuccessBlock _Nullable)uploadSuccessBlock
                       failure:(WYUploadFailureBlock _Nullable)uploadFailureBlock{
    
    
    [self.uploadEngine sendUploadImagesRequest:serializer
                                           url:url
                                 ignoreBaseUrl:ignoreBaseUrl
                                    parameters:parameters
                                        images:@[image]
                                  compressSize:150
                                  compressType:compressType
                                          name:name
                                      mimeType:@"png"
                                      progress:uploadProgressBlock
                                       success:uploadSuccessBlock
                                       failure:uploadFailureBlock];
    
}



- (void)sendUploadImageRequest:(WYRequestSerializer)serializer
                           url:(NSString * _Nonnull)url
                    parameters:(id _Nullable)parameters
                  compressType:(WYUploadCompressType)compressType
                         image:(UIImage * _Nonnull)image
                  compressSize:(float)compressSize
                          name:(NSString * _Nonnull)name
                      mimeType:(NSString * _Nullable)mimeType
                      progress:(WYUploadProgressBlock _Nullable)uploadProgressBlock
                       success:(WYUploadSuccessBlock _Nullable)uploadSuccessBlock
                       failure:(WYUploadFailureBlock _Nullable)uploadFailureBlock{
    
    
    [self.uploadEngine sendUploadImagesRequest:serializer
                                           url:url
                                 ignoreBaseUrl:NO
                                    parameters:parameters
                                        images:@[image]
                                  compressSize:compressSize
                                  compressType:compressType
                                          name:name
                                      mimeType:mimeType
                                      progress:uploadProgressBlock
                                       success:uploadSuccessBlock
                                       failure:uploadFailureBlock];
    
    
}



- (void)sendUploadImageRequest:(WYRequestSerializer)serializer
                           url:(NSString * _Nonnull)url
                 ignoreBaseUrl:(BOOL)ignoreBaseUrl
                    parameters:(id _Nullable)parameters
                  compressType:(WYUploadCompressType)compressType
                         image:(UIImage * _Nonnull)image
                  compressSize:(float)compressSize
                          name:(NSString * _Nonnull)name
                      mimeType:(NSString * _Nullable)mimeType
                      progress:(WYUploadProgressBlock _Nullable)uploadProgressBlock
                       success:(WYUploadSuccessBlock _Nullable)uploadSuccessBlock
                       failure:(WYUploadFailureBlock _Nullable)uploadFailureBlock{
    
    
    [self.uploadEngine sendUploadImagesRequest:serializer
                                           url:url
                                 ignoreBaseUrl:ignoreBaseUrl
                                    parameters:parameters
                                        images:@[image]
                                  compressSize:compressSize
                                  compressType:compressType
                                          name:name
                                      mimeType:mimeType
                                      progress:uploadProgressBlock
                                       success:uploadSuccessBlock
                                       failure:uploadFailureBlock];
}




- (void)sendUploadImagesRequest:(WYRequestSerializer)serializer
                            url:(NSString * _Nonnull)url
                     parameters:(id _Nullable)parameters
                         images:(NSArray<UIImage *> * _Nonnull)images
                           name:(NSString * _Nonnull)name
                       progress:(WYUploadProgressBlock _Nullable)uploadProgressBlock
                        success:(WYUploadSuccessBlock _Nullable)uploadSuccessBlock
                        failure:(WYUploadFailureBlock _Nullable)uploadFailureBlock{
    
    
    [self.uploadEngine sendUploadImagesRequest:serializer
                                           url:url
                                 ignoreBaseUrl:NO
                                    parameters:parameters
                                        images:images
                                  compressSize:150
                                  compressType:WYUploadCompressWeiChat
                                          name:name
                                      mimeType:@"png"
                                      progress:uploadProgressBlock
                                       success:uploadSuccessBlock
                                       failure:uploadFailureBlock];
    
}



- (void)sendUploadImagesRequest:(WYRequestSerializer)serializer
                            url:(NSString * _Nonnull)url
                  ignoreBaseUrl:(BOOL)ignoreBaseUrl
                     parameters:(id _Nullable)parameters
                         images:(NSArray<UIImage *> * _Nonnull)images
                           name:(NSString * _Nonnull)name
                       progress:(WYUploadProgressBlock _Nullable)uploadProgressBlock
                        success:(WYUploadSuccessBlock _Nullable)uploadSuccessBlock
                        failure:(WYUploadFailureBlock _Nullable)uploadFailureBlock{
    
    
    [self.uploadEngine sendUploadImagesRequest:serializer
                                           url:url
                                 ignoreBaseUrl:ignoreBaseUrl
                                    parameters:parameters
                                        images:images
                                  compressSize:150
                                  compressType:WYUploadCompressWeiChat
                                          name:name
                                      mimeType:@"png"
                                      progress:uploadProgressBlock
                                       success:uploadSuccessBlock
                                       failure:uploadFailureBlock];
    
}




- (void)sendUploadImagesRequest:(WYRequestSerializer)serializer
                            url:(NSString * _Nonnull)url
                     parameters:(id _Nullable)parameters
                   compressType:(WYUploadCompressType)compressType
                         images:(NSArray<UIImage *> * _Nonnull)images
                   compressSize:(float)compressSize
                           name:(NSString * _Nonnull)name
                       mimeType:(NSString * _Nullable)mimeType
                       progress:(WYUploadProgressBlock _Nullable)uploadProgressBlock
                        success:(WYUploadSuccessBlock _Nullable)uploadSuccessBlock
                        failure:(WYUploadFailureBlock _Nullable)uploadFailureBlock{
    
    
    [self.uploadEngine sendUploadImagesRequest:serializer
                                           url:url
                                 ignoreBaseUrl:NO
                                    parameters:parameters
                                        images:images
                                  compressSize:compressSize
                                  compressType:compressType
                                          name:name
                                      mimeType:mimeType
                                      progress:uploadProgressBlock
                                       success:uploadSuccessBlock
                                       failure:uploadFailureBlock];
}



- (void)sendUploadImagesRequest:(WYRequestSerializer)serializer
                            url:(NSString * _Nonnull)url
                  ignoreBaseUrl:(BOOL)ignoreBaseUrl
                     parameters:(id _Nullable)parameters
                   compressType:(WYUploadCompressType)compressType
                         images:(NSArray<UIImage *> * _Nonnull)images
                   compressSize:(float)compressSize
                           name:(NSString * _Nonnull)name
                       mimeType:(NSString * _Nullable)mimeType
                       progress:(WYUploadProgressBlock _Nullable)uploadProgressBlock
                        success:(WYUploadSuccessBlock _Nullable)uploadSuccessBlock
                        failure:(WYUploadFailureBlock _Nullable)uploadFailureBlock{
    
    
    [self.uploadEngine sendUploadImagesRequest:serializer
                                           url:url
                                 ignoreBaseUrl:ignoreBaseUrl
                                    parameters:parameters
                                        images:images
                                  compressSize:compressSize
                                  compressType:compressType
                                          name:name
                                      mimeType:mimeType
                                      progress:uploadProgressBlock
                                       success:uploadSuccessBlock
                                       failure:uploadFailureBlock];
}




#pragma mark- ============== Request API downloading ==============

- (void)sendDownloadRequest:(NSString * _Nonnull)url
           downloadFilePath:(NSString *_Nonnull)downloadFilePath
                   progress:(WYDownloadProgressBlock _Nullable)downloadProgressBlock
                    success:(WYDownloadSuccessBlock _Nullable)downloadSuccessBlock
                    failure:(WYDownloadFailureBlock _Nullable)downloadFailureBlock{
    
    
    [self.downloadEngine sendDownloadRequest:url
                               ignoreBaseUrl:NO
                            downloadFilePath:downloadFilePath
                                   resumable:YES
                           backgroundSupport:NO
                                    progress:downloadProgressBlock
                                     success:downloadSuccessBlock
                                     failure:downloadFailureBlock];
}



- (void)sendDownloadRequest:(NSString * _Nonnull)url
              ignoreBaseUrl:(BOOL)ignoreBaseUrl
           downloadFilePath:(NSString *_Nonnull)downloadFilePath
                   progress:(WYDownloadProgressBlock _Nullable)downloadProgressBlock
                    success:(WYDownloadSuccessBlock _Nullable)downloadSuccessBlock
                    failure:(WYDownloadFailureBlock _Nullable)downloadFailureBlock{
    
    
    [self.downloadEngine sendDownloadRequest:url
                               ignoreBaseUrl:ignoreBaseUrl
                            downloadFilePath:downloadFilePath
                                   resumable:YES
                           backgroundSupport:NO
                                    progress:downloadProgressBlock
                                     success:downloadSuccessBlock
                                     failure:downloadFailureBlock];
    
}




- (void)sendDownloadRequest:(NSString * _Nonnull)url
           downloadFilePath:(NSString *_Nonnull)downloadFilePath
                  resumable:(BOOL)resumable
                   progress:(WYDownloadProgressBlock _Nullable)downloadProgressBlock
                    success:(WYDownloadSuccessBlock _Nullable)downloadSuccessBlock
                    failure:(WYDownloadFailureBlock _Nullable)downloadFailureBlock{
    
    
    [self.downloadEngine sendDownloadRequest:url
                               ignoreBaseUrl:NO
                            downloadFilePath:downloadFilePath
                                   resumable:resumable
                           backgroundSupport:NO
                                    progress:downloadProgressBlock
                                     success:downloadSuccessBlock
                                     failure:downloadFailureBlock];
}




- (void)sendDownloadRequest:(NSString * _Nonnull)url
              ignoreBaseUrl:(BOOL)ignoreBaseUrl
           downloadFilePath:(NSString *_Nonnull)downloadFilePath
                  resumable:(BOOL)resumable
                   progress:(WYDownloadProgressBlock _Nullable)downloadProgressBlock
                    success:(WYDownloadSuccessBlock _Nullable)downloadSuccessBlock
                    failure:(WYDownloadFailureBlock _Nullable)downloadFailureBlock{
    
    
    [self.downloadEngine sendDownloadRequest:url
                               ignoreBaseUrl:ignoreBaseUrl
                            downloadFilePath:downloadFilePath
                                   resumable:resumable
                           backgroundSupport:NO
                                    progress:downloadProgressBlock
                                     success:downloadSuccessBlock
                                     failure:downloadFailureBlock];
}




- (void)sendDownloadRequest:(NSString * _Nonnull)url
           downloadFilePath:(NSString *_Nonnull)downloadFilePath
          backgroundSupport:(BOOL)backgroundSupport
                   progress:(WYDownloadProgressBlock _Nullable)downloadProgressBlock
                    success:(WYDownloadSuccessBlock _Nullable)downloadSuccessBlock
                    failure:(WYDownloadFailureBlock _Nullable)downloadFailureBlock{
    
    
    [self.downloadEngine sendDownloadRequest:url
                               ignoreBaseUrl:NO
                            downloadFilePath:downloadFilePath
                                   resumable:YES
                           backgroundSupport:NO
                                    progress:downloadProgressBlock
                                     success:downloadSuccessBlock
                                     failure:downloadFailureBlock];
    
}




- (void)sendDownloadRequest:(NSString * _Nonnull)url
              ignoreBaseUrl:(BOOL)ignoreBaseUrl
           downloadFilePath:(NSString *_Nonnull)downloadFilePath
          backgroundSupport:(BOOL)backgroundSupport
                   progress:(WYDownloadProgressBlock _Nullable)downloadProgressBlock
                    success:(WYDownloadSuccessBlock _Nullable)downloadSuccessBlock
                    failure:(WYDownloadFailureBlock _Nullable)downloadFailureBlock{
    
    
    [self.downloadEngine sendDownloadRequest:url
                               ignoreBaseUrl:ignoreBaseUrl
                            downloadFilePath:downloadFilePath
                                   resumable:YES
                           backgroundSupport:NO
                                    progress:downloadProgressBlock
                                     success:downloadSuccessBlock
                                     failure:downloadFailureBlock];
    
}




- (void)sendDownloadRequest:(NSString * _Nonnull)url
           downloadFilePath:(NSString *_Nonnull)downloadFilePath
                  resumable:(BOOL)resumable
          backgroundSupport:(BOOL)backgroundSupport
                   progress:(WYDownloadProgressBlock _Nullable)downloadProgressBlock
                    success:(WYDownloadSuccessBlock _Nullable)downloadSuccessBlock
                    failure:(WYDownloadFailureBlock _Nullable)downloadFailureBlock{
    
    
    [self.downloadEngine sendDownloadRequest:url
                               ignoreBaseUrl:NO
                            downloadFilePath:downloadFilePath
                                   resumable:resumable
                           backgroundSupport:backgroundSupport
                                    progress:downloadProgressBlock
                                     success:downloadSuccessBlock
                                     failure:downloadFailureBlock];
}





- (void)sendDownloadRequest:(NSString * _Nonnull)url
              ignoreBaseUrl:(BOOL)ignoreBaseUrl
           downloadFilePath:(NSString *_Nonnull)downloadFilePath
                  resumable:(BOOL)resumable
          backgroundSupport:(BOOL)backgroundSupport
                   progress:(WYDownloadProgressBlock _Nullable)downloadProgressBlock
                    success:(WYDownloadSuccessBlock _Nullable)downloadSuccessBlock
                    failure:(WYDownloadFailureBlock _Nullable)downloadFailureBlock{
    
    
    [self.downloadEngine sendDownloadRequest:url
                               ignoreBaseUrl:ignoreBaseUrl
                            downloadFilePath:downloadFilePath
                                   resumable:resumable
                           backgroundSupport:backgroundSupport
                                    progress:downloadProgressBlock
                                     success:downloadSuccessBlock
                                     failure:downloadFailureBlock];
}



#pragma mark- ============== Download suspend operation ==============

- (void)suspendAllDownloadRequests{
    
    [self.downloadEngine suspendAllDownloadRequests];
}




- (void)suspendDownloadRequest:(WYRequestSerializer)serializer
                           url:(NSString * _Nonnull)url{
    
    [self.downloadEngine suspendDownloadRequest:url];
}




- (void)suspendDownloadRequest:(WYRequestSerializer)serializer
                           url:(NSString * _Nonnull)url ignoreBaseUrl:(BOOL)ignoreBaseUrl{
    
    [self.downloadEngine suspendDownloadRequest:url ignoreBaseUrl:ignoreBaseUrl];
}




- (void)suspendDownloadRequests:(NSArray *_Nonnull)urls{
    
    [self.downloadEngine suspendDownloadRequests:urls];
}




- (void)suspendDownloadRequests:(NSArray *_Nonnull)urls ignoreBaseUrl:(BOOL)ignoreBaseUrl{
    
    [self.downloadEngine suspendDownloadRequests:urls ignoreBaseUrl:ignoreBaseUrl];
}



#pragma mark- ============== Download resume operation ==============

- (void)resumeAllDownloadRequests{
    
    [self.downloadEngine resumeAllDownloadRequests];
}



- (void)resumeDownloadReqeust:(NSString *_Nonnull)url{
    
    [self.downloadEngine resumeDownloadReqeust:url];
}




- (void)resumeDownloadReqeust:(NSString *_Nonnull)url ignoreBaseUrl:(BOOL)ignoreBaseUrl{
    
    [self.downloadEngine resumeDownloadReqeust:url ignoreBaseUrl:ignoreBaseUrl];
}




- (void)resumeDownloadReqeusts:(NSArray *_Nonnull)urls{
    
    [self.downloadEngine resumeDownloadReqeusts:urls];
}




- (void)resumeDownloadReqeusts:(NSArray *_Nonnull)urls ignoreBaseUrl:(BOOL)ignoreBaseUrl{
    
    [self.downloadEngine resumeDownloadReqeusts:urls ignoreBaseUrl:ignoreBaseUrl];
}



#pragma mark- ============== Download cancel operation ==============

- (void)cancelAllDownloadRequests{
    
    [self.downloadEngine cancelAllDownloadRequests];
}



- (void)cancelDownloadRequest:(WYRequestSerializer)serializer
                          url:(NSString * _Nonnull)url{
    
    [self.downloadEngine cancelDownloadRequest:url];
    
}



- (void)cancelDownloadRequest:(WYRequestSerializer)serializer
                          url:(NSString * _Nonnull)url ignoreBaseUrl:(BOOL)ignoreBaseUrl{
    
    [self.downloadEngine cancelDownloadRequest:url ignoreBaseUrl:ignoreBaseUrl];
}




- (void)cancelDownloadRequests:(NSArray *_Nonnull)urls{
    
    [self.downloadEngine cancelDownloadRequests:urls];
}




- (void)cancelDownloadRequests:(NSArray *_Nonnull)urls ignoreBaseUrl:(BOOL)ignoreBaseUrl{
    
    [self.downloadEngine cancelDownloadRequests:urls ignoreBaseUrl:ignoreBaseUrl];
}



#pragma mark- ============== Download resume data ratio ==============

- (CGFloat)resumeDataRatioOfRequest:(NSString *_Nonnull)url{
    
    return  [self.downloadEngine resumeDataRatioOfRequest:url];
}



- (CGFloat)resumeDataRatioOfRequest:(NSString *_Nonnull)url ignoreBaseUrl:(BOOL)ignoreBaseUrl{
    
    return  [self.downloadEngine resumeDataRatioOfRequest:url ignoreBaseUrl:ignoreBaseUrl];
}


#pragma mark- ============== Request Operation ==============

- (void)cancelAllCurrentRequests{
    
    [self.requestPool cancelAllCurrentRequests];
}




- (void)cancelCurrentRequestWithUrl:(NSString *)url{
    
    [self.requestPool cancelCurrentRequestWithUrl:url];
}





- (void)cancelCurrentRequestWithUrl:(NSString * _Nonnull)url
                             method:(NSString * _Nonnull)method
                         parameters:(id _Nullable)parameters{
    
    [self.requestPool cancelCurrentRequestWithUrl:url
                                           method:method
                                       parameters:parameters];
    
}



#pragma mark- ============== Request Info ==============

- (void)logAllCurrentRequests{
    
    [self.requestPool logAllCurrentRequests];
}




- (BOOL)remainingCurrentRequests{
    
    return [self.requestPool remainingCurrentRequests];
}




- (NSInteger)currentRequestCount{
    
    return [self.requestPool currentRequestCount];
}



#pragma mark- ============== Cache Operations ==============


#pragma mark Load cache


- (void)loadCacheWithUrl:(NSString * _Nonnull)url completionBlock:(WYLoadCacheArrCompletionBlock _Nullable)completionBlock{
    
    [self.cacheManager loadCacheWithUrl:url completionBlock:completionBlock];
}



- (void)loadCacheWithUrl:(NSString * _Nonnull)url
                  method:(NSString * _Nonnull)method
         completionBlock:(WYLoadCacheArrCompletionBlock _Nullable)completionBlock{
    
    [self.cacheManager loadCacheWithUrl:url
                                 method:method
                        completionBlock:completionBlock];
}



- (void)loadCacheWithUrl:(NSString * _Nonnull)url
                  method:(NSString * _Nonnull)method
              parameters:(id _Nullable)parameters
         completionBlock:(WYLoadCacheCompletionBlock _Nullable)completionBlock{
    
    [self.cacheManager loadCacheWithUrl:url
                                 method:method
                             parameters:parameters
                        completionBlock:completionBlock];
}



#pragma mark calculate cache

- (void)calculateCacheSizeCompletionBlock:(WYCalculateSizeCompletionBlock _Nullable)completionBlock{
    
    [self.cacheManager calculateAllCacheSizecompletionBlock:completionBlock];
}



#pragma mark clear cache

- (void)clearAllCacheCompletionBlock:(WYClearCacheCompletionBlock _Nullable)completionBlock{
    
    [self.cacheManager clearAllCacheCompletionBlock:completionBlock];
}




- (void)clearCacheWithUrl:(NSString * _Nonnull)url completionBlock:(WYClearCacheCompletionBlock _Nullable)completionBlock{
    
    [self.cacheManager clearCacheWithUrl:url completionBlock:completionBlock];
}



- (void)clearCacheWithUrl:(NSString * _Nonnull)url
                   method:(NSString * _Nonnull)method
          completionBlock:(WYClearCacheCompletionBlock _Nullable)completionBlock{
    
    
    [self.cacheManager clearCacheWithUrl:url
                                  method:method
                         completionBlock:completionBlock];
    
}



- (void)clearCacheWithUrl:(NSString * _Nonnull)url
                   method:(NSString * _Nonnull)method
               parameters:(id _Nonnull)parameters
          completionBlock:(WYClearCacheCompletionBlock _Nullable)completionBlock{
    
    [self.cacheManager clearCacheWithUrl:url
                                  method:method
                              parameters:parameters
                         completionBlock:completionBlock];
    
}

#pragma mark- Setter and Getter


- (WYNetworkRequestPool *)requestPool{
    
    if (!_requestPool) {
        _requestPool = [WYNetworkRequestPool sharedPool];
    }
    return _requestPool;
}



- (WYNetworkCacheManager *)cacheManager{
    
    if (!_cacheManager) {
        _cacheManager = [WYNetworkCacheManager sharedManager];
    }
    return _cacheManager;
}




- (WYNetworkRequestEngine *)requestEngine{
    
    if (!_requestEngine) {
        _requestEngine = [[WYNetworkRequestEngine alloc] init];
    }
    return _requestEngine;
}




- (WYNetworkUploadEngine *)uploadEngine{
    
    if (!_uploadEngine) {
        _uploadEngine = [[WYNetworkUploadEngine alloc] init];
    }
    return _uploadEngine;
}




- (WYNetworkDownloadEngine *)downloadEngine{
    
    if (!_downloadEngine) {
        _downloadEngine = [[WYNetworkDownloadEngine alloc] init];;
    }
    return _downloadEngine;
}



@end
