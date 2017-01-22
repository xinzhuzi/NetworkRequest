//
//  SpecialRequest_VC.h
//  NetworkRequest
//
//  Created by 郑冰津 on 2017/1/16.
//  Copyright © 2017年 IceGod. All rights reserved.
//

#import "Parent_Class_VC.h"

@interface SpecialRequest_VC : Parent_Class_VC

@end


/*
 关于cookie的使用,为什么使用:http://www.jianshu.com/p/d144bd7226b7 ,http://blog.csdn.net/chun799/article/details/17206907
 cookie：在客户端发送登录操作的网络请求时，服务器在登陆成功返回的 response header 中会添加一个 set-cookie 的值，作为用户的身份认证，如果是浏览器的话，后面每一次发请求时，浏览器都会自动将之前获取到的 cookie 值插入到 request header 的 cookie 字段中，而且 cookie 本身包括多个属性，比如有效期 expires、域 domain等，因此采用 cookie 的登录机制需要考虑到对 cookie 本身的管理。cookie 主要是在 web 领域使用。
 token：相比 cookie，token 令牌的登录机制要更轻，直观的感受是，登录认证成功后，服务器返回 token 值，然后在请求的 url 中拼接一段 “token=%^&%#&%#&” 就完事了，至于什么跨域、安全策略什么的，根本没他什么事，客户端管理 token 也非常简单，只要看好这个字符串就行了，所以 token 一般在移动端用的比较多。当然，移动应用中的 web view 还是要处理 cookie 的。
 
 除非NSURLRequest明确指定不使用cookie(HTTPShouldHandleCookies设为NO),否则URL loading system会自动为NSURLRequest发送合适的存储cookie。从NSURLResponse返回的cookie也会根据当前的cookie访问策略(cookie acceptance policy)接收到系统中。
 
 Cookie可以分为两类，会话Cookie和持久Cookie,会话Cookie是临时Cookie,当前会话结束(浏览器退出)时Cookie会被删除。持久Cookie会存储在用户的硬盘上,浏览器退出，然后重新启动后Cookie仍然存在。会话Cookie和持久Cookie的区别在于过期时间，如果设置了Discard参数(Cookie 版本1)或者没有设置Expires(Cookie版本0)或Max-Age(Cookie版本1)设置过期时间，则此Cookie为会话Cookie,Cookie有两个版本,一个是版本0(Netscape Cookies)和版本1(RFC 2965),目前大多数服务器使用的Cookie 0。Cookie是由服务器端生成，发送给User-Agent（一般是浏览器或者客户端），浏览器会将Cookie的key/value保存到某个目录下的文本文件内，下次请求同一网站地址时就发送该Cookie给服务器
 
 
 一个set-Cookie字段只能设置一个cookie，当你要想设置多个 cookie，需要添加同样多的set-Cookie字段。
 服务端可以设置cookie 的所有选项：expires、domain、path、secure、HttpOnly
 
 客户端可以设置cookie 的下列选项：expires、domain、path、secure（有条件：只有在https协议的网页中，客户端设置secure类型的 cookie 才能成功），但无法设置HttpOnly选项。
 
 NSHTTPCookieStorage单件类提供了管理所有NSHTTPCookie对象的接口，在OS X里,cookie是在所有程序中共享的，而在iOS中,cookie只当当前应用中有效。
 
 NSHTTPCookieAcceptPolicyAlways:接收所有cookie,默认策略.
 NSHTTPCookieAcceptPolicyNever: 拒绝所有cookie
 NSHTTPCookieAcceptPolicyOnlyFromMainDocumentDomain:只接收main document domain中的cookie.
 */
/*
 NSHTTPCookieComment
 一个NSString包含Cookie的评论对象。仅适用于版本1的Cookie及更高版本。此cookie属性是可选的。
 
 NSHTTPCookieCommentURL
 一个NSURL对象或NSString 对象包含Cookie的注释URL。仅适用于版本1的Cookie或更高版本。此cookie属性是可选的。
 
 NSHTTPCookieDiscard
 一个NSString对象说明Cookie是否应在会议结束时被丢弃。字符串值必须为“TRUE”或“FALSE”。此cookie属性是可选的。默认值为“FALSE”，除非此cookie为版本1或更大，并且未指定NSHTTPCookieMaximumAge的值，在这种情况下，假定为“TRUE”。
 
 NSHTTPCookieDomain
 一个NSString 包含cookie的域对象。如果缺少此cookie属性，则从NSHTTPCookieOriginURL的值推断该域。如果不指定NSHTTPCookieOriginURL值，则必须指定NSHTTPCookieDomain值。
 
 NSHTTPCookieExpires
 一个NSDate对象或NSString 对象，指定为cookie的到期日。此Cookie属性仅用于版本0 Cookie。此cookie属性是可选的。
 
 NSHTTPCookieMaximumAge
 一个NSString包含一个整数值，说明多久秒饼干应保持，最多的对象。仅适用于版本1的Cookie及更高版本。默认值为“0”。此cookie属性是可选的。
 
 NSHTTPCookieName
 一个NSString包含cookie的名称对象。此cookie属性是必需的。

 NSHTTPCookieOriginURL
 一个NSURL或NSString包含设置这个cookie的URL对象。 如果不为NSHTTPCookieOriginURL提供值，那么必须为NSHTTPCookieDomain提供一个值。
 
 NSHTTPCookiePath
 一个NSString 包含该cookie的路径对象。此cookie属性是必需的。
 
 NSHTTPCookiePort
 一个NSString包含逗号分隔的整数值指定Cookie的端口对象。 仅适用于版本1的Cookie或更高版本。默认值为空字符串（“”）。此cookie属性是可选的。

 NSHTTPCookieSecure
 一个NSString指示该cookie只应通过安全通道发送对象。 为此键提供任何值表示cookie应保持安全。
 
 NSHTTPCookieValue
 一个NSString包含cookie的值对象。此cookie属性是必需的。
 
 NSHTTPCookieVersion
 一个NSString 指定cookie的版本对象。必须为“0”或“1”。默认值为“0”。此cookie属性是可选的。
 
 */



/*
 @"http://www.guba.com/mapi/api.php?webSource=guba&a=getList&limit=10&offset=2&orderType=views&desc=1"
 ///下面是返回的数据里面带有这些东西,直接解析不出来json,需要先去除这些东西才行
 NSString *responseString=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
 responseString = [responseString stringByReplacingOccurrencesOfString : @"\r\n" withString : @"" ];
 responseString = [responseString stringByReplacingOccurrencesOfString : @"\n" withString : @"" ];
 responseString = [responseString stringByReplacingOccurrencesOfString : @"\t" withString : @"" ];
 */







