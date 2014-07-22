package net.ion.webapp.utils;

import java.sql.Clob;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import com.sun.org.apache.bcel.internal.generic.ARRAYLENGTH;

import net.ion.webapp.db.DataSourceUtils;
import net.ion.webapp.processor.system.DbProcessor;

public class DbUtils {
	@SuppressWarnings("unchecked")
	public static List<LowerCaseMap<String, Object>> select(String queryPath, Map<String, Object> sourceDate, String dataSourceName, boolean isCache, int refreshTime) throws Exception {
		return (List<LowerCaseMap<String, Object>> )DbProcessor.execute(null, queryPath, sourceDate, isCache, refreshTime);
	}
	
	public static List<LowerCaseMap<String, Object>> select(String queryPath, Map<String, Object> sourceDate, boolean isCache, int refreshTime) throws Exception {
		return select(queryPath, sourceDate, null, false, 0);
	}
	
	public static List<LowerCaseMap<String, Object>> select(String queryPath, Map<String, Object> sourceDate, String dataSourceName) throws Exception {
		return select(queryPath, sourceDate, dataSourceName, false, 0);
	}

	public static List<LowerCaseMap<String, Object>> select(String queryPath, Map<String, Object> sourceDate) throws Exception {
		return select(queryPath, sourceDate, null);
	}

	public static int update(String queryPath, Map<String, Object> sourceDate, String dataSourceName) throws Exception {
		Object obj = DbProcessor.execute(dataSourceName, queryPath, sourceDate, false, 0);
		
		if (obj instanceof List) {
			int count = 0;
			
			List list = (List) obj;
			
			for(Object o : list){
				if (o instanceof Integer) {
					count += ((Integer)o).intValue();
				}
			}
			return count;
		}else{
			return ((Integer)obj).intValue();
		}
		
	}
	
	public static int update(String queryPath, Map<String, Object> sourceDate) throws Exception {
		return update(queryPath, sourceDate, null);
	}
	
	public static int update(String queryPath, List<Map<String, Object>> sourceDateList, String dataSourceName) throws Exception {
		int count = 0;
		for(Map<String, Object>sourceDate : sourceDateList){
			count += (Integer)DbProcessor.execute(dataSourceName, queryPath, sourceDate, false, 0);
		}
		return count;
	}
	
	public static int update(String queryPath, List<Map<String, Object>> sourceDateList) throws Exception {
		return update(queryPath, sourceDateList, null);
	}
	
	public static List<Map<String, Object>> getTable(String dataSourceName) throws Exception {
		DataSource ds = DataSourceUtils.getDataSource(dataSourceName);
		Connection con = null;
		ResultSet rs = null;
		List<Map<String, Object>> rows = null;

		try {
			
			con = ds.getConnection();
			DatabaseMetaData dbmd = con.getMetaData();
			
			rs = dbmd.getTables(null, "ISLIM", null, new String[] {"TABLE"});
			rows = getRows(rs);
			
			
		}finally{
			try {
				if(rs!=null){
					rs.close();
				}
			} catch (Exception e) { }

			try {
				if(con!=null){
					con.close();
				}
			} catch (Exception e) { }
		}
		
		return rows;
		
	}
	public static List<Map<String, Object>> getColumns(String dataSourceName, String tableName) throws Exception {
		DataSource ds = DataSourceUtils.getDataSource(dataSourceName);
		Connection con = null;
		ResultSet rs = null;
		List<Map<String, Object>> rows = null;
		
		try {
			
			con = ds.getConnection();
			DatabaseMetaData dbmd = con.getMetaData();
			
			rs = dbmd.getColumns(null, "ISLIM", tableName, null);
			rows = getRows(rs);

		}finally{
			try {
				if(rs!=null){
					rs.close();
				}
			} catch (Exception e) { }

			try {
				if(con!=null){
					con.close();
				}
			} catch (Exception e) { }
		}
		
		return rows;
		
	}
	
	public static List<Map<String, Object>> getPrimaryKeys(String dataSourceName, String tableName) throws Exception {
		DataSource ds = DataSourceUtils.getDataSource(dataSourceName);
		Connection con = null;
		ResultSet rs = null;
		List<Map<String, Object>> rows = null;
		
		try {
			
			con = ds.getConnection();
			DatabaseMetaData dbmd = con.getMetaData();
			
			rs = dbmd.getPrimaryKeys(null, "ISLIM", tableName);
			rows = getRows(rs);

		}finally{
			try {
				if(rs!=null){
					rs.close();
				}
			} catch (Exception e) { }

			try {
				if(con!=null){
					con.close();
				}
			} catch (Exception e) { }
		}
		
		return rows;
	}
	
	private static List<Map<String, Object>> getRows(ResultSet rs) throws Exception {
		
		List<Map<String, Object>> rows = new ArrayList<Map<String, Object>>();
		
		while(rs.next()){
			
			LowerCaseMap<String, Object> map = new LowerCaseMap<String, Object>();
			ResultSetMetaData rsmd = rs.getMetaData();
			int count = rsmd.getColumnCount()+1;

			for(int i=1; i<count; i++){
				Object val = rs.getObject(i);
				if(val instanceof Clob) val = ((Clob) val).toString();
				else if(val instanceof Date){
					val = rs.getTimestamp(i);
				}

				map.put(rsmd.getColumnName(i), val);
			}
			
			rows.add(map);
		}
		
		return rows;
	}
}
