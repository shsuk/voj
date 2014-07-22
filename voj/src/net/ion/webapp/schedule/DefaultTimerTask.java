package net.ion.webapp.schedule;

import net.ion.webapp.utils.HttpUtils;
import net.ion.webapp.utils.JobLogger;

import org.apache.commons.lang.StringUtils;


public class DefaultTimerTask  extends ImplTimerTask  {


	public void execute()throws Exception {
		String result = "";

		if(StringUtils.isEmpty(path)) return;
		
		if(path.startsWith("http")){
			JobLogger.write(this.getClass(), "scd:"+id, null, scdName, JobId, "L", null, isLogWrite);
			result = HttpUtils.getString(path, null, 0);
		}else{
			throw new Exception("지원하지 않는 타입입니다. 경로를 확인하세요. 경로 : "+path);
			//JSONObject json = runProcessByID(path);
			//result = json.toString();
		}
		
		JobLogger.write(this.getClass(), "scd:"+id, null, scdName + " : " + result.trim(), JobId, "L", null, isLogWrite);
		
	}
}
