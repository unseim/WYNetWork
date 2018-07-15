//
//  WYNetworkCache.m
//  WYNetWork
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "WYNetworkCacheManager.h"
#import "WYNetworkRequestModel.h"
#import "WYNetworkConfig.h"
#import "WYNetworkUtils.h"
#import "WYNetworkCacheInfo.h"
#import "WYNetworkDownloadResumeDataInfo.h"



#ifndef NSFoundationVersionNumber_iOS_8_0
#define NSFoundationVersionNumber_With_QoS_Available 1140.11
#else
#define NSFoundationVersionNumber_With_QoS_Available NSFoundationVersionNumber_iOS_8_0
#endif


static dispatch_queue_t WY_cache_io_queue() {
    
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_attr_t attr = DISPATCH_QUEUE_SERIAL;
        if (NSFoundationVersionNumber >= NSFoundationVersionNumber_With_QoS_Available) {
            attr = dispatch_queue_attr_make_with_qos_class(attr, QOS_CLASS_BACKGROUND, 0);
        }
        queue = dispatch_queue_create("com.WY.caching.io", attr);
    });
    
    return queue;
}





@implementation WYNetworkCacheManager{
    
    NSFileManager *_fileManager;
    NSString *_cacheBasePath;
    BOOL _isDebugMode;
}


#pragma mark- ============== Life Cycle Methods ==============


+ (WYNetworkCacheManager *_Nonnull)sharedManager{
    
    static WYNetworkCacheManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[WYNetworkCacheManager alloc] init];
    });
    return sharedManager;
}


- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        _fileManager = [NSFileManager defaultManager];
        _cacheBasePath = [WYNetworkUtils createCacheBasePath];
        _isDebugMode = [WYNetworkConfig sharedConfig].debugMode;
        
    }
    return self;
}

//==================== Write Cache ====================//

#pragma mark- ============== Public Methods ==============


#pragma mark Write Cache

- (void)writeCacheWithReqeustModel:(WYNetworkRequestModel * _Nonnull)requestModel asynchronously:(BOOL)asynchronously{
    
    
    if (asynchronously) {
        
        dispatch_async(WY_cache_io_queue(), ^{
            [self p_wrtieCacheWithRequestModel:requestModel];
        });
        
    }else{
        
        [self p_wrtieCacheWithRequestModel:requestModel];
    }
}



#pragma mark Load Cache



- (void)loadCacheWithUrl:(NSString * _Nonnull)url completionBlock:(WYLoadCacheArrCompletionBlock _Nullable)completionBlock{
    
    NSString *partialIdentifier = [WYNetworkUtils generatePartialIdentiferWithBaseUrlStr:[WYNetworkConfig sharedConfig].baseUrl
                                                                           requestUrlStr:url
                                                                               methodStr:nil];
    
    [self p_loadCacheWithPartialIdentifier:partialIdentifier completionBlock:completionBlock];

}


- (void)loadCacheWithUrl:(NSString * _Nonnull)url
                  method:(NSString * _Nonnull)method
         completionBlock:(WYLoadCacheArrCompletionBlock _Nullable)completionBlock{
    
    
    NSString *partialIdentifier = [WYNetworkUtils generatePartialIdentiferWithBaseUrlStr:[WYNetworkConfig sharedConfig].baseUrl
                                                                           requestUrlStr:url
                                                                               methodStr:method];
    
    [self p_loadCacheWithPartialIdentifier:partialIdentifier completionBlock:completionBlock];
    
}




- (void)loadCacheWithUrl:(NSString * _Nonnull)url
                  method:(NSString * _Nonnull)method
              parameters:(id _Nullable)parameters
         completionBlock:(WYLoadCacheCompletionBlock _Nullable)completionBlock{
    
    NSString *encodingUrlString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "]];
    NSString *requestIdentifer = [WYNetworkUtils generateRequestIdentiferWithBaseUrlStr:[WYNetworkConfig sharedConfig].baseUrl
                                                                          requestUrlStr:encodingUrlString
                                                                              methodStr:method
                                                                             parameters:parameters];
    
    [self loadCacheWithRequestIdentifer:requestIdentifer completionBlock:^(NSArray * _Nullable cacheArr) {
        
        if (completionBlock) {
            completionBlock(cacheArr);
        }
    
    }];
    
}



- (void)loadCacheWithRequestIdentifer:(NSString * _Nonnull)requestIdentifer
                      completionBlock:(WYLoadCacheCompletionBlock _Nullable)completionBlock{
    
    NSString *cacheDataFilePath = [WYNetworkUtils cacheDataFilePathWithRequestIdentifer:requestIdentifer];
    NSString *cacheInfoFilePath = [WYNetworkUtils cacheDataInfoFilePathWithRequestIdentifer:requestIdentifer];
    
    //load cache info
    WYNetworkCacheInfo *cacheInfo = [self p_loadCacheInfoWithRequestIdentifier:requestIdentifer];
    
    if (!cacheInfo) {
        
        if (_isDebugMode) {
            WYNetworkLog(@"=========== Load cache failed: Cache info dose not exists in path:%@",cacheInfoFilePath);
        }
        
        [self removeCacheDataFile:cacheDataFilePath cacheInfoFile:cacheInfoFilePath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(nil);
            }
        });
        
        return;
    }
    
    BOOL cacheValidation = [self p_checkCacheValidation:cacheInfo];
    
    if (!cacheValidation) {
        
        if (_isDebugMode) {
            WYNetworkLog(@"=========== Load cache failed: Cache info is invalid");
        }
        
        [self removeCacheDataFile:cacheDataFilePath cacheInfoFile:cacheInfoFilePath];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(nil);
            }
        });
        
        return;
        
    }
    
    id cacheObject = [self p_loadCacheObjectWithCacheFilePath:cacheDataFilePath];
    
    if (!cacheObject) {
        
        if (_isDebugMode) {
            WYNetworkLog(@"=========== Load cache failed: Cache data is missing");
        }
        
        [self removeCacheDataFile:cacheDataFilePath cacheInfoFile:cacheInfoFilePath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(nil);
            }
        });
        
        return;
        
    }else {
        
        
        if (_isDebugMode) {
            WYNetworkLog(@"=========== Load cache succeed: Cache loacation:%@",cacheDataFilePath);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(cacheObject);
            }
        });
    }
}




#pragma mark Calculate Cache

- (void)calculateAllCacheSizecompletionBlock:(WYCalculateSizeCompletionBlock _Nullable)completionBlock{

    NSURL *diskCacheURL = [NSURL fileURLWithPath:_cacheBasePath isDirectory:YES];
    
    dispatch_async(WY_cache_io_queue(), ^{
        
        NSUInteger fileCount = 0;
        NSUInteger totalSize = 0;
        
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtURL:diskCacheURL
                                                   includingPropertiesForKeys:@[NSFileSize]
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                 errorHandler:NULL];
        
        for (NSURL *fileURL in fileEnumerator) {
            NSNumber *fileSize;
            [fileURL getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
            totalSize += fileSize.unsignedIntegerValue;
            fileCount += 1;
        }
        
        NSString *totalSizeStr = nil;
        NSUInteger mb = 1024 *1024;
        if (totalSize <mb) {
            totalSizeStr = [NSString stringWithFormat:@"%.4f KB",(totalSize * 1.0/1024)];
        }else{
            totalSizeStr = [NSString stringWithFormat:@"%.4f MB",totalSize * 1.0/(mb)];
        }
        if (_isDebugMode) {
            WYNetworkLog(@"=========== Calculate cache size succeed:total fileCount:%ld & totalSize:%@",(unsigned long)fileCount,totalSizeStr);
        }
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{                
                completionBlock(fileCount, totalSize, totalSizeStr);
            });
        }
    });

}


#pragma mark Clear Cache

- (void)clearAllCacheCompletionBlock:(WYClearCacheCompletionBlock _Nullable)completionBlock{

    dispatch_async(WY_cache_io_queue(), ^{
        
        NSError *removeCacheFolderError = nil;
        NSError *createCacheFolderError = nil;
        [_fileManager removeItemAtPath:_cacheBasePath error:&removeCacheFolderError];
        
        if (!removeCacheFolderError) {
            
            [_fileManager createDirectoryAtPath:_cacheBasePath
                    withIntermediateDirectories:YES
                                     attributes:nil
                                          error:&createCacheFolderError];
            
            if (!createCacheFolderError) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                WYNetworkLog(@"=========== Clearing all cache successfully");
                if (completionBlock) {
                        completionBlock(YES);
                        return;
                }
                });
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                if (_isDebugMode) {
                    WYNetworkLog(@"=========== Clearing cache error: Failed to create cache folder after removing it");
                }
                if(completionBlock) {
                    
                        completionBlock(NO);
                        return;
                      }
                });
              
            }
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_isDebugMode) {
                    WYNetworkLog(@"=========== Clearing cache error: Failed to remove cache folder");
                }
                if (completionBlock) {
                    completionBlock(NO);
                    return;
                }
            });
               
        };
    });
}



- (void)clearCacheWithUrl:(NSString * _Nonnull)url completionBlock:(WYClearCacheCompletionBlock _Nullable)completionBlock{

    
    NSString *partiticalIdentifier = [WYNetworkUtils generatePartialIdentiferWithBaseUrlStr:[WYNetworkConfig sharedConfig].baseUrl
                                                                              requestUrlStr:url
                                                                                  methodStr:nil];
    
    [self p_clearCacheWithIdentifier:partiticalIdentifier completionBlock:completionBlock];
    
}




- (void)clearCacheWithUrl:(NSString * _Nonnull)url
                   method:(NSString * _Nonnull)method
          completionBlock:(WYClearCacheCompletionBlock _Nullable)completionBlock{
    
    NSString *partiticalIdentifier = [WYNetworkUtils generatePartialIdentiferWithBaseUrlStr:[WYNetworkConfig sharedConfig].baseUrl
                                                                              requestUrlStr:url
                                                                                  methodStr:method];
    
    [self p_clearCacheWithIdentifier:partiticalIdentifier completionBlock:completionBlock];
}




- (void)clearCacheWithUrl:(NSString * _Nonnull)url
                   method:(NSString * _Nonnull)method
               parameters:(id _Nullable)parameters
          completionBlock:(WYClearCacheCompletionBlock _Nullable)completionBlock{
    
    NSString *encodingUrlString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "]];
    NSString *requestIdentifer = [WYNetworkUtils generateRequestIdentiferWithBaseUrlStr:[WYNetworkConfig sharedConfig].baseUrl
                                                                          requestUrlStr:encodingUrlString
                                                                              methodStr:method
                                                                             parameters:parameters];
    
    [self p_clearCacheWithIdentifier:requestIdentifer completionBlock:completionBlock];
    
}



#pragma mark Update resume data or resume data info

- (void)updateResumeDataInfoAfterSuspendWithRequestModel:(WYNetworkRequestModel *_Nonnull)requestModel{
    
    NSData *resumeData = requestModel.task.error.userInfo[NSURLSessionDownloadTaskResumeData];
    [resumeData writeToFile:requestModel.resumeDataFilePath options:NSDataWritingAtomic error:nil];
    
    int64_t downloadedByte = requestModel.task.countOfBytesReceived;
    int64_t totalByte = requestModel.task.countOfBytesExpectedToReceive;
    CGFloat percent = 1.0 *downloadedByte/totalByte;
    WYNetworkDownloadResumeDataInfo *dataInfo = [self loadResumeDataInfo:requestModel.resumeDataInfoFilePath];
    dataInfo.resumeDataLength = [NSString stringWithFormat:@"%lld",downloadedByte];
    dataInfo.totalDataLength = [NSString stringWithFormat:@"%lld",totalByte];
    dataInfo.resumeDataRatio = [NSString stringWithFormat:@"%.2f",percent];
    [NSKeyedArchiver archiveRootObject:dataInfo toFile:requestModel.resumeDataInfoFilePath];
}




- (void)removeResumeDataAndResumeDataInfoFileWithRequestModel:(WYNetworkRequestModel *_Nonnull)requestModel{
    
    [_fileManager removeItemAtPath:requestModel.resumeDataFilePath error:nil];
    [_fileManager removeItemAtPath:requestModel.resumeDataInfoFilePath error:nil];
    
}



- (void)removeCompleteDownloadDataAndClearResumeDataInfoFileWithRequestModel:(WYNetworkRequestModel *_Nonnull)requestModel{
    
    NSError *moveFileError = nil;
    [_fileManager moveItemAtPath:requestModel.resumeDataFilePath toPath:requestModel.downloadFilePath error:&moveFileError];
    if (moveFileError.code == 516) {
        [_fileManager removeItemAtPath:requestModel.resumeDataFilePath error:nil];
    }
    [_fileManager removeItemAtPath:requestModel.resumeDataInfoFilePath error:nil];
    
}



- (void)removeCacheDataFile:(NSString *)cacheDataFilePath cacheInfoFile:(NSString *)cacheInfoFilePath{
    
    if([_fileManager fileExistsAtPath:cacheDataFilePath]){
        [_fileManager removeItemAtPath:cacheDataFilePath error:nil];
    }
    
    if([_fileManager fileExistsAtPath:cacheInfoFilePath]){
        [_fileManager removeItemAtPath:cacheInfoFilePath error:nil];
    }
    
}

#pragma mark load resume data info


- (WYNetworkDownloadResumeDataInfo *)loadResumeDataInfo:(NSString *)filePath {
    
    WYNetworkDownloadResumeDataInfo *dataInfo = nil;
    if ([_fileManager fileExistsAtPath:filePath isDirectory:nil]) {
        dataInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if ([dataInfo isKindOfClass:[WYNetworkDownloadResumeDataInfo class]]) {
            return dataInfo;
        }else{
            return nil;
        }
    }
    return nil;
}





#pragma mark- ============== Private Methods ==============


- (void)p_wrtieCacheWithRequestModel:(WYNetworkRequestModel *)requestModel{
    
    if (requestModel.responseData) {
        
        //path of cache file
        [requestModel.responseData writeToFile:requestModel.cacheDataFilePath atomically:YES];
        
        //write cache info data
        WYNetworkCacheInfo *cacheInfo = [[WYNetworkCacheInfo alloc] init];
        cacheInfo.creationDate = [NSDate date];
        cacheInfo.cacheDuration = [NSNumber numberWithInteger:requestModel.cacheDuration];
        cacheInfo.appVersionStr = [WYNetworkUtils appVersionStr];
        cacheInfo.reqeustIdentifer = requestModel.requestIdentifer;
        
        //write cache info
        [NSKeyedArchiver archiveRootObject:cacheInfo toFile:requestModel.cacheDataInfoFilePath];
        
        if (_isDebugMode) {
            WYNetworkLog(@"=========== Write cache succeed!\n =========== cache object: %@\n =========== Cache path: %@\n =========== Available duration: %@ seconds",requestModel.responseObject,requestModel.cacheDataFilePath,cacheInfo.cacheDuration);
        }
        
    }else{
        if (_isDebugMode) {
            WYNetworkLog(@"=========== Write cache failed! reason: There is no responeseData");
        }
    }
}

- (void)p_loadCacheWithPartialIdentifier:(NSString *)partialIdentifier completionBlock:(WYLoadCacheArrCompletionBlock _Nullable)completionBlock{
    
    
    NSDirectoryEnumerator *enumerator = [_fileManager enumeratorAtPath:_cacheBasePath];
    NSMutableArray *requestIdentifersArr = [[NSMutableArray alloc] initWithCapacity:2];
    
    
    for (NSString *fileName in enumerator){
        
        if ([fileName containsString:partialIdentifier]) {
            
            if ([fileName containsString:WYNetworkCacheFileSuffix]) {
                
                NSString *identifier = [fileName substringWithRange:NSMakeRange(0, (fileName.length - WYNetworkCacheFileSuffix.length - 1))];
                [requestIdentifersArr addObject:identifier];
                
            }else{
                //do not match cache data file
            }
        }
    }
    
    if ([requestIdentifersArr count] > 0) {
        NSMutableArray *cacheObjArr = [[NSMutableArray alloc] initWithCapacity:2];
        
        for (NSString* requestIdentifer in requestIdentifersArr) {
            [self loadCacheWithRequestIdentifer:requestIdentifer completionBlock:^(id  _Nullable cacheObject) {
                if (cacheObject) {
                    [cacheObjArr addObject:cacheObject];
                }
            }];
        }
        
        if (_isDebugMode) {
            WYNetworkLog(@"=========== Load cache succeed: Found cache corresponding this url");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock([cacheObjArr copy]);
            }
        });
        
        
        
    }else{
        
        if (_isDebugMode) {
            WYNetworkLog(@"=========== Load cache failed: There is no any cache corresponding this url");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(nil);
            }
        });
    }
    
}


- (BOOL)p_checkCacheValidation:(WYNetworkCacheInfo *)cacheInfo{
    
    if (!cacheInfo || ![cacheInfo isKindOfClass:[WYNetworkCacheInfo class]]) {
        return NO;
    }
    
    //check duration
    NSDate *creationDate = cacheInfo.creationDate;
    NSTimeInterval pastDuration = - [creationDate timeIntervalSinceNow];
    NSTimeInterval cacheDuration = [cacheInfo.cacheDuration integerValue];
    
    if (cacheDuration <= 0 ) {
        if (_isDebugMode) {
            WYNetworkLog(@"=========== Load cache info failed, reason: Did not set duration time, begin to clear cache...");
        }
        [self p_clearCacheWithIdentifier:cacheInfo.reqeustIdentifer completionBlock:nil];
        return NO;
    }
    
    
    if (pastDuration < 0 || pastDuration > cacheDuration) {
        
        if (_isDebugMode) {
            WYNetworkLog(@"=========== Load cache info failed, reason:Cache is expired, begin to clear cache...");
        }
        
        [self p_clearCacheWithIdentifier:cacheInfo.reqeustIdentifer completionBlock:nil];
        return NO;
    }
    
    
    //check app version
    NSString *cacheAppVersionStr = cacheInfo.appVersionStr;
    NSString *currentAppVersionStr = [WYNetworkUtils appVersionStr];
    
    if ( (!cacheAppVersionStr) && (!currentAppVersionStr)) {
        if (_isDebugMode) {
            WYNetworkLog(@"=========== Load cache info failed, reason: Failed to load app version, begin to clear cache...");
        }
        [self p_clearCacheWithIdentifier:cacheInfo.reqeustIdentifer completionBlock:nil];
        return NO;
    }
    
    if (cacheAppVersionStr.length != currentAppVersionStr.length || ![cacheAppVersionStr isEqualToString:currentAppVersionStr]) {
        if (_isDebugMode) {
            WYNetworkLog(@"=========== Load cache info failed, reason: Failed to match app version, begin to clear cache...");
        }
        [self p_clearCacheWithIdentifier:cacheInfo.reqeustIdentifer completionBlock:nil];
        return NO;
    }
    
    return YES;
    
}



- (void)p_clearCacheWithIdentifier:(NSString *)identifier completionBlock:(WYClearCacheCompletionBlock _Nullable)completionBlock{
    
    
    NSMutableArray *deleteFileNamesArr = [[NSMutableArray alloc] initWithCapacity:2];
    NSDirectoryEnumerator *enumerator = [_fileManager enumeratorAtPath:_cacheBasePath];
    
    for (NSString *fileName in enumerator){
        if ([fileName containsString:identifier]) {
            NSString *deleteFilePath = [_cacheBasePath stringByAppendingPathComponent:fileName];
            [deleteFileNamesArr addObject:deleteFilePath];
        }
    }
    
    if ([deleteFileNamesArr count] > 0) {
        
        for (NSInteger index = 0; index < deleteFileNamesArr.count; index++) {
            
            dispatch_async(WY_cache_io_queue(), ^{
                
                [_fileManager removeItemAtPath:deleteFileNamesArr[index] error:nil];
                
                if (index == deleteFileNamesArr.count - 1) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (_isDebugMode) {
                            WYNetworkLog(@"=========== Clearing cache successfully!");
                        }
                        if (completionBlock) {
                            completionBlock(YES);
                            return;
                        }
                    });
                }
            });
            
        }
        
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_isDebugMode) {
                WYNetworkLog(@"=========== Clearing cache error: there is no corresponding cache info");
            }
            if (completionBlock) {
                completionBlock(NO);
                return;
            }
        });
        
    }
    
}



- (id)p_loadCacheObjectWithCacheFilePath:(NSString *)cacheFilePath{
    
    id cacheObject = nil;
    NSError *error = nil;
    
    if ([_fileManager fileExistsAtPath:cacheFilePath isDirectory:nil]) {
        NSData *data = [NSData dataWithContentsOfFile:cacheFilePath];
        cacheObject = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)0 error:&error];
        if (cacheObject) {
            return cacheObject;
        }
    }
    return cacheObject;
}



- (WYNetworkCacheInfo *)p_loadCacheInfoWithRequestIdentifier:(NSString *)requestIdentifer {
    
    NSString *cacheInfoFilePath = [WYNetworkUtils cacheDataInfoFilePathWithRequestIdentifer:requestIdentifer];
    
    WYNetworkCacheInfo *cacheInfo = nil;
    if ([_fileManager fileExistsAtPath:cacheInfoFilePath isDirectory:nil]) {
        
        cacheInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:cacheInfoFilePath];
        if ([cacheInfo isKindOfClass:[WYNetworkCacheInfo class]]) {
            return cacheInfo;
        }else{
            return nil;
        }
    }
    return nil;
}


@end
