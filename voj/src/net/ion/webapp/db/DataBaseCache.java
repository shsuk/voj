package net.ion.webapp.db;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.ion.webapp.utils.LowerCaseMap;

public class DataBaseCache{

	private static Map<String, DataBaseCacheInfo> cacheMap = new HashMap<String, DataBaseCacheInfo>();

	public static List<LowerCaseMap<String, Object>> getCache(String query, Map<String, Object> params, int refreshTime){
		String key = query + "__" + params.toString();
		DataBaseCacheInfo cacheInfo = cacheMap.get(key);
		
		if(cacheInfo==null) return null;
		
		if(refreshTime<1) cacheInfo.getList();
		
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.SECOND, -(refreshTime));

		long endTime = cal.getTimeInMillis();
		
		if(cacheInfo.getCacheTime()<endTime){
			cacheMap.remove(key);
			return null;
		}
		return cacheInfo.getList();
	}
	
	public static synchronized void addCache(String query, Map<String, Object> params, List<LowerCaseMap<String, Object>> list){
		if(cacheMap.size()>200) return;
		
		DataBaseCacheInfo cacheInfo = new DataBaseCacheInfo(list);
		String key = query + "__" + params.toString();
		cacheMap.put(key, cacheInfo);
	}
	public static synchronized int clear(){
		int count = cacheMap.size();
		cacheMap.clear();
		CodeUtils.clear();
		return count;
	}
	
}
