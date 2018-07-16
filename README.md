


## 目录大纲
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
|WYImageScaleTool|图像压缩方式|
|WYNetworkUploadEngine|发送上传请求的类：支持设置图片类型和压缩上传，批量上传|
|WYNetworkDownloadEngine|发送下载请求的类：支持断点续传和后台下载|
|WYNetworkRequestModel|请求对象类：持有某个网络请求的一些数据；比如请求url，请求体等）|
|WYNetworkRequestPool|请求对象池：用于存放正在进行的请求对象|


## 使用方法
手动将 `WYNetwork` 文件夹拖入到工程里面
```
import "SJNetwork.h"
```

## 功能介绍
### 基础配置
因为配置对象是一个单例（WYNetworkConfig），所以可以在项目任何地方来使用。
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
													
默认参数会拼接在所有请求的请求体中；
如果是GET请求，则拼接在url里面。
```
#### 默认请求超时时间
```
[WYNetworkConfig sharedConfig].timeoutSeconds = 45;//默认30s
```

#### Debug模式

```
[WYNetworkConfig sharedConfig].debugMode = YES;//默认为NO，不开启

如果设置debug模式为YES，则会打印出很多详细的Log，如：请求地址、参数、返回数据等便于调试。

```


#### 添加请求头

```
[[WYNetworkConfig sharedConfig] addCustomHeader:@{@"token":@"sahwgve2175sdhvBfqyvaAew9"}];

添加的请求头键值对会自动添加到所有的请求头中；
如果键值对原来不存在，则添加；如果原来存在，则替换原有的。

```


### 网络请求
该框架支持GET，POST，PUT，DELETE四种网络请求，由WYNetworkRequestManager实现。
所有这些普通的网络请求都支持写入和读取缓存，但是默认只有GET支持自动缓存，其他默认都不支持。
用户可以自行决定是否写入，读取缓存已以及缓存时间，默认缓存时间为30天。


```
/** 发送一个带缓存的GET请求 */

[[WYNetworkManager sharedManager] sendPGetRequest:@"toutiao/index"
                                       parameters:@{@"type":@"top",
                                                    @"key" :@"0c60"}
                                          success:^(id responseObject) {

      NSLog(@"request succeed:%@",responseObject);

  } failure:^(NSURLSessionTask *task, NSError *error, NSInteger statusCode) {

      NSLog(@"request failed:%@",error);
  }];
```

