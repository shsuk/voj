<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib prefix="code" uri="/WEB-INF/tlds/Code.tld"%><%@ taglib prefix="uf" uri="/WEB-INF/tlds/fnc.tld"%>
<%@ attribute name="name" type="java.lang.String" required="true"%>
<%@ attribute name="value" type="java.lang.String" required="true"%>
<%@ attribute name="valid" type="java.lang.String" %>
			<input type="hidden" id="${name }" name="${name }" value="${value }"  valid="${valid}" >
			<c:set var="email" value="${fn:split(value,'@')}"/>
			<table  style="margin: 0px;padding: 0px;width: 200px"><tr>
				</td><td style="border:0px;padding:0 0 0 0;">
					<input type="text" name="${name }1" value="${email[0]}" style="width:100px;" >
				</td><td style="border:0px;padding:0 0 0 0;">
					@
				</td><td style="border:0px;padding:0 0 0 0;">
					<input type="text" name="${name }2" value="${email[1]}" style="width:100px;" >
				<td style="border:0px;padding:0 0 0 0;">
					<tp:select name="${name }3" groupId="email" selected="${email[1] }" emptyText="직접입력" className="btn-l"  />
				</td></tr></table>
				<script type="text/javascript">
					$(function() {
						$('[name=${name }1]').keyup(function(){
							$('[name=${name }1]').val($('[name=${name }1]').val());
							changeEmail('#${name }');
						});
						$('[name=${name }2]').keyup(function(){
							$('[name=${name }2]').val($('[name=${name }2]').val());
							changeEmail('#${name }');
						});
						$('[name=${name }3]').change(function(){
							$('[name=${name }2]').val($('[name=${name }3]').val());
							changeEmail('#${name }');
						});
						function changeEmail(id){
							$(id).val($('[name=${name }1]').val()+'@'+$('[name=${name }2]').val());
						}
					});
				</script>
