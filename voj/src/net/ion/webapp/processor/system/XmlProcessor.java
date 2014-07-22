package net.ion.webapp.processor.system;

import java.io.File;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.sun.org.apache.xml.internal.dtm.DTMIterator;
import com.sun.org.apache.xml.internal.dtm.ref.DTMNodeList;

import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;

@Service
public class XmlProcessor extends ImplProcessor{

	/**
	 * 소스
	 * 	<uf:job id="xml" jobId="xml"  singleRow="false">
	 *		src: 'd:/temp/test.xml',
	 *		xpath:['/result/meta/author/text()','/result/meta/author/@val', '/result/meta/subj/text()']
	 *	</uf:job>
	 *
	 *결과
	 * {"xml":[
	 * 		{"result_meta_subj":"subj1","result_meta_author":"author1","result_meta_author_val":"dsfdsf"},
	 * 		{"result_meta_subj":"subj2","result_meta_author":"author2","result_meta_author_val":"dsfdsf"},
	 * 		{"result_meta_subj":"subj3","result_meta_author":"author3","result_meta_author_val":"dsfdsf"}
	 * }]
	 * 
	 * 참고
	 * XPath로 접근한 노드의 갯수가 불일치 하면 오류를 발생 시킨다. 
	 * 단 노드의 수가 1개이면 다른 레코드에 동일 값으로 채운다. 
	 * 노드갯수가 1개인 XPath를 많은 노드의 XPath보다 뒤에 놓아야 한다.
	 */
	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ReturnValue returnValue = new ReturnValue();

		String src = processInfo.getString("src");
		boolean singleRow = processInfo.getBooleanValue("singleRow",false);
		List<String> paths = (List<String>)processInfo.get("xpath"); //{ "/result/source/width", "/result/source/vbitrate", };

		List<Map<String, Object>> list = read(src, paths);
		
		returnValue.setResult(singleRow ? (list.size()>0 ? list.get(0) : new HashMap<String, Object>()) : list);
				
		return returnValue;
	}
	
	public static List<Map<String, Object>> read(InputStream is, List<String> xPaths) throws Exception {
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		factory.setNamespaceAware(true);
		DocumentBuilder builder = factory.newDocumentBuilder();
		Document xmlDoc = builder.parse(is); 
		
		return read(xmlDoc, xPaths);
	}
	
	public static List<Map<String, Object>> read(String path, String[] xPaths) throws Exception {
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		factory.setNamespaceAware(true);
		DocumentBuilder builder = factory.newDocumentBuilder();
		Document xmlDoc = builder.parse(new File(path)); 
		
		return read(xmlDoc, xPaths);
	}
	public static List<Map<String, Object>> read(String path, List<String> xPaths) throws Exception {
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		factory.setNamespaceAware(true);
		DocumentBuilder builder = factory.newDocumentBuilder();
		Document xmlDoc = builder.parse(new File(path)); 
		
		return read(xmlDoc, xPaths);
	}
		
	public static List<Map<String, Object>> read(Document xmlDoc, List<String> xPaths) throws Exception {
		return read(xmlDoc, (String[])xPaths.toArray());
		
	}
	public static List<Map<String, Object>> read(Document xmlDoc, String[] xPaths) throws Exception {

		XPathFactory xPathFactory = XPathFactory.newInstance();
		XPath xPath = xPathFactory.newXPath();

		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		

		for (String path : xPaths) {
			XPathExpression expr = xPath.compile(path);
			
			NodeList nodes = (NodeList)expr.evaluate(xmlDoc, XPathConstants.NODESET);
			String newPath = StringUtils.replace(path, "/text()", "").replaceAll("@", "").replace('/', '_');
			newPath = newPath.startsWith("_") ? newPath.substring(1) : newPath;
			String val =  "";
			
			for(int i=0; i<nodes.getLength(); i++){
				Node node = nodes.item(i);

				if(list.size()<=i) {
					list.add(new HashMap<String, Object>());
				}
				Map<String, Object> data = list.get(i);
				val =  node.getNodeValue();
				data.put(newPath, val);
			}
			//없는 패스의 값을 마지막 노드의 값으로 채워 필드 갯수를 맞춘다.
			if(nodes.getLength() != list.size()){
				if(nodes.getLength()==1){
					for(int i=1; i<list.size(); i++){
						Map<String, Object> data = list.get(i);
						data.put(newPath, val);
					}
				}else{
	            	throw new Exception((new StringBuffer("XML 데이타 갯수 불일치 : path=")).append(path).append(" 갯수 : ").append(nodes.getLength()).append(" != ").append(list.size()).toString());
				}
			}
		}
		
		return list;
	}
}
