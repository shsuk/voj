package net.ion.webapp.mail.message;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * MessageChannel 에 속한 모든 메세지를 처리하는 Thread
 * 
 * @author bleujin
 * @version 1.0
 */

// Worker Thread Pattern
public class WorkerThread extends Thread
{
	private final MessageChannel channel;
	private static final Logger log = LoggerFactory.getLogger(WorkerThread.class);

	public WorkerThread(String name, MessageChannel channel) {
		super(name);
		this.channel = channel;
		this.setDaemon(true);
	}

	public void run() {
		while (!channel.isCompleted()) {
			try {
				Message message = channel.takeMessage();
				message.handle();
			} catch (Exception ex) {
				log.warn("Message Not handled..", ex);
			}
		}
	}
}
