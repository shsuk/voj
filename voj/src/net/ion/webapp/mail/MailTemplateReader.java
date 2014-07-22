package net.ion.webapp.mail;

import java.io.IOException;
import java.io.StringWriter;

import org.apache.commons.digester.Digester;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.Velocity;
import org.springframework.core.io.Resource;
import org.xml.sax.SAXException;

public class MailTemplateReader {

	public static Template getTemplate(Resource resource, String templateName, String langCd, VelocityContext context) throws Exception {

		TemplateConfig templateConfig = readConfiguration(resource);
		Template template = templateConfig.getTemplate(templateName + "|" + langCd);
		StringWriter writer = new StringWriter();
		Velocity.init();
		Velocity.evaluate(context, writer, "LOG", template.getContent());
		template.setContent(writer.getBuffer().toString());
		writer.close();
		return template;
	}

	public static TemplateConfig readConfiguration(Resource resource) throws IOException, SAXException {
		Digester digester = new Digester();
		digester.setValidating(false);

		digester.addObjectCreate("mail-templates/template-list", TemplateConfig.class);

		digester.addObjectCreate("mail-templates/template-list/template", Template.class);
		digester.addBeanPropertySetter("mail-templates/template-list/template/mail-type", "mailType");
		digester.addBeanPropertySetter("mail-templates/template-list/template/lang-code", "langCode");
		digester.addBeanPropertySetter("mail-templates/template-list/template/charset", "charSet");
		digester.addBeanPropertySetter("mail-templates/template-list/template/content-type", "contentType");
		digester.addBeanPropertySetter("mail-templates/template-list/template/from", "from");
		digester.addBeanPropertySetter("mail-templates/template-list/template/cc", "cc");
		digester.addBeanPropertySetter("mail-templates/template-list/template/bcc", "bcc");
		digester.addBeanPropertySetter("mail-templates/template-list/template/subject", "subject");
		digester.addBeanPropertySetter("mail-templates/template-list/template/content", "content");
		digester.addSetNext("mail-templates/template-list/template", "addTemplate");

		return (TemplateConfig) digester.parse(resource.getInputStream());
	}
}
