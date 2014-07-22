<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%>
<%@ taglib prefix="tp"  tagdir="/WEB-INF/tags" %> 

<uf:organism >[
	<uf:job id="trn" jobId="mail" >
		host: 'smtp.i-on.net',
		port: '443',
		from: 'shsuk@i-on.net',
		to: 'b@i-on.net',
		subject: '계정',
		body: '계정',
		authenticate: false
	</uf:job>
	<uf:job id="trn" jobId="mail" >
		host: 'smtp.i-on.net',
		port: '443',
		from: 'shsuk@i-on.net',
		to: 'b@i-on.net',
		subject: '프로젝트',
		body: '프로젝트',
		authenticate: false
	</uf:job>
]</uf:organism>
${JSON }
