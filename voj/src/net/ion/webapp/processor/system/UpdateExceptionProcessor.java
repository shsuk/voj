package net.ion.webapp.processor.system;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Service;

import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;

@Service
public class UpdateExceptionProcessor  extends ImplProcessor {

	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ReturnValue returnValue = new ReturnValue();

		String sourceId = processInfo.getString("sourceId");
		String count = processInfo.getString(sourceId);
		try {
			if("0".equals(count)){
				returnValue.setResult(new Exception("Update count 0"));
			}else{
				returnValue.setResult(false);
			}
		} catch (Exception e) {
			returnValue.setResult(new Exception(sourceId + " : 소스 아이디가 잘못되었습니다."));
		}
		
		return returnValue;
	}
}
