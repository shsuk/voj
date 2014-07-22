package net.ion.webapp.process;

import java.io.File;
import java.io.IOException;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import net.ion.webapp.adapter.RepositoryAdapter;
import net.ion.webapp.adapter.RepositoryFileAdapter;
import net.ion.webapp.db.DataSourceUtils;
import net.ion.webapp.exception.ProcessPageNotFoundException;
import net.ion.webapp.processor.ProcessorFactory;
import net.ion.webapp.schedule.ScheduleFactory;
import net.ion.webapp.service.ProcessService;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.web.context.WebApplicationContext;

public class ProcessInitialization implements ApplicationContextAware{
	protected static final Logger logger = Logger.getLogger(ProcessInitialization.class);
	//private static String tmpScheduleRunIp;
	//private static String scheduleRunIp;
	//private static boolean isScheduleRunIp = false;
	private static String servseIps;
	private static String servseIp;
	private static Map<String, Boolean> servseIpMap;
	private static String WEB_ROOT = null;
	private static String WEB_INF = "/WEB-INF";
	private static String CLASS_PATH = "/WEB-INF/classes" ;
	
	private static String tempDir = "D:/temp/";
	
	private static String webInf;
	private static String clazzRoot;
	private static String queryFullPath;
	private static String viewResolverFullPath;
	//private static String viewResolverPrefix;
	private static RepositoryAdapter repositoryAdapter;
	public static Map<String, Boolean> PUBLIC_URL = null;

	private static ProcessService processService;

	public static ApplicationContext ctx;

	private static ClassLoader classLoader;
	
	private long lastModifyCheck = 0;
	private long modifyCheckInterval = 1000*5;
	/**
	 * 변경여부를 체크할 주기가 되었는지 반환한다.
	 * @return
	 */
	private boolean noModifyCheck(){
		//변경체그 주기가 되었는지 확인
		long curTime = (new Date()).getTime();
		if(lastModifyCheck > curTime) return true;
		lastModifyCheck = curTime + modifyCheckInterval;
		return false;
	}

	public static ClassLoader getClassLoader() {
		return classLoader;
	}
	public static RepositoryAdapter getRepositoryAdapter() {
		return repositoryAdapter;
	}
	public void setRepositoryAdapter(RepositoryAdapter repositoryAdapter) {
		ProcessInitialization.repositoryAdapter = repositoryAdapter;
	}
	
	public static String getTempDir() {
		return tempDir;
	}
	public void setTempDir(String tempDir) {
		ProcessInitialization.tempDir = tempDir;
	}
	private static String dsName;
	
	public static String getDsName() {
		return dsName;
	}
	public void setDsName(String dsName) {
		ProcessInitialization.dsName = dsName;
	}
	/*	public void setViewResolverPrefix(String viewResolverPrefix) {
		ProcessInitialization.viewResolverPrefix = viewResolverPrefix;
	}
	public static String getViewResolverPrefix() {
		return viewResolverPrefix;
	}
*/	
	public static String getServseIps() {
		return servseIps;
	}
	public static String getServseIp() {
		return servseIp;
	}

	public static boolean isServerIp(String ip) {
		return servseIpMap.containsKey(ip);
	}

	private String getAddress() {
		servseIpMap = new HashMap<String, Boolean>();
	 	StringBuffer sb = new StringBuffer();
		try {
	       	logger.info("==========================================");
	       	logger.info("    SCHEDUL CHECK LOCAL IP");
	       	logger.info("==========================================");
		    for (Enumeration<NetworkInterface> en = NetworkInterface.getNetworkInterfaces(); en.hasMoreElements();)
		    {
		        NetworkInterface intf = en.nextElement();
		        for (Enumeration<InetAddress> enumIpAddr = intf.getInetAddresses(); enumIpAddr.hasMoreElements();)
		        {
		            InetAddress inetAddress = enumIpAddr.nextElement();
		            String ip = inetAddress.getHostAddress().toString();
		            //if (inetAddress.isSiteLocalAddress())
		            //if (!inetAddress.isLoopbackAddress() && !inetAddress.isLinkLocalAddress() && inetAddress.isSiteLocalAddress())
		            if(ip.indexOf(':')<0) {
		            	logger.info("local ip : " + ip);
		            	sb.append("[" + ip + "] ");
		            	servseIpMap.put(ip, true);
		            	
		            	if(!"127.0.0.1".equals(ip)) {
		            		servseIp = ip;
		            	}
		            }else{
		            	logger.info("local ip(non) : " + ip);
		            }
		        }
		    }
        	logger.info("==========================================");
		}
		catch (Exception ex) {}
		
		return sb.toString();
	}


	public static String getQueryFullPath() {
		return queryFullPath;
	}
	public void setViewResolverPath(Resource viewResolverPath){
		try {
			this.viewResolverFullPath = viewResolverPath.getFile().getAbsolutePath() + "/";
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public static String getViewResolverFullPath(){
		return viewResolverFullPath;
	}
	public void setQueryPath(Resource queryPath) {
		try {
			ProcessInitialization.queryFullPath = queryPath.getFile().getAbsolutePath() + "/";
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException{
		ctx = applicationContext;
		ServletContext sc = ((WebApplicationContext)ctx).getServletContext();
		String path = sc.getContextPath();
		init();
	}
	public static String getWebInf(){
		return webInf ;
	}
	public static String getWebRoot(){
		return WEB_ROOT ;
	}
	
	public static String getClazzRoot() {
		return clazzRoot;
	}
	private void init() throws BeansException{
		servseIps = getAddress();
		initWebRoot();
		webInf = WEB_ROOT + WEB_INF;
		clazzRoot = WEB_ROOT + CLASS_PATH;
		//initPath();
		DataSourceUtils.init(ctx);
		ProcessorFactory.init();
		ScheduleFactory.init() ;
	}
	/*		
	public void initPath1() {
		classLoader = this.getClass().getClassLoader();
		ClassPathResource res;
		String resPath;
		//스케쥴 패스
		//InputStream is = this.getClass().getClassLoader().getResourceAsStream(schedulePath);
		//res = new ClassPathResource(webInf + "/" + schedulePath);
		//res = new ClassPathResource("/" + schedulePath);
		//resPath = res.getPath();
		//resPath = resPath.indexOf(":")>0 ? resPath : "/" + resPath;
		//ProcessInitialization.schedulePath = resPath;
		//쿼리 ROOT PATH
		res = new ClassPathResource(webInf + "/" + queryPath);
		resPath = res.getPath();
		resPath = resPath.indexOf(":")>0 ? resPath : "/" + resPath;
		ProcessInitialization.queryFullPath = resPath + "/";
	}
*/		
	
	public synchronized static ProcessService getProcessService() throws BeansException {
		
		if(processService==null){
			String[] processServiceList = ctx.getBeanNamesForType(ProcessService.class);
			
			for(String serviceName : processServiceList){
				processService = (ProcessService) ctx.getBean(serviceName);
				break;
			}
		}
		return processService;
	}
	
	private static void initWebRoot(){
		if(WEB_ROOT == null){
			Resource res = ctx.getResource("/");
			//Resource res = new ClassPathResource("/", getClassLoader());
			

			if(res != null && res.exists()){
				try {
					File f = res.getFile() ;
					WEB_ROOT = f.getPath();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	public static ApplicationContext getCtx() {
		return ctx;
	}
	public static Object getService(Class cls) {
		String[] serviceList = ProcessInitialization.getCtx().getBeanNamesForType(cls);
		
		if(serviceList!=null && serviceList.length>0) {
			return ProcessInitialization.getCtx().getBean(serviceList[0]);
		}
		return null;
	}
	public static void setCtx(ApplicationContext ctx) {
		ProcessInitialization.ctx = ctx;
	}

	
	private static Map<String, ProcessInitialization> processInfoMap = null;
	private List<List<JSONObject>> processInfo = null;
	private boolean isMV = false;
	private long lastModified = 0;
	private String filePath = null;
	private boolean isApply = false;

	public boolean isApply() {
		return isApply;
	}
	public boolean apply() {
		if(this.isApply) return true;

		File f = new File(filePath);
		String orgName = StringUtils.replace(filePath, ".test.", ".");
		File orgF = new File(orgName);
		File bakF = new File(orgName + ".bak");
		
		bakF.delete();

		boolean isOK = orgF.renameTo(bakF);
		//실패
		if(!isOK) return isOK;

		isOK = f.renameTo(orgF);
		
		if(isOK){//적용성공으로 변경
			this.isApply = true;
		}else{//실패시 원복
			bakF.renameTo(orgF);			
		}
		
		return isOK;
	}

	public boolean isModified(long lastModified) {
		return this.lastModified != lastModified;
	}
	public void setLastModified(long lastModified) {
		this.lastModified = lastModified;
	}
	public boolean isMV() {
		return isMV;
	}
	public void setMV(boolean isMV) {
		this.isMV = isMV;
	}
	public List<List<JSONObject>> getProcessInfo() {
		return processInfo;
	}
	public void setProcessInfo(List<List<JSONObject>> processInfo) {
		this.processInfo = processInfo;
	}

	public static Map<String, ProcessInitialization> getProcessInfoMap() {
		return processInfoMap;
	}

	private static void addProcessInfo(String key, ProcessInitialization processInfo) {
		if(processInfoMap==null){
			processInfoMap = new HashMap<String, ProcessInitialization>();
		}
		processInfoMap.put(key, processInfo);
	}
	
	/**
	 * jsp,js에 정의된 프로세스의 변경여부를 판단하고, 상세 정보를 읽어 프로세스 정보를 만든다.
	 * @param root
	 * @param processId
	 * @param isTest
	 * @return
	 * @throws Exception
	 */
/*	private static ProcessInitialization makeProcessInfo(String root, String processId, boolean isTest) throws Exception{	
		ProcessInitialization processInfo = null;
		File f = null;
		boolean isMV = false;
		//테스트파일 체크
		if(isTest){
			f =new File(root + processId + ".test.jsp"); 
			isMV = f.exists();
			
			if(!isMV){
				f = new File(root + processId + ".test.js");
			}
			
			if(f.exists()){//테스트 파일이 존재하는 경우 아이디를 테스트 아이디로 변경
				processId += ".test"; 
			}else{//테스트 파일이 없는 경우 테스트를 false로 변경
				isTest = false;
			}
		}
		//테스트가 아닌 경우 또는 테스트 파일이 없는 경우 원본으로 처리 
		if(!isTest){
			processInfo = null;
			if(processInfoMap!=null) processInfo = processInfoMap.get(processId);
			
			if(processInfo!=null){
				if(processInfo.noModifyCheck()){//변경체크 주기가 아직 안된 경우에는 기존 정보를 반환한다.
					return processInfo;
				}
			}
			
			//변경여부를 확인한다.
			f =new File(root + processId + ".jsp"); 
			isMV = f.exists();
			
			if(!isMV){
				f = new File(root + processId + ".js");
			}
	
			if(!f.exists()){
				throw new ProcessPageNotFoundException(processId + ".jsp or " + processId + ".js file not found");
			}
		}
		
		processInfo = null;
		
		if(processInfoMap!=null) processInfo = processInfoMap.get(processId);
		
		//캐쉬 정보가 없거나 파일이 변경된 경우 정보를 다시 읽음
		if(processInfo==null || processInfo.isModified(f.lastModified())){
			processInfo = new ProcessInitialization();
			processInfo.setFilePath(f.getPath());
			processInfo.setProcessId(processId);
			processInfo.setLastModified(f.lastModified());
			processInfo.setMV(isMV);
			
			String prsData = FileUtils.readFileToString(f, "utf-8");
			
			if(isMV){
				prsData = StringUtils.substringBetween(prsData, "<%/**__START_PROCESS_LIST__", "__END_PROCESS_LIST__**%>");
			}
			List<List<JSONObject>> jaProcessGroup = makeProcessGroup(prsData);
			
			
			processInfo.setProcessInfo(jaProcessGroup);
			
			ProcessInitialization.addProcessInfo(processId, processInfo);
		}
		
		return processInfo;
	}
*/	
	/**
	 * 정의된 프로세스의 상세 정보를 파싱하여 구루핑 한다.
	 * @param prsData
	 * @return
	 */
	public static List<List<JSONObject>> makeProcessGroup(String prsData) {
		List<List<JSONObject>> jaProcessGroup = null;
		
		if(prsData==null || StringUtils.isEmpty(prsData.trim())) jaProcessGroup = new JSONArray();
		else{
			prsData = prsData.replaceAll("\r", "");
			prsData = StringUtils.replace(prsData, "\n+", "\\n");
			JSONArray jSONArray = JSONArray.fromObject(prsData);
			if(jSONArray.size()>0){
				Object o = jSONArray.get(0);
				if (o instanceof List) {
					jaProcessGroup = jSONArray;
				}else{
					jaProcessGroup = new ArrayList<List<JSONObject>>();
					jaProcessGroup.add(jSONArray);
				}
			}else{
				jaProcessGroup = new JSONArray();
			}
		}
		
		return jaProcessGroup;
	}

	/**
	 * jsp,js에 정의된 프로세스의 상세 정보를 제공한다.
	 * @param processId
	 * @param isTest
	 * @return
	 * @throws Exception
	 */
/*	@SuppressWarnings("deprecation")
	public static synchronized ProcessInitialization getProcessInfo(String processId, boolean isTest)throws Exception {
				
		ProcessInitialization processInfo = ProcessInitialization.makeProcessInfo(WEB_ROOT + viewResolverPrefix, processId, isTest);
		
		return processInfo;
	}
*/	
}
