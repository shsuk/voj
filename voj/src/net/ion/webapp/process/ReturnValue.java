package net.ion.webapp.process;


public class ReturnValue {
	private StringBuffer log = new StringBuffer();
	private Object o = null;

	public StringBuffer getLog() {
		return (log.length()==0) ? null : log;
	}
	public String getLogString() {
		return (log.length()==0) ? null : log.toString();
	}
	public ReturnValue append(String log) {
		this.log.append(log);
		return this;
	}
	public ReturnValue append(StringBuffer log) {
		this.log.append(log);
		return this;
	}
	public Object getResult() {
		return o;
	}
	public void setResult(Object o) {
		this.o = o;
	}
}
