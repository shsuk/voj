package net.ion.webapp.exception;

public class IslimException extends Exception{
	/**
	 * 
	 */
	private static final long serialVersionUID = -3468071161456670471L;
	String errorId;
	
	public String getErrorId() {
		return errorId;
	}
	public IslimException(String errorId, String message) {
		super(message);
		this.errorId = errorId;
	}
	public IslimException(String errorId, String message, Exception e) {
		super(message, e);
		this.errorId = errorId;
	}
}
