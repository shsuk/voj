package net.ion.webapp.session;

import java.util.HashMap;
import java.util.Map;

import net.ion.webapp.utils.Aes;

import org.apache.commons.lang.StringUtils;

public class UserImpl implements User {
	final String USER_NO = "user_no";
	final String USER_ID = "user_id";
	final String USER_NAME = "user_name";
	final String USER_GROUP = "user_group";
	final String NICK_NAME = "nick_name";
	
	private Map<String, Object> userInfoMap = null;
	private Map<String, Object> userInfo = null;
	private String decUserId = null;
	private String ip = "non";

	public UserImpl(Map<String, Object> user) {
		if(user==null){
			userInfoMap = new HashMap<String, Object>();
			userInfoMap.put(USER_ID, "guest");
			userInfoMap.put(USER_NAME, "Guest");
			userInfoMap.put(USER_GROUP, "guest");
			userInfoMap.put(NICK_NAME, "Guest");
		}else{
			userInfoMap = user;
			userInfoMap.put("org_user_id", userInfoMap.get(USER_ID));
			userInfoMap.put(USER_ID, userInfoMap.get(USER_NO));
			userInfoMap.remove("pw");
			userInfoMap.remove("password");
		}
		
		userInfo = new UserInfo<String, Object>(userInfoMap);

		Map<String, Boolean> myGroupMap = new HashMap<String, Boolean>();

		String groups = getUserGroup();
		
		if(groups!=null){
			String[] userGroups = StringUtils.split(groups,",");
			
			for(String group : userGroups){
				myGroupMap.put(group, true);
			}
		}
		
		userInfoMap.put("myGroups", myGroupMap);
	}
	public Map<String, Object> getUserInfoMap() {
		return userInfo;
	}
	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
		userInfoMap.put("IP", ip);
	}
	public String getDecUserId() {
		if(decUserId!=null) return decUserId;
		String userId = getUserId();
		
		if("guest".equals(userId) || StringUtils.isEmpty(userId)){
			decUserId = userId;
		}else{
			try {
				decUserId = Aes.decrypt(userId);
			} catch (Exception e) {
			}
		}
		return decUserId;
	}
	public String getUserId() {
		return userInfoMap.get(USER_ID).toString();
	}
	public String getUserName() {
		return (String)userInfoMap.get(USER_NAME);
	}
	public String getUserGroup() {
		return (String)userInfoMap.get(USER_GROUP);
	}
	public String getNickName() {
		return (String)userInfoMap.get(NICK_NAME);
	}
	@Override
	public void setLang(String lang) {
		userInfoMap.put("lang", lang);
	}
}
