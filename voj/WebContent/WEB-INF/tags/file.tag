<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%><%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ attribute name="name" type="java.lang.String" required="true"%>
<%@ attribute name="value" type="java.lang.String" %>
<%@ attribute name="fileName" type="java.lang.String" %>
<%@ attribute name="valid" type="java.lang.String" %>
<div style="height: 30px;"> 
	<div style="float: left;"><div type="text" readonly="readonly" class="${name}_info"  style=" border:1px solid #AAAAAA; margin-right: 5px;width: 150px;height: 20px;overflow: hidden;"  src="${img_path }"  name="${name}" valid="${valid}" >${fileName }</div></div>
	<div name="${name}" value="${value}" class="attachment" title="파일첨부" end="uploadDefaultEnd"  style="width: 80px;height: 25px;float: left; " img="at.sh?_ps=co/upload/dl&file_id=${value }"></div>
</div>