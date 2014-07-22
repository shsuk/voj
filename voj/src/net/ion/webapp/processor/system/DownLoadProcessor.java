package net.ion.webapp.processor.system;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ion.webapp.adapter.RepositoryAdapter;
import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ProcessInitialization;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;
import net.ion.webapp.utils.IslimUtils;
import net.ion.webapp.utils.ParamUtils;
import net.ion.webapp.utils.Thumbnail;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

@Service
public class DownLoadProcessor  extends ImplProcessor {
	private boolean isRun = false;
	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ReturnValue returnValue = new ReturnValue();
		//Map<String, List<Map<String, Object>>> result = new HashMap<String, List<Map<String, Object>>>();

		returnValue.setResult(true);

		String fileName;
		String fid = processInfo.getString("fid");
		String thum = request.getParameter("thum");
		long size = 0;//processInfo.getString("size");
		RepositoryAdapter ra = null;
		
		try {
			ra = IslimUtils.getRepositoryAdapter(fid);
			fileName = ra.getFileName();
			size = ra.getFileSize();
		} catch (Exception e) {
			return returnValue;
		}

		InputStream is = null;

		fileName = (String) ParamUtils.getReplaceValue(fileName, processInfo.getSourceDate());
		String fileId = request.getParameter("file_id");

		if(StringUtils.isEmpty(fileId)){
			return returnValue;
		}
		OutputStream out = null;
		
		try {
			out = response.getOutputStream();
			String ext = fileName.substring(fileName.lastIndexOf('.')).toLowerCase();

			if(StringUtils.isNotEmpty(thum) && !".png".equals(ext)){
				try {
					if(isRun){
						for(int i=0;i<10;i++){
							wait(1000);
							if(!isRun){
								break;
							}
						}					
					}
					
					isRun = true;
					ByteArrayOutputStream bufOs = new ByteArrayOutputStream();
					ra.load(bufOs);
					is = getThumnail(new ByteArrayInputStream(bufOs.toByteArray()), thum, fileName, fileId, ext);
					writeHeader(response, request, fileName, 0);
					
					IOUtils.copyLarge(is, out);
				
				} catch (Exception e) {
					// TODO: handle exception
				}finally{
					isRun = false;
				}
			}else{
				writeHeader(response, request, fileName, size);
				try {
					ra.load(out);
				} catch (Exception e) {
					response.setHeader("Content-Length", String.valueOf(0));
					throw e;
				}
			}
			
			out.flush();
		}finally{
			if (out != null){
				try {
					out.close();
				} catch (Exception e) { }
			}
			if(is!=null){
				try {
					is.close();
				} catch (Exception e) { }
			}
		}
		return returnValue;
	}

	private InputStream getThumnail(InputStream is, String thum, String fileName, String fileId, String ext) throws Exception{
		
		String thumPath = ProcessInitialization.getWebRoot() + "/thum/" + thum + "/" + fileId.substring(0, 4)  + "/";
		File destFile = new File(thumPath);
		if(!destFile.exists()) destFile.mkdirs();
		
		thumPath += fileId + ".jpg";
		
		 destFile = new File(thumPath);
		
		if(!destFile.exists()){
			if(!Thumbnail.createThumbnail(is, thumPath, Integer.parseInt(thum), ext)){
				return is;
			}
		}
		return new FileInputStream(destFile);

	}
	public void writeHeader(HttpServletResponse response, HttpServletRequest request, String filename, long size) throws Exception {
		response.setContentType("application/octet-stream; charset=utf-8");
		response.setHeader("Content-Disposition", getDisposition(filename, getBrowser(request)));
		response.setCharacterEncoding("utf-8");
		
		response.setHeader("Content-Transfer-Encoding", "binary"); 
		if (size > 0) response.setHeader("Content-Length", String.valueOf(size));		
	}
	


	private String getBrowser(HttpServletRequest request) {

		String header = request.getHeader("User-Agent");

		if (header.indexOf("MSIE") > -1) return "MSIE";
		else if (header.indexOf("Chrome") > -1) return "Chrome";
		else if (header.indexOf("Opera") > -1) return "Opera";
		
		return "Firefox";

	}

	/**
	 * 
	 * �ٱ��� ���ϸ� ó��
	 * 
	 * @param filename
	 * 
	 * @param browser
	 * 
	 * @return
	 * 
	 * @throws UnsupportedEncodingException
	 */

	private String getDisposition(String filename, String browser) throws Exception {

		String dispositionPrefix = "attachment;filename=";

		String encodedFilename = null;

		if (browser.equals("MSIE")) {
			encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
		} else if (browser.equals("Firefox")) {
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Opera")) {
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Chrome")) {
			StringBuffer sb = new StringBuffer();

			for (int i = 0; i < filename.length(); i++) {
				char c = filename.charAt(i);

				if (c > '~') sb.append(URLEncoder.encode("" + c, "UTF-8"));
				else sb.append(c);
			}

			encodedFilename = sb.toString();
		} else {
			encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
		}

		return dispositionPrefix + encodedFilename;
	}
	
	private void setList(List<Map<String, Object>> result, int idx,
			Map<String, Object> map) {
		// if(result.size()<idx) setList(result, idx-1, makeEmptyFileMap());
		if (result.size() < idx)
			setList(result, idx - 1, null);

		if (result.size() == idx)
			result.add(idx, map);
		else
			result.set(idx, map);
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
