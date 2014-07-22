package net.ion.webapp.utils;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;

public class ShellCommand {
	private static String CHARSET_NAME = "euc-kr";
	
	public static ShellResult exec(String command) {
		return exec(command, null);
	}
	public static ShellResult exec(String command, String charsetName) {
		charsetName = StringUtils.isEmpty(charsetName) ? CHARSET_NAME : charsetName;
		ShellResult sr = new ShellResult();
		
		Process proc = null;
		
		try {
			Runtime rt = Runtime.getRuntime();
			String osName = System.getProperty("os.name");
			
			if(StringUtils.startsWithIgnoreCase(osName, "Windows")){
				proc = rt.exec("cmd.exe /c " + command);
			}else{
				proc = rt.exec(command);
			}
			
			ShellStreamGobbler gbIn = new ShellStreamGobbler(proc.getInputStream(), charsetName);
			ShellStreamGobbler gbEr = new ShellStreamGobbler(proc.getErrorStream(), charsetName);
			gbIn.start();
			gbEr.start();

			while (true) {
				if (!gbIn.isAlive() && !gbEr.isAlive()) { // 두개의 스레드의  프로세스  종료할 때 까지 기다린다.
					//appLoggerEnv.debug("Thread gbIn Status : " + gbIn.getState());
					//appLoggerEnv.debug("Thread gbEr Status : " + gbEr.getState());
					proc.waitFor();
					break;
				}
				Thread.sleep(500);
			}
			
			sr.errorList = gbEr.getResult();
			sr.resultList = gbIn.getResult();
		} catch (Exception e) {
			e.printStackTrace();
			sr.errorList = new ArrayList<String>();
			sr.resultList = new ArrayList<String>();
			
			sr.errorList.add(e.toString());
		} finally {
			if (proc != null)
				proc.destroy();
		}

		return sr;

	}
/*	
	public static boolean isCertificateTerm(List<String> list, int year){

		Date sd = null;
		Date ed = null;
		String termStr = "";
		
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy. MM. dd aa hh:mm");
			
			for(String term : list){
				termStr = term.trim();
				if(!StringUtils.startsWithIgnoreCase(termStr, "[certificate")) continue;
				
				termStr = StringUtils.replace(termStr, "[certificate is valid from", "");
				termStr = StringUtils.replace(termStr, "]", "");
				String [] dates = termStr.split(" to ");
				sd = sdf.parse("20" + dates[0].trim());
				ed = sdf.parse("20" + dates[1].trim());
				Date checkDate = DateUtils.addDays(sd, year*365-1);
				
				return (checkDate.getTime() <= ed.getTime());
			}
			
		} catch (Exception e) {
			System.out.println("유효기간 체크 데이트 : " + termStr);
			e.printStackTrace();
		}
		
		return false;
	}
*/	
	public static void main(String[] args) throws Exception {
		//String javaHome = System.getProperty("java.home");
		String command = "\"C:\\Program Files\\Java\\jdk1.7.0_03\\bin\\jarsigner\" -verify -certs -verbose N:\\sam\\AndExam4_1_100y.apk";
		ShellResult sr = ShellCommand.exec(command, null);
		//boolean ok = ShellCommand.isCertificateTerm(sr.resultList, 20);
		//System.out.println(ok);
	}

}
