//
//  WYNetworkConfig.m
//  WYNetWork
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "WYNetworkConfig.h"

@interface WYNetworkConfig()

@property (nonatomic, readwrite, strong) NSDictionary *customHeaders;

@end

@implementation WYNetworkConfig

+ (WYNetworkConfig *)sharedConfig {
    
    static WYNetworkConfig *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.timeoutSeconds = 30;
    });
    return sharedInstance;
}


- (void)addCustomHeader:(NSDictionary *)header{
    
    if (![header isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    if ([[header allKeys] count] == 0) {
        return;
    }
    
    if (!_customHeaders) {
         _customHeaders = header;
        return;
    }
    
    //add custom header
    NSMutableDictionary *headers_m = [_customHeaders mutableCopy];
    [header enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL * _Nonnull stop) {
        [headers_m setObject:value forKey:key];
    }];
    
    _customHeaders = [headers_m copy];
    
}


@end
