package net.ion.webapp.controller.tag;

import java.util.UUID;

import javax.servlet.ServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

import org.springframework.web.util.HtmlUtils;

public class TokenTag extends TagSupport {
	private String name;

	public void setName(String name) {
		this.name = HtmlUtils.htmlUnescape(name);
	}

	public int doStartTag() throws JspException {
		try {
			String token = UUID.randomUUID().toString();
			pageContext.getSession().setAttribute("__ISLIM_TOKEN__"+"."+name, token);
			JspWriter out = pageContext.getOut();
			ServletRequest request = pageContext.getRequest();
			out.print("<input type=\"hidden\" name=\"__ISLIM_TOKEN__\" value=\"");
			out.print(token);
			out.println("\" />");
		} catch (Exception ex) {
			throw new JspTagException("PageHiddenTag: " + ex.getMessage());
		}
		return SKIP_BODY;
	}
}
