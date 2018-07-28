//
//  WYNetworkCacheInfo.m
//  WYNetWork
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "WYNetworkCacheInfo.h"

@implementation WYNetworkCacheInfo

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.cacheDuration forKey:NSStringFromSelector(@selector(cacheDuration))];
    [aCoder encodeObject:self.creationDate forKey:NSStringFromSelector(@selector(creationDate))];
    [aCoder encodeObject:self.appVersionStr forKey:NSStringFromSelector(@selector(appVersionStr))];
    [aCoder encodeObject:self.reqeustIdentifer forKey:NSStringFromSelector(@selector(reqeustIdentifer))];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [self init];
    
    if (self) {
        
        self.cacheDuration = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(cacheDuration))];
        self.creationDate = [aDecoder decodeObjectOfClass:[NSDate class] forKey:NSStringFromSelector(@selector(creationDate))];
        self.appVersionStr = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(appVersionStr))];
        self.reqeustIdentifer = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(reqeustIdentifer))];
    }

    return self;
}

- (NSString *)description{

    return [NSString stringWithFormat:@"{cacheDuration:%@},{creationDate:%@},{appVersion:%@},{requestIdentifer:%@}",_cacheDuration,_creationDate,_appVersionStr,_reqeustIdentifer];
}

@end
