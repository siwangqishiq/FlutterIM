package xyz.panyi.imserver.handler;

import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.SimpleChannelInboundHandler;
import xyz.panyi.imserver.model.Msg;

/**
 *  im业务服务handler
 */
public class ServiceHandler extends SimpleChannelInboundHandler<Msg> {

    /**
     *
     * @param ctx
     * @param msg
     * @throws Exception
     */
    protected void channelRead0(ChannelHandlerContext ctx, Msg msg) throws Exception {
        if(msg == null|| msg.getData() ==null  || msg.getLength() != msg.getData().length)
            return;

        switch (msg.getCode()){

        }//end switch
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
        cause.printStackTrace();
        ctx.close();
    }

}//end class
