//
//  WYNetworkHeader.h
//  WYNetWork
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#ifndef WYNetworkHeader_h
#define WYNetworkHeader_h

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

//Log used to debug
#ifdef DEBUG
#define WYNetworkLog(...) printf("\n%s  ---->  %s\n",__TIME__,[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#else
#define WYNetworkLog(...)
#endif


//============== Callbacks: Only for ordinary request ==================//
typedef void(^WYSuccessBlock)(id responseObject, BOOL isCacheObject);
typedef void(^WYFailureBlock)(NSURLSessionTask *task, NSError *error, NSInteger statusCode);


//============== Callbacks: Only for upload request ==================//
typedef void(^WYUploadSuccessBlock)(id responseObject);
typedef void(^WYUploadProgressBlock)(NSProgress *uploadProgress);
typedef void(^WYUploadFailureBlock)(NSURLSessionTask *task, NSError *error, NSInteger statusCode, NSArray<UIImage *>*uploadFailedImages);


//============== Callbacks: Only for download request ==================//
typedef void(^WYDownloadSuccessBlock)(id responseObject);
typedef void(^WYDownloadProgressBlock)(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress);
typedef void(^WYDownloadFailureBlock)(NSURLSessionTask *task, NSError *error, NSString* resumableDataPath);


/** 网络请求方方式 */
typedef NS_ENUM(NSInteger, WYRequestMethod) {
    
    WYRequestMethodGET = 60000,
    WYRequestMethodPOST,
    WYRequestMethodPUT,
    WYRequestMethodDELETE,
    
};


/** 网络请求方式 */
typedef NS_ENUM(NSInteger, WYRequestType) {
    
    WYRequestTypeOrdinary = 70000,  //  普通请求
    WYRequestTypeUpload,            //  上传
    WYRequestTypeDownload           //  下载
    
};


/** 下载状态 */
typedef NS_ENUM(NSInteger, WYDownloadManualOperation) {
    
    WYDownloadManualOperationStart = 80000, //  开始下载
    WYDownloadManualOperationSuspend,       //  暂停下载
    WYDownloadManualOperationResume,        //  继续加载
    WYDownloadManualOperationCancel,        //  取消下载
    
};


/** 请求序列化方式 */
typedef NS_ENUM(NSUInteger, WYRequestSerializer) {
    
    WYJSONRequestSerializer = 90000,
    WYHTTPRequestSerializer,
    WYJSONHTTPRequestSerializer
    
};


/** 网络请求缓存策略 */
typedef NS_ENUM(NSUInteger, WYNetworkCacheType) {
    
    WYNetworkCacheTypeCacheNetwork = 50000,      //  先加载网络数据，当发生断网或者链接错误的时候加载缓存数据
    WYNetworkCacheTypeNetworkOnly,               //  只加载网络数据
    WYNetworkCacheTypeNetworkOnlyOneOfCache      //  第一次加载网络数据,以后加载都加载缓存
    
};


/** 图片压缩策略 */
typedef NS_ENUM(NSUInteger, WYUploadCompressType) {
    
    WYWYUploadCompresArtwork = 40000,       //  原图上传，不进行压缩
    WYUploadCompressWeiChat,                //  仿照微信压缩      （仿照微信的压缩比例）
    WYUploadCompressEqualProportion,        //  图像等比例缩小压缩 （宽度参照 1242 进行等比例缩小）
    WYUploadCompressTwoPoints               //  采用二分法压缩    （最接近压缩比例）
};





#endif /* WYNetworkHeader_h */
