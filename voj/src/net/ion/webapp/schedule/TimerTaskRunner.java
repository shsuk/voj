package net.ion.webapp.schedule;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

public class TimerTaskRunner {
	private static final Map<String, Map<String, Object>> tasks = new HashMap<String, Map<String, Object>>() ;
	public final static SimpleDateFormat COMMON_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	public static Map<String, Map<String, Object>> getTasks() {
		return tasks;
	}
	public static void cancel() {
		for(String key : tasks.keySet()){
			Map<String, Object> taskInfo = tasks.get(key);
			Timer timer = (Timer)taskInfo.get("timer");
			if(timer!=null) timer.cancel();
			timer = null;
		}
		tasks.clear();
	}
/*
	private static void init() {
		if(timer==null) timer = new Timer(true);
	}
*/	
	public synchronized static void addTimerTask(String id, TimerTask task, int delay, int period){
		if(!tasks.containsKey(id)){
			Timer timer = new Timer(true);
			timer.schedule(task, delay, period) ;
			Map<String, Object> taskInfo = new HashMap<String, Object>();
			taskInfo.put("task", task);
			taskInfo.put("delay", delay);
			taskInfo.put("period", period);
			taskInfo.put("timer", timer);
			tasks.put(id, taskInfo) ;
		}
	}
	
	public synchronized static void addTimerTask(String id, TimerTask task, Date date, int period){
		if(!tasks.containsKey(id)){
			Timer timer = new Timer(true);
			timer.scheduleAtFixedRate(task, date, period) ;
			Map<String, Object> taskInfo = new HashMap<String, Object>();
			taskInfo.put("task", task);
			taskInfo.put("date", COMMON_FORMAT.format(date.getTime()));
			taskInfo.put("period", period);
			taskInfo.put("timer", timer);
			tasks.put(id, taskInfo) ;
		}
	}

}
