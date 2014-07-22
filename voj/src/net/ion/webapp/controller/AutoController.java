package net.ion.webapp.controller;


import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ion.webapp.controller.DefaultAutoController;
import net.ion.webapp.utils.CookieUtils;
import net.ion.webapp.utils.DbUtils;
import net.ion.webapp.utils.JobLogger;
import net.ion.webapp.utils.LowerCaseMap;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class AutoController extends DefaultAutoController {
	protected static final Logger LOGGER = Logger.getLogger(AutoController.class);


	@RequestMapping(value = "/at.sh")
	public ModelAndView execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return super.execute(request, response);
	}

	@RequestMapping(value = "/atm.sh")
	public ModelAndView atm(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Boolean mb = (Boolean)request.getSession().getAttribute("mb");

		if(mb!=null && mb){
			String mv = ServletRequestUtils.getStringParameter(request, "_ps", "") + ServletRequestUtils.getStringParameter(request, "_q", "");
			if("".equals(mv)){
				return new ModelAndView("main_m");
			}else{
				request.setAttribute("_main_ps", "at/at_main_m");
			}
		}else{
			request.setAttribute("_main_ps", "at/at_main");
		}

		return super.atm(request, response);
	}
	
	@RequestMapping(value = "/call.sh")
	public ModelAndView call(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String jobId = request.getParameter("call_id");
		
		if(StringUtils.isEmpty(jobId)){
			throw new RuntimeException("Job ID 가 없습니다.");
		}
		
		Map<String, Object> params = (Map<String, Object>)request.getAttribute("req");
		List<LowerCaseMap<String, Object>>  list = DbUtils.select("system/call/wiew", params, true, 60);
		
		if(list.size()<1){
			throw new RuntimeException("Job ID = [" + jobId + "]는 정의되지 않은 ID 입니다.");
		}
		
		LowerCaseMap<String, Object> row = list.get(0);
		String page = (String)row.get("call_page");
		ModelAndView mv =new ModelAndView(page);
		
		mv.addObject("call_info", row);
		
		return mv;
	}

	@RequestMapping(value = "/api.sh")
	public ModelAndView api(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		return super.api(request, response);
	}
	@RequestMapping(value = "/view.sh")
	public void view(HttpServletRequest request, HttpServletResponse response){
		String type = request.getParameter("type");
		String sessionid = StringUtils.isEmpty(type) ? request.getSession().getId() : "background-job";

		if(!JobLogger.hasSessionLog(sessionid)){
			JobLogger.initSessionLog(sessionid);
		}
		
		response.setHeader("Content-Type", "text/html;charset=utf-8");
		response.setBufferSize(50);
		try {
			StringBuffer sb = JobLogger.getLog(sessionid);
			response.getOutputStream().write(sb.toString().getBytes());
			response.getOutputStream().flush();
			response.flushBuffer();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
