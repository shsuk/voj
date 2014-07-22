package net.ion.webapp.workflow;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.BlockingQueue;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.PageContext;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import net.ion.webapp.controller.tag.TemplateUtils;
import net.ion.webapp.process.ProcessInitialization;
import net.ion.webapp.service.ProcessService;
import net.ion.webapp.utils.DbUtils;
import net.ion.webapp.utils.JobLogger;
import net.ion.webapp.utils.LowerCaseMap;
import net.sf.json.JSONObject;

@Service
public class WorkflowService {
	private static List<LowerCaseMap<String, Object>> wfTriggerList;
	private static List<LowerCaseMap<String, Object>> wfList;
	public final static String JOB_TRIGGER_CHK_VAL = "JOB_TRIGGER_CHK_VAL";
	public final static String JOB_TRIGGER_PATH = "JOB_TRIGGER_PATH";
	public final static String PROCESS_PATH = "WF_PROC_PATH";
	public final static String JOB_ID = "__wf_tg_return";
	public final static String JOB_TYPE = "job_type";
	public final static String JOB_TRIGGER_YN = "job_trigger_yn";
	public final static String WF_QUERY_ID = "system/wf/wf_list_use";
	public final static String ERROR_MESSAGE = "error_message";
	
	public final static String JOB_STATUS = "job_status";
	public final static String JOB_STATUS_RUN = "RUN";
	public final static String JOB_STATUS_ERROR = "ERR";
	public final static String JOB_STATUS_WAIT = "WAT";
	public final static String JOB_STATUS_RETRY = "RET";
	public final static String JOB_STATUS_SUCCESS = "SCS";
	public final static String JOB_STATUS_END = "END";
	
	protected static final Logger logger = Logger.getLogger(WorkflowService.class);
	@Autowired
	protected static ProcessService processService;
	
	public void clear() {
		wfTriggerList = null;
		wfList = null;
	}
	
	private synchronized void init()  {
		if(processService==null) processService = (ProcessService)ProcessInitialization.getService(ProcessService.class);
		
		if(wfTriggerList!=null){
			return;
		}
		
		wfTriggerList = new ArrayList<LowerCaseMap<String,Object>>();
		wfList = new ArrayList<LowerCaseMap<String,Object>>();

		try {
			List<LowerCaseMap<String, Object>> list = DbUtils.select(WF_QUERY_ID, new HashMap<String, Object>());
			
			for(LowerCaseMap<String, Object> row : list){
				wfList.add(row);
				
				if(!"Y".equals(row.get(JOB_TRIGGER_YN))) continue;
				
				row.put(JOB_TRIGGER_CHK_VAL, "${" + row.get(JOB_TRIGGER_CHK_VAL) + "}");
				wfTriggerList.add(row);
			}
		} catch (Exception e) {
			// TODO: handle exception
		}
		
	}
	
	public List<LowerCaseMap<String, Object>> getWfTriggerList() {
		if(wfTriggerList==null){
			init();
		}
		
		return wfTriggerList;
	}
	
	/**
	 * 워크프로우 트리거에 의한 JOB 생성
	 * @param request
	 * @param response
	 */
	public void addWfTriggerJob(HttpServletRequest request, HttpServletResponse response, PageContext pageContext){
		List<LowerCaseMap<String, Object>> wfTriggerList = getWfTriggerList();
		
		if(wfTriggerList.size()<1){
			return;
		}
		//해당되는 트리거를 찿아 실행한다.
		for(LowerCaseMap<String, Object> triggerInfo : wfTriggerList){
			try {					
				String exp = (String)triggerInfo.get(JOB_TRIGGER_CHK_VAL);//"${req._q=='system/wf/wf_list' && req.statues=='D'}";
				Object findTrgger = TemplateUtils.proprietaryEvaluate(exp, String.class, pageContext, null, false);
				
				if ("true".equals(findTrgger)){
					try {
						branchTriggerJob(request, response, pageContext, triggerInfo);
					} catch (Exception e) {
						JobLogger.write(this.getClass(), "wf", "error", "워크플로우 트리거 오류 : " + triggerInfo, triggerInfo.get("wf_id").toString(), true, e);
					}
				}
			} catch (Exception e) {
				JobLogger.write(this.getClass(), "wf", "error", "워크플로우 트리거 파싱 오류 : " + triggerInfo, triggerInfo.get("wf_id").toString(), true, e);
			}
		}
	}
	
	public static Map<String, Integer> getPoolInfo() {
		ThreadPoolTaskExecutor taskExecutor = (ThreadPoolTaskExecutor)ProcessInitialization.getService(ThreadPoolTaskExecutor.class);
		Map<String, Integer> info = new HashMap<String, Integer>();
		BlockingQueue blockingQueue = taskExecutor.getThreadPoolExecutor().getQueue();
		
		info.put("active_job", taskExecutor.getActiveCount());
		info.put("pool_size", taskExecutor.getPoolSize());
		info.put("waiting_job", blockingQueue.size());
		info.put("pool_capacity", blockingQueue.remainingCapacity());

		return info;
	}
	/**
	 * 워크플로우 트리거에 의해 잡을 생성한다.
	 * @param request
	 * @param response
	 * @param pageContext
	 * @param triggerInfo
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	private void branchTriggerJob(HttpServletRequest request, HttpServletResponse response, PageContext pageContext, LowerCaseMap<String, Object> triggerInfo)throws Exception{
		if(processService==null) processService = (ProcessService)ProcessInitialization.getService(ProcessService.class);
		//if(true) throw new Exception("test");
		String jobType = (String)triggerInfo.get(JOB_TYPE);
		
		if("HTTP".endsWith(jobType)){
			JSONObject processDetail = new JSONObject();
			processDetail.put("id", JOB_ID);
			processDetail.put("jobId", "http");
			processDetail.put("url", triggerInfo.get(JOB_TRIGGER_PATH));

			processService.runProcessJob(request, response, processDetail, triggerInfo);
		}else if("QUERY".equals(jobType)){
			JSONObject processDetail = new JSONObject();
			processDetail.put("id", JOB_ID);
			processDetail.put("jobId", "db");
			processDetail.put("query", triggerInfo.get(JOB_TRIGGER_PATH));

			processService.runProcessJob(request, response, processDetail, triggerInfo);
		}else if("PROC".equals(jobType)){
			JSONObject processDetail = new JSONObject();
			processDetail.put("id", JOB_ID);
			processDetail.put("jobId", triggerInfo.get(JOB_TRIGGER_PATH));

			processService.runProcessJob(request, response, processDetail, triggerInfo);
		}else if("JSP".equals(jobType)){
			TemplateUtils.include((String)triggerInfo.get(JOB_TRIGGER_PATH)+".jsp", pageContext);
		}else{
			throw new Exception("jobType : [" + jobType + "]는 구현되지 않음");
		}
		
	}
	/**
	 * 잡을 실행한다.
	 * @param jobInfo
	 * @return
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public Map<String,Object> branchJob(Map<String,Object> jobInfo) throws Exception{
		if(processService==null) processService = (ProcessService)ProcessInitialization.getService(ProcessService.class);

		String result = JOB_STATUS_ERROR;
		jobInfo.put("job_status", result);
		
		String jobType = (String)jobInfo.get("job_type");
		Object o = null;
	
		if("HTTP".endsWith(jobType)){
			JSONObject processDetail = new JSONObject();
			processDetail.put("id", JOB_ID);
			processDetail.put("jobId", "http");
			processDetail.put("url", jobInfo.get(PROCESS_PATH));

			o = processService.runProcessJob(null, null, processDetail, jobInfo);

			result = JOB_STATUS_SUCCESS;
		}else if("QUERY".equals(jobType)){
			JSONObject processDetail = new JSONObject();
			processDetail.put("id", JOB_ID);
			processDetail.put("jobId", "db");
			processDetail.put("query", jobInfo.get(PROCESS_PATH));

			o = processService.runProcessJob(null, null, processDetail, jobInfo);

			result = JOB_STATUS_SUCCESS;
		}else if("PROC".equals(jobType)){
			JSONObject processDetail = new JSONObject();
			processDetail.put("id", JOB_ID);
			processDetail.put("jobId", jobInfo.get(PROCESS_PATH));

			o = processService.runProcessJob(null, null, processDetail, jobInfo);
			Map rtn = null;
			
			if (o instanceof Map) {
				rtn = (Map) o;
			}else{
				throw new Exception("워크플로우 프로세서 구현 오류 : jobType = [" + jobType + "]는 Map을 반환해야 하며 job_status 값으로 (SCS, WAT, ERR) 중 하나를 가져야 합니다. 오류시에는 error_message 값을 넣어주세요.");
			}
			
			String jobStatus = (String) rtn.get("job_status");
			
			result = jobStatus;
			if(!JOB_STATUS_SUCCESS.equals(jobStatus) && !JOB_STATUS_WAIT.equals(JOB_STATUS_WAIT) && !JOB_STATUS_ERROR.equals(JOB_STATUS_ERROR)){
				throw new Exception("워크플로우 프로세서 구현 오류 : jobType = [" + jobType + "]는 Map에 job_status 값으로 (SCS, WAT, ERR) 중 하나를 가져야 합니다. 오류시에는 error_message 값을 넣어주세요.");
			}
			
		}else{
			throw new Exception("워크플로우 프로세서 구현 오류 : jobType = [" + jobType + "]는 구현되지 않음");
		}
		
		jobInfo.put("job_status", result);

		return jobInfo;
	}

}
