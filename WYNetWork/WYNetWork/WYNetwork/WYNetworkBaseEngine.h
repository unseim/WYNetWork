//
//  WYNetworkBaseEngine.h
//  WYNetWork
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>
#import "WYNetworkRequestModel.h"


@interface WYNetworkBaseEngine : NSObject


/**
 *  This method is used to add customed headers, for subclass to override
 */
- (void)addCustomHeaders;



/**
 *  This method is used to add default parameters with custom parameters, for subclass to override
 *
 *  @param parameters        custom parameters
 *
 */
- (id)addDefaultParametersWithCustomParameters:(id)parameters;




/**
 *  This method is used to execute some operation with the request model when the corresponding request succeed, for subclass to override
 *
 *  @param requestModel      request model of a network request
 *
 */
- (void)requestDidSucceedWithRequestModel:(WYNetworkRequestModel *)requestModel;



@end
