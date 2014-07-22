package net.ion.webapp.processor.system;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;
import net.ion.webapp.service.ProcessService;

@Service
public class PrintProcessor  extends ImplProcessor{
	protected static final Logger logger = Logger.getLogger(PrintProcessor.class);
	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {

		ReturnValue returnValue = new ReturnValue();
		Object source = null;
		Map<String, String[]> params = null;
		String src = processInfo.getString("src");
		String title = processInfo.getString("title");
		StringBuffer message = new StringBuffer("\n request.getParameterMap\n");
		
		if("param".equals(src)){
			params = (Map<String, String[]>)processInfo.getSourceDate().get(ProcessService.REQUEST_PARAMS);
			StringBuffer sb = new StringBuffer("\nrequest.getParameterMap\n");
			for(String key : params.keySet()){
				sb.append("\t").append(key).append("=");
				for(String val : params.get(key)){
					sb.append(val).append(", ");
				}
				sb.append("\n");
			}
			source = sb.toString();
		}else{
			source = processInfo.getSourceDate().get(src);
		}
		
		message.append("\n\n===============================================\n\t");
		message.append(title);
		message.append("\n\n===============================================");
		message.append("\n페이지 정보");
		message.append("\n\t_ps : " + processInfo.replaceString("@{_ps}"));
		message.append("\n\tProcessor : print\n\tsrc : " + src + "\n\tvalue :\n\t\t");
		message.append(source);
		message.append("\n===============================================\n\n");
		logger.info(message.toString());
		returnValue.setResult(true);
		return returnValue;
	}

}
