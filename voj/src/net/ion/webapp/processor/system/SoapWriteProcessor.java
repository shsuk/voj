package net.ion.webapp.processor.system;

import java.io.File;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ProcessInitialization;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;
import net.ion.webapp.utils.ParamUtils;
import net.sf.json.JSONObject;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

@Service
public class SoapWriteProcessor  extends ImplProcessor {

	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ReturnValue returnValue = new ReturnValue();
		StringBuffer sb = new StringBuffer();
		String path = ProcessInitialization.getWebRoot() + processInfo.getString("template");
		HttpURLConnection hc = null;
		String returnType = processInfo.getString("returnType");

		try {
			Object obj = processInfo.get("data");
			if(obj==null){
				obj = FileUtils.readFileToString(new File(path));
			}
			String data = obj.toString();
			data = (String)ParamUtils.getReplaceValue(data, processInfo.getSourceDate());
			URL url = new URL(processInfo.getString("url"));
			hc = (HttpURLConnection)url.openConnection();
			hc.setDoInput(true);
			hc.setDoOutput(true);
			hc.setRequestMethod("POST");
			hc.setUseCaches(false);
			hc.setDefaultUseCaches(false);
			hc.setRequestProperty("Content-Type", "application/json;charset=UTF-8");			
			OutputStream os = hc.getOutputStream();
			IOUtils.write(data, os);
			List<String> list = IOUtils.readLines(hc.getInputStream());
			
			for(String line : list){
				sb.append(line);
			}
		} catch (Exception e) {
			e.printStackTrace();
			sb.append(e.toString());
		}finally{
			if(hc!=null){
				try {
					hc.disconnect();
				} catch (Exception e) {}
			}
		}
		
		if("json".equalsIgnoreCase(returnType)){
			JSONObject jobEtcInfo = JSONObject.fromObject(sb.toString());
			returnValue.setResult(jobEtcInfo);
		}else{
			returnValue.setResult(sb.toString());
		}


		return returnValue;
	}
}
