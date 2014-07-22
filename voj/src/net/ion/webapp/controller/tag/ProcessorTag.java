package net.ion.webapp.controller.tag;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.tagext.TagSupport;

import net.ion.webapp.process.ProcessInitialization;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ProcessorFactory;
import net.ion.webapp.service.ProcessService;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;

/**
 * 트랜잭션 지원 하지 않음
 * 트랜잭션 처리시 OrganismTag태그 사용
 * @author shsuk
 *
 */
public class ProcessorTag extends TagSupport {
	protected String id;
	protected String jobId;
	protected String pd;
	protected String params;
	protected String src;
	protected String desc;
	public void setDesc(String desc) {
		this.desc = desc;
	}

	protected boolean test = true;

	public void setTest(boolean test) {
		this.test = test;
	}
	public void setPd(String pd) {
		pd = pd.replaceAll("\r", "");
		pd = StringUtils.replace(pd, "\n+", "\\n");
		this.pd = pd;
	}
	public void setId(String id) {
		this.id = id;
	}
	public void setJobId(String jobId) {
		this.jobId = jobId;
	}
	public void setSrc(String src) {
		this.src = src;
	}
	public void setParams(String params) {
		this.params = params;
	}

	public int doStartTag() throws JspException {
		if(!test) return SKIP_BODY;
		try {
			JSONObject pDetail = JSONObject.fromObject(pd);
			pDetail.put("jobId", jobId);
			pDetail.put("id", jobId);
			
			ReturnValue rtn = ProcessorFactory.exec(pDetail, makeSourceData());
			pageContext.setAttribute(id, rtn.getResult());
		} catch (Exception ex) {
			throw new JspTagException(ex.getMessage(), ex);
		}
		return SKIP_BODY;
	}
	protected Map<String, Object> makeSourceData() {
		Map<String, Object> sourceData = new HashMap<String, Object>();

		HttpServletRequest request = (HttpServletRequest)pageContext.getRequest();
		sourceData.put("server", request.getAttribute("server"));//LoginInterceptor에서 초기화
		sourceData.put("session", request.getAttribute("session"));//LoginInterceptor에서 초기화 (참조:SessionService.saveSession())
		sourceData.put(ProcessService.REQUEST_PARAMS, request.getParameterMap());//requestMap의 원본값을 저장한다.
		sourceData.putAll((Map)request.getAttribute(ProcessService.REQUEST_REPLACE_PARAMS));//requestMap의 값이 가공되어 변형된 값을 저장한다.

		return makeSourceData(sourceData);
	}
	protected Map<String, Object> makeSourceData(Map<String, Object> sourceData) {
		HttpServletRequest request = (HttpServletRequest)pageContext.getRequest();

		if(params!=null){
			JSONObject prm = JSONObject.fromObject(params);
			sourceData.putAll(prm);
		}
		
		if(src!=null){
			String[] srcs = src.split(",");
			
			for(String id : srcs){
				id = id.trim();
				Object data = pageContext.getAttribute(id);
				if(data==null) data = request.getAttribute(id);
				
				sourceData.put(id, data);
			}
		}
		return sourceData;
	}
	
	protected Object getService(Class cls) {
		String[] serviceList = ProcessInitialization.getCtx().getBeanNamesForType(cls);
		
		for(String service : serviceList){
			return ProcessInitialization.getCtx().getBean(service);
		}
		return null;
	}
}
