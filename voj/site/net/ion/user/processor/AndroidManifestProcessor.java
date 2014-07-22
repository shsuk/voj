package net.ion.user.processor;

import java.io.File;
import java.io.FileOutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import net.ion.webapp.adapter.RepositoryAdapter;
import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ProcessInitialization;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;
import net.ion.webapp.processor.system.XmlProcessor;
import net.ion.webapp.utils.ApkExtractorUtil;
import net.ion.webapp.utils.IslimUtils;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.Namespace;
import org.jdom.input.SAXBuilder;
import org.jdom.output.JDOMLocator;
import org.springframework.stereotype.Service;

import com.sun.org.apache.xerces.internal.dom.DeferredElementNSImpl;

@Service
public class AndroidManifestProcessor  extends ImplProcessor {

	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		boolean isSuccess = false;
		Exception ex = new Exception();
		FileOutputStream fos = null;
		String fid = processInfo.getString("src");
		
		
		String path = ProcessInitialization.getTempDir() + fid + ".apk";
		File f = new File(path);
		//String manifestPath =  "./" + fid + ".xml";
		String manifestPath = ProcessInitialization.getTempDir() + fid + ".xml";
		File manifestFile = new File(manifestPath);
		ReturnValue returnValue = new ReturnValue();
		returnValue.setResult(false);

		RepositoryAdapter ra = ProcessInitialization.getRepositoryAdapter().newInstance();
		//업로드 완료 후 저장소에 저장되기 전 호출되므로 아직 저장소에 저장이 안될 수 있기 때문에 1초 간격으로 30초 가량 재시도 한다.
		for(int i=0; i<30;i++){
			try {
				ra.setFid(fid);
				fos = new FileOutputStream(f);

				ra.load(fos);
				// manifest 파일 추출
				ApkExtractorUtil aex = new ApkExtractorUtil();
				aex.extract(path, manifestPath);
				// manifest 파일에서 데이타 추출
				Map<String, Object> dataList = read(manifestPath);
				
				if(dataList.size()>0){
					returnValue.setResult(dataList);
				}
				isSuccess = true;
				break;
			}catch (Exception e) {
				System.out.println(i);
				ex = e;
			} finally{
				if(fos!=null){
					try {
						fos.close();
					} catch (Exception e) { }
				}
				if(f.exists()){
					f.delete();
				}
				if(manifestFile.exists()){
					//manifestFile.delete();
				}
			}
			Thread.sleep(1000);
		}
		
		if(!isSuccess){
			throw ex;
		}
		return returnValue;
	}
	private Map<String, Object> read(String path)throws Exception{
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		factory.setNamespaceAware(true);
		SAXBuilder builder = new SAXBuilder();
		Document xmlDoc = builder.build(new File(path)); 
		Map<String, Object> data = new HashMap<String, Object>();

		Namespace ns = Namespace.getNamespace("android", "http://schemas.android.com/apk/res/android");

		Element el = xmlDoc.getRootElement();
		
		data.put("package", el.getAttributeValue("package"));
		data.put("versionCode", el.getAttributeValue("versionCode", ns));
		data.put("versionName", el.getAttributeValue("versionName", ns));

		Element el1 = el.getChild("uses-sdk");
		if(el1!=null){
			data.put("minSdkVersion", el1.getAttributeValue("minSdkVersion", ns));
			data.put("maxSdkVersion", el1.getAttributeValue("maxSdkVersion", ns));
		}
		el1 = el.getChild("supports-screens");
		if(el1!=null){
			data.put("smallScreens", el1.getAttributeValue("smallScreens", ns));
			data.put("normalScreens", el1.getAttributeValue("normalScreens", ns));
			data.put("largeScreens", el1.getAttributeValue("largeScreens", ns));
			data.put("xlargeScreens", el1.getAttributeValue("xlargeScreens", ns));
	
			data.put("resizeable", el1.getAttributeValue("resizeable", ns));
			data.put("anyDensity", el1.getAttributeValue("anyDensity", ns));
		}
		return data;
	}
}
