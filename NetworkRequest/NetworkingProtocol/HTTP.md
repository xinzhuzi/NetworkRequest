[https://www.shiyanlou.com/questions/2986]

##########################################################  
Http和Socket连接区别

▶短连接 

连接->传输数据->关闭连接 
　
HTTP是无状态的，浏览器和服务器每进行一次HTTP操作，就建立一次连接，但任务结束就中断连接。 
　
也可以这样说：短连接是指 Socket 连接后发送后接收完数据后马上断开连接。 

▶长连接 

连接->传输数据->保持连接 -> 传输数据-> 。。。 ->关闭连接。 
　
长连接指建立 Socket 连接后不管是否使用都保持连接，但安全性较差。 

▶http的长连接  　

HTTP也可以建立长连接的，使用Connection:keep-alive，HTTP 1.1默认进行持久连接。HTTP1.1和HTTP1.0相比较而言，最大的区别就是增加了持久连接支持(貌似最新的 http1.0 可以显示的指定 keep-alive),但还是无状态的，或者说是不可以信任的。

▶什么时候用长连接，短连接？   　

长连接多用于操作频繁，点对点的通讯，而且连接数不能太多情况。每个TCP连接都需要三步握手，这需要时间，如果每个操作都是先连接，再操作的话那么处理 速度会降低很多，所以每个操作完后都不断开，次处理时直接发送数据包就OK了，不用建立TCP连接。例如：数据库的连接用长连接， 如果用短连接频繁的通信会造成 Socket 错误，而且频繁的 Socket 创建也是对资源的浪费。 

而像WEB网站的http服务一般都用短链接，因为长连接对于服务端来说会耗费一定的资源，而像WEB网站这么频繁的成千上万甚至上亿客户端的连接用短连接 会更省一些资源，如果用长连接，而且同时有成千上万的用户，如果每个用户都占用一个连接的话，那可想而知吧。所以并发量大，但每个用户无需频繁操作情况下需用短连好。 

总之，长连接和短连接的选择要视情况而定。



##########################################################

HTTP协议即超文本传送协议(HypertextTransfer Protocol )，是Web联网的基础，也是手机联网常用的协议之一，HTTP协议是建立在TCP协议之上的一种应用。
　　
HTTP连接最显著的特点是客户端发送的每次请求都需要服务器回送响应，在请求结束后，会主动释放连接。从建立连接到关闭连接的过程称为“一次连接”。
　　
1）在HTTP 1.0中，客户端的每次请求都要求建立一次单独的连接，在处理完本次请求后，就自动释放连接。
　　
2）在HTTP 1.1中则可以在一次连接中处理多个请求，并且多个请求可以重叠进行，不需要等待一个请求结束后再发送下一个请求。
　　
由于HTTP在每次请求结束后都会主动释放连接，因此HTTP连接是一种“短连接”，要保持客户端程序的在线状态，需要不断地向服务器发起连接请求。

通常的做法是即时不需要获得任何数据，客户端也保持每隔一段固定的时间向服务器发送一次“保持连接”的请求，服务器在收到该请求后对客户端进行回复，表明知道客 户端“在线”。若服务器长时间无法收到客户端的请求，则认为客户端“下线”，若客户端长时间无法收到服务器的回复，则认为网络已经断开。


##########################################################
URL(Uniform Resource Locator) 地址用于描述一个网络上的资源, 基本格式如下:
schema://host[:port#]/path/.../[?query-string][#anchor]

scheme               指定低层使用的协议(例如：http, https, ftp)

host                   HTTP服务器的IP地址或者域名

port#                 HTTP服务器的默认端口是80，这种情况下端口号可以省略。如果使用了别的端口，必须指明，例如 http://www.cnblogs.com:8080/

path                   访问资源的路径

query-string       发送给http服务器的数据

anchor-             锚
[URL 的一个例子]

http://www.mywebsite.com/sj/test/test.aspx?name=sviergn&x=true#stuff

Schema:                 http
host:                   www.mywebsite.com
path:                   /sj/test/test.aspx
Query String:           name=sviergn&x=true
Anchor:                 stuff

先看Request 消息的结构, Request 消息分为3部分
第一部分叫Request line,

第二部分叫Request header,

第三部分是body. header和body之间有个空行，

当使用的是"GET" 方法的时候， body是为空的
第一行中的Method表示请求方法,比如"POST","GET", Path-to-resoure表示请求的资源， Http/version-number 表示HTTP协议的版本号







 Host（发送请求时，该报头域是必需的）
 
 作用: 请求报头域主要用于指定被请求资源的Internet主机和端口号，它通常从HTTP URL中提取出来的
 
 例如: 我们在浏览器中输入：http://www.guet.edu.cn/index.html
 
 浏览器发送的请求消息中，就会包含Host请求报头域，如下：
 
 Host：http://www.guet.edu.cn
 此处使用缺省端口号80，若指定了端口号，则变成：Host：指定端口号
 
 Cookie:
 
 作用： 最重要的header, 将cookie的值发送给HTTP 服务器
 
 Cache-Control
 
 作用: 这个是非常重要的规则。 这个用来指定Response-Request遵循的缓存机制。各个指令含义如下:
 Cache-Control:Public 可以被任何缓存所缓存（）
 Cache-Control:Private 内容只缓存到私有缓存中
 Cache-Control:no-cache 所有内容都不会被缓存
 
Connection: keep-alive当一个网页打开完成后，客户端和服务器之间用于传输HTTP数据的TCP连接不会关闭，如果客户端再次访问这个服务器上的网页，会继续使用这一条已经建立的连接
  Connection: close 代表一个Request完成后，客户端和服务器之间用于传输HTTP数据的TCP连接会关闭， 当客户端再次发送Request，需要重新建立TCP连接。
