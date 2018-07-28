//
//  WYNetworkConfig.h
//  WYNetWork
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>

/* =============================
 *
 * WYNetworkConfig
 *
 * WYNetworkConfig is in charge of the configuration of all related network requests
 *
 * =============================
 */

@interface WYNetworkConfig : NSObject

// Base url of requests, default is nil
@property (nonatomic, strong) NSString *_Nullable baseUrl;

// Default parameters, default is nil
@property (nonatomic, strong) NSDictionary * _Nullable defailtParameters;

// Custom headers, default is nil
@property (nonatomic, readonly, strong) NSDictionary * _Nullable customHeaders;

// Request timeout seconds, default is 30 (unit is second)
@property (nonatomic, assign) NSTimeInterval timeoutSeconds;

// If debugMode is set to be YES, then print all detail log
@property (nonatomic, assign) BOOL debugMode;



/**
 *  WYNetworkConfig Singleton
 *
 *  @return sharedConfig singleton instance
 */
+ (WYNetworkConfig *_Nullable)sharedConfig;



/**
 *  This method is used to add request headers (key-value pair(or pairs))
 *
 *  @param header               custom header to be added into request
 *
 */
- (void)addCustomHeader:(NSDictionary *_Nonnull)header;


@end
