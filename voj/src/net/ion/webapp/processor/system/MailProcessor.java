package net.ion.webapp.processor.system;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ion.webapp.db.CodeUtils;
import net.ion.webapp.mail.EmailUtil;
import net.ion.webapp.mail.GMailSender;
import net.ion.webapp.mail.SSLSendMail;
import net.ion.webapp.mail.SendMail;
import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ProcessInitialization;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;
import net.ion.webapp.processor.ProcessorFactory;
import net.ion.webapp.processor.ProcessorService;
import net.ion.webapp.utils.DbUtils;
import net.ion.webapp.utils.LowerCaseMap;
import net.ion.webapp.utils.ParamUtils;
import net.sf.json.JSONArray;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

@Service
public class MailProcessor  extends ImplProcessor{
	protected static final Logger logger = Logger.getLogger(MailProcessor.class);

	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {

		ReturnValue returnValue = new ReturnValue();
		returnValue.setResult(true);

		String smtpHost = processInfo.getString("host");
		String port = processInfo.getString("port"); 
		int smtpPort = StringUtils.isEmpty(port) ? 0 : Integer.parseInt(port); 
		String smtpUser = null;
		String smtpPass = null;

		
		File[] attachments = null;
		boolean hsAuthenticate = processInfo.getBooleanValue("authenticate", false);
		
		String protocol = processInfo.getString("protocol");
		//설정에서 정보를 가지고 온다.
		Object to = processInfo.getProcessDetail().get("to");
		Object cc = processInfo.getProcessDetail().get("cc");
		Object bcc = processInfo.getProcessDetail().get("bcc");

		String from = processInfo.getString("from");
		String subject = ""; // processInfo.getString("subject");
		String body = ""; // processInfo.getString("body");
		String template = processInfo.getString("template");

		//DB에 정보가 있는 경우 DB 정보를 가지고 온다.
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("bd_key", template);
		List<LowerCaseMap<String, Object>> list = DbUtils.select("voj/usr/user_mail", params);
		LowerCaseMap<String, Object> row = list.get(0);
		subject = (String)row.get("title");
		body = (String)row.get("CONTENTS");
		//값을 치환한다.
		String[] tos = getMail(to, processInfo.getSourceDate());
		String[] ccs = getMail(cc, processInfo.getSourceDate());
		String[] bccs = getMail(bcc, processInfo.getSourceDate());
		subject = processInfo.replaceString(subject);
		body = processInfo.replaceString(body);
		
		logger.debug(body);
		
		try {
			smtpHost = StringUtils.isNotEmpty(smtpHost) ? smtpHost : CodeUtils.getReferenceValue("smtp_server", "smtpHost");
			smtpPort = smtpPort!=0 ? smtpPort :  Integer.parseInt(CodeUtils.getReferenceValue("smtp_server", "smtpPort"));
			smtpUser = StringUtils.isNotEmpty(smtpUser) ? smtpUser :  CodeUtils.getReferenceValue("smtp_server", "smtpUser");
			smtpPass = StringUtils.isNotEmpty(smtpPass) ? smtpPass :  CodeUtils.getReferenceValue("smtp_server", "smtpPass");
			from = StringUtils.isNotEmpty(from) ? from : smtpUser;
		} catch (Exception e) {
			throw new Exception("코드 테이블에 CodeUtils에서 사용하는  smtp_server (smtpHost, smtpPort, smtpUser, smtpPass)정보가 등록 되지 안았습니다.");
		}
		String[] froms = getMail(from, processInfo.getSourceDate());
		from = froms[0];
		
		if("ssl".equals(protocol)){
			EmailUtil.send(smtpHost, smtpPort, smtpUser, smtpPass, from, tos, ccs, bccs, "utf-8", subject, body, attachments, true, hsAuthenticate);
		}else if("gmail".equals(protocol)){
			GMailSender.send(from, tos, subject, body);
		}else{
			//EmailUtil.send("mw-002.cafe24.com", 25, "vojesus1@cafe24.com", "dptnakdmf0254","noreturn@vojesus1.cafe24.com", new String[]{"shsuk@vojesus.org"}, new String[]{}, new String[]{}, "utf-8", "test", "연습", null, false, false);
			//System.out.println("\n\n\n 메일 성공");
			EmailUtil.send(smtpHost, smtpPort, smtpUser, smtpPass, from, tos, ccs, bccs, "utf-8", subject, body, attachments, false, true);
		}
		return returnValue;
	}
	
	private String[] getMail(Object o, Map<String, Object> sourceDate) {
		String[] mails = {};
		
		//Object o = processDetail.get(id);
		
		if(o==null){
			return mails;
		}else if (o instanceof List) {
			List<String> to = (List<String>)o;
			mails = to.toArray(new String[0]);
			for(int i=0; i<mails.length; i++) mails[i] = (String)ParamUtils.getReplaceValue(mails[i], sourceDate);
		}else if (o instanceof String) {
			String mail = (String) o;
			if("".equals(mail.trim())){
				return mails;
			}
			mail = (String)ParamUtils.getReplaceValue(mail, sourceDate);
			mails = mail.split(",");
		}
		
		return mails;
	}
	
	public static void main(String[] args)throws Exception {
		String[] tos = {"shsuk@i-on.net"};
		GMailSender.send( "shsuk87@gamil.com", tos, "test", "OKfgfgfgfgf");

	}
/*	
	public static void main(String[] args)throws Exception {
		

		class SmtpGmail extends Authenticator {
			
			public SmtpGmail(){};
			
			 protected PasswordAuthentication getPasswordAuthentication() {

			  // TODO Auto-generated method stub

			  

			  String user = "shsuk87@gmail.com";

			  String pw = "ssh87208720";

			  

			  return new PasswordAuthentication(user, pw);

			 }
		}

			  

			  String from = "shsuk87@gmail.com";

			  String to = "shsuk87@gmail.com";

			  String notice = "";

			  

			  Properties per = new Properties();

			  

			  per.put("mail.transport", "smtp"); //프로토콜 설정

			  per.put("mail.smtp.host", "smtp.gmail.com"); // gmail SMTP 호스트 설정

			  per.put("mail.smtp.port", "465"); //gmail SMTP 포트 설정

			  per.put("mail.smtp.starttls.enable", "true"); //Transport Layer Sercurity 설정

			  per.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory"); 

			                //Secure Socket Layer(SSL)설정

			  per.put("mail.smtp.user", from);  //전송자 메일주소

			  per.put("mail.smtp.auth", "true"); //SMTP 인증 설정

			  

			  //SmtpGmail클래스 객체생성(gmail 아이디/비밀번호값)  

			  Authenticator auth = new SmtpGmail();

			  Session mailSession = Session.getDefaultInstance(per,auth);

			  

			  //메일 전송

			  try{

			  MimeMessage ms = new MimeMessage(mailSession);

			  

			  ms.setFrom(new InternetAddress(from));//전송자 메일주소 설정

			  ms.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));

			                //수신자 메일주소 설정

			    

			  ms.setSubject("제목");

			  ms.setText("내용");

			  ms.setSentDate(new Date());

			  Transport.send(ms);

			  

			  notice = "전송완료";

			  

			  }catch(Exception e){

			  e.printStackTrace();

			  }

			   System.out.print(notice);

		} 
*/

}
