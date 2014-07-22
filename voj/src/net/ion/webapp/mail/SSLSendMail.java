package net.ion.webapp.mail;

import java.io.File;
import java.security.Security;
import java.util.Date;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.sun.net.ssl.internal.ssl.Provider;

/**
 * @author mint
 */
public class SSLSendMail extends SendMail {
	private static final String SSL_FACTORY = "javax.net.ssl.SSLSocketFactory";
	private static boolean debug = false;
	private static final Logger log = LoggerFactory.getLogger(SSLSendMail.class);

	public SSLSendMail(String smtpHost, int smtpPort, final String smtpUser, final String smtpPass) {
		super(smtpHost, smtpPort, smtpUser, smtpPass);
	}

	public void send1(String from, String[] to, String[] cc, String[] bcc,
			String charset, String contentType, String subject, String text,
			File[] attachments) throws MailException {
		Security.addProvider(new Provider());
		
		Properties props = new Properties();
		props.put("mail.smtp.host", smtpHost);
		props.put("mail.from", from);
		props.put("mail.smtp.starttls.enable", "true");
		// I tried this by itself and also together with ssl.enable)
		props.put("mail.smtp.ssl.enable", "true");

		Session session = Session.getInstance(props, null);
		MimeMessage msg = new MimeMessage(session);
		
		try {
			msg.setFrom();
			msg.setRecipients(Message.RecipientType.TO, "shsuk@i-on.net");  
			    // also tried @gmail.com
			msg.setSubject("JavaMail ssl test");
			msg.setSentDate(new Date());
			msg.setText("Hello, world!\n");
			props.put("mail.smtp.auth", "false");

			Transport trnsport;
			trnsport = session.getTransport("smtp");
			trnsport.connect();
			msg.saveChanges(); 
			trnsport.sendMessage(msg, msg.getAllRecipients());
			trnsport.close();
		
		} catch (Exception e) {
			e.printStackTrace();
		}

		
	}
	public void send(String from, String[] to, String[] cc, String[] bcc,
			String charset, String contentType, String subject, String text,
			File[] attachments) throws MailException {
		Security.addProvider(new Provider());
		
		Properties props = new Properties();
		props.put("mail.smtp.host", smtpHost);
		props.put("mail.smtp.auth", "true");
		props.put("mail.debug", "true");
		props.put("mail.smtp.port", String.valueOf(smtpPort));
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.socketFactory.port", String.valueOf(smtpPort));
		props.put("mail.smtp.socketFactory.class", SSL_FACTORY);
		props.put("mail.smtp.socketFactory.fallback", "false");

		Session session = Session.getDefaultInstance(props,
				new javax.mail.Authenticator() {

					protected PasswordAuthentication getPasswordAuthentication() {
						return new PasswordAuthentication(smtpUser, smtpPass);
					}
				});

		session.setDebug(debug);

		try {
			Message msg = new MimeMessage(session);
			//msg.setHeader("X-Mailer", "I-ON FX Mailer");
			
			InternetAddress addressFrom = new InternetAddress(smtpUser);
			msg.setFrom(addressFrom);

			InternetAddress[] addressTo = new InternetAddress[to.length];
			for (int i = 0; i < to.length; i++) {
				addressTo[i] = new InternetAddress(to[i]);
			}
			msg.setRecipients(Message.RecipientType.TO, addressTo);

			// Setting the Subject and Content Type
			msg.setSubject(subject);
			if (contentType == null || "".equals(contentType)) {
				msg.setContent(text, "text/plain; charset=utf-8");
			} else {
				msg.setContent(text, contentType); // HTML
				// message.setContent(text,"text/html; charset=euc-kr"); // HTML
			}
		
			Transport.send(msg);
			
			log.info("From :" + from + " To : " + StringUtils.join(to, ',') + ", mail is sent");

		} catch (MessagingException e) {
			log.warn("From :" + from + " To : " + StringUtils.join(to, ',') + ", mail is not sent");
			e.printStackTrace();
			throw new MailException("could not send the mail", e);
		}
		
	}

	public void enqueueSend(String from, String to, String subject, String text) {
		enqueueSend(from, new String[] { to }, null, null, null, subject, text, null);
	}

	/**
	 * non-blocking mode
	 */
	public void enqueueSend(String from, String[] to, String[] cc, String[] bcc, String charset, String subject, String text, File[] attachments) {
		WaitingTicket ticket = new WaitingTicket(from, to, cc, bcc, charset, subject, text, attachments);
		Thread sendingThread = null;
		synchronized (waitLine) {
			waitLine.addLast(ticket);
			// log.info("sending mail request enqueued, ticket="+ticket);
			if (!hasSendingThread) {
				sendingThread = new Thread(new SendingRunner(this));
				hasSendingThread = true;
			}
		}

		if (sendingThread != null) {
			sendingThread.setDaemon(true);
			sendingThread.start();
		}
	}
	public static void send(String smtpHost, int smtpPort, final String smtpUser, final String smtpPass, String from, String[] to, String[] cc, String[] bcc, String charset, String subject, String text, File[] attachments) throws MailException {
		SSLSendMail sm = new SSLSendMail(smtpHost, smtpPort, smtpUser, smtpPass);
		sm.send(from, to, cc, bcc, charset, null, subject, text, attachments);
		sm = null;
	}
	
}
