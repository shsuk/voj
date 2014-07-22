<%@page import="net.ion.webapp.fleupload.UplInfo"%>
<%@page import="net.ion.webapp.fleupload.UploadMonitor"%>
<%@page import="net.ion.webapp.utils.Aes"%>
<%@page import="net.ion.webapp.processor.ProcessorFactory"%>
<%@page import="net.ion.webapp.process.ReturnValue"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="f" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%
	String file_id = request.getParameter("file_id");
	JSONObject result = new JSONObject();
	UplInfo info = UploadMonitor.getInfo(file_id);
	if(info!=null && info.getPercent()>=100) UploadMonitor.remove(file_id);
	result.put("result", info);
	out.print(result.toString());
%>