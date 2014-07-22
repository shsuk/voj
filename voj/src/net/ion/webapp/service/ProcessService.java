package net.ion.webapp.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ion.webapp.exception.IslimException;
import net.ion.webapp.fleupload.Upload;
import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ProcessInitialization;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ProcessorFactory;
import net.ion.webapp.processor.ProcessorService;
import net.ion.webapp.utils.JobLogger;
import net.ion.webapp.utils.ParamUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.beanutils.MethodUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Service
public class ProcessService {
	@Autowired
	protected TestService testService;
	protected static final Logger logger = Logger.getLogger(ProcessService.class);
	public final static String  REQUEST_REPLACE_PARAMS = "__REQUEST_REPLACE__";
	public final static String  REQUEST_PARAMS = "__REQUEST__";
	public final static String  __PROCESS_ALL_RESULT__ = "__PROCESS_ALL_RESULT__";//result
	
	private Map<String, String[]> copyParameterMap(HttpServletRequest request) {
		Map<String, String[]> map = new HashMap<String, String[]>();

		request.getParameterMap().keySet();
		for (String name : request.getParameterMap().keySet()) {
			map.put(name, request.getParameterValues(name));
		}
		return map;
	}

	public Object runProcessJob(HttpServletRequest request, HttpServletResponse response, JSONObject processDetail, Map<String, Object> result) throws Exception {
		Object ids = processDetail.get("id");
		String findJobId = (String) processDetail.get("jobId");

		if (findJobId == null && findJobId == null) {
			throw new Exception("다음 프로세서에 jobId가 없습니다 : " + processDetail.toString());
		}
		if (ids == null) {
			throw new Exception("다음 프로세서에 id가 없습니다 : " + processDetail.toString());
		}

		if (request != null && request.getAttribute(ProcessService.REQUEST_REPLACE_PARAMS) == null) {
			request.setAttribute(ProcessService.REQUEST_REPLACE_PARAMS, copyParameterMap(request));
		}

		JSONObject pd = JSONObject.fromObject(processDetail);
		String debug = (request == null) ? "false" : request.getParameter("debug");
		boolean isDebug = "true".equals(debug);
		boolean isTest = testService.isTestUser(request);

		ReturnValue returnValue = null;
		/**
		 * 복사해서 써야 하는 이유를 구체적으로 기술할것.
		 * 
		 * @TODO
		 */
		Map<String, Object> copyResult = new HashMap<String, Object>();
		for (String key : result.keySet()) {
			copyResult.put(key, result.get(key));
		}
		// 시스템에 관련된 파라메터를 등록한다.
		if (request != null) {
			Map<String, Object> userParams = (Map<String, Object>) request.getAttribute("_USER_PARAMS_");

			if (userParams != null) {
				for (String key : userParams.keySet()) {
					copyResult.put(key, userParams.get(key));// LoginInterceptor에서
																// 초기화
				}
			}

			copyResult.put("server", request.getAttribute("server"));// LoginInterceptor에서 초기화
			copyResult.put("session", request.getAttribute("session"));// LoginInterceptor에서 초기화 (참조:SessionService.saveSession())
			copyResult.put(ProcessService.REQUEST_PARAMS, request.getParameterMap());// requestMap의 원본값을 저장한다.
			copyResult.putAll((Map) request.getAttribute(ProcessService.REQUEST_REPLACE_PARAMS));// requestMap의 값이 가공되어 변형된 값을 저장한다.
			// taglib의 파라메터 값 추가
			Map __TAGLIB__PARAMS__ = (Map) request.getAttribute("__TAGLIB__PARAMS__");
			if (__TAGLIB__PARAMS__ != null){
				copyResult.putAll(__TAGLIB__PARAMS__);
			}
			// CMS 동적쿼리 정보 생성
			String pageId = request.getParameter("_page_id_");
		} else {
			logger.debug("******************************\nTODO request==null");
		}
		Map<String, Object> defaultValues = (Map<String, Object>) processDetail.get("defaultValues");
		// 기본값 설정
		if (defaultValues != null) {
			for (String key : defaultValues.keySet()) {
				Object val = copyResult.get(key);
				if (val != null) {
					if (val instanceof List) {
						List list = (List) val;

						val = list.size() > 0 ? list.get(0) : "";
					} else if (val instanceof String[]) {
						String[] list = (String[]) val;

						val = list[0];
					}

				}
				if (val == null || StringUtils.isEmpty(val.toString())) {// 값이 없거나 Empty인 경우 기본값으로 대치한다.
					val = defaultValues.get(key);
					if (val instanceof String) {
						val = ParamUtils.getReplaceValue((String) val, copyResult);
					}
					copyResult.put(key, val);
					request.setAttribute(key, val);
				}
			}
		}

		String forName = (String) processDetail.get("forEach");

		// 루핑 처리
		if (StringUtils.isNotEmpty(forName)) {
			String var = (String) processDetail.get("var");// forEach 변수 처리
			if (StringUtils.isEmpty(var)) {
				throw new Exception("id : " + ids + "의 forEach 변수 var가 존재하지 않습니다.");
			}

			if (forName.startsWith("param.") || forName.startsWith("req.")) {//request객체인 경우(param은 원데이타로 돌리고 req는 가공된 값으로 돌린다.
				returnValue = forEachLoopProcessJobByReqParam(forName, var, copyResult, request, response, processDetail);
			} else {
				returnValue = forEachLoopProcessJob(forName, var, copyResult, request, response, processDetail);
			}
		} else {
			Object processJob = ProcessorFactory.getProcessJobService(request, findJobId, isTest);
			returnValue = execute(processJob, pd, copyResult, request, response, isTest, isDebug);
		}

		Object rtn = returnValue.getResult();
		// 처리결과 저장
		setResult(result, ids, rtn);

		result.put("debug_" + ids, returnValue.getLogString());
		result.put("isReturn", isReturn(processDetail, result));

		return returnValue.getResult();
	}

	private void setResult(Map<String, Object> result, Object ids, Object rtn) {
		if (ids instanceof List && rtn instanceof List) {
			List idList = (List) ids;
			List rtnList = (List) rtn;
			for (int i = 0; i < idList.size(); i++) {
				result.put(idList.get(i).toString(), rtnList.get(i));
			}
			logger.debug(result);
		} else {
			result.put(ids.toString(), rtn);
		}

	}

	private ReturnValue execute(Object processJob, JSONObject processDetail, Map<String, Object> sourceDate, HttpServletRequest request, HttpServletResponse response, boolean isTest, boolean isDebug)
			throws Exception {
		ReturnValue returnValue = null;

		boolean isSkip = ProcessInfo.getBooleanValue(processDetail, sourceDate, "skip", false);
		String test = (String) processDetail.get("test");
		if (test != null) {
			String testValue = (String) ParamUtils.getReplaceValue(test, sourceDate);
			try {
				StringBuffer sb = new StringBuffer();
				sb.append("\n=====================================================================")
					.append("\n\t\t\t테\t스\t트\t시\t작")
					.append("\n---------------------------------------------------------------------")
					.append("\ntest 속성의 값을 테스트합니다.")
					.append("\nprintStackTrace는 테스트 위치를 알려주기 위해 넣은 소스입니다.")
					.append("\n테스트후 값은 test 항목은 삭제하여 주세요.")
					.append("\n---------------------------------------------------------------------")
					.append("\n\t\ttest:[" + test + "]의 값 : [" + testValue + "]")
					.append("\n---------------------------------------------------------------------");
				throw new Exception(sb.toString());
			} catch (Exception e) {
				e.printStackTrace();
				StringBuffer sb = new StringBuffer();
				sb.append("\n---------------------------------------------------------------------")
					.append("\n\t\t\t테\t스\t트\t종\t료")
					.append("\n=====================================================================");
				logger.debug(sb.toString());
			}
		}
		// 프로세스를 스킵한다.
		if (isSkip) {
			String id = (String) processDetail.get("id");
			returnValue = new ReturnValue();
			returnValue.setResult(sourceDate.get(id));
			return returnValue;
		}
		if (processJob instanceof ProcessorService) {
			returnValue = ((ProcessorService) processJob).execute(new ProcessInfo(processDetail, sourceDate, isTest, isDebug), request, response);
		} else {
			String method = StringUtils.substringAfter((String) processDetail.get("jobId"), ".");

			Object[] args = { new ProcessInfo(processDetail, sourceDate, isTest, isDebug), request, response };
			returnValue = (ReturnValue) MethodUtils.invokeMethod(processJob, method, args);
		}

		return returnValue;
	}

	private ReturnValue forEachLoopProcessJob(String forName, String var, Map<String, Object> copyResult, HttpServletRequest request, HttpServletResponse response, JSONObject processDetail)
			throws Exception {
		String id = (String) processDetail.get("id");
		String jobId = (String) processDetail.get("jobId");
		String unionVar = (String) processDetail.get("unionVar");

		JSONObject pd = JSONObject.fromObject(processDetail);
		String debug = request.getParameter("debug");
		boolean isDebug = "true".equals(debug);
		boolean isTest = testService.isTestUser(request);

		ReturnValue returnValue = new ReturnValue();
		JSONArray results = new JSONArray();

		Object obj = copyResult.get(forName);
		if (obj == null) {
			return returnValue;
			// throw new Exception("id : " + id + "의 forEach = " + forName +
			// "가 존재하지 않거나 결과가 없습니다.");
		}

		Object processJob = ProcessorFactory.getProcessJobService(request, jobId, isTest);

		List<Object> forList = null;
		// 대상 데이타가 Array가 아닌 경우 Array로 만들어 for문 처리한다.
		if (obj instanceof List) {
			forList = (List<Object>) obj;
		} else if (obj instanceof Map) {
			forList = new ArrayList<Object>();
			forList.add(obj);
		} else if (obj instanceof Object[]) {
			forList = new ArrayList<Object>();
			Object[] objs = (Object[]) obj;
			for (Object o : objs)
				forList.add(o);
		}

		int loop = 0;

		for (Object row : forList) {
			copyResult.put(var, row);
			
			ReturnValue rv = execute(processJob, pd, copyResult, request, response, isTest, isDebug);

			Object rtn = rv.getResult();
			// Exception리턴시에 처리중단
			if (rtn instanceof Exception)
				return rv;

			if (unionVar != null) {
				((Map<String, Object>) row).put(unionVar, rtn);
				results.add(row);
			} else {
				results.add(rtn);
			}
			if (isDebug || isTest) {
				returnValue.append("\n" + forName + "[" + loop++ + "]").append(rv.getLog());
			}
		}
		// 대상 데이타가 Array가 아닌 경우 처리
		if (obj instanceof List) {
			returnValue.setResult(results);
		} else {
			returnValue.setResult(obj);
		}

		return returnValue;
	}

	private ReturnValue forEachLoopProcessJobByReqParam(String forName, String var, Map<String, Object> copyResult, HttpServletRequest request, HttpServletResponse response, JSONObject processDetail)
			throws Exception {
		ReturnValue returnValue = new ReturnValue();

		String id = (String) processDetail.get("id");
		String findJobId = (String) processDetail.get("jobId");

		JSONObject pd = JSONObject.fromObject(processDetail);
		String debug = request.getParameter("debug");
		boolean isDebug = "true".equals(debug);
		boolean isTest = testService.isTestUser(request);

		String[] forInfos = StringUtils.split(forName, '.');
		forName = forInfos[0];
		String forVarName = forInfos[1];

		boolean isEmptySkip = ProcessInfo.getBooleanValue(processDetail, copyResult, "emptySkip", false);

		JSONArray results = new JSONArray();
		
		Map<String, String[]> params = (Map<String, String[]>) ("req".equals(forName) ? request.getAttribute(ProcessService.REQUEST_REPLACE_PARAMS) : copyResult.get(ProcessService.REQUEST_PARAMS));
		String[] paramVal = params.get(forVarName);

		if (paramVal == null)
			return returnValue;

		Object processJob = ProcessorFactory.getProcessJobService(request, findJobId, isTest);

		for (int i = 0; i < paramVal.length; i++) {
			String val = paramVal[i].trim();

			if (isEmptySkip && StringUtils.isEmpty(val))
				continue;

			Map<String, Object> row = getParamRow(params, i, request);

			copyResult.put(var, row);

			ReturnValue rv = execute(processJob, pd, copyResult, request, response, isTest, isDebug);
			Object rtn = rv.getResult();
			if (rtn instanceof Exception)
				return rv;

			results.add(rtn);
			if (isDebug || isTest) {
				returnValue.append("\n" + forName + ":" + val + "").append(rv.getLog());
			}
		}
		returnValue.setResult(results);

		return returnValue;
	}

	private Map<String, Object> getParamRow(Map<String, String[]> params, int idx, HttpServletRequest request) {
		Map<String, Object> row = new HashMap<String, Object>();

		for (String key : params.keySet()) {
			String[] vals = params.get(key);
			String val = (vals.length > idx) ? vals[idx] : vals[0];

			row.put(key, val.trim());
		}

		Map<String, List<Map<String, Object>>> attachReqList = (Map<String, List<Map<String, Object>>>) request.getAttribute("__REQUEST_ATTACH_FILE__");

		if (attachReqList == null)
			return row;

		for (String key : attachReqList.keySet()) {
			List<Map<String, Object>> vals = attachReqList.get(key);
			Map<String, Object> val = (vals.size() > idx) ? vals.get(idx) : null;

			row.put(key, val);
		}
		return row;
	}

	private boolean isReturn(JSONObject processDetail, Map<String, Object> sourceDate) throws Exception {
		return ProcessInfo.getBooleanValue(processDetail, sourceDate, "isReturn", true);
	}

	/**
	 * 프로세서 리스트를 실행한다.
	 * 
	 * @param jaProcessList
	 * @param request
	 * @param response
	 * @param result
	 * @return
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> runProcessList(List<JSONObject> jaProcessList, HttpServletRequest request, HttpServletResponse response, Map<String, Object> result) throws Exception {
		Map<String, Object> retData = new HashMap<String, Object>();

		for (JSONObject processDetail : jaProcessList) {
			Object ids = processDetail.get("id");
			try {
				// logger.debug(" [ START PROCESS ] :  " + ids);
				Object rtn = runProcessJob(request, response, processDetail, result);
				// logger.debug(" [ END PROCESS ] : " + ids);

				if (((Boolean) result.get("isReturn"))) {
					// 처리결과 저장
					setResult(retData, ids, rtn);
				}
				// Exception리턴시에 처리중단
				if (rtn instanceof Exception) {
					result.put("success", false);

					break;
				}
			} catch (Exception e) {
				//오류발생시 첨부파일 롤백처리한다.
				rollbackMultipartAttchFile(request);
				
				throw new Exception(e.toString() + "\n[ ERROR PROCESS ] : " + ids + "\nProcess Info : " + processDetail, e);
			}finally{
				//다음 트랜재션에서 오류 일때 삭제되는 것을 방지하기 위해 지운다.
				request.setAttribute("__ATT_IDS__", null);
			}
		}

		return retData;
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object invokeTransactionMethod(Object obj, String methodName, Object[] params) throws Exception {

		return MethodUtils.invokeMethod(obj, methodName, params);

	}

	public static Object callTransactionMethod(Object obj, String methodName, Object[] params) throws Exception {
		ProcessService processService = (ProcessService) ProcessInitialization.getService(ProcessService.class);

		Object result = processService.invokeTransactionMethod(obj, methodName, params);

		return result;
	}
	
	
	private static void rollbackMultipartAttchFile(HttpServletRequest request) {
		if (!(request instanceof MultipartHttpServletRequest)) {
			return;
		}
		//__ATT_IDS__로 저장한 첨부파일 필드명 정보를 가져온다.
		Object o = request.getAttribute("__ATT_IDS__");
		
		if(o==null){
			return;
		}
		
		List<String> attIds = (List<String>)o;
		
		Map<String, String[]> parameterMap = (Map<String, String[]>)request.getAttribute(ProcessService.REQUEST_REPLACE_PARAMS);

		for(String id: attIds) {
			String[] fileIds = parameterMap.get(id);
			
			for(String fileId : fileIds) {
				if(StringUtils.isEmpty(fileId)){
					continue;
				}
				//첨부파일삭제
				Upload.deleteFile(fileId);
			}
		}
	}
}
