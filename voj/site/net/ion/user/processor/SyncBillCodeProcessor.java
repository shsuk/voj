package net.ion.user.processor;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;
import net.ion.webapp.utils.IslimUtils;
import net.ion.webapp.utils.SaveObject;
import net.ion.webapp.workflow.WorkflowService;

@Service
public class  SyncBillCodeProcessor extends ImplProcessor {
	public static Map<String, List<String[]>> billCodeMap = new HashMap<String, List<String[]>>();
	protected static final Logger logger = Logger.getLogger(SyncBillCodeProcessor.class);
	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		SaveObject.setSavePath(IslimUtils.processInitialization.getWebInf());
		ReturnValue returnValue = new ReturnValue();
		String src = processInfo.getString("src");
		String groupId = processInfo.getString("groupId");
		List<Map<String, Object>> list = (List<Map<String, Object>>)processInfo.getData(src);

		if(list.size()<1 && billCodeMap.size()==0){//신규메일정보가 없는 경우 저장된 정보로 초기화한다.
			billCodeMap = (Map<String, List<String[]>>)SaveObject.load(this.getClass().getSimpleName(), billCodeMap.getClass());
		
			returnValue.setResult("저장된 코드로 동기화됨");
			return returnValue;
		}
		
		returnValue.setResult("동기화 자료가 없습니다.");
		
		for(Map<String, Object>row : list){
			String content = (String)row.get("CONTENT");
			
			content = StringUtils.substringBetween(content, "</th></tr>", "</table>");
			content = content.replaceAll("</tr>", "").replaceAll("</td>", "");
			String[] records = content.split("<tr>");
			
			List<String[]> accountList = new ArrayList<String[]>();
			
			for(String record : records){
				String[] cols = record.split("<td>");
				if(cols.length<2) continue;
				
				if("project".equals(groupId)) {
					accountList.add(new String[] {cols[1].trim(), cols[2].trim()});
				}else{
					accountList.add(new String[] {cols[2].trim()+","+cols[4].trim(), cols[1].trim()+" - "+cols[3].trim(),});
				}
				//System.out.println(cols);
			}
			returnValue.setResult("동기화됨 (" + groupId + " : "+accountList.size() + "개)");
			billCodeMap.put(groupId, accountList);//코드를 등록한다.
			//동기화된코드를 저장한다.
			SaveObject.save(this.getClass().getSimpleName(), billCodeMap);
			break;
		}
		

		return returnValue;
	}

}
