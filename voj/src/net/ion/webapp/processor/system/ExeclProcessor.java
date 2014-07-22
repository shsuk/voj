package net.ion.webapp.processor.system;

import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ion.webapp.db.CodeUtils;
import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;
import net.ion.webapp.utils.Excel;
import net.ion.webapp.utils.ParamUtils;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.springframework.stereotype.Service;

@Service
public class ExeclProcessor  extends ImplProcessor{
	
	/**
	 * ['id','name','align',width,'format']
	 *
	 * {
	 *	id:'els', jobId:'execl', src="rows", fileName="review_all_@{start_date}_@{end_date}.xls", titleName="@{&review_all_report,리뷰전체현황}",
	 *	skip:'${"@{type}"=="excel" ? false : true}',
	 *	header:[
	 *		['nid','ID','center',20],
	 *		['contents_nm', '@{&contents_nm,상품명}','',30],
	 *		['app_ver', '@{&app_ver,버전정보}','center',30],
	 *		['registed', '@{&registed,등록일}','center',20,'yyyy-mm-dd'],
	 *		['review_msg', '@{&review_msg,내용}','',60]
	 *	]
	 * }
	 */
	public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			String fileName = processInfo.getString("fileName");
			String titleName = processInfo.getString("titleName");
			String src = processInfo.getString("src");
			List<List<Object>> header = (List<List<Object>>)processInfo.get("header");
			List<Map<String, Object>> list = (List<Map<String, Object>>)processInfo.getData(src);
			
			Excel excel = write(titleName,list, header, processInfo.getSourceDate());
			writeFile(response, request, fileName, excel);
		} catch (Exception e) {
			throw new RuntimeException(e.toString(), e);
		}

		ReturnValue returnValue = new ReturnValue();
		returnValue.setResult(true);		
		return returnValue;
	}
	
	private void writeFile(HttpServletResponse response, HttpServletRequest request, String filename, Excel excel) throws Exception {
		if (excel == null) return;
		
		String CHARSET = "UTF-8";
		
		response.setContentType("application/octet-stream; charset=utf-8");
		response.setHeader("Content-Disposition", getDisposition(filename, getBrowser(request)));
		response.setCharacterEncoding(CHARSET);
		
		response.setHeader("Content-Transfer-Encoding", "binary"); 
		excel.write(response);
	}
	private Excel write(String titleName,List<Map<String, Object>> list, List<List<Object>> header, Map<String, Object> sourceDate) {		
		Excel xls = new Excel("Sheet1");
		xls.addMergedRegion(0,0,0,header.size()-1);
		xls.addCell(0, 0, titleName, HSSFCellStyle.ALIGN_CENTER,15, -1, true, true,false);
		//xls.addCell(0, 0, "test", HSSFCellStyle.ALIGN_CENTER, 15, -1, true,false,false,"" , false);
		//
		for (int j=0; j<header.size(); j++) {
			List<Object> h = header.get(j);
			int width = -1;
			if(h.size()>3){
				Integer w = (Integer)h.get(3);
				width = w.intValue();
			}
			xls.addCell(1, j, ParamUtils.getReplaceValue(h.get(1).toString(), sourceDate) , HSSFCellStyle.ALIGN_CENTER,11, width,false ,true,true);
		}

		for (int i=0; i<list.size(); i++) {
	    	Map<String, Object> row = list.get(i);
			for (int j=0; j<header.size(); j++) {
				List<Object> h = header.get(j);
				Object val = row.get((String)h.get(0));
				if (val instanceof String) {
					String v = (String) val;
					try {
						val = CodeUtils.getNameAuto((String)h.get(0), v, "");
					} catch (Exception e) {}
					
				}
				short align = HSSFCellStyle.ALIGN_LEFT;
				if(h.size()>2){
					String al = (String)h.get(2);
					if("center".equals(al.toLowerCase())){
						align = HSSFCellStyle.ALIGN_CENTER;
					}else if("right".equals(al.toLowerCase())){
						align = HSSFCellStyle.ALIGN_RIGHT;
					}
				}
				String format = "";
				if(h.size()>4){
					format = (String)h.get(4);
				}
				int width = -1;
				if(h.size()>3){
					Integer w = (Integer)h.get(3);
					width = w.intValue();
				}
				if(StringUtils.isNotEmpty(format)){
					xls.addCell(i+2, j, val, align,11, width,false, true, false,format);
				}else{
					xls.addCell(i+2, j, val, align,11, width,false, true, false);
				}
			}
		}

	    return xls;

	}
	private String getBrowser(HttpServletRequest request) {

		String header = request.getHeader("User-Agent");

		if (header.indexOf("MSIE") > -1) return "MSIE";
		else if (header.indexOf("Chrome") > -1) return "Chrome";
		else if (header.indexOf("Opera") > -1) return "Opera";
		
		return "Firefox";

	}
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
	
}
