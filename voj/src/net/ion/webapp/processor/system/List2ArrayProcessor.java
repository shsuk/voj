package net.ion.webapp.processor.system;

import java.util.ArrayList;
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
public class List2ArrayProcessor extends ImplProcessor{

	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ReturnValue returnValue = new ReturnValue();
		Map<String,Object> data = new HashMap<String, Object>();

		List<String> removecolumn = (List<String>)processInfo.get("removeColumn");
		String src = processInfo.getString("src");
		List<Map<String,Object>> rows = (List<Map<String,Object>>)processInfo.getData(src);
		
		List<String> col_name = new ArrayList<String>();
		Map<String,Object> rec = rows.get(0);
		
		for(String key : rec.keySet()){
			if(removecolumn.contains(key)) continue;
			col_name.add(key);
		}
		
		for(String key : removecolumn){
			data.put(key, rec.get(key));
		}
		
		List<List<Object>> items = new ArrayList<List<Object>>();

		for(Map<String,Object> row : rows){
			List<Object> item = new ArrayList<Object>();
			for(String key : col_name){
				item.add(row.get(key));
			}
			items.add(item);
		}
		
		data.put("col_name", col_name);
		data.put("items", items);
		returnValue.setResult(data);
				
		return returnValue;
	}
}
