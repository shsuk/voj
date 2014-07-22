package net.ion;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;

import org.hyperic.sigar.cmd.Df;
import org.hyperic.sigar.cmd.Shell;

public class Test {

	/**
	 * @param args
	 */
	public static void main(String[] args)throws Exception {
		String format = "%s|%s|%s|%s|%s|%s|%s";
		
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		PrintStream ps = new PrintStream(baos);
		Shell shell = new Shell();
		shell.init("sigar", ps, ps);
		
		try {
			Df df = new Df(shell);
			df.setOutputFormat(format);
			df.processCommand(args);
			
			String data = baos.toString();
			
			System.out.println(data);
			
		} catch (Exception e) {
			e.printStackTrace();
		}


	}

}
