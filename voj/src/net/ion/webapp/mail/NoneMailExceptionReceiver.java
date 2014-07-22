package net.ion.webapp.mail;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class NoneMailExceptionReceiver implements MailExceptionReceiver
{
	public NoneMailExceptionReceiver() {
	}

	public void receive(MailException ex) {
		Logger log = LoggerFactory.getLogger(this.getClass());
		log.error("Send Mail Failed");
	}
}
