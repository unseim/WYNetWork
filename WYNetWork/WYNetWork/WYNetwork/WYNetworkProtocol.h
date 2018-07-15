//
//  WYNetworkProtocol.h
//  WYNetWork
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>

@class WYNetworkRequestModel;

@protocol WYNetworkProtocol <NSObject>

@required

/**
 *  This method is used to deal with the request model when the corresponding request is finished
 *
 *  @param requestModel      request model of a network request
 *
 */
- (void)handleRequesFinished:(WYNetworkRequestModel *)requestModel;



@end
