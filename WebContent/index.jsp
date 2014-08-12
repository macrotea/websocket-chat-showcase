<%@ page language="java" import="org.apache.commons.lang3.RandomStringUtils" pageEncoding="UTF-8" %>

<%
    String ctxPath = request.getContextPath();
    request.setAttribute("ctxPath", ctxPath);
    String clientId = "客户-" + RandomStringUtils.randomAlphabetic(6);
    String websocketPath = String.format("ws://%s:%s%s", request.getServerName(), request.getServerPort(), ctxPath + "/room");
%>

<!DOCTYPE html>
<html lang="zh-cmn-Hans-CN">
<head>
    <title>聊天室</title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content=""/>
    <meta name="keywords" content=""/>

    <link rel="shortcut icon" href="" type="image/x-icon">
    <link rel="icon" href="" type="image/x-icon">

    <!--CSS-->
    <link rel="stylesheet" href="http://cdn.bootcss.com/twitter-bootstrap/3.0.3/css/bootstrap.min.css">
    <style type="text/css">
    </style>

</head>
<body>

<div class="container">
    <h4>当前客户: <%=clientId%> </h4>

    <div class="well well-small">
        <form class="form-inline" role="form" id="messageForm">
            <div class="form-group">
                <label class="sr-only" for="messageHolder">消息：</label>
                <input type="text" class="form-control" id="messageHolder" placeholder="消息" autocomplete="off" autofocus="autofocus">
            </div>
            <button type="submit" class="btn btn-primary">发送</button>
        </form>
        <hr/>
        <table class="table table-striped table-hover" id="messageTable">
            <thead>
            <tr>
                <th>客户端</th>
                <th>消息</th>
                <th>时间</th>
            </tr>
            </thead>
            <tbody id="messages">

            </tbody>
        </table>
    </div>
</div>

<!--[if lt IE 9]>
<script src="http://cdn.bootcss.com/html5shiv/3.7.0/html5shiv.min.js"></script>
<script src="http://cdn.bootcss.com/respond.js/1.3.0/respond.min.js"></script> <![endif]-->
<script src="http://cdn.bootcss.com/jquery/1.10.2/jquery.min.js"></script>
<script src="http://cdn.bootcss.com/twitter-bootstrap/3.0.3/js/bootstrap.min.js"></script>
<script src="${ctxPath}/resources/js/nano.js"></script>
<script src="${ctxPath}/resources/js/moment.min.js"></script>
<script src="${ctxPath}/resources/js/json2.min.js"></script>

<!-- websocket -->
<script src="${ctxPath}/resources/js/websocket/swfobject.js"></script>
<script src="${ctxPath}/resources/js/websocket/web_socket.js"></script>

<script type="text/javascript">
    //此swf文件需放在同一域下
    WEB_SOCKET_SWF_LOCATION = "${ctxPath}/resources/js/websocket/WebSocketMain.swf";
    WEB_SOCKET_DEBUG = true;

    $(function(){
        var clientId = '<%=clientId%>',
            ws = new WebSocket("<%=websocketPath%>"),
            $messageHolder = $("#messageHolder"),
            $messageForm = $("#messageForm"),
            $messages = $("#messages")
            ;

        /**
         * 当点击发送按钮时把消息发送出去
         */
        $messageForm.submit(function(e){
            e.preventDefault();

            var msg = $messageHolder.val();
            if(!msg) return;

            var messageWrapper = {
                clientId: clientId,
                message: msg,
                sendTime: nowTime()
            };

            //发送消息对象
            sendByJson(messageWrapper);

            //清空文本框
            $messageHolder.val('');
        });

        ws.onopen = function () {
            sendByJson({
                clientId: clientId,
                message: clientId + "上线了",
                sendTime: nowTime()
            });
        };

        ws.onclose = function () {
            sendByJson({
                clientId: clientId,
                message: clientId +"下线了",
                sendTime: nowTime()
            });
        };

        ws.onerror = function () {
            sendByJson({
                clientId: clientId,
                message: clientId + "出错了",
                sendTime: nowTime()
            });

            alert("出错了");
        };

        /**
         * 当接收到消息时处理
         * @param e
         * @returns {*}
         */
        ws.onmessage = function (e) {
            var messageWrapper = JSON.parse(e.data);

            var clientId = messageWrapper.clientId;
            var message = messageWrapper.message;
            var sendTime = messageWrapper.sendTime;

            $messages.append(messageTemplate(
                    {
                        clientId: clientId,
                        message: message,
                        sendTime: sendTime
                    }
            ));
        };

        /**
        * 发送已包装的消息对象
        * @param messageWrapperObject
        * @returns {*}
         */
        function sendByJson(messageWrapperObject) {
            //把对象序列化成JSON字符串
            ws.send(JSON.stringify(messageWrapperObject));
        }

        /**
        * 消息模板
        * @param dataObject
        * @returns {*}
         */
        function messageTemplate(dataObject) {
            //基于模板填充数据,注意项目要引入nano.js
            return nano("<tr><td>{clientId}</td> <td>{message}</td> <td>{sendTime}</td> </tr>", dataObject);
        }

        /**
        * 当前时间
        * @returns {*}
         */
        function nowTime() {
            return moment().format("H:mm:ss");
        }

    });
</script>
</body>
</html>