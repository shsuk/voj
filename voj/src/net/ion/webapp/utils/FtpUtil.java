package net.ion.webapp.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.MalformedURLException;
import java.net.URL;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPClientConfig;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;
import org.apache.commons.vfs.FileSystemException;


public class FtpUtil{
    FTPClient client = null;
    URL url = null;
    String hostName;
    int port;
    String username;
    String password;
    String path;
    boolean passiveMode=false;
    String charset;
    String dateFormatStr;
    
    public FtpUtil(String serverInfo) throws MalformedURLException {
    	
        url = new URL(serverInfo);
        
        hostName = url.getHost();
        port = url.getPort();
        username = StringUtils.substringBefore(url.getUserInfo(), ":");
        password = StringUtils.substringAfter(url.getUserInfo(), ":");
        path = url.getPath();

        // Determine the username and password to use
        if (username == null) {
            username = "anonymous";
        }
        if (password == null) {
            password = "anonymous";
        }
        if (port == -1) {
            port = 21;
        }
	}

    public FtpUtil(String serverInfo, boolean bPassiveMode) throws MalformedURLException {
    	
        url = new URL(serverInfo);
        
        hostName = url.getHost();
        port = url.getPort();
        username = StringUtils.substringBefore(url.getUserInfo(), ":");
        password = StringUtils.substringAfter(url.getUserInfo(), ":");
        path = url.getPath();
        passiveMode = bPassiveMode;
        // Determine the username and password to use
        if (username == null) {
            username = "anonymous";
        }
        if (password == null) {
            password = "anonymous";
        }
        if (port == -1) {
            port = 21;
        }
	}


	public File getFile(String source, String target){
		try {
	        client = createConnection();
	        
	        OutputStream output = null;
	        File local = null;
	        try {
	        	local = new File(target);
	            output = new FileOutputStream(local);
	        }
	        catch (FileNotFoundException fnfe) {
	            fnfe.printStackTrace();
	            return null;
	        }
	        
	        try {
	            if (client.retrieveFile(source, output)) {
	                return local;
	            }
	        }
	        catch (IOException ioe) {
	            ioe.printStackTrace();
	        }
			
		} catch (Exception e) {
			// TODO: handle exception
		}finally{
            if (client != null) {
                try {
                    client.disconnect();
                } catch (Exception ignored) {
                }
            }
		}
        return null;
    }
	public boolean deleteFile(String fileName){
		try {
	        client = createConnection();
	        
	        
	        try {
	        	
	        	return client.deleteFile(fileName);
	        }
	        catch (IOException ioe) {
	            ioe.printStackTrace();
	        }
			
		} catch (Exception e) {
			// TODO: handle exception
		}finally{
            if (client != null) {
                try {
                    client.disconnect();
                } catch (Exception ignored) {
                }
            }
		}
        return false;
    }
	public boolean saveFile(String source, String target){
		try {
	        client = createConnection();
	        
	        InputStream input = null;
	        
	        try {
	        	input = new FileInputStream(source);
	        }
	        catch (FileNotFoundException fnfe) {
	            fnfe.printStackTrace();
	            return false;
	        }
	        
	        try {
	        	if(!mk(client, target)) return false;
	        	return client.storeFile(target, input);
	        }
	        catch (IOException ioe) {
	            ioe.printStackTrace();
	        }
			
		} catch (Exception e) {
			// TODO: handle exception
		}finally{
            if (client != null) {
                try {
                    client.disconnect();
                } catch (Exception ignored) {
                }
            }
		}
        return false;
    }

	private boolean mk(FTPClient client, String path) throws IOException{
		client.changeWorkingDirectory("/");
		
        path = getParent(path);
        String[] paths = StringUtils.split(path, "/");
        for (int i = 0; i < paths.length; i++) {
           if (!client.changeWorkingDirectory(paths[i])) { // 1차 시도
            	client.makeDirectory(paths[i]);
               if (!client.changeWorkingDirectory(paths[i])) { // 디릭토리를 만들고 2차 시도
                    return false;
                }
            }
        }
       return true;
	}
	private static String getParent(String path) {
        if (path == null || "".equals(path)) {
            return "/";
        }
        return StringUtils.substringBeforeLast(path.replace('\\', '/'), "/");
    }
	
	public FTPFile[] getDir() throws IOException{
		FTPFile[] files = null;
        try {
            client = createConnection();
            
            files = client.listFiles(path);
            
        }
        catch (IOException ioe) {
            ioe.printStackTrace();
		}finally{
            if (client != null) {
                try {
                    client.disconnect();
                } catch (Exception ignored) {
                }
            }
		}
        return files;
    }
	

	private FTPClient createConnection() throws FileSystemException {

        try {
            final FTPClient client = new FTPClient();
            try {
        		if (dateFormatStr != null) {
	        		FTPClientConfig config = new FTPClientConfig();  
	        		config.setRecentDateFormatStr(dateFormatStr);  
	        		client.configure(config);
        		}
        		if (charset != null) {
                    client.setControlEncoding(charset);
                }
                client.connect(hostName, port);

                int reply = client.getReplyCode();
                if (!FTPReply.isPositiveCompletion(reply)) {
                    throw new FileSystemException("vfs.provider.ftp/connect-rejected.error", hostName);
                }

                // Login
                if (!client.login(username, password)) {
                    throw new FileSystemException("vfs.provider.ftp/login.error", new Object[]{hostName, username} , null);
                }

                // Set binary mode
                if (!client.setFileType(FTP.BINARY_FILE_TYPE)) {
                    throw new FileSystemException("vfs.provider.ftp/set-binary.error", hostName);
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

 

	public String getDateFormatStr() {
		return dateFormatStr;
	}

	public void setDateFormatStr(String dateFormatStr) {
		this.dateFormatStr = dateFormatStr;
	}

	public void setCharset(String charset) {
		this.charset = charset;
	}
	public static void main(String[] args) throws Exception{
		String serverInfo = "ftp://id:password@122.200.210.100/test/test";
	
		//FtpUtil ftp = new FtpUtil(serverInfo, true); //PassiveMode인 경우
		FtpUtil ftp = new FtpUtil(serverInfo);
		
		ftp.setCharset("euc-kr");			 //getDir이 안되는 경우 캐릭터?과 날자 형식을 설정하세요.
		ftp.setDateFormatStr("M월 d일 HH:mm"); //날자는 서버에 설정된 형식으로 해야 합니다.
		FTPFile[] files = ftp.getDir();
		
		for(FTPFile file : files){
			System.out.println(file.getName());
		}
	}

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}
}
