package net.ion.user.interceptor;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ion.user.session.SessionService;
import net.ion.webapp.utils.CookieUtils;
import net.ion.webapp.utils.DbUtils;
import net.ion.webapp.utils.LowerCaseMap;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

public class PagePermission {
	protected static final Logger LOGGER = Logger.getLogger(PagePermission.class);
	private static Map<String, String[]> pageMap = new HashMap<String, String[]>();

	public static void clear() {
		pageMap.clear();
	}

	private static void init() {
		synchronized (pageMap) {
			if (!pageMap.isEmpty()){
				return;
			}

			try {
				// 페이지 접근권한 정보 초기화
				List<LowerCaseMap<String, Object>> list = DbUtils.select("system/menu/auth_list", null);

				for (LowerCaseMap<String, Object> row : list) {
					String menuGroupId = (String) row.get("auth_id");
					if (StringUtils.isEmpty(menuGroupId)){
						continue;
					}
					
					String url = (String) row.get("url");
					String id = StringUtils.substringBetween(url, "_ps=", "&");
					if (StringUtils.isEmpty(id)){
						id = StringUtils.substringAfterLast(url, "_ps=");
					}
					
					if (StringUtils.isEmpty(id)){
						id = StringUtils.substringBetween(url, "_q=", "&");
						if (StringUtils.isEmpty(id)){
							id = StringUtils.substringAfterLast(url, "_q=");
						}
					}
					if (StringUtils.isEmpty(id)){
						continue;
					}
					
					pageMap.put(id, menuGroupId.split(","));

				}
			} catch (Exception e) {
				Logger.getLogger(PagePermission.class).error("페이지 접근권한 초기화 오류", e);
			}
			
		}

	}
	public static String[] getAuthUser(HttpServletRequest request,HttpServletResponse response) throws Exception {
		init();
				
		String id = request.getParameter("_ps");
		if (StringUtils.isEmpty(id)){
			id = request.getParameter("_q");
		}
		if (StringUtils.isEmpty(id)){
			return null;
		}
				
		String[] auths = pageMap.get(id);


		return auths;
	}

	/**
	 * 접근권한 체크
	 *
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public static boolean hasAccess(HttpServletRequest request,HttpServletResponse response, String[] auths) throws Exception {
		init();
		
		if(!SessionService.isLogin(request)) return false;
		//isOtherPcLogin(request, response);
		//접근권한 체크
		// TODO
		Map<String, Object> session = (Map<String, Object>)request.getSession().getAttribute("session");
		Map<String, Boolean> mygroups = (Map<String, Boolean>)session.get("mygroups");
		
		if(mygroups==null){
			return true;
		}
		
		for(String auth : auths){
			if(mygroups.containsKey(auth)){
				return true;
			}
		}
		return false;
	}
	/**
	 * 다른 PC에서 로그인 되었는지 체크한다.
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public static boolean isOtherPcLogin(HttpServletRequest request,HttpServletResponse response) throws Exception {
		long sessionTime = Long.parseLong(CookieUtils.getCookie(request, "ISLIM_SESSION_NUM", "0"));
		long curTime = (new Date()).getTime();
		
		if(sessionTime>(curTime-10000)){
			return true;
		}
		
		String curTimeStr = Long.toString(curTime);
		CookieUtils.setCookie(response, "ISLIM_SESSION_NUM", curTimeStr, 0);
		
		String session_id = CookieUtils.getCookie(request, "ISLIM_SESSION");
		//로그인된 경우는 다른 곳에서 로그인 되었는지 체크한다.		
		Map<String, Object> sourceDate = new HashMap<String, Object>();
		sourceDate.put("session_id", session_id);
		sourceDate.put("user_id", SessionService.getUser(request).getUserId());
		//SELECT count(*) session_count FROM USER_TBL WHERE user_id = :user_id and session_id = :session_id 
		String session_count = DbUtils.select("voj/login/session_check", sourceDate).get(0).get("session_count").toString();

		if(!"0".equals(session_count)){//정상인 경우
			return true;
		}
		//세션아이디가 DB와 다른 경우 다른 곳에서 로그인 된것임
		//세션삭제
		CookieUtils.removeCookie(response, "ISLIM_SESSION");
		//로그아웃 처리
		//먼저 로그인 한 것을 로그아웃시키는 이유는 정당하지 않은 방법으로 들어온것을 죽일 수 있어야 하기 때문임
		response.sendRedirect("at.sh?_ps=sl/login/logout");
		return false;

	}
	/**
	 * 로그인처리시 호출한다.
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public static boolean setLoginInfo(HttpServletRequest request,HttpServletResponse response) throws Exception {
		//로그인 정보 설정
		String session_id = UUID.randomUUID().toString();
		CookieUtils.setCookie(response, "ISLIM_SESSION", session_id, 0);
		Map<String, Object> sourceDate = new HashMap<String, Object>();
		sourceDate.put("session_id", session_id);
		sourceDate.put("user_id", SessionService.getUser(request).getUserId());
		//접속 IP저장해도 됩니다. UPDATE USER_TBL SET session_id = :session_id WHERE user_id = :user_id
		DbUtils.update("voj/login/session_update", sourceDate);
		
		return true;
	}



}
