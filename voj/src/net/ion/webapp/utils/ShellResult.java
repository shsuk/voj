package net.ion.webapp.utils;

import java.util.List;

public class ShellResult {
	public List<String> resultList;
	public List<String> errorList;
	public boolean isSucess() {
		if(errorList != null && errorList.size()>0){
			return false;
		}
		return true;
	}
}
