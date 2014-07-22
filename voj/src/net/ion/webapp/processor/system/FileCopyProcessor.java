package net.ion.webapp.processor.system;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ProcessInitialization;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.springframework.stereotype.Service;

@Service
public class FileCopyProcessor  extends ImplProcessor {

	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ReturnValue returnValue = new ReturnValue();

		returnValue.setResult(false);

		String source = processInfo.getString("source");
		
		if(source.endsWith("/") || source.endsWith("\\") || source.indexOf("..")>-1){
			throw new IOException("source에 ../ 값이 오거나, '/' 또는 '\\'로 끝날 수 없습니다.");
		}
		
		String target = processInfo.getString("target");
		boolean isDelete = processInfo.getBooleanValue("isDelete", false);

		File src = new File(source);
		File dest = new File(target);
		
		copy(src, dest, isDelete);
		
		returnValue.setResult(true);
		return returnValue;
	}
	private void copy(File src, File dest, boolean isDelete)throws IOException {
		if(isDelete && dest.exists()){
			if(dest.isDirectory()){
				FileUtils.deleteDirectory(dest);
			}else{
				dest.delete();
			}
		}

		if(src.isDirectory()){
			FileUtils.copyDirectory(src, dest);
		}else{
			FileUtils.copyFile(src, dest);
		}
	}
}
