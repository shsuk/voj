package net.ion.webapp.processor.system;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

import net.ion.webapp.db.CodeUtils;
import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;

@Service
public class List2TreeProcessor extends ImplProcessor{
	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ReturnValue returnValue = new ReturnValue();

		List<Map<String,Object>> list = (List<Map<String,Object>>)processInfo.getData(processInfo.getString("data"));
		boolean singleKey = processInfo.getBooleanValue("singleKey", false);
		String upperId = processInfo.getString("upperIdField");
		String id = processInfo.getString("idField");
		String[] title = processInfo.getString("title").split(",");
		String rootId = processInfo.getString("rootId");
				
		Map<String,List<Map<String,Object>>> keyMap = new HashMap<String, List<Map<String,Object>>>();
		/*keyMap에 상호 참조되도록 노드를 넣는다. */
		for(Map<String,Object> row : list){
			Map<String,Object> rec = new HashMap<String, Object>();
			rec.putAll(row);

			String uppKey = rec.get(upperId).toString();
			String idKey = rec.get(id).toString();
			
			List<Map<String,Object>> dataList = keyMap.get(uppKey);
			
			if(dataList==null){
				dataList = new ArrayList<Map<String,Object>>();
				if(!uppKey.equals(idKey)) {
					keyMap.put(uppKey, dataList);
				}
			}

			List<Map<String,Object>> children = keyMap.get(idKey);
			
			if(children==null){
				children = new ArrayList<Map<String,Object>>();
				keyMap.put(idKey, children);
			}
			
			rec.put("children",children);
			
			replaceNode(rec, rootId, upperId, id, uppKey, title, singleKey);
			
			dataList.add(rec);
			

		}
		
		List<Map<String,Object>> tree = keyMap.get(rootId);
		
		returnValue.setResult(tree);
				
		return returnValue;
	}
	
	private void replaceNode(Map<String,Object> rec, String rootId, String upperId, String id, String uppKey, String[] title, boolean singleKey)throws Exception {
		String imgUrl = "../../../../at.sh?_ps=at/upload/dl&thum=36&file_id=";
		Object folder = rec.get("isfolder");
		String isfolder = folder==null ? "" : folder.toString();
		String icon = (String)rec.get("icon");

		if(rootId.equals(uppKey)){//root노드
			rec.put("icon", "folder_docs.gif");
			rec.put("isFolder", true);
		}else if(!"0".equals(isfolder)){//자식노드 존재
			rec.put("isFolder", true);
			if(StringUtils.isNotEmpty(icon)){
				rec.put("icon", imgUrl+icon);
			}else{
				rec.put("icon", "");
			}
		}else{
			if(StringUtils.isNotEmpty(icon)){
				rec.put("icon", imgUrl+icon);
			}
		}
		
		
		//트리의 키를 설정한다.
		if(singleKey){
			rec.put("key", rec.get(id));
		}else{
			rec.put("key", uppKey + "." + rec.get(id));
		}
		
		String titles = "";
		for(String key : title){
			titles += "~" + CodeUtils.getName(key.trim(), (String)rec.get(key.trim()));
		}
		rec.put("title", titles.substring(1));
		rec.put("value", rec.get(id));
		
	}
}
