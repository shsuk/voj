package net.ion.webapp.controller.tag;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.tagext.TagSupport;

import org.apache.commons.lang.StringUtils;
//import org.apache.jasper.runtime.JspRuntimeLibrary;
//import org.apache.jasper.runtime.PageContextImpl;

public class Split2ListTag extends TagSupport {

	private static final long serialVersionUID = 4768639759600318520L;
	private String var;
	private String value;
	private static String separatorChar = ",";
	
	public void setVar(String var) {
		this.var = var;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public void setSeparator(String separator) {
		if("\\n".equals(separator)) separator = "\n";
		this.separatorChar = separator;
	}

	public int doStartTag() throws JspException {
		try {
			String[] datas = StringUtils.split(value, separatorChar);
			List<String> list = new ArrayList<String>();

			for(String row : datas){
				list.add(row.trim());
			}

			pageContext.getRequest().setAttribute(var, list);			
		} catch (Exception ex) {
			throw new JspTagException(ex.getMessage(), ex);
		}
		return SKIP_BODY;
	}

}
