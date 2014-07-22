package net.ion.webapp.processor.system;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;
import net.ion.webapp.service.ProcessService;
import net.ion.webapp.utils.Aes;
import net.ion.webapp.utils.Sha256;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.ServletRequestUtils;

@Service
public class RequestEncProcessor extends ImplProcessor{

	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		Map<String, String[]> __REQUEST__ = (Map<String, String[]>)request.getAttribute(ProcessService.REQUEST_REPLACE_PARAMS);
		Map<String, String> param = new HashMap<String, String>();
		
		String[] fields = processInfo.getString("aes256").split(",");
		if(fields!=null){
			for(String field : fields){
				String val = ServletRequestUtils.getStringParameter(request, field, "");
				val = StringUtils.isNotEmpty(val) ? Aes.encrypt(val) : "";
				param.put(field, val);
				String[] vals = {val};
				__REQUEST__.put(field, vals);
			}
		}
		
		fields = processInfo.getString("sha256").split(",");
		if(fields!=null){
			for(String field : fields){
				String val = ServletRequestUtils.getStringParameter(request, field, "");
				
				val = StringUtils.isNotEmpty(val) ? Sha256.encrypt(val) : val;
				param.put(field, val);
				String[] vals = {val};
				__REQUEST__.put(field, vals);
			}
		}
		ReturnValue returnValue = new ReturnValue();
		returnValue.setResult(param);
		
		return returnValue;
	}
}
