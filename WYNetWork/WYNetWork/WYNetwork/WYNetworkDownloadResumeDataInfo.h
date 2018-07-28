//
//  WYNetworkResumeDataInfo.h
//  WYNetWork
//  博客地址：https://www.wncblog.top
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import <Foundation/Foundation.h>


/* =============================
 *
 * WYNetworkDownloadResumeDataInfo
 *
 * WYNetworkDownloadResumeDataInfo is in charge of recording the infomation of resume data of the corresponding download request
 *
 * =============================
 */

@interface WYNetworkDownloadResumeDataInfo : NSObject<NSSecureCoding>

// Record the resume data length
@property (nonatomic, readwrite, copy) NSString *resumeDataLength;

// Record total length of the download data
@property (nonatomic, readwrite, copy) NSString *totalDataLength;

// Record the ratio of resume data length and total length of download data (resumeDataLength/dataTotalLength)
@property (nonatomic, readwrite, copy) NSString *resumeDataRatio;


@end

