package kr.or.voj.webapp.processor;

import java.util.Map;

import net.ion.webapp.utils.LowerCaseMap;
import net.sf.json.JSONObject;

import org.apache.commons.collections.map.CaseInsensitiveMap;
import org.springframework.stereotype.Component;

/**
 * <pre>
 * 시스템명 : KT_MVNO_KPM
 * 작 성 자 : 석승한
 * 작 성 일 : 2014. 3. 18
 * 설    명 : Test
 *
  * </pre>
 */
@Component
public class DBProcessorService extends DBProcessorImp {

	public Map<String, Object> execute(CaseInsensitiveMap params) throws Exception {

		String name = (String)params.get("_QUERY_PATH_");

		Map<String, Object> resultSet = executeQuerys(name, params);
		
		return resultSet;
	}

	
		
}
