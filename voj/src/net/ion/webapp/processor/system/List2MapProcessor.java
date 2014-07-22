package net.ion.webapp.processor.system;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Service;

import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;

@Service
public class List2MapProcessor extends ImplProcessor{

	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ReturnValue returnValue = new ReturnValue();

		String src = processInfo.getString("src");
		String key = processInfo.getString("key");
		List<Map<String,Object>> list = (List<Map<String,Object>>)processInfo.getData(src);
		
		returnValue.setResult(execute(key, list));
				
		return returnValue;
	}
	
	public static Map<String,Map<String,Object>> execute(String key, List<Map<String,Object>> list) {
		Map<String,Map<String,Object>> rowMap = new HashMap<String,Map<String,Object>>();
		
		for(Map<String,Object> map : list){
			Object val = map.get(key);
			String keyVal = val==null ? "" : val.toString();
			rowMap.put(keyVal, map);
		}
		return rowMap;
	}
}
