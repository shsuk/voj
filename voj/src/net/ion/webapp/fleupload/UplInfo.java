package net.ion.webapp.fleupload;

public class UplInfo {

	public long totalSize;
	public long currSize;
	public long starttime;
	public boolean aborted;
	public boolean success;
	public String fileName;

	public String getFileName() {
		return fileName;
	}

	public boolean isSuccess() {
		return success;
	}

	public UplInfo() {
		totalSize = 0l;
		currSize = 0l;
		starttime = System.currentTimeMillis();
		aborted = false;
		success = true;
	}

	public UplInfo(int size) {
		totalSize = size;
		currSize = 0;
		starttime = System.currentTimeMillis();
		aborted = false;
		success = true;
	}

	public String getUprate() {
		long time = System.currentTimeMillis() - starttime;
		if (time != 0) {
			long uprate = currSize * 1000 / time;
			return Upload.convertFileSize(uprate) + "/s";
		}
		else return "n/a";
	}

	public int getPercent() {
		if (totalSize == 0) return 0;
		else return (int) (currSize * 100 / totalSize);
	}

	public String getTimeElapsed() {
		long time = (System.currentTimeMillis() - starttime) / 1000l;
		if (time - 60l >= 0){
			if (time % 60 >=10) return time / 60 + ":" + (time % 60) + "m";
			else return time / 60 + ":0" + (time % 60) + "m";
		}
		else return time<10 ? "0" + time + "s": time + "s";
	}

	public String getTimeEstimated() {
		if (currSize == 0) return "n/a";
		long time = System.currentTimeMillis() - starttime;
		time = totalSize * time / currSize;
		time /= 1000l;
		if (time - 60l >= 0){
			if (time % 60 >=10) return time / 60 + ":" + (time % 60) + "m";
			else return time / 60 + ":0" + (time % 60) + "m";
		}
		else return time<10 ? "0" + time + "s": time + "s";
	}

}
