package net.ion.webapp.utils;

import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;

public class Evaluate {
	public static boolean booleanValue(String exp) throws Exception {
		Object val = eval(exp);
		if (val instanceof Boolean) {
			return ((Boolean) val).booleanValue();			
		}else{
			throw new Exception("표현식이 잘못되었습니다.(" + exp + ")");				
		}
	}
	public static Object eval(String exp) throws Exception {
		ScriptEngineManager mgr = new ScriptEngineManager();
		ScriptEngine engine = mgr.getEngineByName("javascript");
		Object val = null;
		
		try {
			val = engine.eval(exp);
			
		} catch (Exception e) {
			throw new Exception("표현식이 잘못되었습니다.(" + exp + ")",e);
		}
		
		return val;
	}
}
