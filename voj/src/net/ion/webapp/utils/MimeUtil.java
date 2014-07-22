package net.ion.webapp.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.activation.MimetypesFileTypeMap;

import org.apache.commons.lang.StringUtils;
import org.apache.tika.metadata.Metadata;
import org.apache.tika.parser.AutoDetectParser;
import org.apache.tika.parser.Parser;
import org.apache.tika.sax.BodyContentHandler;

/*
 ** --------------------------------------------------------------------------------------------
 ** MimeUtil.class 를 작성하였습니다.
 ** 패키지 경로 : net.ion.plugin.cstore
 ** 
 ** 화일에 대한 MimeType을 분석하는 오른 라이브러리가 몇종류가 됩니다.
 ** 아래의 6종류의 라이브러리들을 위한 테스트코드 작성 및 시험을 하였습니다.
 ** - [MimeType 라이브러리 시험 결과] 
 ** 
 ** 결론적으로 File을 직접 읽어서 분석후 MimeType을 찾기는 어렵습니다.
 ** 이는 MimeType을 지원하지 않는 일부 화일들 때문입니다.
 ** 
 ** 확장성 용이하게 MimeType을 찾을수 방법을 금번에 추가하였습니다.
 ** - MimeType 정의테이블과 확장자명 분석을 통한 Internet media types 결정방법 추가. 
 ** 업무에 참고 하시길 바랍니다. (TB2에 기능 적용 되었습니다)
 ** 
 ** [기준]
 ** 1. 확장이 용이해야 한다.
 ** 2. 가볍고 빨라야 한다.
 ** 
 ** [기능]
 ** 1. Mimetype의 확장 : WEB-INF/classes/META-INF/mime.types 화일에 추가 하시면 됩니다.
 **   - 현재까지 RFC 4288 에 정의된 Internet media types은 모두 정의 하였습니다.(765개)
 **   - 서버의 시동시 activation.jar 라이브러리가 자동으로 읽어들입니다.
 **   - (주의) WebLogic의 경우 META-INF 폴더의 위치.
 **
 ** 2. 파일 확장자명과 자바 기본 라이브러만을 사용하므로 가장 빠르게 처리합니다.
 **   - Using javax.activation.MimetypesFileTypeMap
 **   
 ** 3. 사용방법 (iCafe에서 사용하는 예) : 화일의 확장자명을 통해 MimeType 결정합니다.
 ** import net.ion.plugin.cstore.MimeUtil;
 **	final Id FILE_PATH = new Id("file_path");
 **	FILE file = (FILE) node.get(FILE_PATH) ;
 **	String MimeType = MimeUtil.getMimeType(file.getRealPath());
 **
 ** [MimeType 라이브러리 시험 결과] 
 ** 1. Using javax.activation.MimetypesFileTypeMap
 **   - 화일 확장자를 이용한 MimeType 분석
 ** 2. Using java.net.URL (엄청느림)
 ** 3. Using Apache Tika (대용량 라이브러리 24.5M, 아직 개발중)
 **   - docx, xlsx, pptx 등의 화일 Access시 Exception 처리됨.
 **   - 처리 속도 느림
 ** 4. Using JMimeMagic
 **   - 분석하지 못하는 MimeType 다수 존재함.
 ** 5. Using mime-util
 **   - 분석하지 못하는 MimeType 다수 존재함.
 ** 6. Using FileMainService (iCafe)
 **   - 확장자 분석 방식 사용
 ** --------------------------------------------------------------------------------------------
 */

public class MimeUtil {

	// 화일명의 확장자 가져오기
	public static String getFileExt(final String fileName) {
		return StringUtils.substringAfterLast(fileName, ".").toLowerCase();
	}

	// 1. 확장자 명으로 MimeType 찾기 : WEB-INF/classes/META-INF/mime.types
	public static String getMimeType(final String filePath) {
		return (new MimetypesFileTypeMap().getContentType(new File(filePath)));
	}

	// 1. Magic Code를 지원하는 화일의 경우, 파일내의 정보를 통해 MimeType 결정.
	// - 예 : 이미지 화일, ZIP화일의 경우는 MimeType정보가 화일내에 있음.
	public static String getRealMimeType(final String filePath) {

		String mimeType = null;
		FileInputStream is = null;
		
		try {
			File f = new File(filePath);
			is = new FileInputStream(f);
			mimeType = getRealMimeType(is, f.getName());
		} catch (Throwable e) { }
		finally {
			if (is != null) {
				try { is.close(); }
				catch (IOException e) {}
				finally {}
			}
		}
		if(mimeType == null)
			mimeType = "Unknown MimeType";
		return mimeType;
	}
	public static String getRealMimeType(InputStream is, String name) {

		String mimeType = null;
		try {
			
			BodyContentHandler contenthandler = new BodyContentHandler();
			Metadata metadata = new Metadata();
			metadata.set(Metadata.RESOURCE_NAME_KEY, name);
			Parser parser = new AutoDetectParser();
			parser.parse(is, contenthandler, metadata, null);	
			mimeType = metadata.get(Metadata.CONTENT_TYPE);
		} catch (Exception e) {
			// TODO: handle exception
		}

		if(mimeType == null){
			mimeType = "Unknown MimeType";
		}
		return mimeType;
	}

}