<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%><%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ attribute name="name" type="java.lang.String" required="true"%>
<%@ attribute name="value" type="java.lang.String" %>
<%@ attribute name="imgPath" type="java.lang.String" %>
<%@ attribute name="valid" type="java.lang.String" %>
<c:set var="imgPath">images/bg_img.png</c:set>
<c:if test="${!empty(value)}"><c:set var="imgPath">at.sh?_ps=at/upload/dl&file_id=${value}</c:set></c:if>
<div style="height: 72px;width: 200px;float: left;border:1px solid #B6B5DB;margin: 1px;background: #D9E5FF;">
	<div style="float: left;"><img class="${name}_info"  style="float: left;height:60px;max-width:100px;;border:1px solid #AAAAAA;overflow:hidden; cursor: pointer;margin: 5px;"  src="${imgPath }"  name="${name}" valid="${valid}" onclick="showImg('${value }', this.src);"/></div>
	<div name="${name}" value="${value}" class="attachment" " title="사진" end="uploadDefaultEnd"  style="width: 80px;height:40px;float: right;margin-top:15px; margin-right: 5px; " img="at.sh?_ps=co/upload/dl&file_id=${value }"></div>
</div>