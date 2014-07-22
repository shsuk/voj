package net.ion.webapp.adapter;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPClientConfig;
import org.apache.commons.net.ftp.FTPReply;
import org.apache.commons.vfs.FileSystemException;

import net.ion.webapp.process.ProcessInitialization;
import au.id.jericho.lib.html.OutputSegment;

public class RepositoryFtpAdapter extends RepositoryAdapterImpl {
	private static final SimpleDateFormat YYYYMM_FORMAT = new SimpleDateFormat("yyyy/MM/dd");
	private static String root;
	private static String server;
	private static int port = 21;
	private static boolean passiveMode=false;


	private static String userId;
	private static String password;

	private String volume;
	private String path;
	private String filePath;

	public static String getRoot() {
		return root;
	}

	public void setRoot(String root) {
		RepositoryFtpAdapter.root = root;
	}
	public String getServer() {
		return server;
	}

	public void setServer(String server) {
		RepositoryFtpAdapter.server = server;
	}

	public static int getPort() {
		return port;
	}

	public void setPort(int port) {
		RepositoryFtpAdapter.port = port;
	}
	public static boolean isPassiveMode() {
		return passiveMode;
	}

	public void setPassiveMode(boolean passiveMode) {
		RepositoryFtpAdapter.passiveMode = passiveMode;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		RepositoryFtpAdapter.userId = userId;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		RepositoryFtpAdapter.password = password;
	}

	
	public String getFullPath() {
		return filePath;
	}
	
	public InputStream getInputStream(String volume, String path) throws IOException {
		FTPClient client = null;
		
		try {
			client = createConnection();
	        
			ByteArrayOutputStream output = new ByteArrayOutputStream();
	        
            if (client.retrieveFile(path, output)) {
            	
            	return new ByteArrayInputStream(output.toByteArray()) ;
            }
			
		}finally{
            if (client != null) {
                try {
                    client.disconnect();
                } catch (Exception ignored) {
                }
            }
		}
 
		return new FileInputStream(volume + path);
	}
/*
	public OutputStream getOutputSegment(String fileId) throws IOException {
		volume = ProcessInitialization.getRepositoryPath();
		path = makePath();
		filePath = volume + path + fileId;
		return new FileOutputStream(filePath);
	}
*/
	@Override
	public boolean remove() {
		try {
			throw new Exception("구현되지 않음");
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public String getVolume() {
		return volume;
	}

	public String getPath() {
		return path;
	}
	
	private String makePath() {
		String path = YYYYMM_FORMAT.format(new Date()) + "/";
		path = path.startsWith("/") ?  path : "/" + path;
		String repDir = root + path;

		File ff = new File(repDir);
		
		if(!ff.exists()){
			ff.mkdirs();
		}
		return path;
	}

	public RepositoryAdapter newInstance() {
		
		return new RepositoryFtpAdapter();
	}

	private FTPClient createConnection() throws FileSystemException {

        try {
            final FTPClient client = new FTPClient();
            try {
/*            	
        		if (dateFormatStr != null) {
	        		FTPClientConfig config = new FTPClientConfig();  
	        		config.setRecentDateFormatStr(dateFormatStr);  
	        		client.configure(config);
        		}
        		if (charset != null) {
                    client.setControlEncoding(charset);
                }
*/        		
                client.connect(server, port);

                int reply = client.getReplyCode();
                if (!FTPReply.isPositiveCompletion(reply)) {
                    throw new FileSystemException("vfs.provider.ftp/connect-rejected.error", server);
                }

                // Login
                if (!client.login(userId, password)) {
                    throw new FileSystemException("vfs.provider.ftp/login.error", new Object[]{server, userId} , null);
                }

                // Set binary mode
                if (!client.setFileType(FTP.BINARY_FILE_TYPE)) {
                    throw new FileSystemException("vfs.provider.ftp/set-binary.error", server);
                }

                if (passiveMode) {
                    client.enterLocalPassiveMode();
                }
            } catch (final IOException e) {
                if (client.isConnected()) {
                    client.disconnect();
                }
                throw e;
            }

            return client;
        } catch (final Exception exc) {
            throw new FileSystemException("vfs.provider.ftp/connect.error", new Object[]{path}, exc);
        }
	}

	@Override
	public void save(String fileId, InputStream is) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void setFid(String fid) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public long getFileSize() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public String getFileName() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void load(OutputStream os) throws Exception {
		// TODO Auto-generated method stub
		
	}
}
