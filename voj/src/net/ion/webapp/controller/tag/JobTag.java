package net.ion.webapp.controller.tag;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.tagext.BodyTagSupport;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;


public class JobTag extends BodyTagSupport {

	private static final long serialVersionUID = 9061465283711016644L;
	
	JSONObject jobInfo = new JSONObject();
	
	public void setDesc(String desc) {
		jobInfo.put("desc", desc);
	}
	public void setDs(String ds) {
		jobInfo.put("ds", ds);
	}

	public void setTest(boolean test) {
		jobInfo.put("test", test);
	}

	public void setId(String id) {
		jobInfo.put("id", id);
	}
	
	public void setJobId(String jobId) {
		jobInfo.put("jobId", jobId);
	}
	
	public void setSrc(String src) {
		jobInfo.put("src", src);
	}

	public void setQuery(String query) {
		jobInfo.put("query", query);
	}
	public void setSingleRow(boolean singleRow) {
		jobInfo.put("singleRow", singleRow);
	}
	public void setDefaultValues(String defaultValues) {
		
		String dv =  StringUtils.isEmpty(defaultValues) ? "" : defaultValues.trim();
		
		dv = dv.startsWith("{")  ? dv : "{" + dv + "}";
		
		jobInfo.put("defaultValues", dv);
	}
	public void setForEach(String forEach) {
		jobInfo.put("forEach", forEach);
	}
	public void setVar(String var) {
		jobInfo.put("var", var);
	}
	public void setEmptySkip(boolean emptySkip) {
		jobInfo.put("emptySkip", emptySkip);
	}
	public void setSkip(boolean skip) {
		jobInfo.put("skip", skip);
	}
	public void setIsReturn(boolean isReturn) {
		jobInfo.put("isReturn", isReturn);
	}
	public void setIsCache(boolean isCache) {
		jobInfo.put("isCache", isCache);
	}
	public void setIsReturnColumInfo(boolean isReturnColumInfo) {
		jobInfo.put("isReturnColumInfo", isReturnColumInfo);
	}
	public void setKey(String key) {
		jobInfo.put("key", key);
	}
	public void setRefreshTime(long refreshTime) {
		jobInfo.put("refreshTime", refreshTime);
	}
	
	public int doEndTag() throws JspException {
		try {
			String body = bodyContent!=null ? bodyContent.getString().trim() : "";
			if(StringUtils.isNotEmpty(body)){
				
				body = body.startsWith("{")  ? body : "{" + body + "}";
				JSONObject jobEtcInfo = JSONObject.fromObject(body);

				for(Object key : jobEtcInfo.keySet()){
					if(jobInfo.containsKey(key)){
						throw new JspTagException(key + " 프로퍼티가 중복되었습니다. [" + jobInfo.get(key) + ", " + jobEtcInfo.get(key) + "]");						
					}
					jobInfo.put(key, jobEtcInfo.get(key));
				}
			}
			pageContext.getOut().println(jobInfo.toString() + ",");
		} catch (Exception e) {
			Logger.getLogger(OrganismTag.class).debug(e);
			throw new JspTagException(e.getMessage(), e);
		}finally{
			jobInfo.clear();
		}
		

		return SKIP_BODY;
	}


}
