package net.ion.user.processor;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;
import net.ion.webapp.utils.Aes;
import net.ion.webapp.utils.DbUtils;
import net.ion.webapp.utils.LowerCaseMap;
import net.ion.webapp.workflow.WorkflowService;

@Service
public class TestProcessor  extends ImplProcessor{
	protected static final Logger logger = Logger.getLogger(TestProcessor.class);
	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {

		ReturnValue returnValue = new ReturnValue();

		List<LowerCaseMap<String, Object>> list = (List<LowerCaseMap<String, Object>>)processInfo.getSourceDate().get("rows");

		for(LowerCaseMap<String, Object> row : list){
			String user_nm = Aes.encrypt((String)row.get("user_nm"));
			row.put("user_nm", user_nm);

			String user_id = Aes.encrypt((String)row.get("user_id"));
			row.put("user_id", user_id);
			
			String mb_hp = Aes.encrypt((String)row.get("mb_hp"));
			row.put("mb_hp", mb_hp);

			String mb_email = Aes.encrypt((String)row.get("mb_email"));
			row.put("mb_email", mb_email);

			System.out.println(row);
			DbUtils.update("voj/usr/cvt", row);
		}
		
		return returnValue;
	}

}
