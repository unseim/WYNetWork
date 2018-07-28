//
//  WYNetworkUtils.m
//  WYNetWork
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "WYNetworkUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import "WYNetworkHeader.h"

#define CC_MD5_DIGEST_LENGTH    16          /* digest length in bytes */
#define CC_MD5_BLOCK_BYTES      64          /* block size in bytes */
#define CC_MD5_BLOCK_LONG       (CC_MD5_BLOCK_BYTES / sizeof(CC_LONG))


NSString * const WYNetworkCacheBaseFolderName = @"WYNetworkCache";
NSString * const WYNetworkCacheFileSuffix = @"cacheData";
NSString * const WYNetworkCacheInfoFileSuffix = @"cacheInfo";
NSString * const WYNetworkDownloadResumeDataInfoFileSuffix = @"resumeInfo";


@implementation WYNetworkUtils


#pragma mark- ============== Public Methods ==============



+ (NSString * _Nullable)appVersionStr{
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}


+ (NSString * _Nonnull)generateMD5StringFromString:(NSString * _Nonnull)string {
    
    NSParameterAssert(string != nil && [string length] > 0);
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}


+ (NSString * _Nonnull)generateCompleteRequestUrlStrWithBaseUrlStr:(NSString * _Nonnull)baseUrlStr requestUrlStr:(NSString * _Nonnull)requestUrlStr{
    
    NSURL *requestUrl = [NSURL URLWithString:requestUrlStr];
    
    if (requestUrl && requestUrl.host && requestUrl.scheme) {
        return requestUrlStr;
    }
    
    NSURL *url = [NSURL URLWithString:baseUrlStr];
    
    if (baseUrlStr.length > 0 && ![baseUrlStr hasSuffix:@"/"]) {
        url = [url URLByAppendingPathComponent:@""];
    }
    
    return [NSURL URLWithString:requestUrlStr relativeToURL:url].absoluteString;
}


+ (NSString *_Nonnull)generatePartialIdentiferWithBaseUrlStr:(NSString * _Nonnull)baseUrlStr
                                               requestUrlStr:(NSString * _Nullable)requestUrlStr
                                                   methodStr:(NSString * _Nullable)methodStr{
    
    NSString *url_md5 =           nil;
    NSString *method_md5 =        nil;
    NSString *partialIdentifier = nil;
    
    NSString *host_md5 =         [self generateMD5StringFromString: [NSString stringWithFormat:@"Host:%@",baseUrlStr]];
    
    if (requestUrlStr.length == 0 && methodStr.length == 0) {
        
        partialIdentifier = [NSString stringWithFormat:@"%@",host_md5];
        
    }else if (requestUrlStr.length > 0 && methodStr.length == 0) {
        
        url_md5 =          [self generateMD5StringFromString: [NSString stringWithFormat:@"Url:%@",requestUrlStr]];
        partialIdentifier = [NSString stringWithFormat:@"%@_%@",host_md5,url_md5];
        
    }else if (requestUrlStr.length > 0 && methodStr.length > 0){
        
        url_md5 =          [self generateMD5StringFromString: [NSString stringWithFormat:@"Url:%@",requestUrlStr]];
        method_md5 =          [self generateMD5StringFromString: [NSString stringWithFormat:@"Method:%@",methodStr]];
        partialIdentifier = [NSString stringWithFormat:@"%@_%@_%@",host_md5,url_md5,method_md5];
        
    }
    
    return partialIdentifier;
}


+ (NSString * _Nonnull)generateRequestIdentiferWithBaseUrlStr:(NSString * _Nullable)baseUrlStr
                                                requestUrlStr:(NSString * _Nullable)requestUrlStr
                                                    methodStr:(NSString * _Nullable)methodStr
                                                   parameters:(id _Nullable)parameters{
    
    NSString *host_md5 =         [self generateMD5StringFromString: [NSString stringWithFormat:@"Host:%@",baseUrlStr]];
    NSString *url_md5 =          [self generateMD5StringFromString: [NSString stringWithFormat:@"Url:%@",requestUrlStr]];
    NSString *method_md5 =       [self generateMD5StringFromString: [NSString stringWithFormat:@"Method:%@",methodStr]];
    
    NSString *paramsStr = @"";
    NSString *parameters_md5 = @"";
    
    if (parameters) {
        paramsStr =        [self p_convertJsonStringFromDictionaryOrArray:parameters];
        parameters_md5 =   [self generateMD5StringFromString: [NSString stringWithFormat:@"Parameters:%@",paramsStr]];
    }
    
    NSString *requestIdentifer = [NSString stringWithFormat:@"%@_%@_%@_%@",host_md5,url_md5,method_md5,parameters_md5];
//    WYNetworkLog(@"请求接口：%@%@%@", baseUrlStr,requestUrlStr,paramsStr);
    return requestIdentifer;
    
}


+ (NSString * _Nonnull)generateDownloadRequestIdentiferWithBaseUrlStr:(NSString * _Nullable)baseUrlStr requestUrlStr:(NSString * _Nonnull)requestUrlStr{

    NSString *host_md5 =         [self generateMD5StringFromString: [NSString stringWithFormat:@"Host:%@",baseUrlStr]];
    NSString *url_md5 =          [self generateMD5StringFromString: [NSString stringWithFormat:@"Url:%@",requestUrlStr]];

    NSString *requestIdentifer = [NSString stringWithFormat:@"%@_%@_",host_md5,url_md5];

    return requestIdentifer;

}



+ (NSString * _Nonnull)createBasePathWithFolderName:(NSString * _Nonnull)folderName{
    
    NSString *pathOfCache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfCache stringByAppendingPathComponent:folderName];
    [self p_createDirectoryIfNeeded:path];
    return path;
    
}




+ (NSString * _Nonnull)createCacheBasePath{
    
    return [self createBasePathWithFolderName:WYNetworkCacheBaseFolderName];
}




+ (NSString * _Nonnull)cacheDataFilePathWithRequestIdentifer:(NSString * _Nonnull)requestIdentifer{
    
    if (requestIdentifer.length > 0) {
        
        NSString *cacheFileName = [NSString stringWithFormat:@"%@.%@", requestIdentifer,WYNetworkCacheFileSuffix];
        NSString *cacheFilePath = [[self createCacheBasePath] stringByAppendingPathComponent:cacheFileName];
        return cacheFilePath;
        
    }else{
        
        return nil;
        
    }
}




+ (NSString * _Nonnull)cacheDataInfoFilePathWithRequestIdentifer:(NSString * _Nonnull)requestIdentifer{
    
    if (requestIdentifer.length > 0) {
        
        NSString *cacheInfoFileName = [NSString stringWithFormat:@"%@.%@", requestIdentifer,WYNetworkCacheInfoFileSuffix];
        NSString *cacheInfoFilePath = [[self createCacheBasePath] stringByAppendingPathComponent:cacheInfoFileName];
        return cacheInfoFilePath;
        
    }else{
        
        return nil;
        
    }
    
}




+ (NSString * _Nonnull)resumeDataFilePathWithRequestIdentifer:(NSString * _Nonnull)requestIdentifer downloadFileName:(NSString * _Nonnull)downloadFileName{
    
    NSString *dataFileName = [NSString stringWithFormat:@"%@.%@", requestIdentifer, downloadFileName];
    NSString * resumeDataFilePath = [[self createCacheBasePath] stringByAppendingPathComponent:dataFileName];
    return resumeDataFilePath;
}





+ (NSString * _Nonnull)resumeDataInfoFilePathWithRequestIdentifer:(NSString * _Nonnull)requestIdentifer{
    
    NSString * dataInfoFileName = [NSString stringWithFormat:@"%@.%@", requestIdentifer,WYNetworkDownloadResumeDataInfoFileSuffix];
    NSString * resumeDataInfoFilePath = [[self createCacheBasePath] stringByAppendingPathComponent:dataInfoFileName];
    return resumeDataInfoFilePath;
}




+ (BOOL)availabilityOfData:(NSData * _Nonnull)data{
    
    if (!data || [data length] < 1) return NO;
    
    NSError *error;
    NSDictionary *resumeDictionary = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:&error];
    
    if (!resumeDictionary || error) return NO;
    
    // Before iOS 9 & Mac OS X 10.11
#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED < 90000)\
|| (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED < 101100)
    NSString *localFilePath = [resumeDictionary objectForKey:@"NSURLSessionResumeInfoLocalPath"];
    if ([localFilePath length] < 1) return NO;
    return [[NSFileManager defaultManager] fileExistsAtPath:localFilePath];
#endif
    return YES;
}


+ (NSString * _Nullable)imageFileTypeForImageData:(NSData * _Nonnull)imageData{
    
    uint8_t c;
    [imageData getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([imageData length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[imageData subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
}

#pragma mark- ============== Private Methods ==============


+ (NSString *)p_convertJsonStringFromDictionaryOrArray:(id)parameter {
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:parameter
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    NSString *jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSString *encodingJsonString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)jsonStr,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodingJsonString;
}




+ (void)p_createDirectoryIfNeeded:(NSString *)path {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        
        [self p_createBaseDirectoryAtPath:path];
        
    } else {
        
        if (!isDir) {
            
            NSError *error = nil;
            [fileManager removeItemAtPath:path error:&error];
            [self p_createBaseDirectoryAtPath:path];
        }
    }
}




+ (void)p_createBaseDirectoryAtPath:(NSString *)path {

    [[NSFileManager defaultManager] createDirectoryAtPath:path
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
}





@end
