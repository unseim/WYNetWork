//
//  WYImageScaleTool.h
//  WYNetWork
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WYImageScaleTool : NSObject


/** 仿微信压缩图像
 
 宽高均 <= 1280，图片尺寸大小保持不变
 宽或高 > 1280 && 宽高比 <= 2，取较大值等于1280，较小值等比例压缩
 宽或高 > 1280 && 宽高比 > 2 && 宽或高 < 1280，图片尺寸大小保持不变
 宽高均 > 1280 && 宽高比 > 2，取较小值等于1280，较大值等比例压缩
 
 */
+ (NSData *)compressOfImageWithWeiChat:(UIImage *)source_image
                               maxSize:(NSInteger)maxSize;


/** 等比例缩小图像压缩 图像宽度参照 1242 进行等比例压缩 */
+ (NSData *)compressOfImageWithEqualProportion:(UIImage *)source_image
                                       maxSize:(NSInteger)maxSize;


/** 二分法压缩图像 */
+ (NSData *)compressOfImageWithTwoPoints:(UIImage *)source_image
                                 maxSize:(NSInteger)maxSize;




@end
