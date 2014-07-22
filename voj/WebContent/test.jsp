<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ page import="java.util.*,java.io.*,javax.mail.*" %>
<%@ page import="javax.mail.internet.*" %>
<% 
request.setCharacterEncoding("euc-kr");
%>
<html> 
<head>
<title>mailProc.jsp</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>

 

<body leftmargin="0" topmargin="0">

<div align="center">

<%
// javamail lib 이 필요합니다.
class MyAuthentication extends Authenticator {
    PasswordAuthentication pa;
    public MyAuthentication(){
        pa = new PasswordAuthentication("noreturn@vojesus1.cafe24.com", "dptnakdmf0254"); 

              //ex) ID:cafe24@cafe24.com PASSWD:1234
    }

    public PasswordAuthentication getPasswordAuthentication() {
        return pa;
    }
}


String subject = "subject";  // 제목
String msgText = "msgText";  // 내용
msgText = msgText.replace("\n", "<BR>");

// mw-002.cafe24.com
String host = "mw-002.cafe24.com";                 // smtp mail server(서버관리자)    
String from = "noreturn@vojesus1.cafe24.com";        // 보내는 주소
String to = "shsuk@i-on.net";            // 받는 사람

Properties props = new Properties();
props.put("mail.smtp.host", host);
props.put("mail.smtp.auth","true");

Authenticator auth = new MyAuthentication();
Session sess = Session.getInstance(props, auth);   // 계정 인증 검사

try {
        Message msg = new MimeMessage(sess);
        msg.setFrom(new InternetAddress(from));   // 보낸 사람
       
        // 한명에게만 보냄
        InternetAddress[] address = {new InternetAddress(to)};
       
        // 다중 전송
        // InternetAddress[] address = {new InternetAddress(to), new InternetAddress(to2)};
        msg.setRecipients(Message.RecipientType.TO, address); // 수령인
       
        msg.setSubject(subject);                  // 제목
        msg.setSentDate(new Date());              // 보낸 날짜 
        // msg.setText(msgText); // 글을 문자만 보낼 경우

        // 글을 HTML 형식으로 보낼 경우
        msg.setContent(msgText, "text/html;charset=euc-kr");
        Transport.send(msg);  // 전송
        out.println(to + "님에게 메일을 발송했습니다.");
} catch (MessagingException mex) {
	mex.printStackTrace();
        out.println(mex.getMessage()+"<br>");
        out.println(to + "님에게 메일 발송을 실패 했습니다.");
}

%>

</div>
   
</body>
</html>

 

 

 		