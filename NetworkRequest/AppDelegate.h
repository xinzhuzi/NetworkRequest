//
//  AppDelegate.h
//  NetworkRequest
//
//  Created by 郑冰津 on 2016/12/9.
//  Copyright © 2016年 IceGod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end



/*
 @property (class, readonly, strong) NSURLSessionConfiguration *defaultSessionConfiguration;
 //默认会话模式（default）：工作模式类似于原来的NSURLConnection，使用的是基于磁盘缓存的持久化策略，使用用户keychain中保存的证书进行认证授权。
 @property (class, readonly, strong) NSURLSessionConfiguration *ephemeralSessionConfiguration;
 //瞬时会话模式（ephemeral）：该模式不使用磁盘保存任何数据。所有和会话相关的caches，证书，cookies等都被保存在RAM中，因此当程序使会话无效，这些缓存的数据就会被自动清空。
 + (NSURLSessionConfiguration *)backgroundSessionConfigurationWithIdentifier:(NSString *)identifier NS_AVAILABLE(10_10, 8_0);
 //后台会话模式（background）：该模式在后台完成上传和下载，在创建Configuration对象的时候需要提供一个NSString类型的ID用于标识完成工作的后台会话。
 
 也就是说default同时实现了内存缓存和硬盘缓存，ephemeral实现了内存缓存，对于图片下载我们当然选择default。
 初始化设置：
 NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
 diskCapacity:20 * 1024 * 1024 diskPath:nil];
 [NSURLCache setSharedURLCache:URLCache];
 在AFNetWorking中对于图片网络请求AFImageDownloader里面设置了默认的20M的内存缓存和150M的硬盘缓存：
 
 请求头字段含义请看http://www.jianshu.com/p/42d9cc1dde10
 缓存策略是指对网络请求缓存如果处理，是使用缓存还是不使用
 NSURLRequestUseProtocolCachePolicy： 对特定的 URL 请求使用网络协议(服务器中的请求头字段)中实现的缓存逻辑。这是默认的策略。
 NSURLRequestReloadIgnoringLocalCacheData：数据需要从原始地址加载。不使用现有缓存。
 NSURLRequestReloadIgnoringLocalAndRemoteCacheData：不仅忽略本地缓存，
 同时也忽略代理服务器或其他中间介质目前已有的、协议允许的缓存。
 NSURLRequestReturnCacheDataElseLoad：无论缓存是否过期，先使用本地缓存数据。
 如果缓存中没有请求所对应的数据，那么从原始地址加载数据。
 NSURLRequestReturnCacheDataDontLoad：无论缓存是否过期，先使用本地缓存数据。
 如果缓存中没有请求所对应的数据，那么放弃从原始地址加载数据，
 请求视为失败（即：“离线”模式）。
 NSURLRequestReloadRevalidatingCacheData：从原始地址确认缓存数据的合法性后，
 缓存数据就可以使用，否则从原始地址加载。
 
 
 像素在内存中的布局和它在磁盘中的存储方式并不相同。考虑一种简单的情况：每个像素有R、G、B和alpha四个值，每个值占用1字节，因此每个像素占用4字节的内存空间。一张1920*1080的照片(iPhone6 Plus的分辨率)一共有2,073,600个像素，因此占用了超过8Mb的内存。但是一张同样分辨率的PNG格式或JPEG格式的图片一般情况下不会有这么大。这是因为JPEG将像素数据进行了一种非常复杂且可逆的转化。
 
 ps:
    AFNetWorking3.0放弃了NSCache作为图片内存缓存管理，这让我非常不解。
    有人说它的性能和 key 的相似度有关，如果有大量相似的 key (比如 "1", "2", "3", ...)，NSCache 的存取性能会下降得非常厉害，大量的时间被消耗在 CFStringEqual() 上，不知这是不是放弃使用NSCache的原因。
 
 */


/*
 即时通讯
 
 http://www.jianshu.com/p/0a11b2d0f4ae
 
 http://www.imooc.com/article/8493 webSocket
 
 https://github.com/ChenYilong/iOSBlog 陈一龙
 
 */





