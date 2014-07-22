package net.ion.webapp.processor.system;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Service;

import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;

@Service
public class GetProcessor extends ImplProcessor{

	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ReturnValue returnValue = new ReturnValue();

		Map source = null;
		String src = processInfo.getString("src");
		String item = processInfo.getString("item");
		
		source = (Map)processInfo.getSourceDate().get(src);

		returnValue.setResult(source.get(item));
				
		return returnValue;
	}
}
