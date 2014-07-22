package net.ion.webapp.controller.tag.ui;

import java.util.Map;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.tagext.BodyTagSupport;

import net.ion.webapp.controller.tag.Split2MapTag;
import net.sf.json.JSONObject;

public class ParamTag extends BodyTagSupport {

	private static final long serialVersionUID = -6766515377399985092L;
	private String name;
	private boolean is2Map = false;
	public void setIs2Map(boolean is2Map) {
		this.is2Map = is2Map;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int doEndTag() throws JspException {
		try {
			@SuppressWarnings("unchecked")
			Map<String, Map<String, Object>> ui = (Map<String, Map<String, Object>>)pageContext.getRequest().getAttribute("UI");
			
			if(ui==null){
				throw new JspTagException("상위 UI태그가 없습니다.");
			}
			
			String id = ((SetTag)getParent()).getId();
			Map<String, Object> uiInfoMap = ui.get(id);
			
			String body = bodyContent.getString();
			Object data;
			
			if(is2Map){
				data = Split2MapTag.string2Map(body);
			}else{
				data = JSONObject.fromObject(body.replaceAll("\n", "").replaceAll("\r", ""));
			}
			
			uiInfoMap.put(name, data);

		} catch (Exception ex) {
			throw new JspTagException(ex.getMessage(), ex);
		}
		
		return SKIP_BODY;
	}
}
