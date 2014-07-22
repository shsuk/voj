package net.ion.webapp.controller;


import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.ion.webapp.controller.DefaultAutoController;
import net.ion.webapp.db.CodeUtils;
import net.ion.webapp.db.Lang;
import net.ion.webapp.db.QueryInfo;
import net.ion.webapp.process.ProcessInitialization;
import net.ion.webapp.processor.system.DbProcessor;
import net.ion.webapp.processor.system.List2MapProcessor;
import net.ion.webapp.processor.system.XmlProcessor;
import net.ion.webapp.utils.DbUtils;
import net.sf.json.JSONObject;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.taglibs.standard.functions.Functions;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class ProgramController extends DefaultAutoController {
	protected static final Logger LOGGER = Logger.getLogger(ProgramController.class);
	private static String TEMPLATE_PATH = "WEB-INF/template";
	@RequestMapping(value = "/pgmTL.sh")
	public ModelAndView pgmList(HttpServletRequest request, HttpServletResponse response) throws Exception {
			
		List<Map<String, Object>> tables = DbUtils.getTable(null);

		request.setAttribute("rows", tables);
		return new ModelAndView("admin/menu/table_list");
	}
	@RequestMapping(value = "/devTL.sh")
	public ModelAndView tableList(HttpServletRequest request, HttpServletResponse response) throws Exception {
			
		List<Map<String, Object>> tables = DbUtils.getTable(null);

		request.setAttribute("rows", tables);
		return new ModelAndView(getViewName(request, "admin/pgm/dev_table_list"));
	}
	@RequestMapping(value = "/devTCols.sh")
	public ModelAndView tableColumns(HttpServletRequest request, HttpServletResponse response) throws Exception {
			
		List<Map<String, Object>>  columns = DbUtils.getColumns(null, request.getParameter("table_name"));

		request.setAttribute("rows", columns);
		return new ModelAndView(getViewName(request, "admin/pgm_gui/table_columns"));
	}
	private String getViewName(HttpServletRequest request, String defaultName) {
		String param = request.getParameter("_ps");
		return StringUtils.isEmpty(param) ? defaultName : param;
	}
	@RequestMapping(value = "/loadTpl.sh")
	public ModelAndView loadTpl(HttpServletRequest request, HttpServletResponse response) throws Exception {
			
		String tplPath = request.getRealPath(TEMPLATE_PATH) + "/";
		String tpl_name = sRU.getStringParameter(request, "tpl_name", "tpl_edit_ctl.xml");
		String source = FileUtils.readFileToString(new File(tplPath+tpl_name), "utf-8");
		
		source = Functions.escapeXml(source).replaceAll("\n", "<br>")
			.replaceAll("\t", "&nbsp;&nbsp;&nbsp;&nbsp;")
			.replaceAll("controls", "<font color=\"red\" >controls</font>")
			.replaceAll("control", "<font color=\"red\" >control</font>");
		request.setAttribute("source", source);

		return new ModelAndView("admin/pgm/return_html");
	}

	@RequestMapping(value = "/saveSrc.sh")
	public ModelAndView saveSource(HttpServletRequest request, HttpServletResponse response) throws Exception {
		JSONObject rtn = new JSONObject();
		
		try{
			do{
				String view_name = request.getParameter("view_name")+".jsp";
				String ir1 = request.getParameter("ir1");
				if(StringUtils.isEmpty(ir1)) {
					rtn.put("success", false);
					rtn.put("error_message", "본문 사이즈가 너무 큽니다.");
					break;
				}
				String queryFullPath = ProcessInitialization.getQueryFullPath()+"doc/";
				String viewResolverFullPath = ProcessInitialization.getViewResolverFullPath()+"doc/";
				File tplFile = new File(ProcessInitialization.getViewResolverFullPath(),"admin/pgm_gui/jsp_tpl.jsp");
				String jsp = FileUtils.readFileToString(tplFile, "utf-8");
				jsp = StringUtils.replace( jsp,"$BODY$", ir1);
				
				File file = new File(viewResolverFullPath,view_name);
				FileUtils.writeStringToFile(file, jsp, "utf-8");
				rtn.put("success", true);
			}while(false);
		} catch (Exception e) {
			rtn.put("success", false);
			rtn.put("error_message", e.toString());
		}
		response.getOutputStream().print(rtn.toString());
		return null;
	}
	@RequestMapping(value = "/loadSrc.sh")
	public ModelAndView loadSource(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		try{
			String viewResolverFullPath = "";
			String type = request.getParameter("type");
			String src_name = request.getParameter("src_name");
			//String ir1 = request.getParameter("ir1");
			//String queryFullPath = ProcessInitialization.getQueryFullPath()+"doc/";
			boolean isJsp = "jsp".equals(type);
			
			if(isJsp){
				src_name += ".jsp";
				viewResolverFullPath = ProcessInitialization.getViewResolverFullPath()+"doc/";
			}else{
				src_name += ".sql";
				viewResolverFullPath = ProcessInitialization.getQueryFullPath()+"doc/";
			}
			
			File file = new File(viewResolverFullPath,src_name);
			String src = FileUtils.readFileToString(file, "utf-8");
			
			if(isJsp){
				src = StringUtils.substringBetween(src,"<src>", "</src>");
			}
			
			request.setAttribute("src", src);
		} catch (Exception e) {
			
		}
		return new ModelAndView("admin/pgm_gui/load_src");
	}
	@RequestMapping(value = "/devTC.sh")
	public ModelAndView createQuery(HttpServletRequest request, HttpServletResponse response) throws Exception {
		JSONObject rtn = new JSONObject();
		
		try {
			//Resource
			String tplPath = request.getRealPath(TEMPLATE_PATH);
			String tpl_list = FileUtils.readFileToString(new File(tplPath +  "/tpl_list.sql"));
			String tpl_edit = FileUtils.readFileToString(new File(tplPath +  "/tpl_edit.sql"));

			System.out.println(tpl_list);
			List<Map<String, Object>> tables = DbUtils.getTable(null);
			String target = request.getParameter("path");
			
			for(Map<String, Object> row : tables){
				String tableName = ((String)row.get("table_name"));
				List<Map<String, Object>>  primaryKeys = DbUtils.getPrimaryKeys(null, tableName);
				List<Map<String, Object>>  columns = DbUtils.getColumns(null, tableName);
				//out.println(columns);
				tableName = tableName.toLowerCase();
				
				
				String where = "";
				String read_only = "tmp";
				String pk_where = "";
				String button_search = "";
				String params_update = "";
				String params_insert = "";
				String button_edit = "";
				String pk = "";
				String root = "sm/" + tableName + "/";
				
				(new File(root)).mkdirs();
				
				String _q = root + "edit";
				String key = "";
				int key_seq = 0;
				//기본키 처리
				for(Map<String, Object> fld : primaryKeys){
					String columnName = ((String)fld.get("column_name")).toLowerCase();
					key += "&" + columnName + "=${row." + columnName + "}";

					int seq = Integer.parseInt(fld.get("key_seq").toString());
					
					if(seq > key_seq){
						pk = ((String)fld.get("column_name")).toLowerCase();
					}
					read_only += ", " + columnName;
					pk_where += " and " + columnName + " = @{" + columnName + "}";
					//out.println(fld);
					
					button_search += ", " + columnName + ": 'placeholder=\"" + columnName + "\"'";
					where += "\n\t and " + columnName + " = decode(@{" + columnName + "}, '', " + columnName + ", @{" + columnName + "} ) ";	
				}
				
				int cnt = 0;
				//컬럼 처리
				for(Map<String, Object> col : columns){
					String columnName = (String)col.get("column_name");
					
					if(CodeUtils.getList(columnName)==null){
						columnName = columnName.toLowerCase();
						if(CodeUtils.getList(columnName)==null){
							continue;
						}
					}
					
					button_search += ", " + columnName + ": ''";
					where += "\n\t and decode(@{" + columnName + "}, '', '1', " + columnName + " )  = decode(@{" + columnName + "}, '', '1', @{" + columnName + "} ) ";	
					
					if(cnt<3){
						continue;
					}
					cnt++;
				}
				
				if(button_search.length()>0){
					button_search = button_search.substring(1);
				}
				String sqlList = tpl_list;
				sqlList = sqlList.replaceAll("#id#", tableName)
						.replaceAll("#button_search#", button_search)
						.replaceAll("#pk#", pk)
						.replaceAll("#_q#", _q)
						.replaceAll("#table_name#", tableName)
						.replaceAll("#where#", where);
				sqlList = StringUtils.replace(sqlList,"#key#", key);
				File fl = new File(target + root + "list.sql");
				if(fl.exists()) fl.delete();
				FileUtils.writeStringToFile(fl, sqlList, "utf-8");
				
				String sqlEdit = tpl_edit;
				sqlEdit = sqlEdit.replaceAll("#id#", tableName)
						.replaceAll("#read_only#", read_only)
						.replaceAll("#table_name#", tableName)
						.replaceAll("#pk_where#", pk_where);
				sqlEdit = StringUtils.replace(sqlEdit,"#params_update#", params_update);
				sqlEdit = StringUtils.replace(sqlEdit,"#params_insert#", params_insert);
				sqlEdit = StringUtils.replace(sqlEdit,"#button_edit#", button_edit);
				File fe = new File(target + root + "edit.sql");
				if(fe.exists()) fe.delete();
				FileUtils.writeStringToFile(fe, sqlEdit, "utf-8");
			}
			
			rtn.put("success", true);		
		} catch (Exception e) {
			rtn.put("success", false);
			rtn.put("message", e.toString());
		}
	
		response.getOutputStream().print(rtn.toString());
		return null;
	}

	@RequestMapping(value = "/loadInfo.sh")
	public ModelAndView loadInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
		JSONObject rtn = new JSONObject();
		StringBuffer sb = new StringBuffer();
		
		try {
			String qyery_id = sRU.getStringParameter(request, "qyery_id", "");
			
			Object[] obj = (Object[])DbProcessor.execute(null, qyery_id, new HashMap<String, Object>(), true, false, 0);
			

			Map<String,List<Map<String, Object>>> tableInfo = (Map<String,List<Map<String, Object>>>)obj[1];
			
			for(String key : tableInfo.keySet()){
				List<Map<String, Object>> cols = tableInfo.get(key);
				getClos(sb, cols);
			}
			
		} catch (Exception e) {
			rtn.put("success", false);
			sb.append("Error Message : " + e.toString());
		}

		request.setAttribute("source", sb.toString());

		return new ModelAndView("admin/pgm/return_html");
	}
	private void getClos(StringBuffer sb, List<Map<String, Object>> cols) {
		for(Map<String, Object> col : cols){
			sb.append("<tr><td>").append(col.get("name")).append("</td><td>");
			sb.append("<input class=\"radio\" type=\"radio\" name=\"").append(col.get("name")).append("\" value=\"E\" checked=\"true\"></td><td>");
			sb.append("<input class=\"radio\" type=\"radio\" name=\"").append(col.get("name")).append("\" value=\"R\"></td><td>");
			sb.append("<input class=\"radio\" type=\"radio\" name=\"").append(col.get("name")).append("\" value=\"H\">");
			sb.append("</td></tr>");
		}
	}
	@RequestMapping(value = "/crtPgm.sh")
	public ModelAndView createPgm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		JSONObject rtn = new JSONObject();
	
		try {			
			String target = request.getParameter("path");
			String source = getSource(request);
			File f = new File(target);
			
			if(f.exists()) f.delete();
			
			FileUtils.writeStringToFile(f, source, "utf-8");
			rtn.put("success", true);
		} catch (Exception e) {
			rtn.put("success", false);
			rtn.put("message", e.toString());
		}

		response.getOutputStream().print(rtn.toString());
		return null;
	}
	@RequestMapping(value = "/viewPgm.sh")
	public ModelAndView viewPgm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String source = "";

		try {			
			source = getSource(request);
		} catch (Exception e) {
			logger.error(e.toString(), e);
			source = e.toString();
		}

		request.setAttribute("source", source);

		return new ModelAndView("admin/pgm/return_txt");
	}
	
	private String getSource(HttpServletRequest request) throws Exception  {		
		String resultHtml = "";
		String tplPath = request.getRealPath(TEMPLATE_PATH);
		String tpl_name = sRU.getStringParameter(request, "tpl_name", "tpl_edit_ctl.xml");
		List<Map<String, Object>> tplList = XmlProcessor.read(tplPath + "/" + tpl_name, new String[] {"controls/control/@type", "controls/control/text()"});
		Map<String,Map<String,Object>> tplMap = List2MapProcessor.execute("controls_control_type", tplList);
		String qyery_id = sRU.getStringParameter(request, "qyery_id", "");

		Object[] obj = (Object[])DbProcessor.execute(null, qyery_id, new HashMap<String, Object>(), true, false, 0);	
		Map<String,List<Map<String, Object>>> tableInfo = (Map<String,List<Map<String, Object>>>)obj[1];

		
		String html = (String)tplMap.get("root").get("controls_control");
		String[] tplIds = StringUtils.substringsBetween(html, "#{", "}#");
		
		html = StringUtils.replace(html, "#qyery_id#", qyery_id);
		
		for(String tplId : tplIds){
			if(tplId.indexOf("loop") > -1){
				resultHtml = getLoopSource(tplId, tplMap, tableInfo, request);
			}else if("search".equals(tplId)){
				resultHtml = makeSearch(qyery_id, tplMap);
			}
			
			html = StringUtils.replace(html, "#{"+tplId+"}#", resultHtml);
		}
				
		return html;
	
	}
	
	private String getLoopSource(String tplId, Map<String,Map<String,Object>> tplMap, Map<String,List<Map<String, Object>>> tableInfo, HttpServletRequest request) throws Exception  {
		int idx = 0;
		int fidx = 0;
		
		String sIdx = StringUtils.substringBetween(tplId, "[", "]");
		
		if(StringUtils.isNotEmpty(sIdx)){
			fidx = Integer.parseInt(sIdx);
		}
		
		for(String key : tableInfo.keySet()){
			
			if(fidx!=idx){
				idx++;
				continue;
			}
			
			List<Map<String, Object>> cols = tableInfo.get(key);
			return makeSource(tplId,request, cols, tplMap);
		}
				
		return "";
	
	}
	
	private String makeSource(String loopName, HttpServletRequest request, List<Map<String, Object>> cols, Map<String,Map<String,Object>> tplMap)throws Exception  {
		StringBuffer sb = new StringBuffer();
		StringBuffer hiddenSb = new StringBuffer();
		Map<String,Object> loopInfo = tplMap.get(loopName);
		
		if(loopInfo==null){
			
			return "";
		}
		
		String loopTpl = (String)loopInfo.get("controls_control");
		boolean isFirstTd = false;
		boolean isFirstTdOK = false;
		
		for(Map<String, Object> col : cols){
			String name = (String)col.get("name");
			String type_name = ((String)col.get("type_name")).toLowerCase();
			String precision = col.get("precision").toString();
			String tplKey = type_name;
			String loop = loopTpl;

			String type = sRU.getStringParameter(request, name, "E");
			
			if("R".equals(type)){
				if(CodeUtils.getList(name)!=null){
					tplKey = "r_select";
				}else{
					tplKey = "r_" + type_name;
				}

				if(!isFirstTd){
					isFirstTd = true;
				}
			}else if("H".equals(type)){
				tplKey = "hidden";
				loop = "#value#";
			}else{
				if(CodeUtils.getList(name)!=null){
					Map map = CodeUtils.getCodeInfo("root", name);
					
					if(map!=null){
						String edit_type = (String)map.get("edit_type");					
						tplKey = StringUtils.isEmpty(edit_type) ? "select" : edit_type;					
					}
				}else{
					Map map = CodeUtils.getCodeInfo("code_mapping", name);
					
					if(map!=null){
						String edit_type = (String)map.get("edit_type");					
						tplKey = StringUtils.isEmpty(edit_type) ? "select" : edit_type;
					}else{
						tplKey = type_name;
					}
				}
				
				
				if(!isFirstTd){
					isFirstTd = true;
				}
			}
			
			Map<String, Object> tplInfo = tplMap.get(tplKey);
			if(tplInfo==null){
				tplInfo = tplMap.get("R".equals(type) ? "r_default" : "default");
			}
			String ctlTpl = "\t\t\t\t" + ((String)tplInfo.get("controls_control")).trim();
			if(isFirstTd && !isFirstTdOK){
				ctlTpl += "#hidden#";
				isFirstTdOK = true;
			}
			loop = StringUtils.replace(loop, "#value#", ctlTpl);
			loop = StringUtils.replace(loop, "#label#", Lang.getMessage(name, "kr", name));
			loop = StringUtils.replace(loop, "#name#", name);
			String valid = "0".equals(precision) ? "" : "'maxlen:"+precision+"'";
			loop = StringUtils.replace(loop, "#valid#", valid);

			if("H".equals(type)){
				hiddenSb.append('\n').append(loop.trim());
			}else{
				if(isFirstTd){
					isFirstTd = false;
				}
				sb.append(loop);
			}
		}
		
		String html = StringUtils.replace(sb.toString(), "#hidden#", hiddenSb.toString());
		
		return html;
	}
	private String makeSearch(String queryPath, Map<String,Map<String,Object>> tplMap)throws Exception  {
		QueryInfo queryInfo = QueryInfo.getQuery(queryPath);
		String query = queryInfo.getQueryPropertys().get(0).getOrgQuery();
		String[] params = StringUtils.substringsBetween(query, "@{", "}");
		
		if(params==null) return "";
		
		Map<String,Boolean> serchMap = new HashMap<String,Boolean>();
		serchMap.put("listCount", true);
		serchMap.put("pageNo", true);
		
		StringBuffer sb = new StringBuffer();
		
		for(String param : params){
			if(serchMap.containsKey(param)) continue;
			serchMap.put(param, true);
			String tplKey = "";
			
			if(CodeUtils.getList(param)!=null){
				Map map = CodeUtils.getCodeInfo("root", param);
				
				if(map!=null){
					String edit_type = (String)map.get("edit_type");					
					tplKey = StringUtils.isEmpty(edit_type) ? "search_select" : "search_" + edit_type;					
				}
			}

			Map<String, Object> tplInfo = tplMap.get(tplKey);
			
			if(tplInfo==null){
				tplInfo = tplMap.get("search_default");
			}
			
			if(tplInfo==null) continue;
			
			String ctlTpl =  ((String)tplInfo.get("controls_control")).trim();
			ctlTpl = StringUtils.replace(ctlTpl, "#label#", Lang.getMessage(param, "kr", param));
			ctlTpl = StringUtils.replace(ctlTpl, "#name#", param);
			
			sb.append(ctlTpl).append("\n\t\t\t");
			
		}
		return sb.toString();
	}
}
