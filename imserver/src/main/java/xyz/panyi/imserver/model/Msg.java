package xyz.panyi.imserver.model;

public class Msg {
    private long length; //消息总长度
    private int code; //消息类型
    private byte data[];  //实际数据

    public long getLength() {
        return length;
    }

    public void setLength(long length) {
        this.length = length;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public byte[] getData() {
        return data;
    }

    public void setData(byte[] data) {
        this.data = data;
    }

    @Override
    public String toString() {
        return"msg [ lenght = "+length+" , code = "+ code +" ]";
    }

}//end class
