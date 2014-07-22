package net.ion.user.interceptor;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ion.user.session.SessionService;
import net.ion.webapp.db.CodeUtils;
import net.ion.webapp.exception.UserSecurityException;
import net.ion.webapp.process.ProcessInitialization;
import net.ion.webapp.utils.JobLogger;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.ibm.icu.text.SimpleDateFormat;

public class LoginInterceptor extends HandlerInterceptorAdapter
{	
	SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception  {
		//세션아이디 저장
		JobLogger.setSessionId(request.getSession().getId());
		
		String[] auths = PagePermission.getAuthUser(request, response);
		if(auths!=null){//접근권한이 설정된 경우 권한 체크
			boolean hasAccess = PagePermission.hasAccess(request, response, auths);
			
			if(!hasAccess){
				//response.sendRedirect(request.getContextPath() + "/login/login_form.jsp");
				throw new UserSecurityException("");
			}
			return hasAccess;
		}
		//로그인 없이 접근하는 페이지
		String _ps = ServletRequestUtils.getStringParameter(request, "_ps", "");
		if(ProcessInitialization.PUBLIC_URL==null){
			CodeUtils.init();
		}
		if(ProcessInitialization.PUBLIC_URL.containsKey(_ps)){
			return true;
		}
		String _psPath = StringUtils.substringBeforeLast(_ps, "/");
		if(ProcessInitialization.PUBLIC_URL.containsKey(_psPath)){
			return true;
		}
		//로그인 여부 체크
		boolean hasAccess = SessionService.isLogin(request);
		
		if(!hasAccess){
			//response.sendRedirect(request.getContextPath() + "/login/login_form.jsp");
			throw new UserSecurityException("");
		}
		return hasAccess;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		super.postHandle(request, response, handler, modelAndView);
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
		super.afterCompletion(request, response, handler, ex);
	}
	

}
