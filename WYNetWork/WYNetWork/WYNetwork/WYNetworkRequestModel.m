//
//  WYNetworkRequestModel.m
//  WYNetWork
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "WYNetworkRequestModel.h"
#import "WYNetworkConfig.h"
#import "WYNetworkUtils.h"

@interface WYNetworkRequestModel()

@property (nonatomic, readwrite, copy) NSString *cacheDataFilePath;
@property (nonatomic, readwrite, copy) NSString *cacheDataInfoFilePath;

@property (nonatomic, readwrite, copy) NSString *resumeDataFilePath;
@property (nonatomic, readwrite, copy) NSString *resumeDataInfoFilePath;

@end


@implementation WYNetworkRequestModel

#pragma mark- ============== Public Methods ==============


- (WYRequestType)requestType{
    
    if (self.downloadFilePath){
        
        return WYRequestTypeDownload;
        
    }else if(self.uploadUrl){
        
        return WYRequestTypeUpload;
        
    }else{
        
        return WYRequestTypeOrdinary;
        
    }
}




- (NSString *)cacheDataFilePath{
    
    if (self.requestType == WYRequestTypeOrdinary) {
        
        if (_cacheDataFilePath.length > 0) {
            
            return _cacheDataFilePath;
            
        }else{
            
            _cacheDataFilePath = [WYNetworkUtils cacheDataFilePathWithRequestIdentifer:_requestIdentifer];
            return _cacheDataFilePath;
        }
        
    }else{
        
        return nil;
    }
    
}




- (NSString *)cacheDataInfoFilePath{
    
    
    if (self.requestType == WYRequestTypeOrdinary) {
        
        if (_cacheDataInfoFilePath.length > 0) {
            
            return _cacheDataInfoFilePath;
            
        }else{
            
            _cacheDataInfoFilePath = [WYNetworkUtils cacheDataInfoFilePathWithRequestIdentifer:_requestIdentifer];
            return _cacheDataInfoFilePath;
        }
        
    }else{
        
        return nil;
    }
    
}





- (NSString *)resumeDataFilePath{
    
    if (self.requestType == WYRequestTypeDownload) {
        
        if (_resumeDataFilePath.length > 0) {
            
            return _resumeDataFilePath;
            
        }else{
            
            _resumeDataFilePath = [WYNetworkUtils resumeDataFilePathWithRequestIdentifer:_requestIdentifer downloadFileName:_downloadFilePath.lastPathComponent];
            return _resumeDataFilePath;
        }
        
    }else{
        
        return nil;
        
    }
}




- (NSString *)resumeDataInfoFilePath{
    
    if (self.requestType == WYRequestTypeDownload) {
        
        if (_resumeDataInfoFilePath.length > 0) {
            
            return _resumeDataInfoFilePath;
            
        }else{
            
            _resumeDataInfoFilePath = [WYNetworkUtils resumeDataInfoFilePathWithRequestIdentifer:_requestIdentifer];
            return _resumeDataInfoFilePath;
        }
        
    }else{
        
        return nil;
        
    }
    
}





- (void)clearAllBlocks{
    
    _successBlock = nil;
    _failureBlock = nil;
    
    _uploadProgressBlock = nil;
    _uploadSuccessBlock = nil;
    _uploadFailedBlock = nil;
    
    _downloadProgressBlock = nil;
    _downloadSuccessBlock = nil;
    _downloadFailureBlock= nil;
    
}


#pragma mark- ============== Override Methods ==============

- (NSString *)description{
    
    if ([WYNetworkConfig sharedConfig].debugMode) {
        
        switch (self.requestType) {
                
            case WYRequestTypeOrdinary:
                return [NSString stringWithFormat:@"\n{\n   <%@: %p>\n   type:            oridnary request\n   method:          %@\n   url:             %@\n   parameters:      %@\n   loadCache:       %@\n   cacheDuration:   %@ seconds\n   requestIdentifer:%@\n   task:            %@\n}" ,NSStringFromClass([self class]),self,_method,_requestUrl,_parameters,_loadCache?@"YES":@"NO",[NSNumber numberWithInteger:_cacheDuration],_requestIdentifer,_task];
                break;
                
            case WYRequestTypeUpload:
                return [NSString stringWithFormat:@"\n{\n   <%@: %p>\n   type:            upload request\n   method:          %@\n   url:             %@\n   parameters:      %@\n   images:          %@\n    requestIdentifer:%@\n   task:            %@\n}" ,NSStringFromClass([self class]),self,_method,_requestUrl,_parameters,_uploadImages,_requestIdentifer,_task];
                break;
                
            case WYRequestTypeDownload:
                return [NSString stringWithFormat:@"\n{\n   <%@: %p>\n   type:            download request\n   method:          %@\n   url:             %@\n   parameters:      %@\n   target path:     %@\n    requestIdentifer:%@\n   task:            %@\n}" ,NSStringFromClass([self class]),self,_method,_requestUrl,_parameters,_downloadFilePath,_requestIdentifer,_task];
                break;
                
            default:
                [NSString stringWithFormat:@"\n  request type:unkown request type\n  request object:%@",self];
                break;
        }
        
        
    }else{
        
         return [NSString stringWithFormat:@"<%@: %p>" ,NSStringFromClass([self class]),self];
    }
}

@end
