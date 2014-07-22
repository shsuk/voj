

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import java.net.InetAddress;
import java.net.UnknownHostException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpMethodBase;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.protocol.Protocol;
import org.apache.commons.httpclient.protocol.SSLProtocolSocketFactory;
import org.apache.commons.lang.StringUtils;

import org.hyperic.sigar.CpuPerc;
import org.hyperic.sigar.FileSystem;
import org.hyperic.sigar.FileSystemUsage;
import org.hyperic.sigar.Mem;
import org.hyperic.sigar.NetFlags;
import org.hyperic.sigar.Sigar;
import org.hyperic.sigar.SigarException;
/**
 * 시스템 정보 추합
 * java SysInfo http://echo.co.kr:8080/api.sh 20165702 D:\ interwork/dvc_usage_insert
 * java SysInfo http://echo.co.kr:8080/api.sh 20165702 D:\ interwork/st_nas_insert
 * wget http://echo.co.kr:8080/api.sh?_q=interwork/dvc_info_health_dt&dvc_id=20165702
 * @author shsuk
 *
 */
public class SysInfo {
	private static final int BUFFER_SIZE = 4 * 1024;
	
	public static void main(String[] args) throws Exception {
		
		if(args==null || args.length<4){
			System.out.println("ser_url dvc_id dir");
		}
		
		Map<String, Object> params = new HashMap<String, Object>();

		params.put("dvc_id", args[1]);
		params.put("_q", args[3]);

		SysInfo p = new SysInfo();
		Sigar sigar = new Sigar();

		String ip = p.getDefaultIpAddress();
		params.put("ip", ip);

		CpuPerc cpu = sigar.getCpuPerc();
		float cpuUsedPercent = (long)(cpu.getCombined()*10000);
		params.put("cpu_use_percent", cpuUsedPercent/100);


		Mem mem = sigar.getMem();
		long memUsed = mem.getUsed();
		long memTotal = mem.getTotal();
		long memUsedPercent = (long)(mem.getUsedPercent()*100);
		params.put("mem_used", memUsed);
		params.put("mem_total", memTotal);
		params.put("mem_use_percent", (float)memUsedPercent/100);


		List<String> dirs = new ArrayList<String>();
		dirs.add(args[2]);
		p.testFileSystemInfo(dirs, params);
		
		System.out.println(params);
		
		String url = args[0];
		
		String html = getString(url, params, 60000);
		System.out.println(html);
	}

	public void testFileSystemInfo(List<String> dirs, Map<String, Object> params) throws Exception {

		Sigar sigar = new Sigar();
		FileSystem fslist[] = sigar.getFileSystemList();
		// String dir = System.getProperty ("user.home ");// current user folder
		// path
		for (int i = 0; i < fslist.length; i++) {
			String dirId = "";
			FileSystem fs = fslist[i];
			
			if(dirs.size()>0){
				boolean isFindDir = false;
				
				for(String dir : dirs){
					if(StringUtils.startsWithIgnoreCase(fs.getDevName(), dir) || StringUtils.startsWithIgnoreCase(fs.getDirName(), dir)){
						isFindDir = true;
						break;
					}
				}
				
				if(!isFindDir) continue;
				dirId = "disk_";
			}else{
				dirId = "disk_" + fs.getDirName() + "_";
			}
			
			params.put(dirId+"name", fs.getDirName());

			FileSystemUsage usage = null;
			try {
				usage = sigar.getFileSystemUsage(fs.getDirName());
			} catch (SigarException e) {
				if (fs.getType() == 2)
					throw e;
				continue;
			}
			
			switch (fs.getType()) {
				case 0: // TYPE_UNKNOWN: Unknown
					break;
				case 1: // TYPE_NONE
					break;
				case 2: // TYPE_LOCAL_DISK: local hard drive
					params.put(dirId+"total", usage.getTotal() / 1024L / 1024L);
					params.put(dirId+"used", usage.getUsed() / 1024L / 1024L);
					params.put(dirId+"use_percent", usage.getUsePercent() * 100D);
					break;
				case 3: // TYPE_NETWORK: Network
					break;
				case 4: // TYPE_RAM_DISK: Flash
					break;
				case 5: // TYPE_CDROM: CD-ROM
					break;
				case 6: // TYPE_SWAP: exchange page
					break;
			}
		}
		return;
	}

	public String getDefaultIpAddress() {
		String address = null;
		try {
			address = InetAddress.getLocalHost().getHostAddress();
			// No exception to the normal when taking IP, if the card is not
			// taken to address through the back to back
			// Otherwise, and through Sigar toolkit approach to obtain
			if (!NetFlags.LOOPBACK_ADDRESS.equals(address)) {
				return address;
			}
		} catch (UnknownHostException e) {
			// Hostname not in DNS or / etc / hosts
		}
		Sigar sigar = new Sigar();
		try {
			address = sigar.getNetInterfaceConfig().getAddress();
		} catch (SigarException e) {
			address = NetFlags.LOOPBACK_ADDRESS;
		} finally {
			sigar.close();
		}
		return address;
	}

	private static String getString(String url, Map<String, Object> parameterMap, int timeout)throws Exception {
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		getByteArrayOutputStream(url, parameterMap, baos, timeout);
		return baos.toString();
	}

	private static void getByteArrayOutputStream(String url, Map<String, Object> parameterMap, OutputStream os, int timeout)throws Exception {

		HttpMethodBase httpMethod = null;
		
		try {
			httpMethod = getHttpMethodBase(url, parameterMap, timeout);
			InputStream is = httpMethod.getResponseBodyAsStream();
			byte[] b = new byte[BUFFER_SIZE];
			int len = 0;
			while ((len = is.read(b)) > 0) {
				os.write(b, 0, len);
			}

		} finally {
			try {
				httpMethod.releaseConnection();
			} catch (Exception e) {}
		}
	}

	private static HttpMethodBase getHttpMethodBase(String url,
			Map<String, Object> parameterMap, int timeout) throws Exception {

		Protocol.registerProtocol("https", new Protocol("https",
				new SSLProtocolSocketFactory(), 443));
		HttpClient httpClient = new HttpClient();
		
		if(0>timeout)httpClient.setTimeout(timeout);
		
		HttpMethodBase httpMethod = null;

		if (parameterMap == null || parameterMap.isEmpty()) {
			httpMethod = new GetMethod(url);
		} else {
			httpMethod = new PostMethod(url);
		}

		httpMethod.addRequestHeader("Content-Type",
				"application/x-www-form-urlencoded; charset=euc-kr");

		if (parameterMap != null && !parameterMap.isEmpty()) {
			for (String key : parameterMap.keySet()) {
				String value = (parameterMap.get(key) != null) ? parameterMap.get(key).toString() : "";
				((PostMethod) httpMethod).addParameter(key, value);
			}
		}

		try {
			httpClient.executeMethod(httpMethod);

		} catch (Exception e) {
			throw e;
		}

		if (httpMethod.getStatusCode() != HttpStatus.SC_OK) {
			String message = "Http Status Code is not OK : "
					+ httpMethod.getStatusCode();

			IOException e = new IOException("Http Status Code is not OK : "
					+ httpMethod.getStatusCode());
			throw e;
			// PopupMessage.openError(e, Display.getCurrent().getActiveShell(),
			// "서버 접속에 실패하였습니다./n서버가 정상인지 확인하세요.");
		}

		return httpMethod;
	}


}