package xyz.panyi.imserver;

public class Main {

    /**
     *  启动服务
     * @param args
     */
    public static void main(String[] args){
        ImServer server = new ImServer(Config.IM_SERVER_PORT);
        server.runLoop();
    }

}//end class
