package net.ion.webapp.db;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.ion.webapp.utils.DbUtils;
import net.ion.webapp.utils.LowerCaseMap;

public class UserUtils {
	private static String queryPath = "user/userInfo";


	public static String getName(int userId)throws Exception{

		LowerCaseMap<String, Object> userInfo = getUserInfo(userId);
		
		return userInfo==null ? "" : (String)userInfo.get("mb_nm");
	}
	
	public static String getLoginId(int userId)throws Exception{

		LowerCaseMap<String, Object> userInfo = getUserInfo(userId);
		
		return userInfo==null ? "" : (String)userInfo.get("mb_login_id");
	}
	private static LowerCaseMap<String, Object> getUserInfo(int userId)throws Exception{
		List<LowerCaseMap<String, Object>> list = null;

		try {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("user_id", userId);
			list = DbUtils.select(queryPath, param, true, 600);
		}catch(Exception e){
			return null;
		}
		
		return list.size()>0 ? list.get(0) : null;
	}

}
