package net.ion.user.session;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.ion.webapp.session.User;
import net.ion.webapp.session.UserImpl;
import net.ion.webapp.utils.CookieUtils;

import org.apache.commons.lang.StringUtils;
import org.apache.taglibs.standard.functions.Functions;
import org.springframework.stereotype.Service;

@Service
public class SessionService {
	private static User newInstance(Map<String, Object> row) {
		return new UserImpl(row);		
	}

	private static User getDefaultUser(HttpServletRequest request) {
		HttpSession session = request.getSession();

		User user = (User) session.getAttribute("user");
		if (user == null) {
			user = saveUserInSession(request, null, null);
		}
		return user;
	}

	public static User saveUserInSession(HttpServletRequest request, HttpServletResponse response, Map<String, Object> row) {
		User user = newInstance(row);
		user.setIp(request.getRemoteAddr());

		request.getSession().setAttribute("user", user);
		if(response!=null) initLang(response, getLang(request));
		return user;
	}


	public static void logOut(HttpServletRequest request, HttpServletResponse response) {
		request.getSession().removeAttribute("user");
		CookieUtils.setCookie(response, "SESSION_ID", "", 0);
	}

	public static void initLang(HttpServletResponse response, String lang) {
		String initLang = "en".equals(lang) ? lang : "kr";
		CookieUtils.setCookie(response, "LANG_ISLIM", initLang, 3600000);
	}

	private static String getLang(HttpServletRequest request) {
		String LANG_ISLIM = Functions.escapeXml(CookieUtils.getCookie(request,"LANG_ISLIM"));

		if (StringUtils.isEmpty(LANG_ISLIM)) {
			String serverName = request.getServerName();
			if (serverName.indexOf(".com") > 0){
				LANG_ISLIM = "kr";
			}else{
				LANG_ISLIM = "kr";
			}
		}
		
		return LANG_ISLIM;

	}

	public static boolean isLogin(HttpServletRequest request) {
		boolean isLogin = false;
		User user = getDefaultUser(request);

		if (user == null || "guest".equals(user.getUserId())) {
			 isLogin = false;
		}else{
			isLogin = true;
		}
		return isLogin;
	}
	
	public static void setUserInfoOnRequest(HttpServletRequest request) {
		boolean isLogin = false;
		User user = getDefaultUser(request);
		
		String lang = getLang(request);
		user.setLang(lang);
		request.setAttribute("lang", lang);
		request.getSession().setAttribute("session", user.getUserInfoMap());
		request.setAttribute("session", user.getUserInfoMap());
		request.setAttribute("isLogin", isLogin);
	}

	public static User getUser(HttpServletRequest request) {
		return getDefaultUser(request);
	}
}
