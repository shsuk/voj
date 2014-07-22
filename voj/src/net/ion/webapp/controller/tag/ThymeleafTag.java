package net.ion.webapp.controller.tag;

import java.io.StringWriter;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.BodyTagSupport;

import net.ion.webapp.process.ProcessInitialization;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.support.RequestContext;
import org.springframework.web.servlet.view.AbstractTemplateView;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.IWebContext;
import org.thymeleaf.spring3.context.SpringWebContext;
import org.thymeleaf.spring3.naming.SpringContextVariableNames;


public class ThymeleafTag extends BodyTagSupport {

	
	private static final long serialVersionUID = -4532449725358164369L;

	@Autowired
	protected TemplateEngine templateEngine;

	String id;
	public void setId(String id) {
		this.id=id;
		
		if(templateEngine==null){
			templateEngine = (TemplateEngine)ProcessInitialization.getService(TemplateEngine.class);
		}
	}
	
	public int doEndTag() throws JspException {
		try {
			process((HttpServletRequest)pageContext.getRequest(), (HttpServletResponse)pageContext.getResponse(), pageContext.getServletContext(), templateEngine);

		} catch (Exception e) {
			Logger.getLogger(OrganismTag.class).debug(e);
			throw new JspTagException(e.getMessage(), e);
		}
		

		return SKIP_BODY;
	}

	private void process(HttpServletRequest request, HttpServletResponse response, ServletContext servletContext, TemplateEngine templateEngine) {
		final Map<String, Object> mergedModel = new HashMap<String, Object>();
		Enumeration<String> en = pageContext.getAttributeNamesInScope(PageContext.PAGE_SCOPE);

		while(en.hasMoreElements()){
			String key = en.nextElement();
			mergedModel.put(key, pageContext.getAttribute(key));
		}
		
		final RequestContext requestContext = new RequestContext(request, response, servletContext, mergedModel);
		//request.getAttribute("rows")
		// For compatibility with ThymeleafView
		addRequestContextAsVariable(mergedModel, SpringContextVariableNames.SPRING_REQUEST_CONTEXT, requestContext);
		// For compatibility with AbstractTemplateView
		addRequestContextAsVariable(mergedModel, AbstractTemplateView.SPRING_MACRO_REQUEST_CONTEXT_ATTRIBUTE, requestContext);
		
		final IWebContext context = new SpringWebContext(request, response, servletContext , request.getLocale(), mergedModel, ProcessInitialization.getCtx());

		templateEngine.process(id, context, null, pageContext.getOut());
	}
	private void addRequestContextAsVariable(final Map<String,Object> model, final String variableName, final RequestContext requestContext) {

		model.put(variableName, requestContext);

	}

}
