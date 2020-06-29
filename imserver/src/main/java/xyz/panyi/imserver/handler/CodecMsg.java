package xyz.panyi.imserver.handler;

import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.ByteToMessageCodec;
import io.netty.handler.codec.ByteToMessageDecoder;
import xyz.panyi.imserver.model.Msg;

import java.util.List;

/**
 *   消息的编解码
 *
 */
public class CodecMsg extends ByteToMessageCodec<Msg> {

    protected void encode(ChannelHandlerContext ctx, Msg msg, ByteBuf byteBuf) throws Exception {
        System.out.println("encode msg = " + msg);

    }

    protected void decode(ChannelHandlerContext ctx, ByteBuf byteBuf, List<Object> list) throws Exception {
        System.out.println("decode bytebuf");
    }
}//end class
