package net.ion.webapp.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.ion.webapp.db.QueryInfo;
import net.ion.webapp.process.ProcessInitialization;
import net.ion.webapp.processor.ProcessorFactory;
import net.ion.webapp.utils.CookieUtils;
import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;

@Service
public class TestService {
	
	private boolean isTest = false;
	//private Map<String, Boolean> testUserMap = new HashMap<String, Boolean>();;
	
	public boolean isTest()throws Exception{
		return isTest;
	} 
	public boolean isTestUser(HttpServletRequest request)throws Exception{
		if(request==null) return false;
		//if(!isTest) return false;
		
		String val = CookieUtils.getCookie(request, "_debug_");
		if("true".equals(val)){
			isTest = true;;
		}else{
			isTest = false;
		}
		return isTest;
		//return testUserMap.containsKey(val);
	}
	public void setTest(boolean isTest)throws Exception{
		this.isTest = isTest;
	}
/*	
	public String getTestUser()throws Exception{
		StringBuffer sb = new StringBuffer();
		
		for(String user : testUserMap.keySet()){
			sb.append(user).append("\n");
		}
		return sb.toString();
	}
	public void setTestUser(String[] users)throws Exception{
		testUserMap.clear();
		for(String user : users){
			user = user.trim();
			if("".equals(user)) continue;
			testUserMap.put(user, true);
		}
	}
*/	
	public Map<String, Object> getTestProcessInfo() {
		Map<String, Object> rtn = new HashMap<String, Object>();
		List<JSONObject> pl = new ArrayList<JSONObject>();
		Map<String, ProcessInitialization> pm = ProcessInitialization.getProcessInfoMap();
		
		if(pm==null) return rtn;
		
		for(String key : pm.keySet()){
			if(key.endsWith(".test")){
				JSONObject jo = new JSONObject();
				ProcessInitialization processInfo = pm.get(key);
				jo.put("id", key);
				jo.put("적용여부", processInfo.isApply());
				pl.add(jo);
			}
		}
		rtn.put("테스트 목록", pl);
		rtn.put("전체 건수", pl.size());
		
		return rtn;
	}
	
	public Map<String, Object> getTestQueryInfo() {
		Map<String, Object> rtn = new HashMap<String, Object>();
		List<JSONObject> pl = new ArrayList<JSONObject>();
		Map<String, QueryInfo> pm = QueryInfo.getQueryInfoMap();
		
		if(pm==null) return rtn;
		
		for(String key : pm.keySet()){
			if(key.endsWith(".test")){
				JSONObject jo = new JSONObject();
				QueryInfo queryInfo = pm.get(key);
				jo.put("id", key);
				jo.put("적용여부", queryInfo.isApply());
				pl.add(jo);
			}
		}
		
		rtn.put("테스트 목록", pl);
		rtn.put("전체 건수", pl.size());
		
		return rtn;
	}
	
	
	/**
	 * 테스트 쿼리정보에 있는 정보와 물리 파일을 삭제한다.
	 * @return
	 */
	public Map<String, Object> deleteTestQueryInfo() {
		Map<String, Object> pl = new HashMap<String, Object>();
		Map<String, QueryInfo> pm = QueryInfo.getQueryInfoMap();
		
		if(pm==null) return pl;
			
		for(String key : pm.keySet()){
			if(key.endsWith(".test")){
				//테스트가 적용된 건은 제외(복구를 위해 테스트 정보는 삭제되지 않는다.)
				if(!pm.get(key).isApply()){
					pl.put(key, false);
				}
			}
		}
		int failCount = 0;
		for(String key : pl.keySet()){
			boolean isSuccess = pm.get(key).remove();
			pl.put(key, isSuccess);
			if(!isSuccess) failCount++;
		}
		
		pl.put("전체 건수", pl.size());
		pl.put("실패 건수", failCount);
		return pl;
	}
	
	/**
	 * 테스트 쿼리와 프로세스 정보를 삭제한다.
	 * 물리 파일은 삭제되지 않는다.
	 */
	public void deleteTestInfo() {
		
		Map<String, QueryInfo> qm = QueryInfo.getQueryInfoMap();
		Map<String, Object> info = getTestQueryInfo();
		for(String key : info.keySet()){
			qm.remove(key);
		}
		
		Map<String, ProcessInitialization> pm = ProcessInitialization.getProcessInfoMap();
		info = getTestProcessInfo();
		
		for(String key : info.keySet()){
			pm.remove(key);
		}
		
	}
	
	
	/**
	 * 물리적인 파일은 적용되지만 복구를 위해 테스트 정보는 삭제되지 않는다.
	 * @return
	 */
	public Map<String, Object> applyTestProcessInfo() {
		Map<String, Object> pl = new HashMap<String, Object>();
		Map<String, ProcessInitialization> pm = ProcessInitialization.getProcessInfoMap();
		
		if(pm==null) return pl;
		//적용할 테스트 대상을 찾는다.
		for(String key : pm.keySet()){
			if(key.endsWith(".test")){
				ProcessInitialization processInfo = pm.get(key);
				if(!processInfo.isApply()) pl.put(key, false);
			}
		}
		
		int failCount = 0;
		//찾은 적용 대상을 적용한다.
		for(String key : pl.keySet()){
			boolean isSuccess = pm.get(key).apply();
			pl.put(key, isSuccess);
			if(!isSuccess) failCount++;
		}
		
		pl.put("전체 건수", pl.size());
		pl.put("실패 건수", failCount);
		return pl;
	}
	
	/**
	 * 물리적인 파일은 적용되지만 복구를 위해 테스트 정보는 삭제되지 않는다.
	 * @return
	 */
	public Map<String, Object> applyTestQueryInfo() {
		Map<String, Object> pl = new HashMap<String, Object>();
		Map<String, QueryInfo> pm = QueryInfo.getQueryInfoMap();
		
		if(pm==null) return pl;
			
		for(String key : pm.keySet()){
			if(key.endsWith(".test")){
				QueryInfo queryInfo = pm.get(key);
				if(!queryInfo.isApply()) pl.put(key, false);
			}
		}
		int failCount = 0;
		for(String key : pl.keySet()){
			boolean isSuccess = pm.get(key).apply();
			pl.put(key, isSuccess);
			if(!isSuccess) failCount++;
		}
		
		pl.put("전체 건수", pl.size());
		pl.put("실패 건수", failCount);
		
		return pl;
	}
	
	
	public Map<String, Object> recoveryTestQueryInfo() {
		Map<String, Object> pl = new HashMap<String, Object>();
		Map<String, QueryInfo> pm = QueryInfo.getQueryInfoMap();
		
		if(pm==null) return pl;
			
		for(String key : pm.keySet()){
			if(key.endsWith(".test")){
				QueryInfo queryInfo = pm.get(key);
				if(queryInfo.isApply()) pl.put(key, false);
			}
		}
		int failCount = 0;
		for(String key : pl.keySet()){
			boolean isSuccess = pm.get(key).recovery();
			pl.put(key, isSuccess);
			if(!isSuccess){
				failCount++;
			}
		}
		
		pl.put("전체 건수", pl.size());
		pl.put("실패 건수", failCount);

		return pl;
	}
	
}
