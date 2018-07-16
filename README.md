


## 文件目录
|类名|作用|
|---|---
|WYNetwork|总头文件，只需要引入该文件即可使用该框架所有功能|
|WYNetworkConfig|配置类：配置服务器地址，token，debug模式等|
|WYNetworkUtils|工具类：可以用于生成缓存路径，app版本号等|
|WYNetworkCacheManager|	缓存处理类：缓存的写入，读取，删除|
|WYNetworkProtocol|定制了请求结束后的处理方法，未来可能还会扩展|
|WYNetworkHeader|定义了回调block和一些枚举类型|
|WYNetworkManager|与业务层直接对接的类，包含了除配置接口外所有关于网络请求功能的接口|
|WYNetworkBaseEngine|所有负责发送请求类的基类|
|WYNetworkRequestEngine|发送（GET,POST,PUT,DELETE）请求的类：支持设置缓存有效期，读、写和清理缓存|
|WYImageScaleTool|图像压缩类：图像的压缩方式|
|WYNetworkUploadEngine|发送上传请求的类：支持设置图片类型和压缩上传，批量上传|
|WYNetworkDownloadEngine|发送下载请求的类：支持断点续传和后台下载|
|WYNetworkRequestModel|请求对象类：持有某个网络请求的一些数据；比如请求url，请求体等）|
|WYNetworkRequestPool|请求对象池：用于存放正在进行的请求对象|


## 使用方法
手动将 `WYNetwork` 文件夹拖入到工程里面
```
import "WYNetwork.h"
```

## 功能介绍
### 基础配置
网络配置由 `WYNetworkConfig` 来完成，因为是单利，所以可以在项目任何地方来使用。
#### 服务器地址
```
[WYNetworkConfig sharedConfig].baseUrl = @"http://116.22.115.104:8181";

添加的服务器地址会自动添加到所有的请求中；
如果原来不存在，则添加；如果原来存在，则替换原有的地址。
```
#### 默认参数
```
[WYNetworkConfig sharedConfig].defailtParameters = @{@"version":@"1.0",
													@"platform":@"iOS"};
													
*默认参数会拼接在所有请求的请求体中；
*如果是GET请求，则拼接在url里面。
```
#### 默认请求超时时间
```
[WYNetworkConfig sharedConfig].timeoutSeconds = 45;//默认30s
```

#### Debug模式

```
[WYNetworkConfig sharedConfig].debugMode = YES;//默认为NO，不开启

*如果设置debug模式为YES，则会打印出很多详细的Log，如：请求地址、参数、返回数据等便于调试。

```


#### 添加请求头

```
[[WYNetworkConfig sharedConfig] addCustomHeader:@{@"token":@"sahwgve2175sdhvBfqyvaAew9"}];

*添加的请求头键值对会自动添加到所有的请求头中；
*如果键值对原来不存在，则添加；如果原来存在，则替换原有的。

```


### 网络请求
* 该框架支持GET，POST，PUT，DELETE四种网络请求，由 `WYNetworkRequestManager` 实现
* 所有这些普通的网络请求都支持写入和读取缓存，但是默认只有GET支持自动缓存，当在发送错误的时候（如：网络断开）自动加载缓存数据，其他默认都不支持
* 支持用户自行决定是否写入、读取缓存已以及设置缓存时间，默认缓存时间为30天
* 支持用户自行选择请求序列化方式


#### 基本用法
发送一个带缓存的GET请求
```

[[WYNetworkManager sharedManager] sendGetRequest:WYJSONRequestSerializer
                                                 url:@"index/test"
                                          parameters:@{@"page"    : @(0),
                                                       @"version" : @"1.0" }
                                             success:^(id responseObject, BOOL isCacheObject)
     {
         NSLog(@"responseObject = %@", responseObject);
         
     } failure:^(NSURLSessionTask *task, NSError *error, NSInteger statusCode) {
         
         NSLog(@"error = %@", error);
     }];
```




发送一个支持写入有效时间为15天并在缓存有效时读取缓存的GET请求 

```
[[WYNetworkManager sharedManager] sendGetRequest:WYJSONRequestSerializer
                                                 url:@"index/test"
                                          parameters:@{@"page"    : @(0),
                                                       @"version" : @"1.0" }
                                       cacheDuration:15
                                             success:^(id responseObject, BOOL isCacheObject)
     {
         NSLog(@"responseObject = %@", responseObject);
         
     } failure:^(NSURLSessionTask *task, NSError *error, NSInteger statusCode) {
         
         NSLog(@"error = %@", error);
     }];
```
     
     
     
     
   发送一个不写入读取读取缓存，只能用网络加载的GET请求  
```
     [[WYNetworkManager sharedManager] sendGetRequest:WYJSONRequestSerializer
                                                 url:@"index/test"
                                          parameters:@{@"page"    : @(0),
                                                       @"version" : @"1.0" }
                                           cacheType:WYNetworkCacheTypeNetworkOnly
                                             success:^(id responseObject, BOOL isCacheObject)
     {
         NSLog(@"responseObject = %@", responseObject);
         
     } failure:^(NSURLSessionTask *task, NSError *error, NSInteger statusCode) {
         
         NSLog(@"error = %@", error);
     }];
```


### 缓存管理
缓存管理是由 `WYNetworkCacheManager` 单列来实现的，分为缓存的读取，删除和计算。

#### 读取缓存

**单个缓存的读取**

如果知道这个缓存对应的请求url，method，请求体，就能尝试获取它所对应的缓存对象

```
[[WYNetworkCacheManager sharedManager] loadCacheWithUrl:@"index/test"
                                                     method:@"GET"
                                                 parameters:@{@"page"    : @(0),
                                                              @"version" : @"1.0" }
                                            completionBlock:^(id  _Nullable cacheObject)
     {
         NSLog(@"cacheObject = %@", cacheObject);
     }];
     
```

**多个缓存的读取：**

如果有些请求使用的是同一个url（但是不同的请求方法或者参数）并做了缓存，那么通过如下方法可以获取它们的缓存：


```
[[WYNetworkCacheManager sharedManager] loadCacheWithUrl:@"index/test"
                                            completionBlock:^(NSArray * _Nullable cacheArr)
    {
        NSLog(@"cacheArr = %@", cacheArr);
    }];
```


#### 清除缓存
**清除单个缓存**

同上，如果知道这个缓存对应的请求url，method，请求体，就能删除它所对应的缓存对象
```
[[WYNetworkCacheManager sharedManager] clearCacheWithUrl:@"index/test"
                                             completionBlock:^(BOOL isSuccess)
     {
         if (isSuccess) {
             NSLog(@"删除成功");
         }
     }];
```

**删除多个缓存：**

同上，如果有些请求使用的是同一个url（但是不同的请求方法或者参数）并做了缓存，那么通过如下方法可以将它们删除：


```
[[WYNetworkCacheManager sharedManager] clearCacheWithUrl:@"index/test"
                                                      method:@"GET"
                                                  parameters:@{@"page"    : @(0),
                                                               @"version" : @"1.0" }
                                             completionBlock:^(BOOL isSuccess)
     {
         if (isSuccess) {
             NSLog(@"删除成功");
         }
     }];
```


**删除所有缓存：**

```
[[WYNetworkCacheManager sharedManager] clearAllCacheCompletionBlock:^(BOOL isSuccess)
    {
        if (isSuccess) {
            NSLog(@"删除成功");
        }
    }];
```

**缓存计算**

* fileCount       文件数量
* totalSize       文件字节大小
* totalSizeString 带有KB和MB转化的字符串

```
[[WYNetworkCacheManager sharedManager] calculateAllCacheSizecompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize, NSString * _Nonnull totalSizeString)
     {
         
     }];
```

### 图像上传

* 由 `WYNetworkUploadManager` 类的单例实现，支持上传单个与多个图像
* 内置三张压缩算法，不同大小的图像下压缩效率各有千秋
* 支持压缩最小值设置，低于最小值便不会继续压缩，默认为150kb大小


```
* 仿微信压缩
 宽高均 <= 1280px，图片尺寸大小保持不变
 宽或高 > 1280px && 宽高比 <= 2，取较大值等于1280px，较小值等比例压缩
 宽或高 > 1280px && 宽高比 > 2 && 宽或高 < 1280px，图片尺寸大小保持不变
 宽高均 > 1280px && 宽高比 > 2，取较小值等于1280px，较大值等比例压缩
 
 
* 等比例缩小图像压缩
等比例缩小图像进行压缩，图像宽度参照 1242px 进行等比例压缩


* 二分法压缩图像到绝对值
采用二分法，压缩到指定大小，如果图像本身就很大，那么压缩可能会有失真

```

#### 上传单张图片

* 默认采用仿微信的压缩方式进行上传
* 默认最低压缩比率为150kb
* 默认上传图像格式为png格式


**发起一个上传图像的请求**
```
[[WYNetworkManager sharedManager] sendUploadImageRequest:WYHTTPRequestSerializer
                                                         url:@"upload/image"
                                                  parameters:nil
                                                       image:image
                                                        name:@"file"
                                                    progress:^(NSProgress *uploadProgress)
     {
         
     } success:^(id responseObject) {
         
     } failure:^(NSURLSessionTask *task, NSError *error, NSInteger statusCode, NSArray<UIImage *> *uploadFailedImages) {
         
     }];
```


**发起一个完全自定义的上传图像的请求**

用户可以自定义图像的压缩方式、压缩大小以及图像类型，更方便在不同的场景下使用

```
[[WYNetworkManager sharedManager] sendUploadImageRequest:WYHTTPRequestSerializer
                                                         url:@"https://upload.api/image"
                                                  parameters:@{@"id" : @"232657321769854"}
                                                compressType:WYUploadCompressEqualProportion
                                                       image:image
                                                compressSize:100
                                                        name:@"file"
                                                    mimeType:@"jpg"
                                                    progress:^(NSProgress *uploadProgress)
     {
         
     } success:^(id responseObject) {
         
     } failure:^(NSURLSessionTask *task, NSError *error, NSInteger statusCode, NSArray<UIImage *> *uploadFailedImages) {
         
     }];
```


**忽略设置过的baseUrl**

考虑到上传图片的服务器可能与普通请求的服务器不同，特意增加了一个ignoreBaseUrl参数
如果该BOOL设置为YES，则在WYNetworkConfig里面设置的baseUrl就会被忽略掉

```
[[WYNetworkManager sharedManager] sendUploadImageRequest:WYHTTPRequestSerializer
                                                         url:@"https://upload.api/image"
                                               ignoreBaseUrl:YES
                                                  parameters:@{@"id" : @"232657321769854"}
                                                       image:image
                                                        name:@"file"
                                                    progress:^(NSProgress *uploadProgress)
     {
         
     } success:^(id responseObject) {
         
     } failure:^(NSURLSessionTask *task, NSError *error, NSInteger statusCode, NSArray<UIImage *> *uploadFailedImages) {
         
     }];
```


