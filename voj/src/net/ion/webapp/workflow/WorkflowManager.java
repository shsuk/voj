package net.ion.webapp.workflow;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimerTask;
import java.util.concurrent.BlockingQueue;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import net.ion.webapp.process.ProcessInitialization;
import net.ion.webapp.processor.system.DbProcessor;
import net.ion.webapp.service.TestService;
import net.ion.webapp.utils.JobLogger;

public class WorkflowManager  extends TimerTask {
	protected static final Logger logger = Logger.getLogger(WorkflowManager.class);
	private ThreadPoolTaskExecutor taskExecutor;
	protected WorkflowService workflowService;
	

	@Override
	public void run() {
		boolean hasRunData = false;
		
		if(workflowService==null) workflowService = (WorkflowService)ProcessInitialization.getService(WorkflowService.class);
		if(taskExecutor==null) taskExecutor = (ThreadPoolTaskExecutor)ProcessInitialization.getService(ThreadPoolTaskExecutor.class);

		try {
			do {
				//재시도 횟수 초과 Job 오류 처리
				changeErrorRetryJob();
				Thread.sleep(2000);
				//Job의 처리단계를 바꾼다.
				changeJobStep();
				//Job을 실행한다.
				hasRunData = runJob();
				
				Thread.sleep(3000);
			} while (hasRunData);
			
			//상태만 진행중인 Job을 해제한다.
			releaseHangingJob();
		} catch (Exception e) {
			JobLogger.write(this.getClass(), "wf", "error", "워크프로우 관리자 오류 : 워크프로우 관리자가 Job을 관리하는 중 오류가 발생하였습니다.", "", true, e);
		}
	}
	/**
	 * Job을 실행한다.
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private boolean runJob() {
		boolean hasRunData = false;
		
		try {
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("run_ip", ProcessInitialization.getServseIp());
			//int poolSize = taskExecutor.getActiveCount();
			BlockingQueue blockingQueue = taskExecutor.getThreadPoolExecutor().getQueue();
			int poolCapacity = blockingQueue.remainingCapacity();
			
			while(blockingQueue.size() < poolCapacity){			
				List<Object> result = (List<Object>)DbProcessor.execute(null, "system/wf/working_job", params, false, 0);				
				List<Map<String,Object>> list = (List<Map<String,Object>>)result.get(2);
				
				if(list.size()<1) break;
				
				WorkflowTask workflowTask = new WorkflowTask(list.get(0), workflowService);
				//Job을 실행한다.
				taskExecutor.execute(workflowTask);
				hasRunData = true;
				
				Thread.sleep(100);
			}
			
		} catch (Exception e) {
			JobLogger.write(this.getClass(), "wf", "error", "워크프로우 관리자 오류 : 워크프로우 관리자가 Job을 관리하는 중 오류가 발생하였습니다.", "", true, e);
		}
		
		return hasRunData;
	}
	/**
	 * Job의 처리단계를 바꾼다.
	 */
	private void changeJobStep() {
		try {
			int ni = 0;
			String befWfId = "";
			
			//프로세스 단계 변경 자료를 가지고 온다.
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> list = (List<Map<String, Object>>)DbProcessor.execute(null, "system/wf/change_proc_list", new HashMap<String, Object>(), false, 0);				
			
			for(int i=0; i<list.size(); i++){
				Map<String, Object> row = list.get(i);
				ni = i+1;
				ni = ni==list.size() ? i : ni;
				
				Map<String, Object> nRow = list.get(ni);
				String curWfId = null;
				
				try {
					curWfId = row.get("wf_id").toString();
										
					if(i==ni || !StringUtils.equals(curWfId, nRow.get("wf_id").toString())){//마지막 단계
						Object rtn = DbProcessor.execute(null, "system/wf/change_end_job", row, false, 0);			
					}else{
						row.put("next_wf_proc_id", nRow.get("wf_proc_id"));
						Object rtn = DbProcessor.execute(null, "system/wf/change_next_job", row, false, 0);			
					}
					//새로 등록된 Job을 처음 단계로 설정한다.
					if(!StringUtils.equals(befWfId, curWfId)){
						row.put("next_wf_proc_id", row.get("wf_proc_id"));
						row.put("wf_proc_id", 0);
						Object rtn = DbProcessor.execute(null, "system/wf/change_next_job", row, false, 0);			
					}

					befWfId = curWfId;
				} catch (Exception e) {
					JobLogger.write(this.getClass(), "wf", "error", "워크프로우 관리자 오류 : 프로세스 단계 변경중 오류가 발생하였습니다.", curWfId, true, e);
				}
			}
			//프로세스가 없는 Job을 완료 한다.
			Object rtn = DbProcessor.execute(null, "system/wf/change_end_no_proc_job", new HashMap<String, Object>(), false, 0);
		} catch (Exception e) {
			JobLogger.write(this.getClass(), "wf", "error", "워크프로우 관리자 오류 : 프로세스 단계 변경중 오류가 발생하였습니다.", "", true, e);
		}
	}
	/**
	 * 상태만 진행중인 Job을 해제한다.
	 */
	private void releaseHangingJob() {

		try {
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("run_ip", ProcessInitialization.getServseIp());
			
			List<Map<String, Object>> list = (List<Map<String, Object>>)DbProcessor.execute(null, "system/wf/working_list", params, false, 0);				
			
			for(Map<String, Object> row : list){

				if(!WorkflowTask.hasJob(row.get("wf_job_id").toString())){
					Object rtn = DbProcessor.execute(null, "system/wf/change_job_status", row, false, 0);			
				}
			}
		} catch (Exception e) {
			logger.error("워크프로우 관리자 오류 : 프로세스 단계 변경중 오류가 발생하였습니다.", e);
		}

	}
	/**
	 * 재시도 횟수 초과 Job 오류 처리
	 */
	private void changeErrorRetryJob() {

		try {

			Object rtn = DbProcessor.execute(null, "system/wf/change_retry_over_job", new HashMap<String, Object>(), false, 0);				
			
		} catch (Exception e) {
			logger.error("워크프로우 관리자 오류 : 프로세스 단계 변경중 오류가 발생하였습니다.", e);
		}

	}
	
}
