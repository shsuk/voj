package net.ion.user.schedule;


import java.io.File;

import net.ion.webapp.exception.IslimException;
import net.ion.webapp.process.ProcessInitialization;
import net.ion.webapp.schedule.ImplTimerTask;
import net.ion.webapp.service.ProcessService;
import net.ion.webapp.utils.JobLogger;

public class TestTimerTask extends ImplTimerTask {

	public void execute()throws Exception{
		String result = "이곳에 비즈니스 로직을 구현하세요.";
		String msg = "이 로그는 db에 등록 됨";

		JobLogger.write(this.getClass(), "scd", "test_log", scdName + " \n" + msg, JobId, "L", null, isLogWrite, new File("C:/Users/shsuk/Pictures/11.jpg"));

		ProcessService.callTransactionMethod(this, "test", new Object[] {result});
	}

	public void test(String test)throws IslimException{
		String msg = "/이 로그는 db에 등록 안됨";

		JobLogger.write(this.getClass(), "scd", "test_log", scdName + " \n" + msg, JobId, "L", null, isLogWrite, new File("C:/Users/shsuk/Pictures/11.jpg"));
		
		throw new IslimException("test_err", "테스트 오류가 발생하였습니다.");
	}
}
