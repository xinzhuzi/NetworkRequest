//
//  AFHTTPHeader.h
//  NetworkRequest
//
//  Created by 郑冰津 on 2016/12/18.
//  Copyright © 2016年 IceGod. All rights reserved.
//

#ifndef AFHTTPHeader_h
#define AFHTTPHeader_h

typedef NS_ENUM(NSUInteger, AFHTTPNetworkType) {
    NetworkType_WiFi = 399999,
    NetworkType_4G,
    NetworkType_3G,
    NetworkType_2G,
    NetworkType_NO,//无连接状态
    NetworkType_Unknown,//未知网络状态
};

typedef NS_ENUM(NSUInteger, AFHTTPNetworkUploadDownloadType) {
    UploadDownloadType_Images = 499999,///POST上传图片
    UploadDownloadType_Videos,///POST上传视频
};

#import "AFHTTPRequest.h"


//学习链接:http://www.cnblogs.com/QianChia/p/5768428.html
//http://www.cnblogs.com/190196539/archive/2011/04/05/2005751.html
//http://blog.csdn.net/u010529455/article/details/42918639
/*
 在 iOS 开发中，一般情况下，简单的向某个 Web 站点简单的页面提交请求并获取服务器的响应,在绝大部分下我们所需要访问的 Web 页面则是属于那种受到权限保护的页面，并不是有一个简单的 URL 可以访问的。这就涉及到了 Session 和 Cookie 的处理了,使用 AFNetworking 则是更好的选择。
 Session：中文有译作时域的，就是指某个客户端从访问服务器起到停止访问这一段的时间间隔被称为时域。
 Cookie：由服务器发送给客户端，把 Cookie 的 key：value 值储存在本地文件夹下，当下次请求的时候能够直接发送 Cookie 获得权限验证。
 GET： 请求指定的页面信息，并返回实体主体。
 HEAD： 只请求页面的首部。
 POST： 请求服务器接受所指定的文档作为对所标识的URI的新的从属实体。
 PUT： 从客户端向服务器传送的数据取代指定的文档的内容。
 DELETE： 请求服务器删除指定的页面。
 OPTIONS： 允许客户端查看服务器的性能。
 TRACE： 请求服务器在响应中的实体主体部分返回所得到的内容。
 PATCH： 实体中包含一个表，表中说明与该URI所表示的原内容的区别。
 MOVE： 请求服务器将指定的页面移至另一个网络地址。
 COPY： 请求服务器将指定的页面拷贝至另一个网络地址。
 LINK： 请求服务器建立链接关系。
 UNLINK： 断开链接关系。
 WRAPPED： 允许客户端发送经过封装的请求。
 Extension-mothed：在不改动协议的前提下，可增加另外的方法。
 
 
 ① 客户方错误
 100　 继续
 101　 交换协议
 ② 成功
 200 　OK
 201 　已创建
 202　 接收
 203　 非认证信息
 204　 无内容
 205 　重置内容
 206　 部分内容
 ③ 重定向
 300 　多路选择
 301　 永久转移
 302　 暂时转移
 303　 参见其它
 304 　未修改（Not Modified）
 305　 使用代理
 ④ 客户方错误
 400　 错误请求（Bad Request）
 401 　未认证
 402 　需要付费
 403　 禁止（Forbidden）
 404　 未找到（Not Found）
 405　 方法不允许
 406　 不接受
 407　 需要代理认证
 408　 请求超时
 409　 冲突
 410 　失败
 411 　需要长度
 412　 条件失败
 413 　请求实体太大
 414 　请求URI太长
 415 　不支持媒体类型
 ⑤ 服务器错误
 500　 服务器内部错误
 501　 未实现（Not Implemented）
 502　 网关失败
 504 　网关超时
 505 HTTP版本不支持
 */
#endif /* AFHTTPHeader_h */
