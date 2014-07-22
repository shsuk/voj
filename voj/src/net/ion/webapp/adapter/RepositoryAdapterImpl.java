package net.ion.webapp.adapter;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;

import net.ion.webapp.process.ProcessInitialization;
import net.ion.webapp.utils.DbUtils;
import net.ion.webapp.utils.LowerCaseMap;
import au.id.jericho.lib.html.OutputSegment;

public abstract class RepositoryAdapterImpl implements RepositoryAdapter {
	protected static final SimpleDateFormat YYYYMM_FORMAT = new SimpleDateFormat("yyyy/MM/dd");
	protected static String repositoryPath;
	protected String fid;
	protected String fileName;
	protected String volume;
	protected String path;
	protected String filePath;
	protected long fileSize;

	@Override
	public void setFid(String fid)throws Exception {
		this.fid = fid;
		Map<String, Object> sourceDate = new HashMap<String, Object>();
		sourceDate.put("file_id", fid);
		List<LowerCaseMap<String, Object>> list = DbUtils.select("system/attach_download", sourceDate);
		
		if(list.size()>0){
			Map<String, Object> row = list.get(0);
			volume = (String)row.get("volume");
			path = (String)row.get("file_path");
			fileName = (String)row.get("file_name");
			fileSize = Long.parseLong(row.get("file_size").toString());
			filePath = volume + path;
			
			return;
		}
		
		throw new IOException("File not found : " + fid);
	}

	public String getFullPath() {
		return filePath;
	}
	
	public static String getRepositoryPath() {
		return repositoryPath;
	}
	public void setRepositoryPath(String repositoryPath) {
		try {
			RepositoryAdapterImpl.repositoryPath = repositoryPath;
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public String getVolume() {
		return volume;
	}

	public String getPath() {
		return path;
	}

	@Override
	public String getFileName() {
		
		return fileName;
	}
	@Override
	public long getFileSize() {
		return fileSize;
	}

}
