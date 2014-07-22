package net.ion.user.processor;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.eclipse.jdt.internal.compiler.ast.TryStatement;
import org.springframework.stereotype.Service;

import com.sun.media.jai.codec.FileSeekableStream;

import net.ion.webapp.adapter.RepositoryAdapter;
import net.ion.webapp.db.CodeUtils;
import net.ion.webapp.fleupload.Upload;
import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ProcessInitialization;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;
import net.ion.webapp.utils.IslimUtils;

@Service
public class MainImageConvertProcessor  extends ImplProcessor{
	protected static final Logger logger = Logger.getLogger(MainImageConvertProcessor.class);
	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ReturnValue returnValue = new ReturnValue();
		List<Map<String, String>> resultList = new ArrayList<Map<String,String>>();
		
		String fid = processInfo.getString("src");
		RepositoryAdapter ra = IslimUtils.getRepositoryAdapter(fid);
		File imgSrcFile = new File(ProcessInitialization.getTempDir() + fid + ra.getFileName());
		FileOutputStream fos = null;
		FileSeekableStream fss = null;
		Map<String, Object> session = (Map<String, Object>)request.getSession().getAttribute("session");
		String userId = (String)session.get("user_id");
		
		try {
			fos = new FileOutputStream(imgSrcFile);
			ra.load(fos);
			
			fss = new FileSeekableStream(imgSrcFile);
			List<Map>  list = (List<Map>)CodeUtils.getList("main_image");
			
			for(Map<String, String> row : list){
				String[] wh = row.get("reference_value").split(":");
				
				String fileId = UUID.randomUUID().toString();
				String fileName = fileId + ".png";
				String dest = ProcessInitialization.getTempDir() + fileName;
				ImageConverter ic = new ImageConverter();
				File newFile = new File(dest);
				ic.convert(Float.parseFloat(wh[0]), Float.parseFloat(wh[1]), fss, newFile);
				
				InputStream is = null;
				
				try {
					is = new FileInputStream(newFile);
					Upload.saveFile(fileId, fileName, null, "st_contents_image", userId, is, newFile.length(), null);
					Map<String, String> result = new HashMap<String, String>();
	
					result.put("fid", fileId);
					result.put("name", row.get("code_name"));
					result.put("type", row.get("code_value"));
					
					resultList.add(result);
					
				} finally {
					if(is!=null){
						try {
							is.close();
						} catch (Exception e1) { }
					}
					
					if(newFile.exists()){
						try {
							boolean isDel = newFile.delete();
							System.out.println(isDel);
						} catch (Exception e2) {
							e2.printStackTrace();
						}
					}
				}
			}
			
		} finally{
			if(fos!=null){
				try {
					fos.close();
				} catch (Exception e) { }
			}
			if(fss!=null){
				try {
					fss.close();
				} catch (Exception e) { }
			}
			if(imgSrcFile.exists()){
				try {
					imgSrcFile.delete();
				} catch (Exception e2) {
					e2.printStackTrace();
				}
			}
		}
		

		returnValue.setResult(resultList);
		return returnValue;
	}
	

}

