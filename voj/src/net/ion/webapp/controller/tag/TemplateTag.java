package net.ion.webapp.controller.tag;

import java.io.IOException;
import java.io.PrintWriter;


import javax.el.ELContext;
import javax.el.ExpressionFactory;
import javax.el.ValueExpression;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspFactory;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.BodyContent;
import javax.servlet.jsp.tagext.TagSupport;

import org.apache.commons.lang.StringUtils;
import org.apache.taglibs.standard.functions.Functions;

public class TemplateTag extends TagSupport {
	private String src;

	public void setSrc(String src) {
		this.src = src;
	}
	public void setData(String data) {
		String[] datas = data.split(",");
		
		for(String id : datas){
			pageContext.getRequest().setAttribute(id.trim(), pageContext.getAttribute(id.trim()));
		}
		
	}

	public int doStartTag() throws JspException {
		try {
			TemplateUtils.include(src, pageContext);
		} catch (Exception ex) {
			throw new JspTagException(ex.getMessage(), ex);
		}
		return SKIP_BODY;
	}
}
