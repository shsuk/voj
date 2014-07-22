package net.ion.webapp.exception;

public class UserSecurityException extends Exception{
	private String modulePath;
	
	public UserSecurityException(String modulePath) {
		this.modulePath = modulePath;
	}
	public String getModulePath() {
		return modulePath;
	}
}
