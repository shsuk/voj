package net.ion.webapp.interceptor;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.ion.user.session.SessionService;
import net.ion.webapp.exception.ProcessPageNotFoundException;
import net.ion.webapp.process.ProcessInitialization;
import net.ion.webapp.process.ProcessMain;
import net.ion.webapp.schedule.ScheduleFactory;
import net.ion.webapp.service.ProcessService;
import net.ion.webapp.service.TestService;
import net.ion.webapp.utils.CookieUtils;
import net.ion.webapp.utils.LowerCaseMap;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.util.HtmlUtils;


public class ControllerInterceptor extends HandlerInterceptorAdapter{	
	@Autowired
	protected ProcessService processService;
	@Autowired
	protected TestService testService;
	SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		super.postHandle(request, response, handler, modelAndView);
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
		super.afterCompletion(request, response, handler, ex);
	}
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
	
		serReq(request);
		SessionService.setUserInfoOnRequest(request);
		checkMobile(request);
		return true;
	}

	private String[] mbl = {"iPhone", "iPod", "BlackBerry", "Android", "Windows CE", "LG", "MOT", "SAMSUNG", "SonyEricsson"};
	private void serReq(HttpServletRequest request){
		Map<String, String> req = new LowerCaseMap<String, String>();
		for(String key : request.getParameterMap().keySet()){
			String value = request.getParameter(key);
			req.put(key, HtmlUtils.htmlEscape(value));
		}
		request.setAttribute("req", req);
		
		try {
			JSONObject js = new JSONObject();
			for(String key : request.getParameterMap().keySet()){
				String value = request.getParameter(key);
				js.put(key, HtmlUtils.htmlEscape(value));
			}
			request.setAttribute("reqJS", js);
		} catch (Exception e) {
			// TODO: handle exception
		}
	}
	private void checkMobile(HttpServletRequest request){
		HttpSession session = request.getSession();
		boolean isMobile = false;

		//세션 초기화
		if(session.getAttribute("isMobile")==null){
			String userAgent = request.getHeader("user-agent");

			for(String ml : mbl){
				if(StringUtils.containsIgnoreCase(userAgent, ml) ){
					isMobile = true;
					break;
				}
			}
						
			session.setAttribute("isMobile", isMobile);
			session.setAttribute("mobile", (isMobile ? "m" : ""));
			session.setAttribute("isMobileView", isMobile);
		}
		
		String mb = request.getParameter("mb");
		//변경시 세션 초기화
		if(StringUtils.isNotEmpty(mb)){
			isMobile = StringUtils.equalsIgnoreCase(mb, "Y");
			
			session.setAttribute("isMobile", isMobile);
			session.setAttribute("mobile", (isMobile ? "m" : ""));
			session.setAttribute("isMobileView", isMobile);
		}
		
		request.setAttribute("isMobile", session.getAttribute("isMobile"));
		request.setAttribute("mobile", session.getAttribute("mobile"));
		request.setAttribute("isMobileView", session.getAttribute("isMobileView"));
	}

}
