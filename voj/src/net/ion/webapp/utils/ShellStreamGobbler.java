package net.ion.webapp.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

class ShellStreamGobbler extends Thread {
	InputStream is;
	List<String> result;
	String charsetName = "euc-kr";

	public ShellStreamGobbler(InputStream is, String charsetName) {
		this.charsetName = charsetName;
		this.is = is;
	}
	public ShellStreamGobbler(InputStream is) {
		this.is = is;
	}

	public void run() {
		result = new ArrayList<String>();
		InputStreamReader isr = null;
		BufferedReader br = null;
		
		try {
			isr = new InputStreamReader(is, charsetName);
			br = new BufferedReader(isr);
			String line;
			while ((line = br.readLine()) != null){
				result.add(line);
			}
		} catch (IOException ioe) {
			ioe.printStackTrace();
		}finally{
			try {
				if(br!=null) br.close();
			} catch (Exception e) { }
			try {
				if(isr!=null) isr.close();
			} catch (Exception e) { }
		}
	}
	
	public List<String> getResult() {
		return result;
		
	}
}