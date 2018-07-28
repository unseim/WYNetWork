//
//  WYNetworkCacheInfo.h
//  WYNetWork
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//


#import <Foundation/Foundation.h>


/* =============================
 *
 * WYNetworkCacheInfo
 *
 * WYNetworkCacheInfo is in charge of recording the infomation of cache which is related to a specific network request
 *
 * =============================
 */

@interface WYNetworkCacheInfo : NSObject<NSSecureCoding>

// Record the creation date of the cache
@property (nonatomic, readwrite, strong) NSDate *creationDate;

// Record the length of the period of validity (unit is second)
@property (nonatomic, readwrite, strong) NSNumber *cacheDuration;

// Record the app version when the cache is created
@property (nonatomic, readwrite, copy)   NSString *appVersionStr;

// Record the request identifier of the cache
@property (nonatomic, readwrite, copy)   NSString *reqeustIdentifer;

@end
