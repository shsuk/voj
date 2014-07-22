package net.ion.webapp.db;

import net.ion.webapp.utils.Aes;

public class BasicDataSource extends org.apache.commons.dbcp.BasicDataSource{
	@Override
	public synchronized void setUsername(String username) {
		
		super.setUsername(Aes.getKeyDecode(username));
	}
	@Override
	public synchronized void setPassword(String password) {
		super.setPassword(Aes.getKeyDecode(password));
	}
}
