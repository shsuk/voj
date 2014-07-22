package net.ion.webapp.session;

import java.util.Map;

public interface User {
	public String getIp();

	public void setIp(String ip);
	
	public Map<String, Object> getUserInfoMap();
	public void setLang(String lang);
	public String getDecUserId();
	public String getUserId();
	public String getUserName();
	public String getUserGroup();
	public String getNickName();
}
