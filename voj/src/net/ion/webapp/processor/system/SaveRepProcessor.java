package net.ion.webapp.processor.system;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ion.user.session.SessionService;
import net.ion.webapp.fleupload.Upload;
import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ProcessInitialization;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;
import net.ion.webapp.processor.ProcessorFactory;
import net.ion.webapp.utils.DbUtils;
import net.ion.webapp.utils.LowerCaseMap;
import net.sf.json.JSONObject;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.ServletRequestUtils;

@Service
public class SaveRepProcessor  extends ImplProcessor {

	/**
	 * path에 있는 파일을 저장소에 저장한다.
	 */
	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ReturnValue returnValue = new ReturnValue();
		returnValue.setResult(false);

		String path = processInfo.getString("path");
		String fileClass = processInfo.getString("fileClass");
		String endsWith = processInfo.getString("endsWith");
		boolean isEndsWith = StringUtils.isNotEmpty(endsWith);
		String startsWith = processInfo.getString("startsWith");
		boolean isStartsWith = StringUtils.isNotEmpty(startsWith);
		boolean isImage = processInfo.getBooleanValue("isImage", false);
		
		File[] fs = (new File(path)).listFiles();
		
		for(File f : fs){
			String fileName = f.getName();
			
			if(isEndsWith && !StringUtils.endsWithIgnoreCase(fileName, endsWith)) continue;
			if(isStartsWith && !StringUtils.endsWithIgnoreCase(fileName, startsWith)) continue;
			
			String refTbl = ServletRequestUtils.getStringParameter(request, "ref_tbl", "etc");
			SessionService.setUserInfoOnRequest(request);
			Map<String, Object> session = (Map<String, Object>)request.getSession().getAttribute("session");
			String userId = (String)session.get("user_id");
			
			String file_id = Upload.saveFile(null, fileName, fileClass, refTbl, userId, f, processInfo.getString("ds"));
			
			processInfo.getProcessDetail().put("jobId", "db");
			Map<String, Object> sourceDate = processInfo.getSourceDate();
			sourceDate.put("file_id", file_id);
			sourceDate.put("file_nm", fileName);
			
			if(isImage){
				setImage(f, sourceDate);
			}
			ProcessorFactory.exec(processInfo.getProcessDetail(), sourceDate, request, response, processInfo.isTest(), processInfo.isDebug());
		}
		
		returnValue.setResult(true);
		return returnValue;
	}
	private void setImage(File f, Map<String, Object> sourceDate) throws Exception {

		FileInputStream is = null;
		try {
			is = new FileInputStream(f);
			BufferedImage inImage = ImageIO.read(is);
			sourceDate.put("img_width", Integer.toString(inImage.getWidth()));
			sourceDate.put("img_height", Integer.toString(inImage.getHeight()));
		} catch (Exception e) {
			sourceDate.put("img_width", 0);
			sourceDate.put("img_height", 0);
		}finally{
			if(is != null){
				try {
					is.close();
				} catch (Exception e2) {}
			}
		}
	}
}
