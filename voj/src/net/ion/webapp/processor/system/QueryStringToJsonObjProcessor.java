package net.ion.webapp.processor.system;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Service;

import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;
import net.sf.json.JSONObject;

@Service
public class QueryStringToJsonObjProcessor extends ImplProcessor{

	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ReturnValue returnValue = new ReturnValue();

		String source = null;
		String src = processInfo.getString("src");
		
		source = (String)processInfo.getSourceDate().get(src);
		
		JSONObject js = new JSONObject();
		String[] params = source.split("&");
		
		for(String param : params){
			String[] val = param.split("=");
			js.put(val[0], val[1]);
		}
		returnValue.setResult(js);
				
		return returnValue;
	}
}
