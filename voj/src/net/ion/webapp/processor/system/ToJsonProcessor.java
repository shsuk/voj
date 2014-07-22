package net.ion.webapp.processor.system;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Service;

import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;
import net.ion.webapp.service.ProcessService;
import net.sf.json.JSONObject;

@Service
public class ToJsonProcessor extends ImplProcessor{

	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ReturnValue returnValue = new ReturnValue();

		Object source = null;
		String src = processInfo.getString("src");
		
		if("param".equals(src)){
			source = (Map<String, String[]>)processInfo.getSourceDate().get(ProcessService.REQUEST_PARAMS);
		}else{
			source = processInfo.getSourceDate().get(src);
		}
		
		JSONObject js = new JSONObject();
		
		js.put("data", source);
		returnValue.setResult(js.get("data"));
				
		return returnValue;
	}
}
