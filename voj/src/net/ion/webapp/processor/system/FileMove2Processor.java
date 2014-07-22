package net.ion.webapp.processor.system;

import java.io.File;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;

import org.apache.commons.io.FileUtils;
import org.springframework.stereotype.Service;
/**
 * FileMoveProcessor와 차이점은 물리적으로 파일을 복사한 후 지우는 방식으로 처리한다.
 * @author shsuk
 *
 */
@Service
public class FileMove2Processor  extends ImplProcessor {

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
		
		move(src, dest, isDelete);
		
		returnValue.setResult(true);
		return returnValue;
	}
	
	private void move(File src, File dest, boolean isDelete)throws IOException {
		if(isDelete && dest.exists()){
			if(dest.isDirectory()){
				FileUtils.deleteDirectory(dest);
			}else{
				dest.delete();
			}
		}

		if(src.isDirectory()){
			FileUtils.copyDirectory(src, dest);
			FileUtils.deleteDirectory(src);
		}else{
			FileUtils.copyFile(src, dest);
			src.delete();
		}
	}
	
	public static void main(String[] args) throws IOException {
		FileMove2Processor fM = new FileMove2Processor();
		//FileUtils.moveDirectoryToDirectory(new File("c:/temp1"), new File("c:/temp2"), true);
		fM.move(new File("C:/temp/쉐어박스1"), new File("C:/temp/쉐어박스2"), false);
	}
}
