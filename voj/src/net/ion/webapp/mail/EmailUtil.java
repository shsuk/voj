package net.ion.webapp.mail;

import java.io.*; 
import java.security.*;
import java.security.cert.*;

import javax.net.ssl.*;
import javax.mail.*; 
import javax.mail.Part;
import javax.servlet.http.*; 

import java.util.*; 

import net.ion.webapp.utils.LowerCaseMap;

import org.apache.commons.beanutils.MethodUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.mail.DefaultAuthenticator;
import org.apache.commons.mail.Email;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.SimpleEmail;
import org.springframework.security.util.FieldUtils;

import com.sun.mail.pop3.POP3SSLStore;


/**
 * @author mint
 */
public class EmailUtil  {
	private final String smtpHost;
	private final int smtpPort;
	private final String smtpUser;
	private final String smtpPass;
	private boolean hsAuthenticate;
	private boolean isSSL;
	private String charset;
	private static final String SSL_FACTORY = "javax.net.ssl.SSLSocketFactory";
	
	public EmailUtil(String smtpHost, int smtpPort, final String smtpUser, final String smtpPass,boolean isSSL, boolean hsAuthenticate, String charset) {
		this.smtpHost = smtpHost;
		this.smtpPort = smtpPort;
		this.smtpUser = smtpUser;
		this.smtpPass = smtpPass;
		this.charset = charset;
		this.hsAuthenticate = hsAuthenticate;
		this.isSSL = isSSL;
	}
	// javamail lib 이 필요합니다.
	class MyAuthentication extends Authenticator {
	    PasswordAuthentication pa;
	    public MyAuthentication(String smtpUser, String smtpPass){
	        pa = new PasswordAuthentication(smtpUser, smtpPass); 

	              //ex) ID:cafe24@cafe24.com PASSWD:1234
	    }

	    public PasswordAuthentication getPasswordAuthentication() {
	        return pa;
	    }
	}
	public void send(String from, String[] tos, String[] ccs, String[] bccs, String charset, String contentType, String subject, String text, File[] attachments) throws EmailException {
		
		Email email = new SimpleEmail();
		email.setHostName(smtpHost);
		email.setSmtpPort(smtpPort);
		email.setSslSmtpPort(String.valueOf(smtpPort));
		if(hsAuthenticate){
			email.setAuthenticator(new MyAuthentication(smtpUser, smtpPass));
		}
		if(isSSL){
			email.setSSLOnConnect(true);
		}
		//email.setStartTLSEnabled(true);
		//email.setSSLCheckServerIdentity(true);
		
		email.setFrom(from);
		email.setSubject(subject);
		//email.setMsg(text);
		email.setContent(text, "text/html;charset=euc-kr");
		for(String to : tos){
			System.out.println("to : " + to);
			email.addTo(to);
		}
		for(String cc : ccs){
			System.out.println("cc : " + cc);
			email.addCc(cc);
		}
		for(String bcc : bccs){
			System.out.println("bcc : " + bcc);
			email.addCc(bcc);
		}
		email.send();	
	}
	
	public List<Map<String, Object>> receivePop3(String searchFrom, Date receivedDate, String searchSubject, int limit) throws Exception { 
		long startTime = receivedDate==null ? 0 : receivedDate.getTime();
		boolean isSearchFrom = StringUtils.isNotEmpty(searchFrom);
		boolean isSearchSubject = StringUtils.isNotEmpty(searchSubject);
		
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		Folder folder = null;
		Store store = null;
		
		try {
			
			 Properties pop3Props = new Properties();
             pop3Props.setProperty("mail.pop3.ssl.trust", "*");
             pop3Props.setProperty("mail.pop3.port", String.valueOf(smtpPort));
             URLName url = new URLName("pop3", smtpHost, smtpPort, "", smtpUser, smtpPass);
             Session session = Session.getInstance(pop3Props, null);
             store = new POP3SSLStore(session, url);
             store.connect();
			

			folder = store.getFolder("INBOX");
			folder.open(Folder.READ_ONLY);

			Message message[] = folder.getMessages();
			int n = message.length-100;
			
			for (int i = message.length-1; i >= n; i--) {
				if(list.size() > limit) {
					break;
				}
	
				Date sentDate = message[i].getSentDate();
				if(sentDate!=null && startTime > sentDate.getTime()) {
					break;
				}
				
				String from = (String)FieldUtils.getProtectedFieldValue("address", message[i].getFrom()[0]);
				if(isSearchFrom){
					if(!searchFrom.equals(from)) {
						continue;
					}
				}

				String subject = message[i].getSubject();
				if(isSearchSubject){
					if(subject.indexOf(searchSubject)<0) {
						continue;
					}
				}
				Map<String, Object> row = new LowerCaseMap<String, Object>();
				list.add(row);
				
				row.put("from", from);
				row.put("subject", subject);
				//row.put("received_date", message[i].getReceivedDate());
				row.put("sent_date", message[i].getSentDate());
				//out.print("from: " + message[i].getFrom()[0] + " ,  subject: " + message[i].getSubject() + "<br><br>");
				
				if (message[i].isMimeType("multipart/*")) {
					Multipart multipart = (Multipart) message[i].getContent();

					for (int j = 0; j < multipart.getCount(); j++) {
						Part p = multipart.getBodyPart(j);
						if (p.isMimeType("text/plain") || p.isMimeType("text/html")) {
							//out.print(p.getContent());
							row.put("content", p.getContent());
						} else {
							String filename = p.getFileName();
							if (filename != null) {
								InputStream in = null;
								FileOutputStream fout = null;
								try {
									in = p.getInputStream();
									fout = new FileOutputStream(new File(filename));
									int c = in.read();
									while (c != -1) {
										fout.write(c);
										c = in.read();
									}
									row.put("content", filename);
									//out.print(" file :<a href = D:/jakarta/bin/" + filename + ">" + filename + "</a>");
									
								}catch (Exception e) {
									row.put("content", e.toString());
								} finally {
									if(fout!=null){
										try {
											fout.close();
										} catch (Exception e2) { } 
									}
									if(in!=null){
										try {
											in.close();
										} catch (Exception e2) { } 
									}
								}
							}
						}
					}

				} else {
					//out.print(message[i].getContent() + "<hr>");
					row.put("content", message[i].getContent());
				}
			}
		} catch (Exception e) {
			if (e instanceof MessagingException) {
				MessagingException me = (MessagingException)e;
				Exception ne = me.getNextException();
				if (ne instanceof SSLHandshakeException) {
					try {
						//인증서를 가져온다.
						String[] args = {smtpHost + ":" + smtpPort};
						InstallCert.main(args);
					} catch (Exception e2) {
						e2.printStackTrace();
						throw e2;
					}					
				}
				
				throw e;
			}
			throw e;
		}finally{
			if(folder!=null){
				try {
					folder.close(false);
				} catch (Exception e2) { } 
			}
			
			if(store!=null){
				try {
					store.close();
				} catch (Exception e2) { } 
			}
		}
		return list;
	}
	
	public static void send(String smtpHost, int smtpPort, final String smtpUser, final String smtpPass, String from, String[] to, String[] cc, String[] bcc, String charset, String subject, String text, File[] attachments,boolean isSSL, boolean hsAuthenticate) throws EmailException {
		EmailUtil sm = new EmailUtil(smtpHost, smtpPort, smtpUser, smtpPass, isSSL, hsAuthenticate, charset);
		sm.send(from, to, cc, bcc, charset, null, subject, text, attachments);
		
	}
	
	public static List<Map<String, Object>> receivePop3(String smtpHost, int smtpPort, final String smtpUser, final String smtpPass, String charset,boolean isSSL, String searchFrom, Date receivedDate, String searchSubject, int limit) throws Exception { 

		EmailUtil sm = new EmailUtil(smtpHost, smtpPort, smtpUser, smtpPass, isSSL, true, charset);

		return sm.receivePop3(searchFrom, receivedDate, searchSubject, limit);
	}
	
	public static void main(String[] args)throws Exception {
		EmailUtil.send("mw-002.cafe24.com", 25, "vojesus1", "dptnakdmf0254","noreturn@vojesus1.cafe24.com", new String[]{"shsuk@i-on.net"}, new String[]{}, new String[]{}, "utf-8", "test", "연습", null, false, true);
	}

}
