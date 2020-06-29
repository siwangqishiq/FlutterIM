package xyz.panyi.imserver;

import io.netty.bootstrap.ServerBootstrap;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.ChannelOption;
import io.netty.channel.ChannelPipeline;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.SocketChannel;
import io.netty.channel.socket.nio.NioServerSocketChannel;
import xyz.panyi.imserver.handler.CodecMsg;
import xyz.panyi.imserver.handler.ServiceHandler;

public class ImServer {
    private int port;

    public ImServer(int port){
        this.port = port;
    }

    public void runLoop(){
        NioEventLoopGroup bossGroup = new NioEventLoopGroup();//boss线程组
        NioEventLoopGroup workerGroup = new NioEventLoopGroup();// worker线程组

        try{
            ServerBootstrap bootstrap = new ServerBootstrap();
            bootstrap.group(bossGroup , workerGroup)//
                    .channel(NioServerSocketChannel.class)
                    .option(ChannelOption.SO_BACKLOG , 128) //每个线程的最大连接数
                    .childOption(ChannelOption.SO_KEEPALIVE , true)
                    .childHandler(new ChannelInitializer<SocketChannel>() {
                        protected void initChannel(SocketChannel socketChannel) throws Exception {
                            final ChannelPipeline pipeline = socketChannel.pipeline();
                            pipeline.addLast("msg_codec" , new CodecMsg());
                            pipeline.addLast("service_handler" , new ServiceHandler());
                        }
                    });

            System.out.println("启动服务 port : " + port + " ...");
            //绑定端口  启动服务
            ChannelFuture cf = bootstrap.bind(port).sync();
            //结束
            cf.channel().closeFuture().sync();
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            bossGroup.shutdownGracefully();
            workerGroup.shutdownGracefully();
        }
    }
}//end class
