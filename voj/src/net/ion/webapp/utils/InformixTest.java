package net.ion.webapp.utils;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Properties;

public class InformixTest
{
	public static void main( String[] args)
	{
		test();
	}		
	public static void test()
	{
		Connection conn = null;
		String sql = "";			
		//ResultSet rset = null;
		Statement stmt = null;
		
		try {
		    Properties props = new Properties();
		    props.put("charSet", "8859_1");
			Class.forName("com.informix.jdbc.IfxDriver").newInstance();
			String url = "jdbc:informix-sqli://10.20.26.101:7500/kbsda:informixserver=kbsdasvr;user=phj;password=phj";
		    conn = DriverManager.getConnection(url, props);
		    DatabaseMetaData dmd = conn.getMetaData();
		    ResultSet rs = dmd.getTables("kbsda", null, null, null);
		    int cnt = rs.getMetaData().getColumnCount()+1;
		    while(rs.next()){ 
		    	for(int i=1; i<cnt; i++){
		    		System.out.print(rs.getString(i));
		    		System.out.print(",\t");
		    	}
		    	System.out.println(rs.getString(2));
		    }

		    stmt = conn.createStatement();
		    sql = "select   * from kbsarchivetape ";
		    rs = stmt.executeQuery(sql);
		    cnt = rs.getMetaData().getColumnCount()+1;
		    int n=0;
		    while(rs.next()){
		    	n++;
		    	for(int i=1; i<cnt; i++){
		    		String val = rs.getString(i);
		    		System.out.print(new String(val.getBytes(),"iso-8859-1"));
		    		System.out.print(",\t");
		    	}
		    	System.out.println(rs.getString(2));
		    	if(n>10) break;
		    }
		    stmt.close();
            conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		    System.out.println("FAILED: failed to close the connection!");
		} finally {
			try{
				stmt.close();
				conn.close();
			} catch(Exception ex){}
		}
	}	
	
	
}

