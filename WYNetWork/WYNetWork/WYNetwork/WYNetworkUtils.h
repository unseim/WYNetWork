//
//  WYNetworkUtils.h
//  WYNetWork
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>


/* =============================
 *
 * WYNetworkUtils
 *
 * WYNetworkUtils is in charge of some operation of string or generate information
 *
 * =============================
 */

extern NSString * _Nonnull const WYNetworkCacheBaseFolderName;
extern NSString * _Nonnull const WYNetworkCacheFileSuffix;
extern NSString * _Nonnull const WYNetworkCacheInfoFileSuffix;
extern NSString * _Nonnull const WYNetworkDownloadResumeDataInfoFileSuffix;


@interface WYNetworkUtils : NSObject


/**
 *  This method is used to return app version
 *
 *  @return app version string
 */
+ (NSString * _Nullable)appVersionStr;



/**
 *  This method is used to generate the md5 string of given string
 *
 *  @param string                       original string
 *
 *  @return the transformed md5 string
 */
+ (NSString * _Nonnull)generateMD5StringFromString:(NSString *_Nonnull)string;




/**
 *  This method is used to generate complete request url
 *
 *  @param baseUrlStr                   base url
 *  @param requestUrlStr                request url
 *
 *  @return the complete request url
 */
+ (NSString *_Nonnull)generateCompleteRequestUrlStrWithBaseUrlStr:(NSString *_Nonnull)baseUrlStr requestUrlStr:(NSString *_Nonnull)requestUrlStr;





/**
 *  This method is used to generate partial identifier of more than one request
 *
 *  @param baseUrlStr                   base url
 *  @param requestUrlStr                request url
 *  @param methodStr                       request method
 *
 *  @return the unique identifier  of a specific request
 */
+ (NSString *_Nonnull)generatePartialIdentiferWithBaseUrlStr:(NSString * _Nonnull)baseUrlStr
                                               requestUrlStr:(NSString * _Nullable)requestUrlStr
                                                   methodStr:(NSString * _Nullable)methodStr;





/**
 *  This method is used to generate unique identifier of a specific request
 *
 *  @param baseUrlStr                   base url
 *  @param requestUrlStr                request url
 *  @param methodStr                    request method
 *  @param parameters                   parameters (can be nil)
 *
 *  @return the unique identifier  of a specific request
 */
+ (NSString *_Nonnull)generateRequestIdentiferWithBaseUrlStr:(NSString * _Nullable)baseUrlStr
                                               requestUrlStr:(NSString * _Nullable)requestUrlStr
                                                   methodStr:(NSString * _Nullable)methodStr
                                                  parameters:(id _Nullable)parameters;



/**
 *  This method is used to generate unique identifier of a download request
 *
 *  @param baseUrlStr                   base url
 *  @param requestUrlStr                request url
 *
 *  @return the unique identifier of a download request
 */
+ (NSString * _Nonnull)generateDownloadRequestIdentiferWithBaseUrlStr:(NSString * _Nullable)baseUrlStr requestUrlStr:(NSString * _Nonnull)requestUrlStr;




/**
 *  This method is used to create a folder of a given folder name
 *
 *  @param folderName                   folder name
 *
 *  @return the full path of the new folder
 */
+ (NSString * _Nonnull)createBasePathWithFolderName:(NSString * _Nonnull)folderName;





/**
 *  This method is used to create cache base folder path
 *
 *
 *  @return the base cache  folder path
 */
+ (NSString * _Nonnull)createCacheBasePath;




/**
 *  This method is used to return the cache data file path of the given requestIdentifer
 *
 *  @param requestIdentifer     the unique identier of a specific  network request
 *
 *  @return the cache data file path
 */
+ (NSString * _Nonnull)cacheDataFilePathWithRequestIdentifer:(NSString * _Nonnull)requestIdentifer;





/**
 *  This method is used to return the cache data file path of the given requestIdentifer
 *
 *  @param requestIdentifer     the unique identier of a specific  network request
 *
 *  @return the cache data file path
 */
+ (NSString * _Nonnull)cacheDataInfoFilePathWithRequestIdentifer:(NSString * _Nonnull)requestIdentifer;





/**
 *  This method is used to return resume data file path of the given requestIdentifer
 *
 *  @param requestIdentifer     the unique identier of a specific  network request
 *  @param downloadFileName     the download file name (the last path component of a complete download request url)
 *
 *  @return resume data file path
 */
+ (NSString * _Nonnull)resumeDataFilePathWithRequestIdentifer:(NSString * _Nonnull)requestIdentifer downloadFileName:(NSString * _Nonnull)downloadFileName;




/**
 *  This method is used to return the resume data info file path of the given requestIdentifer
 *
 *  @param requestIdentifer     the unique identier of a specific  network request
 *
 *  @return the resume data info file path
 */
+ (NSString * _Nonnull)resumeDataInfoFilePathWithRequestIdentifer:(NSString * _Nonnull)requestIdentifer;




/**
 *  This method is used to check the availability of given data
 *
 *  @param data                 NSData object (can be a cache data of cache info data etc.)
 *
 *  @return the availability of a given data
 */
+ (BOOL)availabilityOfData:(NSData * _Nonnull)data;





/**
 *  This method is used to generate image file type string of a certain image data
 *
 *  @param imageData            image data
 *
 *  @return image file type
 */
+ (NSString * _Nullable)imageFileTypeForImageData:(NSData * _Nonnull)imageData;


@end
