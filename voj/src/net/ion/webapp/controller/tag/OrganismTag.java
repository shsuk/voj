package net.ion.webapp.controller.tag;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.Servlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.tagext.BodyTagSupport;

import net.ion.webapp.process.ProcessInitialization;
import net.ion.webapp.process.ProcessMain;
import net.ion.webapp.service.ProcessService;
import net.ion.webapp.service.TestService;
import net.ion.webapp.utils.IslimUtils;
import net.ion.webapp.utils.JobLogger;
import net.ion.webapp.workflow.WorkflowService;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.security.util.FieldUtils;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.util.HtmlUtils;


public class OrganismTag extends BodyTagSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = 3339084892205224240L;

	protected static final Logger logger = Logger.getLogger(OrganismTag.class);

	protected Object id;
	protected String jobId;
	protected String pd;
	protected String params;
	protected String src;
	protected String desc;
	protected ProcessService processService;
	protected TestService testService;
	protected WorkflowService workflowService;
	
	protected String processInfo;
	protected String errorId = "9999";
	protected boolean token = false;
	protected boolean useTrigger = false;
	public void setUseTrigger(boolean useTrigger) {
		this.useTrigger = useTrigger;
	}
	private String tokenName;

	protected boolean test = true;
	private boolean noException = false;

	public void setDesc(String desc) {
		this.desc = desc;
	}
	public void setTest(boolean test) {
		this.test = test;
	}
	public void setPd(String pd) {
		pd = pd.replaceAll("\r", "");
		pd = StringUtils.replace(pd, "\n+", "\\n");
		this.pd = pd;
	}
	public void setId(String id) {
		if(((String)id).startsWith("[")){
			this.id = JSONArray.fromObject(id);
		}else{
			this.id = id;
		}
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
	public void setTokenName(String tokenName) {
		this.tokenName = HtmlUtils.htmlUnescape(tokenName);
	}

	public void setToken(boolean token) {
		this.token = token;
	}
	public void setPageContextDataId(String dataId) {
		Map<String,Object> userParams = new HashMap<String, Object>();
		String[] datas = dataId.split(",");
		
		for(String id : datas){
			userParams.put(id, pageContext.getAttribute(id.trim()));
		}
		pageContext.getRequest().setAttribute("_USER_PARAMS_", userParams);
	}

	public void setProcessInfo(String processInfo) {
		this.processInfo = processInfo.trim();
	}
	public void setNoException(boolean noException) {
		this.noException = noException;
	}

	public int doEndTag() throws JspException {
		if(!test) return SKIP_BODY;
		String body = bodyContent!=null ? bodyContent.getString().trim() : "";
		if(StringUtils.isNotEmpty(body)){
			processInfo = body;
		}
		try {
			autoProcess((HttpServletRequest)pageContext.getRequest(), (HttpServletResponse)pageContext.getResponse());
		} catch (Exception e) {
			JobLogger.write(this.getClass(), "jsp", "process", ((HttpServletRequest)pageContext.getRequest()).getServletPath(), true, e);
			throw new JspTagException(e.getMessage(), e);
		}
		processInfo = "";
		return SKIP_BODY;
	}
	@SuppressWarnings("unchecked")
	private void autoProcess(HttpServletRequest request, HttpServletResponse response)throws Exception {
		if(testService==null) testService = (TestService)ProcessInitialization.getService(TestService.class);
		if(processService==null) processService = (ProcessService)ProcessInitialization.getService(ProcessService.class);
		if(workflowService==null) workflowService = (WorkflowService)ProcessInitialization.getService(WorkflowService.class);
	
		
		request.setAttribute("__PAGECONTEXT__", pageContext);
		//Servlet servlet = (Servlet)FieldUtils.getProtectedFieldValue("servlet", pageContext);
		//request.setAttribute("__THIS__", servlet);
	
		String processId = ServletRequestUtils.getStringParameter(request, "_ps", "auto");
		
		Map<String, Object> returnData = null;

		try {
			//토큰 체크
/*
			if(token){
				String tokenCheckValue = (String)pageContext.getSession().getAttribute("__ISLIM_TOKEN__"+"."+tokenName);
				String tokenValue = pageContext.getRequest().getParameter("__ISLIM_TOKEN__");
				errorId = "errid_999";
				
				if(StringUtils.isEmpty(tokenCheckValue) || !tokenValue.equals(tokenCheckValue)){
					errorId = "errid_token";
					throw new Exception("Error token");
				}
				pageContext.getSession().removeAttribute("__ISLIM_TOKEN__");
			}
*/			
			request.setAttribute("__TAGLIB__PARAMS__", makeSourceData(new HashMap<String, Object>()));
			
			List<List<JSONObject>> jaProcessGroup = ProcessInitialization.makeProcessGroup(processInfo);
			//그룹 프로세서 실행
			returnData = ProcessMain.runProcessGroup(processService, processId, jaProcessGroup, request, response, testService.isTestUser(request));
			//성공시에 워크프로우 트리거에 의한 JOB 생성
			if(!returnData.containsKey("success")){
				//워크프로우 트리거에 의한 JOB 생성
				if(useTrigger){
					workflowService.addWfTriggerJob(request, response, pageContext);
				}
			}

			Map<String, Object> processAllResult = (Map<String, Object>)request.getAttribute(ProcessService.__PROCESS_ALL_RESULT__);
			JSONObject returnJSONData = (JSONObject)pageContext.getAttribute("JSON");
			
			if(returnJSONData==null){
				returnJSONData = new JSONObject();
			}
			
			for(String key : returnData.keySet()){
				returnJSONData.put(key, returnData.get(key));
			}
			
			pageContext.setAttribute("JSON", returnJSONData);
			
			for(String key : processAllResult.keySet()){
				pageContext.setAttribute(key, processAllResult.get(key));
			}
		}catch (Exception e) {//오류인 경우 처리
			returnData = (Map<String, Object>)request.getAttribute(ProcessService.__PROCESS_ALL_RESULT__);//오류인 경우 저장된 실행 결과 값을 가져온다.
			if(returnData==null){
				returnData = new JSONObject();
				request.setAttribute(ProcessService.__PROCESS_ALL_RESULT__, returnData);
			}
			returnData.put("success", false);
			if(request.getAttribute("error_id")!=null){
				returnData.put("error_id", request.getAttribute("error_id"));
				returnData.put("error_message", request.getAttribute("error_message"));
				returnData.put("error_message_detail", e.toString());				
			}else{
				returnData.put("error_id", errorId);
				returnData.put("error_message", e.toString());				
			}
			
			//Cookie : _debug_=true
			boolean isTestUser = testService.isTestUser(request);;

			request.setAttribute("__IS_TEST__", isTestUser);//테스트 유저인 경우 err.jsp에 오류 정보를 표시 하기 위한 처리
			
			if(noException){
				//e.printStackTrace();
				JSONObject ruturnData = new JSONObject();
				ruturnData.putAll(returnData);
				pageContext.setAttribute("JSON", ruturnData);
				
				JobLogger.write(this.getClass(), "jsp", "no_exception", request.getServletPath(), true, e);
				return;
			}
			//Cookie : _debug_=true
			if(isTestUser){
				StringWriter sw = new StringWriter() ;
				PrintWriter pw = new PrintWriter(sw) ;
				e.printStackTrace(pw) ;
				String errorMessage = sw.getBuffer().append("\n[실행정보]\n").append(returnData.toString()).toString();
				String str = StringUtils.replace(errorMessage, "net.ion.", "<font color='red'>net.ion."); 
				str = StringUtils.replace(str, "at", "</font>at"); 
				str = StringUtils.replace(str, "\t", "&nbsp;&nbsp;&nbsp;&nbsp;"); 
				str = StringUtils.replace(str, "\n", "<br>"); 
				pageContext.getOut().print(str);
			}else{
				throw e;
			}
			
		}
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
}
