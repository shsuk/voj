package net.ion.webapp.process;

import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ion.webapp.exception.IslimException;
import net.ion.webapp.fleupload.Upload;
import net.ion.webapp.service.ProcessService;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;


public class ProcessMain {
	protected static final Logger logger = Logger.getLogger(ProcessMain.class);

	/**
	 * processId에 해당하는 프로세서들을 실행한다.
	 * @param processId
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public static Map<String, Object> runProcessGroup (ProcessService processService, String processId, List<List<JSONObject>> jaProcessGroup, HttpServletRequest request, HttpServletResponse response, boolean isTestUser)throws Exception{
		Map<String, Object> result = (Map<String, Object>)request.getAttribute(ProcessService.__PROCESS_ALL_RESULT__);//프로세서가 진행되는 동안 결과 값을 저장한다.
		
		if(result==null){
			result = new HashMap<String, Object>();
		}
		
		Map<String, Object> returnData = new HashMap<String, Object>();//웹에 전달할 결과 값을 저장한다.
		String debug = request.getParameter("debug");
		boolean isDebug = "true".equals(debug);
		long startTime = (new Date()).getTime();
		request.setAttribute(ProcessService.__PROCESS_ALL_RESULT__, result);//오류가 발생 할 경우를 대비 저장 
		
		if(isTestUser || isDebug){
			request.setAttribute("__PROCESS_INFO__", jaProcessGroup);
			result.put("debug_process", processId);
		}
		
		Exception processException = null;
		//**************************************************************
		// Run Process GROUP
		//**************************************************************
		//logger.debug("======================================");
		//logger.debug("[START PROCESS GROUP]");
		//logger.debug("======================================");
		for(int i=0; i<jaProcessGroup.size(); i++){
			List<JSONObject> jaProcessList = jaProcessGroup.get(i);
			try {
				//**************************************************************
				// Run Process
				//**************************************************************
				//logger.debug(">>>>>> START PROCESS GROUP : " + i);
				Map<String, Object> rtn = processService.runProcessList(jaProcessList, request, response, result);
				returnData.putAll(rtn);
				//logger.debug(">>>>>> END PROCESS GROUP : " + i);
			} catch (Exception e) {
				logger.error(">>>>>> ERROR PROCESS GROUP : " + i);
								
				if (e.getCause() instanceof IslimException) {
					IslimException isE = (IslimException) e.getCause();
					request.setAttribute("error_id", isE.getErrorId());
					request.setAttribute("error_message", isE.getMessage());
				}else{
					request.setAttribute("error_id", "9999");
					request.setAttribute("error_message", e.toString());
				}
				
				String message = (processException != null ? processException.toString() : "") + "\n[" + (i+1) + "번 프로세서 구룹 오류]\n" + e.toString();
				processException = new Exception(message, e);
			}
		}
		//logger.debug("======================================");
		//logger.debug("[END PROCESS GROUP]");
		//logger.debug("======================================");
		long runTime =  (new Date()).getTime() - startTime;
		
		if(runTime>1000){
			logger.debug("Servlet Run time : " + runTime + " \tPath : " + request.getServletPath() + "?_ps=" + request.getParameter("_ps") + "&_q=" + request.getParameter("_q"));
		}
		
		
		if(isTestUser || isDebug) returnData.put("__trace_data__", result);//테스트나 디버깅인 경우 전체 정보를 전달한다.
		if(!returnData.containsKey("success")) returnData.put("success", true);
		//이전 프로세스 처리 결과에 현재 프로세스 결과를 추가한다.
		result.putAll(returnData);
		
		if(processException != null) throw processException;
		
		return returnData;
		//return result;
	}

}
