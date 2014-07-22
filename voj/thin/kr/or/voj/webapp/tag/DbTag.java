package kr.or.voj.webapp.tag;

import java.util.Map;

import javax.servlet.ServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.tagext.BodyTagSupport;

import kr.or.voj.webapp.processor.DBProcessor;
import kr.or.voj.webapp.processor.ProcessorServiceFactory;
import kr.or.voj.webapp.utils.DefaultLowerCaseMap;
import net.sf.json.JSONObject;

import org.apache.commons.collections.map.CaseInsensitiveMap;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;


public class DbTag extends BodyTagSupport {

	
	/**
	 * 
	 */
	private static final long serialVersionUID = -8153914754350715168L;
	String queryPath = null;
	String actionFild = null;
	
	public void setActionFild(String actionFild) {
		this.actionFild = actionFild;
	}
	public void setQueryPath(String queryPath) {
		this.queryPath = queryPath;
	}
	public int doEndTag() throws JspException {
		try {
			
			ServletRequest request = pageContext.getRequest();
			JSONObject result = new JSONObject();
			CaseInsensitiveMap params = new CaseInsensitiveMap();
			DefaultLowerCaseMap req = new DefaultLowerCaseMap();

			String body = bodyContent!=null ? bodyContent.getString().trim() : "";
			
			if(StringUtils.isNotEmpty(body)){
				body = body.startsWith("{")  ? body : "{" + body + "}";
				JSONObject defaultParam = JSONObject.fromObject(body);
				params.putAll(defaultParam);
			}
			
			Map<String, String[]> parameterMap = request.getParameterMap();
			
			for(String key :  parameterMap.keySet()){
				String[] vals = parameterMap.get(key);
				params.put(key, vals[0]);
				req.put(key, vals[0]);
				
				for(int i=0; i<vals.length; i++){
					String val = vals[i];
					params.put(key+"[" +i + "]", val);
					req.put(key+"[" +i + "]", val);
				}
			}
			
			String action = (String)req.get(actionFild);
			action = StringUtils.isEmpty(action) ? "" : action;
			
			Map<String, Object> resultSet = ProcessorServiceFactory.executeDataBase(queryPath, params, action);
			
			for(String key : resultSet.keySet()){
				result.put(key, resultSet.get(key));
				pageContext.setAttribute(key, resultSet.get(key));;
			}
			
			request.setAttribute("req", req);;
			result.put("success", true);
		
			pageContext.setAttribute("JSON", result);
		} catch (Exception e) {
			Logger.getLogger(DbTag.class).debug(e);
			throw new JspTagException(e.getMessage(), e);
		}

		return SKIP_BODY;
	}


}
