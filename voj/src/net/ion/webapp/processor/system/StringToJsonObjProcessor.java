package net.ion.webapp.processor.system;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;
import net.sf.json.JSONObject;

@Service
public class StringToJsonObjProcessor extends ImplProcessor{

	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ReturnValue returnValue = new ReturnValue();

		String source = null;
		String src = processInfo.getString("src");
		
		source = (String)processInfo.getSourceDate().get(src);
		source = StringUtils.isEmpty(source) ? src : source;
		
		JSONObject js = new JSONObject();
		
		js.put("data", JSONObject.fromObject(source));
		returnValue.setResult(js.get("data"));
		
		return returnValue;
	}
}
