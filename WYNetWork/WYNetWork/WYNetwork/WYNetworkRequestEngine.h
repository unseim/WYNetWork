//
//  WYNetworkRequestManager.h
//  WYNetWork
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>
#import "WYNetworkBaseEngine.h"

/* =============================
 *
 * WYNetworkRequestEngine
 *
 * WYNetworkRequestEngine is in charge of sending GET,POST,PUT or DELETE requests.
 *
 * =============================
 */

@interface WYNetworkRequestEngine : WYNetworkBaseEngine



/**
 *  This method offers the most number of parameters of a certain network request.
 *
 *
 *  @note:
 *
 *        1. WYRequestMethod:
 *
 *             a) If the method is set to be 'WYRequestMethodGET', then send GET request
 *             b) If the method is set to be 'WYRequestMethodPOST', then send POST request
 *             c) If the method is set to be 'WYRequestMethodPUT', then send PUT request
 *             d) If the method is set to be 'WYRequestMethodDELETE', then send DELETE request
 *
 *
 *        2. If 'loadCache' is set to be YES, then cache will be tried to
 *           load before sending network request no matter if the cache exists:
 *           If it exists, then load it and callback immediately.
 *           If it dose not exist,then send network request.
 *
 *           If 'loadCache' is set to be NO, then no matter if the cache
 *           exists, network request will be sent.
 *
 *
 *        3. If 'cacheDuration' is set to be large than 0,
 *           then the cache of this request will be written and
 *           the available duration of this cache will be equal to 'cacheDuration'.
 *
 *           So, if the past time is longer than the settled time duration,
 *           the network request will be sent.
 *
 *           If 'cacheDuration' is set to be less or equal to 0, then the cache
 *           of this request will not be written(The unit of cacheDuration is second).
 *
 *
 *  @param serializer         json or http
 *  @param url                request url
 *  @param method             request method
 *  @param parameters         parameters
 *  @param cacheType          first load cache,then load networt data or only load load networt
 *  @param cacheDuration      consider whether to write cache unit/day (default 30)
 *  @param successBlock       success callback
 *  @param failureBlock       failure callback
 *
 */
- (void)sendRequest:(WYRequestSerializer)serializer
                url:(NSString * _Nonnull)url
             method:(WYRequestMethod)method
         parameters:(id _Nullable)parameters
           cacheType:(WYNetworkCacheType)cacheType
      cacheDuration:(NSTimeInterval)cacheDuration
            success:(WYSuccessBlock _Nullable)successBlock
            failure:(WYFailureBlock _Nullable)failureBlock;


@end
