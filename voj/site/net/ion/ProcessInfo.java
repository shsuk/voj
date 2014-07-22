package net.ion;

import java.net.InetAddress;
import java.net.UnknownHostException;
import org.hyperic.sigar.CpuInfo;
import org.hyperic.sigar.CpuPerc;
import org.hyperic.sigar.FileSystem;
import org.hyperic.sigar.FileSystemUsage;
import org.hyperic.sigar.Mem;
import org.hyperic.sigar.NetFlags;
import org.hyperic.sigar.NetInterfaceConfig;
import org.hyperic.sigar.NetInterfaceStat;
import org.hyperic.sigar.OperatingSystem;
import org.hyperic.sigar.Sigar;
import org.hyperic.sigar.SigarException;
import org.hyperic.sigar.SigarNotImplementedException;
import org.hyperic.sigar.Swap;

public class ProcessInfo {

	public static void main(String[] args) throws Exception {

		ProcessInfo p = new ProcessInfo();

		// 1.CPU Resource Information
		System.out.println(getCpuCount());
		p.getCpuTotal();
		p.testCpuPerc();

		// 2. Memory resource information
		p.getPhysicalMemory();

		// 3. Operating system information
		System.out.println(p.getPlatformName());
		p.testGetOSInfo();
		p.testWho();

		// 4. Resource information (mainly the hard drive)
		p.testFileSystemInfo();

		// 5. Network Information
		System.out.println(p.getFQDN());
		System.out.println(p.getDefaultIpAddress());
		System.out.println(p.getMAC());
		p.testNetIfList();
		p.getEthernetInfo();
	}

	// 1.CPU Resource Information

	// A) CPU number (Unit:)
	public static int getCpuCount() throws SigarException {
		Sigar sigar = new Sigar();

		try {
			return sigar.getCpuInfoList().length;
		} finally {
			sigar.close();
		}
	}

	// B) CPU of the total (unit: HZ) and the CPU-related information
	public void getCpuTotal() {
		Sigar sigar = new Sigar();
		CpuInfo[] infos;
		try {
			infos = sigar.getCpuInfoList();
			for (int i = 0; i < infos.length; i++) { // either single or
														// multi-CPU CPU block
														// are applicable
				CpuInfo info = infos[i];
				System.out.println("mhz =" + info.getMhz());// CPU MHz total
															// amount of
				System.out.println("vendor =" + info.getVendor());// get CPU
																	// vendor,
																	// such as:
																	// Intel
				System.out.println("model =" + info.getModel());// get the type
																// of CPU, such
																// as: Celeron
				System.out.println("cache size =" + info.getCacheSize());// the
																			// number
																			// of
																			// buffer
																			// memory
			}
		} catch (SigarException e) {
			e.printStackTrace();
		}
	}

	// C) CPU usage of users, the system uses the remaining amount, the total
	// remaining amount of the total volume occupied by such use (unit: 100%)
	public void testCpuPerc() {

		Sigar sigar = new Sigar();
		// Method one, mainly for the case of a CPU
		CpuPerc cpu;
		try {
			cpu = sigar.getCpuPerc();
			printCpuPerc(cpu);
		} catch (SigarException e) {
			e.printStackTrace();
		}
		// Second way, either single or multi-CPU CPU block are applicable
		CpuPerc cpuList[] = null;
		try {
			cpuList = sigar.getCpuPercList();
		} catch (SigarException e) {
			e.printStackTrace();
			return;
		}
		for (int i = 0; i < cpuList.length; i++) {
			printCpuPerc(cpuList[i]);
		}
	}

	private void printCpuPerc(CpuPerc cpu) {
		System.out.println("User:" + CpuPerc.format(cpu.getUser()));// user
																	// usage
		System.out.println("Sys:" + CpuPerc.format(cpu.getSys()));// system
																	// utilization
		System.out.println("Wait:" + CpuPerc.format(cpu.getWait()));// rate of
																	// the
																	// current
																	// waiting
		System.out.println("Nice:" + CpuPerc.format(cpu.getNice()));//
		System.out.println("Idle:" + CpuPerc.format(cpu.getIdle()));// rate of
																	// the
																	// current
																	// idle
		System.out.println("Total:" + CpuPerc.format(cpu.getCombined()));// utilization
																			// of
																			// the
																			// total
	}

	// 2. Memory resource information
	public void getPhysicalMemory() {

		Sigar sigar = new Sigar();
		try {
			// A) information about physical memory
			Mem mem = sigar.getMem();
			System.out.println("Total =" + mem.getTotal() / 1024L + "K av"); // Total
																				// memory
			System.out.println("Used =" + mem.getUsed() / 1024L + "K used"); // Current
																				// memory
																				// usage
			System.out.println("Free =" + mem.getFree() / 1024L + "K free"); // The
																				// current
																				// amount
																				// of
																				// memory
																				// remaining
			// B) information on the system page file swap
			Swap swap = sigar.getSwap();
			System.out.println("Total =" + swap.getTotal() / 1024L + "K av"); // Total
																				// amount
																				// of
																				// swap
			System.out.println("Used =" + swap.getUsed() / 1024L + "K used"); // Use
																				// the
																				// current
																				// exchange
																				// area
			System.out.println("Free =" + swap.getFree() / 1024L + "K free"); // Swap
																				// the
																				// remaining
																				// amount
																				// of
																				// the
																				// current

		} catch (SigarException e) {
			e.printStackTrace();
		}
	}

	// 3. Operating system information

	// A) take the name of the current operating system:
	public String getPlatformName() {
		String hostname = "";

		try {
			hostname = InetAddress.getLocalHost().getHostName();
		} catch (Exception exc) {
			Sigar sigar = new Sigar();
			try {
				hostname = sigar.getNetInfo().getHostName();
			} catch (SigarException e) {
				hostname = "localhost.unknown";
			} finally {
				sigar.close();
			}
		}
		return hostname;
	}

	// B) to take the current operating system information
	public void testGetOSInfo() {
		OperatingSystem OS = OperatingSystem.getInstance();

		// Type of operating system kernel, such as: 386,486,586, etc. x86
		System.out.println("OS.getArch () =" + OS.getArch());
		System.out.println("OS.getCpuEndian () =" + OS.getCpuEndian());//
		System.out.println("OS.getDataModel () =" + OS.getDataModel());//
		// System Description
		System.out.println("OS.getDescription () =" + OS.getDescription());
		System.out.println("OS.getMachine () =" + OS.getMachine());//
		// Operating system type
		System.out.println("OS.getName () =" + OS.getName());
		System.out.println("OS.getPatchLevel () =" + OS.getPatchLevel());//
		// Operating system vendor
		System.out.println("OS.getVendor () =" + OS.getVendor());
		// Vendor name
		System.out
				.println("OS.getVendorCodeName () =" + OS.getVendorCodeName());
		// Operating system name
		System.out.println("OS.getVendorName () =" + OS.getVendorName());
		// Type of operating system vendor
		System.out.println("OS.getVendorVersion () =" + OS.getVendorVersion());
		// Operating system version number
		System.out.println("OS.getVersion () =" + OS.getVersion());
	}

	// C) the process of taking the current system user information table
	public void testWho() {
		try {
			Sigar sigar = new Sigar();
			org.hyperic.sigar.Who[] who = sigar.getWhoList();
			if (who != null && who.length > 0) {
				for (int i = 0; i < who.length; i++) {
					System.out.println("\n ~~~~~~~~~" + String.valueOf(i)
							+ "~~~~~~~~~");
					org.hyperic.sigar.Who _who = who[i];
					System.out.println("getDevice () =" + _who.getDevice());
					System.out.println("getHost () =" + _who.getHost());
					System.out.println("getTime () =" + _who.getTime());
					// Current system user name in the process table
					System.out.println("getUser () =" + _who.getUser());
				}
			}
		} catch (SigarException e) {
			e.printStackTrace();
		}
	}

	// 4. Resource information (mainly the hard drive)

	// A) has taken the hard disk partition and details (via
	// sigar.getFileSystemList () to get a list of FileSystem object, then its
	// code calendar):
	public void testFileSystemInfo() throws Exception {

		Sigar sigar = new Sigar();
		FileSystem fslist[] = sigar.getFileSystemList();
		// String dir = System.getProperty ("user.home ");// current user folder
		// path
		for (int i = 0; i < fslist.length; i++) {
			System.out.println("\n ~~~~~~~~~~" + i + "~~~~~~~~~~");
			FileSystem fs = fslist[i];
			// Partition the drive name
			System.out.println("fs.getDevName () =" + fs.getDevName());
			// Partition the drive name
			System.out.println("fs.getDirName () =" + fs.getDirName());
			System.out.println("fs.getFlags () =" + fs.getFlags());//
			// File system type, such as FAT32, NTFS
			System.out.println("fs.getSysTypeName () =" + fs.getSysTypeName());
			// File system type name, such as local hard drives, CD drives,
			// network file system, etc.
			System.out.println("fs.getTypeName () =" + fs.getTypeName());
			// File system type
			System.out.println("fs.getType () =" + fs.getType());
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
				// Total size of the file system
				System.out.println("Total =" + usage.getTotal() + "KB");
				// Remaining size of the file system
				System.out.println("Free =" + usage.getFree() + "KB");
				// Size of the file system is available
				System.out.println("Avail =" + usage.getAvail() + "KB");
				// Use the file system has been
				System.out.println("Used =" + usage.getUsed() + "KB");
				double usePercent = usage.getUsePercent() * 100D;
				// File system resource utilization
				System.out.println("Usage =" + usePercent + "%");
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
			System.out.println("DiskReads =" + usage.getDiskReads());
			System.out.println("DiskWrites =" + usage.getDiskWrites());
		}
		return;
	}

	// 5. Network Information

	// A) the official name of the current machine
	public String getFQDN() {

		Sigar sigar = null;
		try {
			return InetAddress.getLocalHost().getCanonicalHostName();
		} catch (UnknownHostException e) {
			try {
				sigar = new Sigar();
				return sigar.getFQDN();
			} catch (SigarException ex) {
				return null;
			} finally {
				sigar.close();
			}
		}
	}

	// B) access to the current machine's IP address
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

	// C) get to the current MAC address of the machine
	public String getMAC() {
		Sigar sigar = null;
		try {
			sigar = new Sigar();
			String[] ifaces = sigar.getNetInterfaceList();
			String hwaddr = null;
			for (int i = 0; i < ifaces.length; i++) {
				NetInterfaceConfig cfg = sigar.getNetInterfaceConfig(ifaces[i]);
				if (NetFlags.LOOPBACK_ADDRESS.equals(cfg.getAddress())
						|| (cfg.getFlags() & NetFlags.IFF_LOOPBACK) != 0
						|| NetFlags.NULL_HWADDR.equals(cfg.getHwaddr())) {
					continue;
				}
				/*
				 * If there are multiple NICs, including virtual machine cards,
				 * the default just take the first network card MAC address, if
				 * you want to return all the cards (including physical and
				 * virtual), you can modify the return type is an array or
				 * Collection Loop through for multiple access to the MAC
				 * address.
				 */
				hwaddr = cfg.getHwaddr();
				break;
			}
			return hwaddr != null ? hwaddr : null;
		} catch (Exception e) {
			return null;
		} finally {
			if (sigar != null)
				sigar.close();
		}
	}

	// D) for network traffic and other information
	public void testNetIfList() throws Exception {
		Sigar sigar = new Sigar();
		String ifNames[] = sigar.getNetInterfaceList();
		for (int i = 0; i < ifNames.length; i++) {
			String name = ifNames[i];
			NetInterfaceConfig ifconfig = sigar.getNetInterfaceConfig(name);
			print("\nname =" + name); // network device name
			print("Address =" + ifconfig.getAddress());// IP address
			print("Netmask =" + ifconfig.getNetmask());// subnet mask
			if ((ifconfig.getFlags() & 1L) <= 0L) {
				print("! IFF_UP … skipping getNetInterfaceStat");
				continue;
			}
			try {
				NetInterfaceStat ifstat = sigar.getNetInterfaceStat(name);
				print("RxPackets =" + ifstat.getRxPackets());// number to
																// receive the
																// total package
				print("TxPackets =" + ifstat.getTxPackets());// sent the total
																// number of
																// parcels
				print("RxBytes =" + ifstat.getRxBytes());// total number of
															// bytes received
				print("TxBytes =" + ifstat.getTxBytes());// total number of
															// bytes sent
				print("RxErrors =" + ifstat.getRxErrors());// error packets
															// received
				print("TxErrors =" + ifstat.getTxErrors());// send packets when
															// the number of
															// errors
				print("RxDropped =" + ifstat.getRxDropped());// receiving the
																// number of
																// dropped
																// packets
				print("TxDropped =" + ifstat.getTxDropped());// sent the number
																// of dropped
																// packets
			} catch (SigarNotImplementedException e) {
			} catch (SigarException e) {
				print(e.getMessage());
			}
		}
	}

	void print(String msg) {
		System.out.println(msg);
	}

	// E) other information
	public void getEthernetInfo() {
		Sigar sigar = null;
		try {
			sigar = new Sigar();
			String[] ifaces = sigar.getNetInterfaceList();
			for (int i = 0; i < ifaces.length; i++) {
				NetInterfaceConfig cfg = sigar.getNetInterfaceConfig(ifaces[i]);
				if (NetFlags.LOOPBACK_ADDRESS.equals(cfg.getAddress())
						|| (cfg.getFlags() & NetFlags.IFF_LOOPBACK) != 0
						|| NetFlags.NULL_HWADDR.equals(cfg.getHwaddr())) {
					continue;
				}
				System.out.println("cfg.getAddress () =" + cfg.getAddress());// IP
																				// address
				System.out
						.println("cfg.getBroadcast () =" + cfg.getBroadcast());// gateway
																				// broadcast
																				// address
				System.out.println("cfg.getHwaddr () =" + cfg.getHwaddr());// card
																			// MAC
																			// address
				System.out.println("cfg.getNetmask () =" + cfg.getNetmask());// subnet
																				// mask
				System.out.println("cfg.getDescription () ="
						+ cfg.getDescription());// card descriptions
				System.out.println("cfg.getType () =" + cfg.getType());//
				System.out.println("cfg.getDestination () ="
						+ cfg.getDestination());
				System.out.println("cfg.getFlags () =" + cfg.getFlags());//
				System.out.println("cfg.getMetric () =" + cfg.getMetric());
				System.out.println("cfg.getMtu () =" + cfg.getMtu());
				System.out.println("cfg.getName () =" + cfg.getName());
				System.out.println();
			}
		} catch (Exception e) {
			System.out.println("Error while creating GUID" + e);
		} finally {
			if (sigar != null)
				sigar.close();
		}
	}
}