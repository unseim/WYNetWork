//
//  WYNetworkUploadManager.h
//  WYNetWork
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>
#import "WYNetworkBaseEngine.h"


/* =============================
 *
 * WYNetworkUploadEngine
 *
 * WYNetworkUploadEngine is in charge of upload image or images.
 *
 * =============================
 */


@interface WYNetworkUploadEngine : WYNetworkBaseEngine


//========================= Request API upload images ==========================//


/**
 *  This method offers the most number of parameters of a certain upload request.
 *
 *  @note:
 *        1. All the other upload image API will call this method.
 *
 *        2. If 'ignoreBaseUrl' is set to be YES, the base url which is holden by
 *           WYNetworkConfig will be ignored, so the 'url' will be the complete request
 *           url of this request.(default is set to be NO)
 *
 *        3. 'name' is the name of image(or images). When uploading more than one
 *           image, a new unique name of one single image will be generated in method
 *           implementation.
 *
 *  @param serializer            json or http
 *  @param url                   request url
 *  @param ignoreBaseUrl         consider whether to ignore configured base url
 *  @param parameters            parameters
 *  @param images                UIImage object array
 *  @param compressSize          compress size of images
 *  @param compressType          compress size of type
 *  @param name                  file name
 *  @param mimeType              file type
 *  @param uploadProgressBlock   upload progress callback
 *  @param uploadSuccessBlock    upload success callback
 *  @param uploadFailureBlock    upload failure callback
 *
 */
- (void)sendUploadImagesRequest:(WYRequestSerializer)serializer
                            url:(NSString * _Nonnull)url
                  ignoreBaseUrl:(BOOL)ignoreBaseUrl
                     parameters:(id _Nullable)parameters
                         images:(NSArray<UIImage *> * _Nonnull)images
                   compressSize:(float)compressSize
                   compressType:(WYUploadCompressType)compressType
                           name:(NSString * _Nonnull)name
                       mimeType:(NSString * _Nullable)mimeType
                       progress:(WYUploadProgressBlock _Nullable)uploadProgressBlock
                        success:(WYUploadSuccessBlock _Nullable)uploadSuccessBlock
                        failure:(WYUploadFailureBlock _Nullable)uploadFailureBlock;




@end
