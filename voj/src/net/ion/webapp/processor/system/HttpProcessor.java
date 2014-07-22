package net.ion.webapp.processor.system;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;
import net.ion.webapp.processor.ProcessorFactory;
import net.ion.webapp.utils.HttpUtils;
import net.ion.webapp.utils.ParamUtils;
import net.sf.json.JSONObject;

@Service
public class HttpProcessor  extends ImplProcessor{
	protected static final Logger logger = Logger.getLogger(HttpProcessor.class);

	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String url = processInfo.getString("url");
		Map<String, Object> params = null;
		String val = null;
		try {
			params = makeParams(processInfo.getProcessDetail(), processInfo.getSourceDate());
			//http 연동
			logger.info("\n[연동정보]\nURL : " + url + "\nPrrameter : " + (params!=null ? params.toString() : "") + "\n");
			val = HttpUtils.getString(url, params);
		} catch (Exception e) {
			throw new RuntimeException(e.toString() + "\n[연동정보]\nURL : " + url + "\nPrrameter : " + (params!=null ? params.toString() : "") + "\n", e);
		}

		ReturnValue returnValue = new ReturnValue();
		returnValue.setResult(val);
		
		if(processInfo.isDebug() || processInfo.isTest()){
			returnValue.append("URL : " + url + "\nParameter : " + params + "\nSource Date : " + processInfo.getSourceDate());
		}
		
		return returnValue;
	}
	
	private Map<String, Object> makeParams(JSONObject processDetail, Map<String, Object> sourceDate) {
		Object params = (Object)processDetail.get("params");

		if(params==null) return null;
/*		
		if (params instanceof String) {
			return (JSONObject)ParamUtils.getReplaceValue((String) params, sourceDate) ;
		}
*/		
		if (params instanceof Map) {
			Map<String, Object>paramValues = new HashMap<String, Object>();
			paramValues.putAll((Map<String, Object>) params);
			
			for(String key : paramValues.keySet()){
				String val = ParamUtils.getReplaceValue(paramValues.get(key).toString(), sourceDate).toString();
				paramValues.put(key, val);
			}
			return paramValues;
		}
		//위 케이스가 아닌 경우 오류
		throw new RuntimeException("파라메터 형식 오류 : Prrameter : " + params.toString());
	}

}
