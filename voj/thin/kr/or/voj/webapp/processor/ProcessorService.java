package kr.or.voj.webapp.processor;

import java.util.Map;


public interface ProcessorService {
	public Object execute(Map<String, Object> param) throws Exception;
}
