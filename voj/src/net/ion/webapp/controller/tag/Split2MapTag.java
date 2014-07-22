package net.ion.webapp.controller.tag;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.tagext.TagSupport;

import org.apache.commons.lang.StringUtils;
//import org.apache.jasper.runtime.JspRuntimeLibrary;
//import org.apache.jasper.runtime.PageContextImpl;

public class Split2MapTag extends TagSupport {

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
		this.separatorChar = separator;
	}

	public int doStartTag() throws JspException {
		try {
			String[] datas = StringUtils.split(value, separatorChar);
			Map<String, Object> map = string2Map(value);
			pageContext.getRequest().setAttribute(var, map);			
		} catch (Exception ex) {
			throw new JspTagException(ex.getMessage(), ex);
		}
		return SKIP_BODY;
	}
	public static Map<String, Object> string2Map(String value) {
		String[] datas = StringUtils.split(value, separatorChar);
		Map<String, Object> map = new HashMap<String, Object>();
		for(String id : datas){
			id = id.trim();
			if("".equals(id)) continue;
			String[] temp = id.split(":") ;
			if(temp.length<2) map.put(id, true);
			else  map.put(temp[0], temp[1]);
		}
		return map;			
	}
}
