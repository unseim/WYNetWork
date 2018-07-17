//
//  WYImageScaleTool.m
//  WYNetWork
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "WYImageScaleTool.h"
#import "WYNetworkConfig.h"
#import "WYNetworkHeader.h"

@implementation WYImageScaleTool

+ (instancetype)sharedManager {
    
    static WYImageScaleTool *_instace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[WYImageScaleTool alloc] init];
    });
    return _instace;
}



#pragma mark- ============== Public Methods ==============


/** 仿微信压缩图像 */
+ (NSData *)compressOfImageWithWeiChat:(UIImage *)source_image
                               maxSize:(NSInteger)maxSize {
    
    CGFloat compression    = 1.0f;
    CGFloat minCompression = 0.5f;
    NSData * imageData = UIImageJPEGRepresentation(source_image, compression);
    CGFloat imageFileSize = imageData.length / 1024;
    
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    if ([WYNetworkConfig sharedConfig].debugMode) {
        WYNetworkLog(@"原图大小 = %lu Kb", (unsigned long)imageData.length/1024);
    }
    
    
    WYImageScaleTool *tool = [WYImageScaleTool sharedManager];
    UIImage *newImage = [tool Compresimage:source_image];
    
    
    // 每次减少的比例
    float scale = 0.05;
    // 循环条件：没到最小压缩比例，且没压缩到目标大小
    while ((compression > minCompression) &&
           (imageFileSize > maxSize))
    {
        compression -= scale;
        imageData = UIImageJPEGRepresentation(newImage,
                                              compression);
        
//        WYNetworkLog(@"\n压缩比 -> %g, \n压缩后的大小 -> %lu Kb, \n缩放后的大小 -> %lu Kb, \n原图大小 -> %lu Kb", compression, (unsigned long)imageData.length/1024, (unsigned long)scaleData.length/1024, (unsigned long)originalData.length/1024);
        
    }
    
    CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
    if ([WYNetworkConfig sharedConfig].debugMode) {
        WYNetworkLog(@"压缩时间  = %.4lf s,  压缩后图片大小 = %lu Kb", linkTime, (unsigned long)imageData.length/1024);
    }
    
    return imageData;
}


/** 二分法压缩图像 */
+ (NSData *)compressOfImageWithTwoPoints:(UIImage *)source_image maxSize:(NSInteger)maxSize {
    
    // 先判断当前质量是否满足要求，不满足再进行压缩
    __block NSData *finallImageData = UIImageJPEGRepresentation(source_image,1.0);
    NSUInteger sizeOrigin   = finallImageData.length;
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    
    if (sizeOriginKB <= maxSize) {
        return finallImageData;
    }
    
    WYImageScaleTool *tool = [WYImageScaleTool sharedManager];
    
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    if ([WYNetworkConfig sharedConfig].debugMode) {
        WYNetworkLog(@"原图大小 = %lu Kb", (unsigned long)finallImageData.length/1024);
    }
    
    
    // 先调整分辨率
    CGSize defaultSize = CGSizeMake(1024, 1024);
    UIImage *newImage = [tool newSizeImage:defaultSize image:source_image];
    finallImageData = UIImageJPEGRepresentation(newImage,1.0);
    
    
    // 保存压缩系数
    NSMutableArray *compressionQualityArr = [NSMutableArray array];
    CGFloat avg   = 1.0/250;
    CGFloat value = avg;
    for (int i = 250; i >= 1; i--) {
        value = i*avg;
        [compressionQualityArr addObject:@(value)];
    }
    
    /* 调整大小 压缩系数数组compressionQualityArr是从大到小存储。 */
    /** 使用二分法搜索 */
    finallImageData = [tool halfFuntion:compressionQualityArr image:newImage sourceData:finallImageData maxSize:maxSize];
    
    //如果还是未能压缩到指定大小，则进行降分辨率
    while (finallImageData.length == 0) {
        //每次降100分辨率
        if (defaultSize.width-100 <= 0 || defaultSize.height-100 <= 0) {
            break;
        }
        defaultSize = CGSizeMake(defaultSize.width-100, defaultSize.height-100);
        UIImage *image = [tool newSizeImage:defaultSize
                                      image:[UIImage imageWithData:UIImageJPEGRepresentation(newImage,[[compressionQualityArr lastObject] floatValue])]];
        finallImageData = [tool halfFuntion:compressionQualityArr image:image sourceData:UIImageJPEGRepresentation(image,1.0) maxSize:maxSize];
    }
    
    
    CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
    if ([WYNetworkConfig sharedConfig].debugMode) {
        WYNetworkLog(@"压缩时间  = %.4lf s,  压缩后图片大小 = %lu Kb", linkTime, (unsigned long)finallImageData.length/1024);
    }
    
    return finallImageData;
}





/** 等比例缩小图像压缩 */
+ (NSData *)compressOfImageWithEqualProportion:(UIImage *)source_image maxSize:(NSInteger)maxSize {
    
    CGFloat compression    = 1.0f;
    CGFloat minCompression = 0.5f;
    NSData * imageData = UIImageJPEGRepresentation(source_image, compression);
    
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    if ([WYNetworkConfig sharedConfig].debugMode) {
        WYNetworkLog(@"原图大小 = %lu Kb", (unsigned long)imageData.length/1024);
    }
    
    CGFloat imageFileSize = imageData.length / 1024;
    WYImageScaleTool *tool = [WYImageScaleTool sharedManager];
    UIImage *newImage = [tool scaleToWidth:1242 scaleImage:source_image];
    
    
    // 每次减少的比例
    float scale = 0.05;
    // 循环条件：没到最小压缩比例，且没压缩到目标大小
    while ((compression > minCompression) &&
           (imageFileSize > maxSize))
    {
        compression -= scale;
        imageData = UIImageJPEGRepresentation(newImage,
                                              compression);
        
//        WYNetworkLog(@"\n压缩比 -> %g, \n压缩后的大小 -> %lu Kb, \n缩放后的大小 -> %lu Kb, \n原图大小 -> %lu Kb", compression, (unsigned long)imageData.length/1024, (unsigned long)scaleData.length/1024, (unsigned long)originalData.length/1024);
        
    }
    
    CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
    if ([WYNetworkConfig sharedConfig].debugMode) {
        WYNetworkLog(@"压缩时间  = %.4lf s,  压缩后图片大小 = %lu Kb", linkTime, (unsigned long)imageData.length/1024);
    }
    
    return imageData;
}










#pragma mark- ============== Private Methods ==============


/** 调整图片分辨率/尺寸（等比例缩放） */
- (UIImage *)newSizeImage:(CGSize)size image:(UIImage *)source_image {
    
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);
    CGFloat tempHeight = newSize.height / size.height;
    CGFloat tempWidth = newSize.width / size.width;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight, source_image.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



/** 二分法压缩 */
- (NSData *)halfFuntion:(NSArray *)arr image:(UIImage *)image sourceData:(NSData *)finallImageData maxSize:(NSInteger)maxSize {
    
    NSData *tempData = [NSData data];
    NSUInteger start = 0;
    NSUInteger end = arr.count - 1;
    NSUInteger index = 0;
    
    NSUInteger difference = NSIntegerMax;
    while(start <= end) {
        index = start + (end - start)/2;
        
        finallImageData = UIImageJPEGRepresentation(image,[arr[index] floatValue]);
        
        NSUInteger sizeOrigin = finallImageData.length;
        NSUInteger sizeOriginKB = sizeOrigin / 1024;
        
//        WYNetworkLog(@"当前降到的质量 -> %ld 压缩系数 -> %lg", (unsigned long)sizeOriginKB,  [arr[index] floatValue]);
        
        
        if (sizeOriginKB > maxSize) {
            start = index + 1;
        } else if (sizeOriginKB < maxSize) {
            if (maxSize-sizeOriginKB < difference) {
                difference = maxSize-sizeOriginKB;
                tempData = finallImageData;
            }
            if (index<=0) {
                break;
            }
            end = index - 1;
        } else {
            break;
        }
    }
    return tempData;
}




/** 在原有基础上图像等比例缩放 */
- (UIImage *)scaleToWidth:(CGFloat)width scaleImage:(UIImage *)image {
    
    if (width > image.size.width) {
        return  image;
    }
    CGFloat height = (width / image.size.width) * image.size.height;
    CGRect  rect = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


/** 仿照微信朋友圈图像缩放比例进行缩放图片 */
- (UIImage *)Compresimage:(UIImage *)image {
    
    CGSize size = [self CompressSizeImage:image];
    UIImage *reImage = [self resizedImage:size image:image];
    return reImage;
}


- (CGSize)CompressSizeImage:(UIImage *)image {
    
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat boundary = 1280;
    
    if (width < boundary && height < boundary) {
        return CGSizeMake(width, height);
    }
    
    CGFloat ratio = MAX(width, height) / MIN(width, height);
    if (ratio <= 2) {
        CGFloat x = MAX(width, height) / boundary;
        if (width > height) {
            width = boundary;
            height = height / x;
        } else {
            height = boundary;
            width = width / x;
        }
    } else {
        if (MIN(width, height) >= boundary) {
            CGFloat x = MIN(width, height) / boundary;
            if (width < height) {
                width = boundary;
                height = height / x;
            } else {
                height = boundary;
                width = width / x;
            }
        }
    }
    
    return CGSizeMake(width, height);
}


- (UIImage *)resizedImage:(CGSize)newSize image:(UIImage *)image {
    
    CGRect newRect = CGRectMake(0, 0, newSize.width, newSize.height);
    UIGraphicsBeginImageContext(newRect.size);
    UIImage *newImage = [[UIImage alloc] initWithCGImage:image.CGImage scale:1 orientation:image.imageOrientation];
    [newImage drawInRect:newRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
