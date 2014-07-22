package net.ion.webapp.processor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ReturnValue;


public interface ProcessorService {
	public String getJobId();
	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception;
}
