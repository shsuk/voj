package net.ion.webapp.mail;

public class Template
{
	private String mailType;

	private String contentType;
	private String from;
	private String replyTo;
	private String cc;
	private String bcc;
	private String subject;
	private String content;

	public final static String KEY_SEPERATOR = "|";
	private String langCode;
	private String charSet;

	public Template() {
	}

	public String getTemplateKey() {
		return getMailType() + KEY_SEPERATOR + getLangCode();
	}

	public String getBcc() {
		return bcc;
	}

	public String getContent() {
		return content;
	}

	public String getContentType() {
		return contentType;
	}

	public String getFrom() {
		return from;
	}

	public String getMailType() {
		return mailType;
	}

	public String getReplyTo() {
		return replyTo;
	}

	public String getSubject() {
		return subject;
	}

	public void setBcc(String bcc) {
		this.bcc = bcc;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

	public void setFrom(String from) {
		this.from = from;
	}

	public void setMailType(String mailType) {
		this.mailType = mailType;
	}

	public void setReplyTo(String replyTo) {
		this.replyTo = replyTo;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public String getCc() {
		return cc;
	}

	public void setCc(String cc) {
		this.cc = cc;
	}

	public String getLangCode() {
		return langCode;
	}

	public void setLangCode(String langCode) {
		this.langCode = langCode;
	}

	public String getCharSet() {
		return charSet;
	}

	public void setCharSet(String charSet) {
		this.charSet = charSet;
	}
}