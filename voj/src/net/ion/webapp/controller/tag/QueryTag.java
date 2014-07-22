package net.ion.webapp.controller.tag;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;

import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ProcessorFactory;
import net.sf.json.JSONObject;

/**
 * 트랜잭션 지원 하지 않음
 * 트랜잭션 처리시 OrganismTag태그 사용
 * @author shsuk
 *
 */
public class QueryTag extends ProcessorTag {
	private String jobId = "db";
	private String ds;
	private String query;
	private boolean singleRow = false;

	public void setDs(String ds) {
		this.ds = ds;
	}

	public void setQuery(String query) {
		this.query = query;
	}

	public void setSingleRow(boolean singleRow) {
		this.singleRow = singleRow;
	}

	public int doStartTag() throws JspException {
		if(!test) return SKIP_BODY;
		try {
			JSONObject pDetail = new JSONObject();
			pDetail.put("jobId", jobId);
			pDetail.put("ds", ds);
			pDetail.put("singleRow", singleRow);
			pDetail.put("query", query);
			ReturnValue rtn = ProcessorFactory.exec(pDetail, makeSourceData());
			pageContext.setAttribute(id, rtn.getResult());
		} catch (Exception ex) {
			throw new JspTagException(ex.getMessage(), ex);
		}
		return SKIP_BODY;
	}

}
