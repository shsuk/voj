<%@page import="net.ion.webapp.utils.ParamUtils"%>
<%@page import="net.ion.webapp.fleupload.FileInfo"%>
<%@page import="net.ion.webapp.fleupload.Upload"%>
<%@page import="net.ion.webapp.utils.Aes"%>
<%@page import="net.ion.webapp.processor.ProcessorFactory"%>
<%@page import="net.ion.webapp.process.ReturnValue"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%
	FileInfo fi = Upload.getFile(request, response);
	
%>
<%=fi.clientFileName%>
<%=fi.name%>
<%=fi.file.length()%>