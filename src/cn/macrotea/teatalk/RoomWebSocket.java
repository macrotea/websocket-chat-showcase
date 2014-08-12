package cn.macrotea.teatalk;

import com.alibaba.fastjson.JSON;

import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Set;

//如下注解是J2EE7的标准,tomcat7已经实现这个标准
//故而服务器端需要的配置是: Java7(+) + Tomcat7(+)

@ServerEndpoint("/room")
public class RoomWebSocket {

    /**
     * 发布
     *
     * @param jsonMessage
     * @param session
     * @return
     */
    public void publish(String jsonMessage, Session session) throws IOException {
        Set<Session> sessionSet = session.getOpenSessions();

        //获取所有存活会话，并发送消息
        for (Session eachSession : sessionSet) {
            if (eachSession.isOpen()) {
                //eachSession.getAsyncRemote().sendText(jsonMessage);
                eachSession.getBasicRemote().sendText(jsonMessage);
            }
        }
    }

    @OnMessage
    public void onMessage(String message, Session session) throws IOException {

        //message变量保存的是json字符串
        //我们也可以把json字符串转换成对象,便于后续操作
        Message msg = JSON.parseObject(message, Message.class);
        System.out.println("onMessage() - Message对象数据: " + msg);

        //仅仅响应当前来访session
        //session.getBasicRemote().sendText(message,true);

        publish(message, session);

    }

    /**
     * 当客户端建立连接
     *
     * @param session
     * @throws IOException
     */
    @OnOpen
    public void onOpen(Session session) throws IOException {
        System.out.println("客户端建立连接");
    }

    /**
     * 当客户端关闭连接
     *
     * @param session
     * @throws IOException
     */
    @OnClose
    public void onClose(Session session) throws IOException {
        System.out.println("客户端关闭连接");
    }

    /**
     * 当客户端出错
     *
     * @param session
     * @param t
     */
    @OnError
    public void OnError(Session session, Throwable t) {
        t.printStackTrace();
    }


}