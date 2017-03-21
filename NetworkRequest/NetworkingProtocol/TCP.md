所谓三次握手(Three-way Handshake)，是指建立一个TCP连接时，需要客户端和服务器总共发送3个包。
　　
三次握手的目的是连接服务器指定端口，建立TCP连接,并同步连接双方的序列号和确认号并交换 TCP 窗口大小信息.在 Socket 编程中，客户端执行connect()时。将触发三次握手。 

首先了解一下几个标志，SYN（synchronous），同步标志，ACK (Acknowledgement），即确认标志，seq应该是Sequence Number，序列号的意思，另外还有四次握手的fin，应该是final，表示结束标志。
第一次握手：客户端发送一个TCP的SYN标志位置1的包指明客户打算连接的服务器的端口，以及初始序号X,保存在包头的序列号(Sequence Number)字段里。
　　
第二次握手：服务器发回确认包(ACK)应答。即SYN标志位和ACK标志位均为1同时，将确认序号(Acknowledgement Number)设置为客户的序列号加1以，即X+1。
　　
第三次握手：客户端再次发送确认包(ACK) SYN标志位为0，ACK标志位为1。并且把服务器发来ACK的序号字段+1，放在确定字段中发送给对方.并且在数据段放写序列号的+1。




TCP的连接的拆除需要发送四个包，因此称为四次挥手(four-way handshake)。客户端或服务器均可主动发起挥手动作，在socket
编程中，任何一方执行close()操作即可产生挥手操作。
其实有个问题，为什么连接的时候是三次握手，关闭的时候却是四次挥手？

因为当Server端收到Client端的SYN连接请求报文后，可以直接发送SYN+ACK报文。其中ACK报文是用来应答的，SYN报文是用来 同步的。

但是关闭连接时，当Server端收到FIN报文时，很可能并不会立即关闭SOCKET，所以只能先回复一个ACK报文，告诉Client端，” 你发的FIN报文我收到了”。只有等到我Server端所有的报文都发送完了，我才能发送FIN报文，因此不能一起发送。故需要四步握手。

常用的Socket类型有两种：流式Socket（SOCK_STREAM）和数据报式Socket（SOCK_DGRAM）。流式是一种面向连接的 Socket，针对于面向连接的TCP服务应用；数据报式 Socket 是一种无连接的 Socket ，对应于无连接的UDP服务应用。

/*
http://mp.weixin.qq.com/s?__biz=MjM5OTMxMzA4NQ==&mid=508448427&idx=2&sn=02f8ee64c18355be0bdf5e8006bcf396
*/

