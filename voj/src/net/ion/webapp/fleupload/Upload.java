package net.ion.webapp.fleupload;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLConnection;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ion.user.session.SessionService;
import net.ion.webapp.adapter.RepositoryAdapter;
import net.ion.webapp.process.ProcessInitialization;
import net.ion.webapp.utils.DbUtils;
import net.ion.webapp.utils.IslimUtils;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.web.bind.ServletRequestUtils;

public class Upload {
	private static final boolean ALLOW_UPLOAD = true;

	public static String getfileId() {
		return UUID.randomUUID().toString();
	}
	public static FileInfo getFile(HttpServletRequest request, HttpServletResponse response) {
		
		FileInfo fi = null;
		UplInfo info = null;
		if ((request.getContentType() == null) || (!request.getContentType().toLowerCase().startsWith("multipart")))
			return fi;

		if (!ALLOW_UPLOAD) {
			request.setAttribute("error", "Upload is forbidden!");
		}

		response.setContentType("text/html");
		HttpMultiPartParser parser = new HttpMultiPartParser();
		boolean error = false;
		try {
			int bstart = request.getContentType().lastIndexOf("oundary=");
			String bound = request.getContentType().substring(bstart + 8);
			int clength = request.getContentLength();
			Hashtable<String, Object> ht = parser.processData(request.getInputStream(), bound, "./", clength);
			
			for(String fileId : ht.keySet()){
				Object o = ht.get(fileId);
				if (o instanceof FileInfo) {
					fi = (FileInfo) o;
				}else{
					continue;
				}
				
				File f = fi.file;
				
				try {
					info = UploadMonitor.getInfo(fi.name);
					if (info != null && info.aborted) {
						request.setAttribute("error", "Upload aborted");
					} else {
						//업로드 파일정보 저장
						String fileName = fi.clientFileName;
						String fileClass = (String)ht.get("file_class");
						String ds = (String)ht.get("ds");
						saveFile(fileId, fileName, fileClass, f, ds, request);
			
						break;
					}
					
				}finally{
					if(f!=null){
						f.delete();
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			
			request.setAttribute("error", e.getMessage());
			error = true;
		}
		if (!error)
			request.setAttribute("message", "File upload correctly finished.");
		
		return fi;
	}
	
	private static void saveFile(String fileId, String fileName, String fileClass, File f, String ds, HttpServletRequest request) throws Exception {

		String refTbl = ServletRequestUtils.getStringParameter(request, "ref_tbl", "etc");
		SessionService.setUserInfoOnRequest(request);
		Map<String, Object> session = (Map<String, Object>)request.getSession().getAttribute("session");
		String userId = (String)session.get("user_id");

		saveFile(fileId, fileName, fileClass, refTbl, userId, f, ds);
	}
	
	
	public static String saveFile(String fileId, String fileName, String fileClass, String refTbl, String userId, InputStream fis, long size, String ds) throws Exception {
		fileId = StringUtils.isEmpty(fileId) ? getfileId() : fileId;
		
		RepositoryAdapter ra = ProcessInitialization.getRepositoryAdapter().newInstance();
		
		ra.save(fileId, fis);
			
		Logger.getLogger(IslimUtils.class).info("저장된 파일 경로 : " + ra.getFullPath());		
		
		insertFileInfo(ra.getVolume(), fileName, ra.getPath(), fileId, fileClass, refTbl, userId, size, ds);
		
		return fileId;
	}
	
	public static String saveFile(String fileId, String fileName, String fileClass, String refTbl, String userId, File f, String ds) throws Exception {
		FileInputStream fis = null;
		
		try {
			fis = new FileInputStream(f);
			
			return saveFile(fileId, fileName, fileClass, refTbl, userId, fis, f.length(), ds);
		}finally{
			try { if(fis!=null) fis.close(); }catch (Exception e) {} 
		}
	}


	public static void deleteFile(String fileId) {
		try {
			RepositoryAdapter ra = ProcessInitialization.getRepositoryAdapter().newInstance();
			ra.setFid(fileId);
			ra.remove();
			
		} catch (Exception e) {
			;
		}
		
	}

	private static void insertFileInfo(String volume, String fileName, String path, String fileId, String fileClass, String refTbl, String userId, long size, String ds) throws Exception {
		Map<String, Object> fileMap = new HashMap<String, Object>();
		
		String ext = StringUtils.substringAfterLast(fileName, ".");
		ext = ext!=null ? ext.toLowerCase() : "";
		
		String filePath = path + fileId;
		
		fileMap.put("fileClass", fileClass);
		fileMap.put("fileId", fileId);
		fileMap.put("mimeType", getMimeType(fileName));
		fileMap.put("fileName", fileName);
		fileMap.put("ext", ext);
		fileMap.put("size", size);
		fileMap.put("root", volume);
		fileMap.put("filePath", filePath);
		fileMap.put("ref_tbl", refTbl);
		fileMap.put("user_id", userId);
		
		DbUtils.update("/system/attach", fileMap, ds);
	}
	
	private static String getMimeType(String fileName) {
		String mimeType = URLConnection.guessContentTypeFromName(fileName);
		if (mimeType == null) {
			if (fileName.endsWith(".doc")) {
				mimeType = "application/msword";
			} else if (fileName.endsWith(".xls")) {
				mimeType = "application/vnd.ms-excel";
			} else if (fileName.endsWith(".ppt")) {
				mimeType = "application/mspowerpoint";
			} else {
				mimeType = "application/octet-stream";
			}
		}
		return mimeType;
	}

	public static String convertFileSize(long size) {
		int divisor = 1;
		String unit = "bytes";
		if (size >= 1024 * 1024) {
			divisor = 1024 * 1024;
			unit = "MB";
		}
		else if (size >= 1024) {
			divisor = 1024;
			unit = "KB";
		}
		if (divisor == 1) return size / divisor + " " + unit;
		String aftercomma = "" + 100 * (size % divisor) / divisor;
		if (aftercomma.length() == 1) aftercomma = "0" + aftercomma;
		return size / divisor + "." + aftercomma + " " + unit;
	}
	
	private static final boolean READ_ONLY = false;
	private static final boolean RESTRICT_BROWSING = false;
	private static final boolean RESTRICT_WHITELIST = false;
	private static final String RESTRICT_PATH = "/etc;/var";
	
	static boolean isAllowed(File path, boolean write) throws IOException{
		if (READ_ONLY && write) return false;
		
		if (RESTRICT_BROWSING) {
			StringTokenizer stk = new StringTokenizer(RESTRICT_PATH, ";");
			while (stk.hasMoreTokens()){
				if (path!=null && path.getCanonicalPath().startsWith(stk.nextToken()))
					return RESTRICT_WHITELIST;
			}
			return !RESTRICT_WHITELIST;
		} else return true;
	}
}
