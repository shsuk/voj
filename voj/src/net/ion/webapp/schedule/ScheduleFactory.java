package net.ion.webapp.schedule;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Timer;
import java.util.TimerTask;

import net.ion.webapp.process.ProcessInitialization;
import net.ion.webapp.processor.system.DbProcessor;
import net.ion.webapp.workflow.WorkflowManager;

import org.apache.commons.lang.StringUtils;
import org.apache.coyote.http11.InputFilter;
import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;
import org.springframework.util.ClassUtils;

public class ScheduleFactory  {
	public static ApplicationContext ctx1;
	public final static SimpleDateFormat COMMON_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	private static int DELAY_DAY = 24*60*60*1000;
	private static int DELAY_WEEK = DELAY_DAY*7;
	protected static final Logger logger = Logger.getLogger(ScheduleFactory.class);
	private static Timer  initManagerTimer = null;
	private static Timer  wfManagerTimer = null;
	
	public static void init() {
		initCodeManager();
		initSchedule();
		
		startWFManager();
	}
	
	public static void initCodeManager() {
		try {
			//코드 관리자를 스케쥴링한다.
			if(initManagerTimer!=null) initManagerTimer.cancel();
			initManagerTimer = new Timer(true);
			InitManager initManager = new InitManager();
			initManagerTimer.schedule(initManager, 60000*2, 60000*2) ;
		} catch (Exception e) {
			logger.error("워크프로우 관리자 오류 : 워크프로우 관리자 초기화 하는중에 오류가 발생하였습니다.", e);
		}
	}
	
	private static void startWFManager() {
		try {
			//워크프로우 관리자를 스케쥴링한다.
			if(wfManagerTimer!=null) wfManagerTimer.cancel();
			wfManagerTimer = new Timer(true);
			WorkflowManager workflowManager = new WorkflowManager();
			wfManagerTimer.schedule(workflowManager, 60000, 60000) ;
		} catch (Exception e) {
			logger.error("워크프로우 관리자 오류 : 워크프로우 관리자 초기화 하는중에 오류가 발생하였습니다.", e);
		}
	}

	public static void initSchedule() {
		//스케쥴 타이머를 초기화 한다.
		TimerTaskRunner.cancel();
		List<Map<String,Object>> list = null;
		
		try {
			list = (List<Map<String,Object>>)DbProcessor.execute(null, "system/schedule/list", new HashMap<String, Object>(), false, 0);				
		} catch (Exception e) {
			logger.error("스케쥴 초기화 오류 : system/schedule/list 쿼리의 정보를 가지고 오는중 오류가 발생하였습니다.", e);
		}
		
		for (Map<String,Object> row : list) {
			try {

				if(!"Y".equals((String) row.get("use_yn"))) continue;
				
				if(!ProcessInitialization.isServerIp((String) row.get("scd_run_ip"))) continue;
				
				String timerTask = (String) row.get("scd_id");
				String path = (String) row.get("scd_path");
				String period = (String) row.get("scd_period");
				String[] values = StringUtils.split(period, ',');
				if (values == null) continue;

				TimerTask task = getTimerTask(timerTask, path, (String) row.get("scd_name"), (String) row.get("log_write"));
				if (task == null){
					logger.info("다음 스케쥴을 생성할 수 없습니다. path : " + path);
					continue;
				}
				
				Calendar current = Calendar.getInstance();
				
				switch (values.length) {
					case 1: {
						Integer delay = new Integer(values[0].trim())*1000*60;
						TimerTaskRunner.addTimerTask(timerTask, task, 60000, delay);
						break;
					}
					case 2: {//매일 hh시 mm분
						Calendar firstTime = Calendar.getInstance();
						firstTime.set(Calendar.HOUR_OF_DAY, new Integer(values[0].trim()));
						firstTime.set(Calendar.MINUTE, new Integer(values[1].trim()));
						logger.info(COMMON_FORMAT.format(firstTime.getTime()));
						if (firstTime.before(current)) {
							firstTime.add(Calendar.DAY_OF_MONTH, 1);
						}
						logger.info(COMMON_FORMAT.format(firstTime.getTime()));
						TimerTaskRunner.addTimerTask(timerTask, task, firstTime.getTime(), DELAY_DAY);
						break;
					}
					case 3: {//매주 x요일 hh시 mm분
						Calendar firstTime = Calendar.getInstance();
						firstTime.set(Calendar.DAY_OF_WEEK, new Integer(values[2].trim()));
						firstTime.set(Calendar.HOUR_OF_DAY, new Integer(values[0].trim()));
						firstTime.set(Calendar.MINUTE, new Integer(values[2].trim()));
						logger.info(COMMON_FORMAT.format(firstTime.getTime()));
						if (firstTime.before(current)) {
							firstTime.add(Calendar.WEEK_OF_MONTH, 1);
						}
						logger.info(COMMON_FORMAT.format(firstTime.getTime()));
						TimerTaskRunner.addTimerTask(timerTask, task, firstTime.getTime(), DELAY_WEEK);
						break;
					}
					default:
						break;
				}
			} catch (Exception e) {
				logger.error("스케쥴 초기화 오류", e);
			}
		}			
	}

	public static TimerTask getTimerTask(String id, String classPath, String name, String log_write) throws ClassNotFoundException, LinkageError{
		ImplTimerTask dtt = null;
		
		try {
			Class cls = forName(classPath);
			Object obj = cls.newInstance();
			if (obj instanceof ImplTimerTask) {
				dtt = (ImplTimerTask) obj;
			}else{
				throw new Exception("ImplTimerTask클래스를 extends하여 개발하세요. 참조) DefaultTimerTask");
			}
		} catch (Exception e) {
			//정의된 타스크가 없는 경우 DefaultTimerTask를 이용하여 처리한다.
			dtt = new DefaultTimerTask();
		}
		dtt.setPath(classPath);
		dtt.setId(id);
		dtt.setScdName(name);
		dtt.setLogWrite("Y".equals(log_write));
		return dtt;
	}
	private static final ClassLoader classLoader = ClassUtils.getDefaultClassLoader() ;
	private  static Class<?> forName(String name) throws ClassNotFoundException, LinkageError {
		Class<?> cls = ClassUtils.forName(name, classLoader) ;
		return cls ;
}	
}
