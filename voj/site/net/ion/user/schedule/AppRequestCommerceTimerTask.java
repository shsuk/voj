package net.ion.user.schedule;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.ion.webapp.schedule.ImplTimerTask;
import net.ion.webapp.service.ProcessService;
import net.ion.webapp.utils.DbUtils;
import net.ion.webapp.utils.JobLogger;
import net.ion.webapp.utils.LowerCaseMap;

public class AppRequestCommerceTimerTask extends ImplTimerTask {

	public void execute()throws Exception{
		List<LowerCaseMap<String, Object>> list = DbUtils.select("sl/sch/app_req_com_list", new HashMap<String, Object>());

		for(Map<String, Object> row : list){
			try {
				ProcessService.callTransactionMethod(this, "work", new Object[] {row});
			} catch (Exception e) {
				JobLogger.write(this.getClass(), "스케쥴", "오류", "data : " + row, row.get("hcid").toString(), true, e);
			}
			
		}
	}

	public void work(Map<String, Object> row)throws Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("hcid", row.get("hcid"));
		int count = DbUtils.update("sl/sch/app_req_com_update", params);
		if(count<1){
			throw new Exception("작업상태를 바꿀수 없습니다. 데이타를 확인하세요.");
		}
		JobLogger.write(this.getClass(), "스케쥴", "로그", "data : " + row, row.get("hcid").toString(), true, null);
	}
}
