package net.ion.webapp.processor.system;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;
import net.ion.webapp.processor.ProcessorFactory;

import org.apache.commons.beanutils.MethodUtils;
import org.springframework.stereotype.Service;
/**
 * 예제
[
	{
		id:'fnc', jobId:'fnc',
		path:'net.ion.webapp.utils.Function',
		method:'formatDate',
		params:['yyyy-MM-dd HH:mm:ss']
	},{
		id:'aes', jobId:'requestEnc',
		fields:['a1', 'a2']
	},{
		id:'rows', jobId:'db', ds:"dDS", query:'/test/select_aes'
	}
]
 * @author shsuk
 *
 */
@Service
public class FncProcessor  extends ImplProcessor{

	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String path = processInfo.getString("path");
		String method = processInfo.getString("method");
		Object val = null;
		try {
			List<Object> params = (List<Object>)processInfo.get("params");
			List<Object> argsList = new ArrayList<Object>();
			
			for(int i=0; i<params.size(); i++){
				Object o = params.get(i);
				
				if (o instanceof String) {
					o = processInfo.replaceObject((String)o);
				}
				argsList.add(i, o);
			}
			Object[] args = argsList.toArray();

			Class cls = ProcessorFactory.forName(path);
			
			val = MethodUtils.invokeMethod(cls.newInstance(), method, args);
		} catch (Exception e) {
			throw new RuntimeException(e.toString() + "\npath : " + path + "\nmethod : " + method + "\n", e);
		}

		ReturnValue returnValue = new ReturnValue();
		returnValue.setResult(val);
		
		return returnValue;
	}
	
}
