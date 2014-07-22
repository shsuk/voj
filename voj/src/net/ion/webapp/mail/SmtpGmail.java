package net.ion.webapp.mail;

import java.io.UnsupportedEncodingException;
import java.security.Security;
import java.util.Date;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeUtility;

import org.apache.log4j.Logger;

public class SmtpGmail extends Authenticator {
		protected PasswordAuthentication getPasswordAuthentication() {

			  String user = "shsuk87@gmail.com";

			  String pw = "ssh87208720";
			return new PasswordAuthentication(user, pw);

		}


}