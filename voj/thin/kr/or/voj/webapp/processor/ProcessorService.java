package kr.or.voj.webapp.processor;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ReturnValue;


public interface ProcessorService {
	public Object execute(Map<String, Object> param) throws Exception;
}
