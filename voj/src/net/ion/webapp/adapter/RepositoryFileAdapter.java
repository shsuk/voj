package net.ion.webapp.adapter;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Date;

import org.apache.commons.io.IOUtils;

public class RepositoryFileAdapter extends RepositoryAdapterImpl {

	@Override
	public RepositoryAdapter newInstance() throws Exception {
		return new RepositoryFileAdapter();
	}

	@Override
	public void load(OutputStream os) throws Exception {
		if(path==null){
			throw new IOException("파일 아이디가 없습니다. ");
		}
		InputStream is = null;
		
		try {
			if("sftp".equals(volume)){ 
				volume = RepositoryFileAdapter.getRepositoryPath();
			}
			filePath = volume + path;
			is = new FileInputStream(filePath);
			IOUtils.copyLarge(is, os);			
		} finally{
			if(is!=null){
				try {
					is.close();
				} catch (Exception e) {}
			}
		}
		return;
	}

	public void save(String fileId, InputStream is) throws IOException {
		OutputStream os = null;
		
		try {
			volume = RepositoryFileAdapter.getRepositoryPath();
			path = makePath();
			filePath = volume + path + fileId;
			os = new FileOutputStream(filePath);
			IOUtils.copyLarge(is, os);			
		} finally{
			if(os!=null){
				try {
					os.close();
				} catch (Exception e) {}
			}
			if(is!=null){
				try {
					is.close();
				} catch (Exception e) {}
			}
		}
	}

	@Override
	public boolean remove() {
		if("sftp".equals(volume)){ 
			volume = RepositoryFileAdapter.getRepositoryPath();
		}
		
		filePath = volume + path;
		File f = new File(filePath);

		return f.delete();
	}
	
	private String makePath() {
		String repRoot = RepositoryFileAdapter.getRepositoryPath();
		String path = YYYYMM_FORMAT.format(new Date()) + "/";
		path = path.startsWith("/") ?  path : "/" + path;
		String repDir = repRoot + path;

		File ff = new File(repDir);
		
		if(!ff.exists()){
			ff.mkdirs();
		}
		return path;
	}

}
