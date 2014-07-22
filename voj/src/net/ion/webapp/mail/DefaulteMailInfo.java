package net.ion.webapp.mail;

import net.ion.webapp.mail.message.MailMessageInfo;

import org.apache.commons.lang.StringUtils;

/**
 * @author yucea
 */

public class DefaulteMailInfo implements MailMessageInfo
{
	private SendMail sendMail;

	private String from;
	private String[] to;
	private String[] cc;
	private String[] bcc;
	private String charset;
	private String contentType;
	private String subject;
	private String content;

	public DefaulteMailInfo(SendMail sendMail, String receiver, String subject, Template template, String fromId) {
		this.sendMail = sendMail;

		this.from = fromId;
		this.to = StringUtils.split(receiver, ',');
		this.cc = StringUtils.split(template.getCc(), ',');
		this.bcc = StringUtils.split(template.getBcc(), ',');
		this.charset = template.getCharSet();
		this.contentType = template.getContentType();
		this.subject = subject;
		this.content = template.getContent();
	}

	public void sendMail() throws MailException {
		sendMail.send(from, to, cc, bcc, charset, contentType, subject, content, null);
	}
}