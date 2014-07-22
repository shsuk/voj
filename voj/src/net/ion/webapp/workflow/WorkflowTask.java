package net.ion.webapp.workflow;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import net.ion.webapp.processor.system.DbProcessor;
import net.ion.webapp.utils.JobLogger;

public class WorkflowTask  implements Runnable {
	protected static final Logger logger = Logger.getLogger(WorkflowTask.class);
	private static Map<String, Boolean> runMap = new HashMap<String, Boolean>();

	private Map<String,Object> jobInfo;
	private WorkflowService workflowService;
	private String wfJobId;
	
	public WorkflowTask(Map<String,Object> jobInfo, WorkflowService workflowService){
		this.jobInfo = jobInfo;
		this.workflowService = workflowService;
		this.wfJobId = jobInfo.get("wf_job_id").toString();
		
		runMap.put(wfJobId, false);
	}
	
	@Override
	public void run() {
		logger.debug("Start Job : " + wfJobId);
		
		try {
			runMap.put(wfJobId, true);
			
			jobInfo = workflowService.branchJob(jobInfo);
			//오류인 경우
			if(StringUtils.equals(WorkflowService.JOB_STATUS_ERROR, (String)jobInfo.get(WorkflowService.JOB_STATUS))){
				if(!jobInfo.containsKey(WorkflowService.ERROR_MESSAGE)){
					jobInfo.put(WorkflowService.ERROR_MESSAGE, "오류가 발생하였습니다.\n결과 : "+jobInfo.get(WorkflowService.JOB_ID));
				}
			}
		} catch (Exception e) {
			jobInfo.put(WorkflowService.ERROR_MESSAGE, StringUtils.substring(e.toString(),0,3000));
			logger.error("워크프로우 Job 오류", e);
			
		}finally{
			try {
				runMap.remove(wfJobId);
				DbProcessor.execute(null, "system/wf/change_job_status_result", jobInfo, false, 0);
			} catch (Exception e2) {
				JobLogger.write(this.getClass(), "wf", "error", "워크프로우 Job 오류 : Job상태를 변경하는중 오류가 발생하였습니다.", "", true, e2);
			}
		}
		
		logger.debug("End Job : " + wfJobId);
	}
	
	public static boolean hasJob(String jobId) {
		return runMap.containsKey(jobId);
	}
	
	public static boolean isRunJob(String jobId) {
		return runMap.get(jobId);
	}
	
	public static String getRunInfo() {
		return runMap.toString();
	}
}
