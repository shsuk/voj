package net.ion.webapp.controller;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ion.webapp.service.TestService;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.servlet.ModelAndView;

@Controller
@SuppressWarnings("unchecked")
public class DefaultAutoController extends DefaultController{
	protected static final Logger logger = Logger.getLogger(DefaultAutoController.class);
	@Autowired
	protected TestService testService;
	protected ServletRequestUtils sRU;

	public ModelAndView execute(HttpServletRequest request, HttpServletResponse response) throws Exception{
		if(response.isCommitted()) return null;

		@SuppressWarnings("static-access")
		String tplId = sRU.getStringParameter(request, "_ps", "at/at");
		
		return new ModelAndView(tplId);

	}

	public ModelAndView atm(HttpServletRequest request, HttpServletResponse response) throws Exception{
		if(response.isCommitted()) return null;

		//response.setHeader("Content-Type", "text/javascript;charset=utf-8");
		return new ModelAndView((String)request.getAttribute("_main_ps"));
	}

	public ModelAndView api(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String ps = ServletRequestUtils.getStringParameter(request, "_ps", "at/api");

		response.setHeader("Content-Type", "text/javascript;charset=utf-8");

		return new ModelAndView(ps);
	}


}
