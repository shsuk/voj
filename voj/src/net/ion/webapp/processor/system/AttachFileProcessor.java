package net.ion.webapp.processor.system;
import java.io.File;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ion.webapp.exception.IslimException;
import net.ion.webapp.fleupload.Upload;
import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;
import net.ion.webapp.service.ProcessService;
import net.ion.webapp.utils.MimeUtil;

import org.apache.commons.lang.StringUtils;
import org.springframework.security.util.FieldUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Service
public class AttachFileProcessor extends ImplProcessor{

	private static final SimpleDateFormat YYYYMM_FORMAT = new SimpleDateFormat("yyyy_MM");

	/**
	 * 콘트롤명에 fname%1 fname%2와 같이 지정하면 fname의 리스트로 %뒤의 인덱스에 파일을 위치시켜 주고 없는 인덱스는 null로 채워준다.
	 * 인덱스는 1부터 지정한다.
	 * 지정하지 않는 경우 같은 이름은 순차적으로 넣는다.
	 */
	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ReturnValue returnValue = new ReturnValue();
		Map<String, List<Map<String, Object>>> result = new HashMap<String, List<Map<String,Object>>>();

		returnValue.setResult(result);

		if (!(request instanceof MultipartHttpServletRequest) || request.getAttribute("MULTIPART_END") != null) return returnValue;

		request.setAttribute("MULTIPART_END", true);

		Map<String, Object> session = (Map<String, Object>)request.getSession().getAttribute("session");
		String userId = (String)session.get("user_id");

		Object maxSizeO = processInfo.get("maxSize");
		String maxSizeS = maxSizeO==null ? "0" : maxSizeO.toString();
		long maxSize = Long.parseLong(maxSizeS);
		Object allowMimeTypeObj = processInfo.get("mimeType");	
		Object allowExtObj = processInfo.get("ext");
		Object unZip = processInfo.getSourceDate().get("unZip");
		boolean isUnZip = unZip==null ? false : ((Boolean)unZip).booleanValue();
		
		MultipartHttpServletRequest mRequest = (MultipartHttpServletRequest) request;
		
		Iterator<String> it = mRequest.getFileNames();
		
		while (it.hasNext()) {
			int idx = -1;
			String attachId = it.next();
			List<MultipartFile> files = mRequest.getFiles(attachId);
			
			for(MultipartFile file : files){
				long fileSize = file.getSize();
				String fileName = file.getOriginalFilename();
				
				if(fileSize<1) continue;
				
				if(attachId.indexOf('%')>0){
					String[] attachIdInfo = StringUtils.split(attachId, "%");
					
					if(attachIdInfo.length>2) throw new RuntimeException("파일 콘트롤 이름[" + attachId + "]의 형식에 '%' 이 두개 이상 올 수 없습니다.");
					
					idx = Integer.parseInt(attachIdInfo[1]);
					attachId = attachIdInfo[0];
				}

				String ext = StringUtils.substringAfterLast(fileName, ".");
				ext = ext!=null ? ext.toLowerCase() : "";
				if(isUnZip && "zip".equals(ext)){
					File zipFile = File.createTempFile("temp", "zip");
					ZipFile zf = null;
					
					try {
						file.transferTo(zipFile);
						zf = new ZipFile(zipFile);
						
						Enumeration en = zf.entries();
						while(en.hasMoreElements()){
							ZipEntry ze = (ZipEntry)en.nextElement();
							fileName = ze.getName();
							String mimeType = MimeUtil.getRealMimeType(zf.getInputStream(ze), fileName);
							InputStream zis = zf.getInputStream(ze);
							saveAndSetFileInfo(result, attachId, idx, zis, ze.getName(), ze.getSize(), mimeType, allowMimeTypeObj, allowExtObj, maxSize, userId);
						}
					
					} catch (Exception e) {
						// TODO: handle exception
					}finally{
						if(zf!=null){
							try {
								zf.close();
							} catch (Exception e2) {
								// TODO: handle exception
							}
						}
						if(zipFile.exists()){
							zipFile.delete();
						}
					}
				}else{
					String mimeType = MimeUtil.getRealMimeType(file.getInputStream(), fileName);
					InputStream is = file.getInputStream();
					//파일정보를 설정하고 저장소에 파일을 저장한다.
					saveAndSetFileInfo(result, attachId, idx, is, fileName, fileSize, mimeType, allowMimeTypeObj, allowExtObj, maxSize, userId);
				}
			}
		}
		//request의 파일콘트롤 값을 파일 아이디로 치환한다. ParameterMap과 가공된 정보 모두 치환한다.
		//Map<String, String[]> reqParameterMap = mRequest.getParameterMap();
		Map<String, String[]> parameterMap = (Map<String, String[]>)request.getAttribute(ProcessService.REQUEST_REPLACE_PARAMS);
		List<String> attIds = new ArrayList<String>();
		
		for(String key : result.keySet()){
			List<String> values = new ArrayList<String>();
			List<Map<String, Object>> attchFileList = result.get(key);
			
			attIds.add(key);//오류시 롤백을 위해 첨부파일의 필드명을 저장한다.
			
			for(Map<String, Object> map : attchFileList){
				Object o = map.get("fileId");
				String fileId = o==null ? null : o.toString();
				values.add(fileId);
			}
			parameterMap.put(key, values.toArray(new String[0]));
		}
		
		FieldUtils.setProtectedFieldValue("multipartParameters", mRequest, parameterMap);
		request.setAttribute(ProcessService.REQUEST_REPLACE_PARAMS, parameterMap);
		request.setAttribute("__ATT_IDS__", attIds);//오류시 롤백을 위해 첨부파일의 필드명을 저장한다.
		
		return returnValue;
	}
	/**
	 * 파일정보를 설정하고 저장소에 파일을 저장한다.
	 * @param result
	 * @param attachId
	 * @param idx
	 * @param is
	 * @param fileName
	 * @param fileSize
	 * @param allowMimeTypeObj //입력가능 마입타입
	 * @param allowExtObj //입력가능 확장자
	 * @param maxSize
	 * @param userId
	 */
	private void saveAndSetFileInfo(Map<String, List<Map<String, Object>>> result, String attachId, int idx, InputStream is, String fileName, long fileSize, String mimeType, Object allowMimeTypeObj, Object allowExtObj, long maxSize, String userId) throws Exception{
		
		String exts = null;
		String mimeTypes = null;

		String ext = StringUtils.substringAfterLast(fileName, ".");
		ext = ext!=null ? ext.toLowerCase() : "";

		if(maxSize > 0 && maxSize < fileSize){
			String error_message = fileName + " 파일이 업로드 사이즈를 초과 했습니다. Size:"+fileSize;
			throw new IslimException( "max_size", error_message);
		}

		//확장자체크
		if (allowExtObj instanceof Map) {
			Map<String, String> extMap = (Map<String, String>) allowExtObj;
			exts = extMap.get(attachId);
			exts = StringUtils.isEmpty(exts) ? null : exts.toLowerCase();
		}else if(allowExtObj instanceof String){
			exts = allowExtObj.toString().toLowerCase();
		}
		if(exts!=null && exts.indexOf(ext)<0){
			String error_message = fileName + " 파일은 허용되지 않는 확장자 입니다. Ext:"+ext;
			throw new IslimException( "ext", error_message);
		}

		List<Map<String, Object>> attchFileList = result.get(attachId);
		
		if(attchFileList==null){
			attchFileList = new ArrayList<Map<String,Object>>();
			result.put(attachId, attchFileList);
		}
		
		
		
		//마임타입체크
		if (allowMimeTypeObj instanceof Map) {
			Map<String, String> mimeTypeMap = (Map<String, String>) allowMimeTypeObj;
			mimeTypes = mimeTypeMap.get(attachId);
			mimeTypes = StringUtils.isEmpty(mimeTypes) ? null : mimeTypes.toLowerCase();
		}else if(allowMimeTypeObj instanceof String){
			mimeTypes = allowMimeTypeObj.toString().toLowerCase();
		}

		if(mimeTypes!=null && mimeTypes.indexOf(mimeType)<0){
			String error_message = fileName + " 파일은 허용되지 않는 마임타입 입니다. Mime types:"+mimeType;
			throw new IslimException( "mime_type", error_message);
		}

		String fileId = UUID.randomUUID().toString();
		Map<String, Object> fileMap = new HashMap<String, Object>();
		
		Upload.saveFile(fileId, fileName, null, "", userId, is, fileSize, null);
		
		fileMap.put("id", attachId);
		fileMap.put("fileId", fileId);
		fileMap.put("fileName", fileName);
		fileMap.put("ext", ext);
		fileMap.put("size", fileSize);
		
		if(idx<0){
			attchFileList.add(fileMap);
		}else{
			setList(attchFileList, idx, fileMap);
		}
	}
	/**
	 * 인덱스에 파일정보를 채워준다.
	 * @param result
	 * @param idx
	 * @param map
	 */
	private void setList(List<Map<String, Object>> attchFileList, int idx, Map<String, Object> map) {

		if(attchFileList.size()<idx) setList(attchFileList, idx-1, null);
		
		if(attchFileList.size()==idx) attchFileList.add(idx, map);
		else attchFileList.set(idx, map);
	}
	
	private Map<String, Object> makeEmptyFileMap() {
		Map<String, Object> fileMap = new HashMap<String, Object>();
		
		fileMap.put("fileName", "");
		fileMap.put("ext", "");
		fileMap.put("size", 0);
		fileMap.put("root", "");
		fileMap.put("filePath", "");
		return fileMap;		
	}
	
}
