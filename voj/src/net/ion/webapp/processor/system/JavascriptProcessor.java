package net.ion.webapp.processor.system;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Service;

import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;
import net.ion.webapp.utils.ParamUtils;
/**
 * 
 *예제
{
		id:'rows', jobId:'javascript', 
		src = '
+		var sum=0;
+		for(var i=0;i<10;i++)  sum = sum + i; 
+	
+		sum;'
},{
		id:'rows', jobId:'javascript', 
		src = "'ddddddfffdfdfdf'.substring(5)"
}
 * @author shsuk
 *
 */

@Service
public class JavascriptProcessor  extends ImplProcessor{

	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String src = processInfo.getString("src");

		Object val = null;
		
		try {
			val = ParamUtils.getReplaceValue("${" + src + "}", processInfo.getSourceDate());
		} catch (Exception e) {
			throw new RuntimeException(e.toString() + "\nsrc : \n" + src, e);
		}

		ReturnValue returnValue = new ReturnValue();
		returnValue.setResult(val);
		
		return returnValue;
	}
	
}
