//
//  WYNetworkRequestPool.h
//  WYNetWork
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>


@class WYNetworkRequestModel;


/* =============================
 *
 * WYNetworkRequestPool
 *
 * WYNetworkRequestPool is in charge of managing current requests (holding request models,
 *  add or remove request models, cancel current requests etc)
 *
 * =============================
 */


/**
 *  WYCurrentRequestModels: A dictionary which is used to hold all current request models
 */
typedef NSMutableDictionary<NSString *, WYNetworkRequestModel *> WYCurrentRequestModels;


@interface WYNetworkRequestPool : NSObject


//============================= Initialization =============================//


/**
 *  WYNetworkRequestPool Singleton
 *
 *  @return WYNetworkRequestPool singleton instance
 */
+ (WYNetworkRequestPool *_Nonnull)sharedPool;



//============================= Requests Management =============================//

/**
 *  This method is used to return all current request models
 *
 *  @return currentRequestModels    all current request models set(NSDictionary)
 */
- (WYCurrentRequestModels *_Nonnull)currentRequestModels;




/**
 *  This method is used to add a request model into current request models set
 */
- (void)addRequestModel:(WYNetworkRequestModel *_Nonnull)requestModel;



/**
 *  This method is used to remove a request model from current request models set
 */
- (void)removeRequestModel:(WYNetworkRequestModel *_Nonnull)requestModel;




/**
 *  This method is used to exchange a new request model with an old one
 */
- (void)changeRequestModel:(WYNetworkRequestModel *_Nonnull)requestModel forKey:(NSString *_Nonnull)key;



//============================= Requests Info =============================//



/**
 *  This method is used to check if there is remaining curent request
 *
 *  @return if there is remaining requests
 */
- (BOOL)remainingCurrentRequests;



/**
 *  This method is used to calculate the count of current requests
 *
 *  @return the count of current requests
 */
- (NSInteger)currentRequestCount;




/**
 *  This method is used to log all current requests' information
 */
- (void)logAllCurrentRequests;





//============================= Cancel requests =============================//


/**
 *  This method is used to cancel all current requests
 */
- (void)cancelAllCurrentRequests;





/**
 *  This method is used to cancel all current requests corresponding a reqeust url,
 *  no matter what the method is and parameters are
 *
 *  @param url              request url
 *
 */
- (void)cancelCurrentRequestWithUrl:(NSString * _Nonnull)url;





/**
 *  This method is used to cancel all current requests corresponding given reqeust urls,
 *  no matter what the method is and parameters are
 *
 *  @param urls              request url
 *
 */
- (void)cancelCurrentRequestWithUrls:(NSArray * _Nonnull)urls;






/**
 *  This method is used to cancel all current requests corresponding a specific reqeust url, method and parameters
 *
 *  @param url              request url
 *  @param method           request method
 *  @param parameters       parameters
 *
 */
- (void)cancelCurrentRequestWithUrl:(NSString * _Nonnull)url
                             method:(NSString * _Nonnull)method
                         parameters:(id _Nullable)parameters;



@end
