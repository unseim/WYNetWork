//
//  WYNetworkConfig.m
//  WYNetWork
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
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
        sharedInstance.timeoutSeconds = 20;
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
