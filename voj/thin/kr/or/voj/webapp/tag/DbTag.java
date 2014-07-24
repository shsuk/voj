package kr.or.voj.webapp.tag;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.tagext.BodyTagSupport;

import kr.or.voj.webapp.processor.ProcessorParam;
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
	boolean exception  = true;
	public void setException(boolean exception) {
		this.exception = exception;
	}

	List<String> processorList = null;
	
	public void setProcessorList(String processorList) {
		this.processorList = new ArrayList<String>();
		String[] list = processorList.split(",");
		for(String pr : list){
			pr = pr.trim();
			if(StringUtils.isEmpty(pr)){
				continue;
			}
			this.processorList.add(pr);
		}
	}
	
	public void setActionFild(String actionFild) {
		this.actionFild = actionFild;
	}
	
	public void setQueryPath(String queryPath) {
		this.queryPath = queryPath;
	}
	
	public int doEndTag() throws JspException {
		JSONObject jsonResult = new JSONObject();

		try {			
			ServletRequest request = pageContext.getRequest();
			request.setAttribute("req", ProcessorServiceFactory.getReqParam(request));
			
			CaseInsensitiveMap params = new CaseInsensitiveMap();
			

			//body에 설정된 기본값 파라메터에 추가한다.
			String body = bodyContent!=null ? bodyContent.getString().trim() : "";
			if(StringUtils.isNotEmpty(body)){
				body = body.startsWith("{")  ? body : "{" + body + "}";
				JSONObject defaultParam = JSONObject.fromObject(body);
				params.putAll(defaultParam);
			}
			//실행할 쿼리의 구룹을 정보를 설정한다.
			String action = (String)params.get(actionFild);
			action = StringUtils.isEmpty(action) ? "" : action;
			
			//**************************************************
			//				프로세서를 실행한다.
			//**************************************************
			Map<String, Object> resultSet = ProcessorServiceFactory.executeMain(processorList, params, body, action, request);
			
			//결과를 페이지 컨텍스트와 JSON으로 request에 반환한다.
			for(String key : resultSet.keySet()){
				pageContext.setAttribute(key, resultSet.get(key));;
			}
			
			jsonResult.putAll(resultSet);
			jsonResult.put("success", true);
		} catch (Exception e) {
			jsonResult.put("success", false);
			jsonResult.put("message", e.toString());
			
			Logger.getLogger(DbTag.class).debug(e);

			if(exception){
				throw new JspTagException(e.getMessage(), e);
			}
		}
		
		pageContext.setAttribute("JSON", jsonResult);

		return SKIP_BODY;
	}


}
