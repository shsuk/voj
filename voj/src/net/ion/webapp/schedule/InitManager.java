package net.ion.webapp.schedule;


import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimerTask;

import org.apache.log4j.Logger;

import net.ion.user.interceptor.PagePermission;
import net.ion.webapp.db.CodeUtils;
import net.ion.webapp.db.Lang;
import net.ion.webapp.process.ProcessInitialization;
import net.ion.webapp.utils.DbUtils;
import net.ion.webapp.utils.LowerCaseMap;
import net.ion.webapp.workflow.WorkflowService;

public class InitManager extends TimerTask {
	protected static final Logger logger = Logger.getLogger(CodeUtils.class);

	SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	private static String checkDate;
	
	public InitManager(){
		checkDate = dateFormater.format(new Date());
	}
	
	public void run() {
		String runDate = checkDate;
		String queryPath = "system/init_list";
		
		try {
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("mod_dt", checkDate);
			
			//변경여부 정보 가져오기
			List<LowerCaseMap<String, Object>> list = DbUtils.select(queryPath, params);

			for(LowerCaseMap<String, Object> row : list){
				String count = row.get("chg_count").toString();
				runDate = (String)row.get("check_date");
				
				if("0".equals(count)){
					continue;
				}
				
				String kind = (String)row.get("kind");

				if("code".equals(kind)){//코드 초기화
					CodeUtils.clear();
				}else if("lang".equals(kind)){//다국어 초기화
					Lang.clear();
				}else if("schedule".equals(kind)){//스케쥴 초기화
					ScheduleFactory.initSchedule();
				}else if("menu".equals(kind)){//메뉴 초기화
						PagePermission.clear();
						System.out.println("메뉴 초기화");
				}else if("workflow".equals(kind)){//워크플로우 초기화
					((WorkflowService)ProcessInitialization.getService(WorkflowService.class)).clear();
				}
			}
			checkDate = runDate;
			
		} catch (Exception e) {
			logger.error("코드 초기화 중 오류가 발생하였습니다.", e);
		}

		
	}

}
