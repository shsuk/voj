package net.ion.webapp.adapter;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;


public interface RepositoryAdapter {
	public RepositoryAdapter newInstance()throws Exception;
	public void setFid(String fid)throws Exception;
	public String getVolume();
	public long getFileSize();
	public String getPath();
	public String getFullPath();
	public String getFileName();

	public void load(OutputStream os) throws Exception ;
	//public void load(String volume, String path, OutputStream os) throws Exception ;
	public void save(String fileId, InputStream is) throws Exception;
	public boolean remove();
}
