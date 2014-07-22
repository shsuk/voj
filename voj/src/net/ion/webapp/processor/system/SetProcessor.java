package net.ion.webapp.processor.system;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Service;

import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;

@Service
public class SetProcessor extends ImplProcessor{
	/**
	 * 프로그램에서 사용할 기본값들을 설정한다.
	 */
	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {

		String val = processInfo.getString("val");
		
		ReturnValue returnValue = new ReturnValue();
		returnValue.setResult(val);
		
		return returnValue;
	}
}
