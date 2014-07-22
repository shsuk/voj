<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="job"  tagdir="/WEB-INF/tags/job" %> 
<%@ taglib prefix="jobu"  tagdir="/WEB-INF/tags/job/user" %> 
<%@ taglib prefix="tpu"  tagdir="/WEB-INF/tags/user" %> 

<uf:organism >[
	<job:mailRcv  id="rows" receivedTime="600" user="shsuk@i-on.net" port="10004" searchSubject="프로젝트" host="smtp.i-on.net" searchFrom="b@i-on.net" pwd="ssh8720" isReturn="false" />
	<jobu:syncBillCode  id="project" groupId="project" src="rows"/>
	<job:mailRcv  id="rows" receivedTime="600"  user="shsuk@i-on.net" port="10004" searchSubject="계정" host="smtp.i-on.net" searchFrom="b@i-on.net" pwd="ssh8720" isReturn="false"/>
	<jobu:syncBillCode id="account" groupId="account" src="rows"/>
]</uf:organism>
${JSON}