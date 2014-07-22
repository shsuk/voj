package kr.or.voj.webapp.processor;

import java.util.Map;

import org.apache.commons.collections.map.CaseInsensitiveMap;

import net.ion.webapp.utils.LowerCaseMap;

/**
 * <pre>
 * 시스템명 : KT_MVNO_KPM
 * 작 성 자 : Park Sang-Hoon
 * 작 성 일 : 2010. 4. 2
 * 설    명 : 메뉴관리 Business logic
 *
 * 수정이력 : 2010. 4. 2 Park Sang-Hoon 최초작성
 * 
 * 저 작 권 : I-ON Communications ECM Business Team
 * </pre>
 */
public interface DBProcessor {
	
	public Map<String, Object> execute(CaseInsensitiveMap params) throws Exception;
	public Map<String, Object> executeQuerys(String path, CaseInsensitiveMap params) throws Exception;
	public Object executeQuery(String query, boolean isSingleRow, CaseInsensitiveMap params) throws Exception;
}
