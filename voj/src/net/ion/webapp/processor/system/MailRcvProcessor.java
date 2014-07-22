package net.ion.webapp.processor.system;

import java.io.File;
import java.util.Date;
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
import net.ion.webapp.utils.ParamUtils;
import net.sf.json.JSONArray;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

@Service
public class MailRcvProcessor  extends ImplProcessor{
	protected static final Logger logger = Logger.getLogger(MailRcvProcessor.class);

	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {

		ReturnValue returnValue = new ReturnValue();
		returnValue.setResult(true);

		String smtpHost = processInfo.getString("host");
		String port = processInfo.getString("port"); 
		int smtpPort = StringUtils.isEmpty(port) ? 0 : Integer.parseInt(port); 
		String smtpUser = processInfo.getString("user");
		String smtpPass = processInfo.getString("pwd");
		String protocol = processInfo.getString("protocol");

		String searchFrom = processInfo.getString("searchFrom");
		String searchSubject = processInfo.getString("searchSubject");
		int receivedTime = processInfo.getIntValue("receivedTime", 0);
		int limit = processInfo.getIntValue("limit", Integer.MAX_VALUE);
				
		Date receivedDate = receivedTime==0 ? null : DateUtils.addMinutes(new Date(), -receivedTime);
		
		try {
			smtpHost = StringUtils.isNotEmpty(smtpHost) ? smtpHost : CodeUtils.getReferenceValue("smtp_server", "smtpHost");
			smtpPort = smtpPort!=0 ? smtpPort :  Integer.parseInt(CodeUtils.getReferenceValue("smtp_server", "smtpPort"));
			smtpUser = StringUtils.isNotEmpty(smtpUser) ? smtpUser :  CodeUtils.getReferenceValue("smtp_server", "smtpUser");
			smtpPass = StringUtils.isNotEmpty(smtpPass) ? smtpPass :  CodeUtils.getReferenceValue("smtp_server", "smtpPass");
		} catch (Exception e) {
			throw new Exception("코드 테이블에 CodeUtils에서 사용하는  smtp_server (smtpHost, smtpPort, smtpUser, smtpPass)정보가 등록 되지 안았습니다.");
		}
		
		List<Map<String, Object>> list = EmailUtil.receivePop3(smtpHost, smtpPort, smtpUser, smtpPass, "utf-8", "ssl".equalsIgnoreCase(protocol), searchFrom, receivedDate, searchSubject, limit);
		returnValue.setResult(list);
		return returnValue;
	}
	
}
