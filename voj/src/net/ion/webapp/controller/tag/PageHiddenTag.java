package net.ion.webapp.controller.tag;

import javax.servlet.ServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.util.HtmlUtils;

public class PageHiddenTag extends TagSupport {

	private static final long serialVersionUID = -7800750408395935250L;

	private String args;

	public void setArgs(String args) {
		this.args = args;
	}

	public int doStartTag() throws JspException {
		try {
			JspWriter out = pageContext.getOut();
			ServletRequest request = pageContext.getRequest();
			if (StringUtils.isNotEmpty(args)) {
				String[] pd = StringUtils.split(args, ',');

				for (String param : pd) {
					param = param.trim();
					out.println("<input type=\"hidden\" name=\"" + param
							+ "\" value=\""
							+ HtmlUtils.htmlEscape(ServletRequestUtils.getStringParameter(request, param, ""))
							+ "\" />");
				}
			}
		} catch (Exception ex) {
			throw new JspTagException("PageHiddenTag: " + ex.getMessage());
		}
		return SKIP_BODY;
	}
}
