package net.ion.webapp;

import java.io.File;
import java.net.URLDecoder;
import java.util.Calendar;
import java.util.Date;

import org.apache.commons.io.FileUtils;
import org.apache.commons.mail.DefaultAuthenticator;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.SimpleEmail;

public class Test {
	public void sendMail() {
		SimpleEmail email = new SimpleEmail();

    try {
        email.setHostName("smtp.i-on.net");
		email.setSmtpPort(443);
		email.setSslSmtpPort("443");
		email.setAuthenticator(new DefaultAuthenticator("shsuk@i-on.net", "ssh8720"));
		//email.setSSLOnConnect(true);
		email.addTo("shsuk@i-on.net");
        email.setFrom("shsuk@i-on.net");
        email.setSubject("메일");
        email.setMsg("This is a simple test of commons-email");
        email.send();

    } catch (EmailException ex) {
        ex.printStackTrace();
    }
}

public static void main(String[] args) throws Exception {
	Date date = new Date();
	Calendar cal = Calendar.getInstance();
	int year = 2014;
	int month = 1;
	
	cal.set(cal.YEAR, year);
	cal.set(cal.MONTH, month-1);
	
	Calendar calcal = (Calendar)cal.clone();

	cal.set(cal.DATE, 1);
	int sWeek = cal.get(cal.DAY_OF_WEEK)-1;
	month = cal.get(cal.MONTH)+1;
	cal.set(cal.MONTH,month);
	date = cal.getTime();
	cal.add(cal.DATE, -1);
	int eDay = cal.get(cal.DATE);

	

	calcal.add(cal.MONTH, -1);
	int bYear = calcal.get(cal.YEAR);
	int bMonth = calcal.get(cal.MONTH)+1;

	calcal.add(cal.MONTH, 2);
	int aYear = calcal.get(cal.YEAR);
	int aMonth = calcal.get(cal.MONTH)+1;
	
	
	System.out.println("주시작 : " + sWeek);
	System.out.println("월의 마지막일 : " + eDay);
	System.out.println("전달 : " + bYear + "-" + bMonth);
	System.out.println("다음달 : " + aYear + "-" + aMonth);

	
	String s= URLDecoder.decode("%E3%85%87%E3%85%87%E3%85%87","utf-8");
	
	Test main = new Test();
    main.sendMail();
  }
}

