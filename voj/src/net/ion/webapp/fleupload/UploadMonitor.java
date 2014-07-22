package net.ion.webapp.fleupload;

import java.util.Hashtable;

public class UploadMonitor {

	static Hashtable uploadTable = new Hashtable();

	static void set(String fName, UplInfo info) {
		uploadTable.put(fName, info);
	}

	public static void remove(String fName) {
		uploadTable.remove(fName);
	}

	public static UplInfo getInfo(String fName) {
		UplInfo info = (UplInfo) uploadTable.get(fName);
		return info;
	}
}
