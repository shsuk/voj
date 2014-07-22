package net.ion.webapp.processor.system;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Service;

import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;

@Service
public class DefaultValueProcessor extends ImplProcessor{
	/**
	 * 프로그램에서 사용할 기본값들을 설정한다.
	 */
	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {

		Object params = processInfo.get("params");
		
		ReturnValue returnValue = new ReturnValue();
		returnValue.setResult(params);
		
		return returnValue;
	}
}
