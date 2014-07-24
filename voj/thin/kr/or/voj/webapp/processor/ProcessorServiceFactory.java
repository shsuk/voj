package kr.or.voj.webapp.processor;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletRequest;

import org.apache.commons.collections.map.CaseInsensitiveMap;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.core.io.Resource;

/**
 * <pre>
 * 시스템명 : KT_MVNO_KPM
 * 작 성 자 : 석승한
 * 작 성 일 : 2014. 3. 18
 * 설    명 : Test
 * 
 * </pre>
 */
public class ProcessorServiceFactory  implements ApplicationContextAware {
	private static Map<String, ProcessorService> processorServiceMap = new HashMap<String, ProcessorService>();;
	private static ApplicationContext applicationContext;
	private static final Logger logger = Logger.getLogger(ProcessorServiceFactory.class);
	private static String queryFullPath = null;

	public static String getQueryFullPath() {
		return queryFullPath;
	}

	public void setApplicationContext(ApplicationContext applicationContext) {
		ProcessorServiceFactory.applicationContext = applicationContext;
		//프로세서 서비스를 초기화 한다.
		init();
	}

	public static ApplicationContext getApplicationContext() {
		return applicationContext;
	}
	public void setQueryPath(Resource queryPath) {
		try {
			queryFullPath = queryPath.getFile().getAbsolutePath() + "/";
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	/**
	 * 프로세서 서비스를 초기화 한다.
	 */
	public static void init(){
		if(processorServiceMap.size() > 0){
			//return;
		}
		String[] serviceList = applicationContext.getBeanNamesForType(ProcessorService.class);

		for(String key : serviceList) {
			String name = "";
			try {
				ProcessorService autoProcessor = (ProcessorService)applicationContext.getBean(key);
				name = autoProcessor.toString();
				
				name = StringUtils.substringBetween(name, "kr.or.voj.webapp.processor.", "Processor").toLowerCase();
				name = name.replace('.', '_');
				processorServiceMap.put(name , autoProcessor);
				
			} catch (Exception e) {
				logger.error(name + "의 이름이 Processor 로 끝나지 않아 등록되지 않았습니다.");
			}
		}			
	
	}
	
	public static ProcessorService getProcessorService(String method) {
		return processorServiceMap.get(method);

	}
	public static Map<String, Object> executeDataBase(String path, CaseInsensitiveMap params, String action, ServletRequest request) throws Exception{
		Map<String,Object> paramMap = new HashMap<String, Object>();
		paramMap.put("queryPath", path);
		paramMap.put("params", params);
		paramMap.put("action", action);
		paramMap.put("_REQUEST_", request);
		
		return (Map<String, Object>)processorServiceMap.get("db").execute(paramMap);

	}
	
/*
	public static Map<String, ProcessorService> getProcessorServiceMap() {
		return processorServiceMap;
	}
*/
}
