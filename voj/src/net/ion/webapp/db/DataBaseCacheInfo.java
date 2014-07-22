package net.ion.webapp.db;

import java.util.Date;
import java.util.List;

import net.ion.webapp.utils.LowerCaseMap;

class DataBaseCacheInfo{
	List<LowerCaseMap<String, Object>> list;
	public long getCacheTime() {
		return cacheTime;
	}

	public void setCacheTime(long cacheTime) {
		this.cacheTime = cacheTime;
	}

	public List<LowerCaseMap<String, Object>> getList() {
		return list;
	}

	long cacheTime;
	
	public DataBaseCacheInfo(List<LowerCaseMap<String, Object>> list){
		cacheTime = (new Date()).getTime();
		this.list = list;
	}

}
