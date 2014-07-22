package net.ion.webapp.utils;

import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLConnection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import net.ion.user.session.SessionService;
import net.ion.webapp.adapter.RepositoryAdapter;
import net.ion.webapp.db.CodeUtils;
import net.ion.webapp.fleupload.Upload;
import net.ion.webapp.process.ProcessInitialization;
import net.ion.webapp.processor.system.FileReadProcessor;
import net.ion.webapp.processor.system.XmlProcessor;
import net.ion.webapp.service.ProcessService;

public class IslimUtils {
	public static CodeUtils code;
	public static DbUtils db;
	public static FileReadProcessor fileRead;
	public static XmlProcessor xml;
	public static JobLogger jobLogger;
	public static ProcessInitialization processInitialization;
	public static ProcessService processService;
	public static SessionService sessionService;
	public static Upload upload;
	//저장소에 저장하거나 삭제한다. 
	//TODO public static Repository repository;
	
	public static RepositoryAdapter getRepositoryAdapter(String fid)throws Exception {
		RepositoryAdapter ra = ProcessInitialization.getRepositoryAdapter().newInstance();
		ra.setFid(fid);
		return ra;
	}
	public static void loadRepository(String fid, OutputStream os)throws Exception {
		RepositoryAdapter ra = ProcessInitialization.getRepositoryAdapter().newInstance();
		ra.setFid(fid);
		ra.load(os);
	}

	/**
	 * 휘발성 다운로드용 파일아이디
	 * @param fileId
	 * @return
	 * @throws Exception
	 */
	public static String getFileId(String fileId, String userId)throws Exception {
		String uuid = UUID.randomUUID().toString();
		Map<String, Object> sourceDate = new HashMap<String, Object>();
		sourceDate.put("file_id", fileId);
		sourceDate.put("user_id", userId);
		sourceDate.put("uuid", uuid);
		DbUtils.update("", sourceDate);
		return uuid;
	}
	public static String getOrgFileId(String fileId, String userId)throws Exception {
		Map<String, Object> sourceDate = new HashMap<String, Object>();
		sourceDate.put("file_id", fileId);
		sourceDate.put("user_id", userId);
		String orgFileId = (String)DbUtils.select("", sourceDate).get(0).get("file_id");
		return orgFileId;
	}
	
	
	public static String getFileName(String fileId)throws Exception {
		if(StringUtils.isEmpty(fileId)) {
			return "";
		}
		Map<String, Object> sourceDate = new HashMap<String, Object>();
		sourceDate.put("file_id", fileId);
		
		List<LowerCaseMap<String, Object>> list = DbUtils.select("system/attach/selectbyid", sourceDate);
		if(list.size() < 1){
			return "";
		}
		String fileName = (String)list.get(0).get("file_name");
		return fileName;
	}
	
	public static void main(String[] args) throws Exception {
System.out.println( (Math.floor(Math.random() *100) % 2)) ;
	}
}
