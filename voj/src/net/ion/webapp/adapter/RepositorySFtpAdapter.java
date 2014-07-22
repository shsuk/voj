package net.ion.webapp.adapter;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Date;

public class RepositorySFtpAdapter extends RepositoryAdapterImpl {
	private static String root;
	private static String server;
	private static int port = 21;

	private static String userId;
	private static String password;

	@Override
	public RepositoryAdapter newInstance() throws Exception {
		return new RepositorySFtpAdapter();
	}

	@Override

	public void load(OutputStream os) throws Exception {
		SFTPClient client = null;

		try {
			client = createConnection();

			if (client.downloadFile(RepositorySFtpAdapter.root + path, os)) {

				return;
			}

		} finally {
			if (client != null) {
				try {
					client.disconnect();
				} catch (Exception ignored) {
				}
			}
		}

		return;
	}
	@Override
	public void save(String fileId, InputStream is) throws Exception {
		SFTPClient client = null;
		volume = "sftp";

		try {
			client = createConnection();
			path = makePath(client);
			filePath = RepositorySFtpAdapter.root + path + fileId;
			client.uploadFile(is, filePath);
			return;
		} finally {
			if (client != null) {
				try {
					client.disconnect();
				} catch (Exception ignored) {
				}
			}
		}
	}

	public boolean remove(){
		SFTPClient client = null;
		volume = "sftp";

		try {
			client = createConnection();
			
			client.deleteFile(RepositorySFtpAdapter.root + path);
			return true;
		} catch (final Exception e) {
			return false;
		} finally {
			if (client != null) {
				try {
					client.disconnect();
				} catch (Exception ignored) {
				}
			}
		}
	}

	private SFTPClient createConnection() throws Exception {

		final SFTPClient client = new SFTPClient();

		try {
			client.connect(server, userId, password, port);
		} catch (final Exception e) {
			if (client != null) {
				client.disconnect();
			}
			throw e;
		}

		return client;
	}

	private String makePath(SFTPClient client) {

		String path = YYYYMM_FORMAT.format(new Date()) + "/";
		path = path.startsWith("/") ? path : "/" + path;
		String repDir = root + path;

		client.createDirectorys(repDir);
		return path;
	}

	public static String getRoot() {
		return root;
	}

	public void setRoot(String root) {
		RepositorySFtpAdapter.root = root;
	}

	public String getServer() {
		return server;
	}

	public void setServer(String server) {
		RepositorySFtpAdapter.server = server;
	}

	public static int getPort() {
		return port;
	}

	public void setPort(int port) {
		RepositorySFtpAdapter.port = port;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		RepositorySFtpAdapter.userId = userId;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		RepositorySFtpAdapter.password = password;
	}


}
