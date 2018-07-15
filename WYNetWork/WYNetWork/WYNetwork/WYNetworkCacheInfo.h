//
//  WYNetworkCacheInfo.h
//  WYNetWork
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
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
