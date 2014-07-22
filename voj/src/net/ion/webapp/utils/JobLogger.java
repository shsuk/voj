package net.ion.webapp.utils;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.PrintStream;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.apache.log4j.Logger;

import net.ion.webapp.db.CodeUtils;
import net.ion.webapp.exception.IslimException;
import net.ion.webapp.fleupload.Upload;
import net.ion.webapp.process.ProcessInitialization;
import net.ion.webapp.processor.system.DbProcessor;

public class JobLogger {
	private static final ThreadLocal<String> sessionIdThreadLocal = new ThreadLocal<String>() ;
	private static final Map<String, StringBuffer> sessionLogMap = new HashMap<String, StringBuffer>();
	private static long lastLogReadTime = 0;
	private static int MAX_LOG_SIZE = 1024*1024;
	/**
	 * 로그정보가 있는지 체크함
	 * @param sessionid
	 * @return
	 */
	public static boolean hasSessionLog(String sessionid){
		return sessionLogMap.containsKey(sessionid);
	}
	/**
	 * 세션별 로그 기록 초기화
	 * @param sessionid
	 */
	public static void initSessionLog(String sessionid){
		JobLogger.sessionLogMap.put(sessionid, new StringBuffer());
	}
	/**
	 * 로그 읽기
	 * @param sessionid
	 * @return
	 */
	public static StringBuffer getLog(String sessionid){
		StringBuffer sb = JobLogger.sessionLogMap.get(sessionid);
		JobLogger.sessionLogMap.put(sessionid, new StringBuffer());
		lastLogReadTime = (new Date()).getTime();
		return sb;
	}
	/**
	 * 세션아이디 설정
	 * LoginInterceptor.preHandle에서 설정
	 * @param sessionId
	 */
	public static void setSessionId(String sessionId){
		JobLogger.sessionIdThreadLocal.set(sessionId);
	}
	/**
	 * 세션에 로그 기록
	 * @param clazz
	 * @param message
	 * @param e
	 */
	private static void writeSessonLog(Class clazz, String message, Exception e) {
		long checkTime = DateUtils.addMinutes(new Date(), -1).getTime();
		//로그를 1분동안 읽지 않으면 삭제하고 기록 중지
		if(lastLogReadTime < checkTime){
			sessionLogMap.clear();
			return;
		}
		
		String sessionid = JobLogger.sessionIdThreadLocal.get();
		sessionid = (sessionid==null) ? "background-job" : sessionid;

		StringBuffer logSb = sessionLogMap.get(sessionid);
		
		if(logSb.length()>MAX_LOG_SIZE){
			logSb = new StringBuffer();
			JobLogger.sessionLogMap.put(sessionid, logSb);
		}
		
		synchronized (logSb) {
			try {
				
				String name = clazz.getName();
				Exception ee = new Exception(message);
				StackTraceElement[] ste = ee.getStackTrace();
				for(StackTraceElement st : ste){
					String cname = st.getClassName();
					if(StringUtils.equals(cname, name)){
						logSb.append("<font color=\"red\">[");
						logSb.append(st.toString());
						logSb.append("]</font>");
						break;
					}
				}
				
				logSb.append("<font color=\"red\">");
				logSb.append(StringUtils.replace(message,"\n","<br>"));
				logSb.append("</font><br>");

				if(e!=null){
					StackTraceElement[] stes = e.getStackTrace();
					for(StackTraceElement st : stes){
						String str = st.toString();
						logSb.append((StringUtils.startsWith(str,"net.ion") ? "<font color=\"blue\">" : ""));
						logSb.append(str);
						logSb.append("</font><br>");
					}
				}
			} catch (Exception e2) {
				sessionLogMap.remove(sessionid);
			}
		}
	}
	
	public static void write(Class clazz, String jobClass, String messageId, String message, String jobId, String logStatus, Exception e, boolean isDBWrite, File f){
		InputStream is = null;
		String fName = "";
		long size = 0;
		
		try {
			if(f!=null){
				try {
					size = f.length();
					is = new FileInputStream(f);
					fName = f.getName();
				} catch (Exception e2) {
					// TODO: handle exception
				}
			}
			write(clazz, jobClass, messageId, message, jobId, logStatus, e, isDBWrite, is, size, fName);
		} catch (Exception e2) {
			e2.printStackTrace();
		}finally{
			try { if(is!=null) is.close(); }catch (Exception e1) {} 
		}
	}
	public static void write(Class clazz, String jobClass, String messageId, String message, String jobId, String logStatus, Exception e, boolean isDBWrite, InputStream is, long size, String fName){
		Logger logger = null;
		try {
			logger = Logger.getLogger(clazz);
			String logStatusName = logStatus;
			
			try {
				logStatusName = CodeUtils.getName("log_status", logStatus);
			} catch (Exception e2) { }
			
			messageId = (StringUtils.isEmpty(messageId) ? "log" : messageId);
			String msg = StringUtils.isEmpty(messageId) ? message : " \n\tMESSAGE ID : " + messageId + 
					" \n\tJOB ID : " + jobId + 
					" \n\tLOG STATUS : " + logStatusName + 
					" \n\tMESSAGE : " + message;
			//로그파일에 로그 기록
			if(e==null) logger.info(msg);
			else logger.error(msg , e);
			//브라우져에 로그 기록
			writeSessonLog(clazz, msg, e);
			
			String fileId = null;
			//파일이 있는 경우 저장소에 저장
			if(is!=null){
				try {
					fileId = Upload.saveFile(null, fName, "log", "joblog_tbl", "system", is, size,null);
				} catch (Exception e2) {
					fileId = "save error";
				}
			}
			//DB에 로그 기록
			if(!isDBWrite){
				return;
			}

			Map<String, Object> params = new HashMap<String, Object>();
			String errMessage = message;
			
			
			if(e!=null){
				ByteArrayOutputStream baos = new ByteArrayOutputStream();
				PrintStream ps = new PrintStream(baos);
				e.printStackTrace(ps);
				errMessage = message + " \nException Info : " + baos.toString();
				
				if (e instanceof IslimException) {
					IslimException ie = (IslimException) e;
					String errId = ie.getErrorId();
					messageId = StringUtils.isEmpty(errId) ? messageId : StringUtils.substring(errId, 0, 20);
				}
			}
			int len = 0;
			
			for(int i=0;i<errMessage.length();i++){
				int c = errMessage.codePointAt(i);
				len += (c<129 && c>0) ? 1 : 3;
				if(len>3990) {
					errMessage = errMessage.substring(0, i);
					break;
				}
			}
			String[] jobClasss = jobClass.split(":");
			params.put("job_class", jobClasss[0]);
			params.put("server", ProcessInitialization.getServseIp());
			params.put("job_id", jobId);
			params.put("message_id", messageId);
			params.put("log_status", logStatus);
			params.put("message", errMessage);
			params.put("class_name", (jobClasss.length >1 ? jobClasss[1] : clazz.getName()));
			params.put("file_id",fileId);
			DbProcessor.execute(null, "/system/job/add_log", params, false, 0);			
		}catch (Exception e2) {
			try {
				logger.error("오류가 발생하여 작업로그를 기록하지 못했습니다. \n" + message + " \n" +e.toString() , e2);
			} catch (Exception e3) {
				// TODO: handle exception
			}
		}
	}
	
	public static void write(Class clazz, String jobClass, String messageId, String message, String jobId, String logStatus, Exception e, boolean isDBWrite){
		InputStream is = null;
		write(clazz, jobClass, messageId, message, jobId, logStatus, e, isDBWrite, is, 0, "");
	}

	public static void write(Class clazz, String jobClass, String messageId, String message, String jobId, boolean isDBWrite, Exception e){
		write(clazz, jobClass, messageId, message, jobId, (e==null ? "L" : "F"), e, isDBWrite, null);
	}
	public static void write(Class clazz, String message, Exception e){
		write(clazz, "", "", message, "", (e==null ? "L" : "F"), e, false, null);
	}
	public static void write(Class clazz, String message){
		write(clazz, message, null);
	}
	
	public static void write(Class clazz, String jobClass, String messageId, String message, String jobId, boolean isDBWrite, Exception e, File f){
		write(clazz, jobClass, messageId, message, jobId, (e==null ? "L" : "F"), e, isDBWrite, f);
	}
	public static void write(Class clazz, String jobClass, String messageId, String message, String jobId, boolean isDBWrite, Exception e, InputStream is , long size, String fName){
		write(clazz, jobClass, messageId, message, jobId, (e==null ? "L" : "F"), e, isDBWrite, is, size, fName);
	}
	
	public static void write(Class clazz, String jobClass, String messageId, String message, boolean isDBWrite, Exception e){
		write(clazz, jobClass, messageId, message, null, (e==null ? "L" : "F"), e, isDBWrite, null);
	}
	
	public static void write(Class clazz, String jobClass, String messageId, String message, boolean isDBWrite, Exception e, File f){
		write(clazz, jobClass, messageId, message, null, (e==null ? "L" : "F"), e, isDBWrite, f);
	}
	
	public static void write(Class clazz, String jobClass, String messageId, String message, boolean isDBWrite, Exception e, InputStream is, long size, String fName){
		write(clazz, jobClass, messageId, message, null, (e==null ? "L" : "F"), e, isDBWrite, is, size, fName);
	}
}
