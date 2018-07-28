//
//  WYNetworkCache.h
//  WYNetWork
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>

@class WYNetworkRequestModel;
@class WYNetworkDownloadResumeDataInfo;


// Callback when the cache is cleared
typedef void(^WYClearCacheCompletionBlock)(BOOL isSuccess);

// Callback when the cache is loaded
typedef void(^WYLoadCacheCompletionBlock)(id _Nullable cacheObject);

// Callback when cache array is loaded
typedef void(^WYLoadCacheArrCompletionBlock)(NSArray * _Nullable cacheArr);

// Callback when the size of cache is calculated
typedef void(^WYCalculateSizeCompletionBlock)(NSUInteger fileCount, NSUInteger totalSize, NSString * _Nonnull totalSizeString);



/* =============================
 *
 * WYNetworkCacheManager
 *
 * WYNetworkCacheManager is in charge of managing operations of oridinary request cache(and cache info) and resume data (and resume data info)of a certain download request
 *
 * =============================
 */

@interface WYNetworkCacheManager : NSObject



/**
 *  WYNetworkCacheManager Singleton
 *
 *  @return WYNetworkCacheManager singleton instance
 */
+ (WYNetworkCacheManager *_Nonnull)sharedManager;





//============================ Write Cache ============================//

/**
 *  This method is used to write cache(cache data and cache info), 
    can only be called by WYNetworkManager instance
 *
 *  @param requestModel        the model holds the configuration of a specific request
 *  @param asynchronously      if write cache asynchronously
 *
 */
- (void)writeCacheWithReqeustModel:(WYNetworkRequestModel * _Nonnull)requestModel asynchronously:(BOOL)asynchronously;




//============================= Load cache =============================//


/**
 *  This method is used to load cache which is related to a specific url,
    no matter what request method is or parameters are
 *
 *
 *  @param url                  the url of related network requests
 *  @param completionBlock      callback
 *
 */
- (void)loadCacheWithUrl:(NSString * _Nonnull)url completionBlock:(WYLoadCacheArrCompletionBlock _Nullable)completionBlock;




- (void)loadCacheWithUrl:(NSString * _Nonnull)url
                  method:(NSString * _Nonnull)method
         completionBlock:(WYLoadCacheArrCompletionBlock _Nullable)completionBlock;



/**
 *  This method is used to load cache which is related to a specific url,method and parameters
 *
 *  @param url                  the url of the network request
 *  @param method               the method of the network request
 *  @param parameters           the parameters of the network request
 *  @param completionBlock      callback
 *
 */
- (void)loadCacheWithUrl:(NSString * _Nonnull)url
                  method:(NSString * _Nonnull)method
              parameters:(id _Nullable)parameters
         completionBlock:(WYLoadCacheCompletionBlock _Nullable)completionBlock;





/**
 *  This method is used to load cache which is related to a identier which is the unique to a network request,
    can only be called by WYNetworkManager instance
 *
 *  @param requestIdentifer     the unique identier of a specific  network request
 *  @param completionBlock      callback
 *
 */
- (void)loadCacheWithRequestIdentifer:(NSString * _Nonnull)requestIdentifer completionBlock:(WYLoadCacheCompletionBlock _Nullable)completionBlock;





//============================ calculate cache ============================//

/**
 *  This method is used to calculate the size of the cache folder (include ordinary request cache and download resume data file and resume data info file)
 *
 *  @param completionBlock      finish callback
 *
 */
- (void)calculateAllCacheSizecompletionBlock:(WYCalculateSizeCompletionBlock _Nullable)completionBlock;





//============================== clear cache ==============================//

/**
 *  This method is used to clear all cache which is in the cache folder
 *
 *  @param completionBlock      callback
 *
 */
- (void)clearAllCacheCompletionBlock:(WYClearCacheCompletionBlock _Nullable)completionBlock;




/**
 *  This method is used to clear the cache which is related the specific url,
    no matter what request method is or parameters are
 *
 *  @param url                   the url of network request
 *  @param completionBlock       callback
 *
 */
- (void)clearCacheWithUrl:(NSString * _Nonnull)url completionBlock:(WYClearCacheCompletionBlock _Nullable)completionBlock;




- (void)clearCacheWithUrl:(NSString * _Nonnull)url
                   method:(NSString * _Nonnull)method
          completionBlock:(WYClearCacheCompletionBlock _Nullable)completionBlock;


/**
 *  This method is used to clear cache which is related to a specific url,method and parameters
 *
 *  @param url                  the url of the network request
 *  @param method               the method of the network request
 *  @param parameters           the parameters of the network request
 *  @param completionBlock      callback
 *
 */
- (void)clearCacheWithUrl:(NSString * _Nonnull)url
                   method:(NSString * _Nonnull)method
               parameters:(id _Nullable)parameters
          completionBlock:(WYClearCacheCompletionBlock _Nullable)completionBlock;



//============================== Update resume data or resume data info ==============================//

/**
 *  This method is used to update resume data info after suspending a download request
 *
 *  @param requestModel      request model of a network requst
 *
 */
- (void)updateResumeDataInfoAfterSuspendWithRequestModel:(WYNetworkRequestModel *_Nonnull)requestModel;




/**
 *  This method is used to remove resume data and resume data info files
 *
 *  @param requestModel      request model of a network requst
 *
 */
- (void)removeResumeDataAndResumeDataInfoFileWithRequestModel:(WYNetworkRequestModel *_Nonnull)requestModel;





/**
 *  This method is used to remove download data to target download file path and clear the resume data info file
 *
 *  @param requestModel      request model of a network requst
 *
 */
- (void)removeCompleteDownloadDataAndClearResumeDataInfoFileWithRequestModel:(WYNetworkRequestModel *_Nonnull)requestModel;




//============================== Load resume data info ==============================//

/**
 *  This method is used to load resume data info in a given file path
 *
 *  @param filePath          file path
 *
 */
- (WYNetworkDownloadResumeDataInfo *_Nullable)loadResumeDataInfo:(NSString *_Nonnull)filePath;


@end
