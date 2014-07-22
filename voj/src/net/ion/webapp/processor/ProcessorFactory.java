package net.ion.webapp.processor;

import java.io.File;
import java.io.FileInputStream;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.jar.JarEntry;
import java.util.jar.JarInputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ion.webapp.exception.ProcessNotFoundException;
import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ProcessInitialization;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.system.DbProcessor;
import net.ion.webapp.processor.system.PrintProcessor;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.util.ClassUtils;


public class  ProcessorFactory{
	protected static final Logger logger = Logger.getLogger(ProcessorFactory.class);
	public final static String PROCESSOR_SUFFIX = "Processor";
	private static Map<String, ProcessorService> processorServiceMap = new HashMap<String, ProcessorService>();;
	private static final ClassLoader classLoader = ClassUtils.getDefaultClassLoader() ;


	public static void init(){
		String[] serviceList = ProcessInitialization.getCtx().getBeanNamesForType(ProcessorService.class);

		for(String key : serviceList) {
			ProcessorService processorService = (ProcessorService)ProcessInitialization.getCtx().getBean(key);
			processorServiceMap.put(processorService.getJobId().toLowerCase(), processorService);
		}			

	}


	/**
	 * findObjId의 ProcessJobService 또는 서블릿을 반환한다.
	 * @param request
	 * @param findObjId
	 * @param isTest
	 * @return
	 * @throws Exception
	 */
	public static Object getProcessJobService(HttpServletRequest request, String findObjId, boolean isTest)throws Exception{
		if(findObjId.startsWith("this.")){//jsp소스상에서 정의된 프로세스
			Object processJobService = request.getAttribute("__THIS__");
			if(processJobService!=null) return processJobService;
			throw new Exception("jobId : " + findObjId + "를 찾을 수 없습니다.");
		}
		return getProcessorService(findObjId, isTest);
	}
	/**
	 * findObjId의 ProcessJobService를 반환한다.
	 * @param findObjId
	 * @param isTest
	 * @return
	 * @throws Exception
	 */
	public static ProcessorService getProcessorService(String findObjId, boolean isTest)throws Exception{
		
		ProcessorService processorService =  (ProcessorService)processorServiceMap.get(findObjId.toLowerCase());
		if(processorService==null) {
			throw new ProcessNotFoundException("jobId : " + findObjId + "를 찾을 수 없습니다.");
		}
		return processorService;
	}

	public static ReturnValue exec(JSONObject processDetail, Map<String, Object> params)throws Exception {
		return exec(processDetail, params, null, null, false, false);
	}
	
	public static ReturnValue exec(JSONObject processDetail, Map<String, Object> params, HttpServletRequest request, HttpServletResponse response, boolean isTest, boolean isDebug)throws Exception {
		Object processJob =  ProcessorFactory.getProcessorService(processDetail.getString("jobId"), false);
		return ((ProcessorService)processJob).execute(new ProcessInfo(processDetail, params, false, false), request, response);
	}
	
	public static ReturnValue exec(String jobId, Map<String, Object> params, HttpServletRequest request, HttpServletResponse response)throws Exception {
		JSONObject processDetail = new JSONObject();
		processDetail.put("jobId", jobId);
		return exec(processDetail, params, request, response, false, false);
	}

	public static Class<?> forName(String name) throws ClassNotFoundException, LinkageError {
			Class<?> cls = ClassUtils.forName(name, classLoader) ;
			ClassLoader cl = ClassUtils.getDefaultClassLoader().getSystemClassLoader();
			return cls ;
	}
	
	public static boolean setJspProcess(Object obj, HttpServletRequest request){
		String __key = request.getRequestURI().replaceAll(request.getContextPath(), "");
		Object thisObject = request.getServletContext().getAttribute(__key);
		request.getServletContext().setAttribute(__key, obj);

		if(thisObject==null) {
			logger.debug(__key + " process 초기화");
			return true;
		}
		return false;
	}

}
