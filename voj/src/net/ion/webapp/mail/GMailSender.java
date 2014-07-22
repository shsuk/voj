package net.ion.webapp.mail;

import java.io.UnsupportedEncodingException;
import java.security.Security;
import java.util.Date;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeUtility;

import org.apache.log4j.Logger;

public class GMailSender {
	protected static final Logger logger = Logger.getLogger(GMailSender.class);
	private static final String SSL_FACTORY = "javax.net.ssl.SSLSocketFactory";

	
	public void sendSSLMessage(String subject, String message, String from, String to[], String[] attachments) throws MessagingException,	UnsupportedEncodingException {
		boolean debug = false;

		Properties per = new Properties();

		per.put("mail.transport", "smtp"); // 프로토콜 설정
		per.put("mail.smtp.host", "smtp.gmail.com"); // gmail SMTP 호스트 설정
		per.put("mail.smtp.port", "465"); // gmail SMTP 포트 설정
		per.put("mail.smtp.starttls.enable", "true"); // Transport Layer
		per.put("mail.smtp.socketFactory.class","javax.net.ssl.SSLSocketFactory");

		// Secure Socket Layer(SSL)설정
		per.put("mail.smtp.user", from); // 전송자 메일주소
		per.put("mail.smtp.auth", "true"); // SMTP 인증 설정

		// SmtpGmail클래스 객체생성(gmail 아이디/비밀번호값)
		Authenticator auth = new SmtpGmail();
		Session mailSession = Session.getDefaultInstance(per, auth);

		// 메일 전송
		MimeMessage ms = new MimeMessage(mailSession);
		ms.setFrom(new InternetAddress(from));// 전송자 메일주소 설정
		ms.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to[0], false));

		ms.setHeader("Content-Type", "text/html; charset=UTF-8");
		//ms.setSubject(MimeUtility.encodeText(subject, "utf-8", "B"));
		ms.setSubject(subject);
		ms.setContent(message,"text/html;charset=utf-8"); // 내용 설정 (HTML 형식)
		ms.setSentDate(new Date());
		Transport.send(ms);

	}

	public static void send(String from, String[] to, String subject, String text) throws Exception {
		Security.addProvider(new com.sun.net.ssl.internal.ssl.Provider());

		GMailSender sm = new GMailSender();
		sm.sendSSLMessage(subject, text, from, to, null);
		sm = null;
	}
	
	public static void main(String[] args) throws Exception {
		String from = "shsuk@i-on.net";
		String[] to = {"shsuk@i-on.net"};
		String subject = "dddd";
		String text = "ddddd<br>ddddd";
		
		Security.addProvider(new com.sun.net.ssl.internal.ssl.Provider());

		GMailSender sm = new GMailSender();
		sm.sendSSLMessage(subject, text, from, to, null);
		sm = null;
		
	}
}