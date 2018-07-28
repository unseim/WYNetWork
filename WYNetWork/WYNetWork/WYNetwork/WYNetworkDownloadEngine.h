//
//  WYNetworkDownloadManager.h
//  WYNetWork
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>
#import "WYNetworkBaseEngine.h"


/* =============================
 *
 * WYNetworkDownloadEngine
 *
 * WYNetworkDownloadEngine is in charge of sending downloading requests.
 *
 * =============================
 */

@interface WYNetworkDownloadEngine : WYNetworkBaseEngine


//========================= Request API upload images ==========================//



/**
 *  This method offers the most number of parameters of a certain download request.
 
 *  @note:
 *        1. All the other download file API will call this method.
 *
 *        2. If 'ignoreBaseUrl' is set to be YES, the base url which is holden by
 *           WYNetworkConfig will be ignored, so the 'url' will be the complete request
 *           url of this request.(default is set to be YES)
 *
 *        3. If 'resumable' is set to be YES, incomplete download data will be saved and
 *           when the same request is sent, the saved data will be used.(default is set to be YES)
 *
 *  @param url                      request url
 *  @param ignoreBaseUrl            consider whether to ignore configured base url
 *  @param downloadFilePath         target path of download file
 *  @param resumable                consider whether to save or load resumble data
 *  @param downloadProgressBlock    download progress callback
 *  @param downloadSuccessBlock     download success callback
 *  @param downloadFailureBlock     download failure callback
 *
 */
- (void)sendDownloadRequest:(NSString * _Nonnull)url
              ignoreBaseUrl:(BOOL)ignoreBaseUrl
           downloadFilePath:(NSString *_Nonnull)downloadFilePath
                  resumable:(BOOL)resumable
          backgroundSupport:(BOOL)backgroundSupport
                   progress:(WYDownloadProgressBlock _Nullable)downloadProgressBlock
                    success:(WYDownloadSuccessBlock _Nullable)downloadSuccessBlock
                    failure:(WYDownloadFailureBlock _Nullable)downloadFailureBlock;





/**
 *  This method is used to suspend all current download requests
 */
- (void)suspendAllDownloadRequests;




/**
 *  This method is used to suspend a download request with given url
 *
 *  @param url                   download url
 *
 */
- (void)suspendDownloadRequest:(NSString * _Nonnull)url;




/**
 *  This method is used to suspend a download request with given url which contains the baseUrl or not
 *
 *  @param url                   download url
 *  @param ignoreBaseUrl         ignore baseUrl or not
 *
 */
- (void)suspendDownloadRequest:(NSString * _Nonnull)url ignoreBaseUrl:(BOOL)ignoreBaseUrl;




/**
 *  This method is used to suspend one nor more download requests with given urls array
 *
 *  @param urls                   download url array
 *
 */
- (void)suspendDownloadRequests:(NSArray *_Nonnull)urls;




/**
 *  This method is used to suspend one nor more download requests with given urls which contain the baseUrl or not
 *
 *  @param urls                   download url array
 *  @param ignoreBaseUrl          ignore baseUrl or not
 *
 */
- (void)suspendDownloadRequests:(NSArray *_Nonnull)urls ignoreBaseUrl:(BOOL)ignoreBaseUrl;





/**
 *  This method is used to resume all suspended download requests
 */
- (void)resumeAllDownloadRequests;





/**
 *  This method is used to resume a suspended request with given url
 *
 *  @param url                   download url
 *
 */
- (void)resumeDownloadReqeust:(NSString *_Nonnull)url;




/**
 *  This method is used to resume a suspended request with given url which contains the baseUrl or not
 *
 *  @param url                   download url
 *  @param ignoreBaseUrl         ignore baseUrl or not
 *
 */
- (void)resumeDownloadReqeust:(NSString *_Nonnull)url ignoreBaseUrl:(BOOL)ignoreBaseUrl;




/**
 *  This method is used to resume one nor more suspended requests with given urls array
 *
 *  @param urls                   download url array
 *
 */
- (void)resumeDownloadReqeusts:(NSArray *_Nonnull)urls;




/**
 *  This method is used to suspend one nor more suspended requests with given urls which contain the baseUrl or not
 *
 *  @param urls                   download url array
 *  @param ignoreBaseUrl          ignore baseUrl or not
 *
 */
- (void)resumeDownloadReqeusts:(NSArray *_Nonnull)urls ignoreBaseUrl:(BOOL)ignoreBaseUrl;





/**
 *  This method is used to cancel all current download requests
 */
- (void)cancelAllDownloadRequests;





/**
 *  This method is used to cancel a current download request with given url
 *
 *  @param url                   download url
 *
 */
- (void)cancelDownloadRequest:(NSString * _Nonnull)url;





/**
 *  This method is used to cancel a current download request with given url which contains the baseUrl or not
 *
 *  @param url                   download url
 *  @param ignoreBaseUrl         ignore baseUrl or not
 *
 */
- (void)cancelDownloadRequest:(NSString * _Nonnull)url ignoreBaseUrl:(BOOL)ignoreBaseUrl;





/**
 *  This method is used to cancel one nor more current download requests with given urls array
 *
 *  @param urls                   download url array
 *
 */
- (void)cancelDownloadRequests:(NSArray *_Nonnull)urls;




/**
 *  This method is used to cancel one nor more current download requests with given urls which contain the baseUrl or not
 *
 *  @param urls                   download url array
 *  @param ignoreBaseUrl          ignore baseUrl or not
 *
 */
- (void)cancelDownloadRequests:(NSArray *_Nonnull)urls ignoreBaseUrl:(BOOL)ignoreBaseUrl;






/**
 *  This method is used to get incomplete download data ratio of a download request with a given download url
 *
 *  @param url                    download url
 *
 *  @return incomplete download data ratio
 */
- (CGFloat)resumeDataRatioOfRequest:(NSString *_Nonnull)url;





/**
 *  This method is used to get incomplete download data ratio of a download request with a given download url which contains the baseUrl or not
 *
 *  @param url                    download url
 *  @param ignoreBaseUrl          ignore baseUrl or not
 *
 *  @return incomplete download data ratio
 */
- (CGFloat)resumeDataRatioOfRequest:(NSString *_Nonnull)url ignoreBaseUrl:(BOOL)ignoreBaseUrl;


@end
