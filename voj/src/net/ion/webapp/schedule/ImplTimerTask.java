package net.ion.webapp.schedule;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.TimerTask;
import java.util.UUID;

import net.ion.webapp.processor.system.DbProcessor;
import net.ion.webapp.utils.JobLogger;
import net.ion.webapp.utils.ParamUtils;

import org.apache.log4j.Logger;


public abstract class ImplTimerTask  extends TimerTask implements ScheduleTimerTask {
	protected String JobId;
	protected String scdName;

	protected String id;
	protected String path;
	protected boolean isLogWrite = true;

	protected SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	protected static final Logger logger = Logger.getLogger(ImplTimerTask.class);
	private boolean isRun = false;
	private Map<String, Object> taskInfo = null;
	
	public String getScdName() {
		return scdName;
	}

	public void setScdName(String scdName) {
		this.scdName = scdName;
	}
	public void setLogWrite(boolean isLogWrite) {
		this.isLogWrite = isLogWrite;
	}
	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = (String)ParamUtils.getReplaceValue(path, new HashMap<String, Object>()) ;
		//logger.info("[Schedul info]\n\trun ip = " + ProcessInitialization.getScheduleRunIp() + "\n\tpath = " + path + " > " + this.path);
	}
	public void setId(String id) {
		this.id = id;
		scdName = id;
		
		try {
			Map<String, Object> params= new HashMap<String, Object>();
			params.put("scd_id", id);
			DbProcessor.execute(null, "system/schedule/reg", params, false, 0);
		} catch (Exception e) {
			JobLogger.write(this.getClass(), "scd:"+id, "error", scdName, JobId, true, e);
		}
	}
	public String toString(){
		return "'path : " + path + "'";
	}
	@Override
	public void run() {
		JobId = UUID.randomUUID().toString();
		this.taskInfo = ((Map) TimerTaskRunner.getTasks().get(this.id));

		if(isRun){
			String result = "";
			result = "[" + dateFormater.format(new Date()) + "] Skip Schedule : " + path;
			logger.info(result);
			return;
		}
		
		try {
			Map<String, Object> params= new HashMap<String, Object>();
			params.put("scd_id", id);
			JobLogger.write(this.getClass(), "scd:"+id, null, scdName, JobId, "S", null, isLogWrite);
			DbProcessor.execute(null, "system/schedule/str", params, false, 0);
		} catch (Exception e) {
			JobLogger.write(this.getClass(), "scd:"+id, "error", scdName, JobId, true, e);
		}

		try {
			this.taskInfo.put("Last run Time", this.dateFormater.format(new Date()));
			isRun = true;
			String result = "";
			result = "[" + dateFormater.format(new Date()) + "] Start Schedule : " + path;
			logger.info(result);
			StringBuffer sb = new StringBuffer(result);
			result = "";

			execute();

			sb.append("\n[" + dateFormater.format(new Date()) + "] End Schedule : " + path);
			logger.info(sb.toString());
			this.taskInfo.put("End Time", this.dateFormater.format(new Date()));
		}catch (Exception e) {
			this.taskInfo.put("Schedule Error", e.toString());
			JobLogger.write(this.getClass(), "scd:"+id, "error", scdName, JobId, true, e);
			try {
				Map<String, Object> params= new HashMap<String, Object>();
				params.put("scd_id", id);
				params.put("err_msg", e.toString());
				DbProcessor.execute(null, "system/schedule/err", params, false, 0);
			} catch (Exception e1) {
				JobLogger.write(this.getClass(), "scd:"+id, "error", scdName, JobId, true, e1);
			}
		}finally{
			isRun = false;
			try {
				Map<String, Object> params= new HashMap<String, Object>();
				params.put("scd_id", id);
				DbProcessor.execute(null, "system/schedule/end", params, false, 0);
				JobLogger.write(this.getClass(), "scd:"+id, null, scdName, JobId, "E", null, isLogWrite);
			} catch (Exception e) {
				JobLogger.write(this.getClass(), "scd:"+id, "error", scdName, JobId, true, e);
			}
		}
	}
/*
	protected JSONObject runProcessByID (String processId)throws Exception{
		ProcessService processService = ProcessInitialization.getProcessService();
		JSONObject result = new JSONObject();

		ProcessInitialization processInfo = ProcessInitialization.getProcessInfo(processId, false);
		processId = processInfo.getProcessId();
		List<List<JSONObject>> jaProcessList = processInfo.getProcessInfo();

		for(int i=0; i<jaProcessList.size(); i++){
			List<JSONObject> jaProcess = jaProcessList.get(i);

			processService.runProcessList(jaProcess, new SimpleRequest(), null, result);				
		}

		return result;
	}
*/	

}
