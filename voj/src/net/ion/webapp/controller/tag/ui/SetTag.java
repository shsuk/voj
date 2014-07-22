package net.ion.webapp.controller.tag.ui;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.tagext.TagSupport;

import net.ion.webapp.controller.tag.Split2MapTag;
import net.sf.json.JSONObject;

public class SetTag extends TagSupport {

	private static final long serialVersionUID = -1888886025532372066L;
	private Map<String, Object> hiddens;
	private Map<String, Object> read_onlys;
	private Map<String, Object> read_onlys2;
	private Map<String, Object> images;
	private Map<String, Object> files;
	private Map<String, Object> pk;
	private Map<String, Object> sort;
	private JSONObject button_search;
	private JSONObject link;
	private boolean isSingleRow = false;
	private String token = "";
	
	public void setToken(String token) {
		this.token = token;
	}
	public void setSingleRow(boolean isSingleRow) {
		this.isSingleRow = isSingleRow;
	}
	public void setButton_search(String button_search) {
		this.button_search = JSONObject.fromObject(button_search);
	}
	public void setLink(String link) {
		this.link = JSONObject.fromObject(link);
	}
	public void setHiddens(String hiddens) {
		this.hiddens = Split2MapTag.string2Map(hiddens);
	}
	public void setRead_onlys(String read_onlys) {
		this.read_onlys = Split2MapTag.string2Map(read_onlys);
	}
	public void setRead_onlys2(String read_onlys2) {
		this.read_onlys2 = Split2MapTag.string2Map(read_onlys2);
	}
	public void setImages(String images) {
		this.images = Split2MapTag.string2Map(images);
	}
	public void setFiles(String files) {
		this.files = Split2MapTag.string2Map(files);
	}
	public void setPk(String pk) {
		this.pk = Split2MapTag.string2Map(pk);
	}

	public void setSort(String sort) {
		this.sort = Split2MapTag.string2Map(sort);
	}

	public int doStartTag() throws JspException {
		try {
			Map<String, Object> uiInfoMap = new HashMap<String, Object>();
			@SuppressWarnings("unchecked")
			Map<String, Map<String, Object>> ui = (Map<String, Map<String, Object>>)pageContext.getRequest().getAttribute("UI");
			
			if(ui==null){
				ui = new  HashMap<String, Map<String, Object>>();
				pageContext.getRequest().setAttribute("UI", ui);
			}
			
			uiInfoMap.put("hiddens", hiddens);
			uiInfoMap.put("read_onlys", read_onlys);
			uiInfoMap.put("read_onlys2", read_onlys2);
			uiInfoMap.put("images", images);
			uiInfoMap.put("files", files);
			uiInfoMap.put("files", files);
			uiInfoMap.put("pk", pk);
			uiInfoMap.put("sort", sort);
			uiInfoMap.put("token", token);
			uiInfoMap.put("singleRow", isSingleRow);
			

			uiInfoMap.put("button_search", button_search);
			uiInfoMap.put("link", link);

			ui.put(id, uiInfoMap);
		} catch (Exception ex) {
			throw new JspTagException(ex.getMessage(), ex);
		}
		return EVAL_PAGE;
	}
}
