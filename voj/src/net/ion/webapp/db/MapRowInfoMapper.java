package net.ion.webapp.db;

import java.sql.Clob;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.ion.webapp.utils.LowerCaseMap;

import org.apache.commons.io.IOUtils;
import org.springframework.jdbc.core.simple.ParameterizedRowMapper;

class MapRowInfoMapper implements ParameterizedRowMapper<LowerCaseMap<String, Object>> {

	@Override
	public LowerCaseMap<String, Object> mapRow(ResultSet rs, int rowNum) throws SQLException {
		LowerCaseMap<String, Object> map = new LowerCaseMap<String, Object>();
		ResultSetMetaData rsmd = rs.getMetaData();
		int count = rsmd.getColumnCount()+1;
		
		for(int i=1; i<count; i++){
			Object val = rs.getObject(i);
			//rs.getDate(i);
			if(val instanceof Clob){
				Clob clob = (Clob) val;
				try {
					@SuppressWarnings("unchecked")
					List<String> ls = IOUtils.readLines(clob.getCharacterStream());
					StringBuffer sb = new StringBuffer();
					for(String s : ls){
						sb.append('\n').append(s);
					}
					val = sb.toString().trim();
				} catch (Exception e) {}
			}else if(val instanceof Date){
				val = rs.getTimestamp(i);
			}
			map.put(rsmd.getColumnName(i), val);
		}
		
		if(rowNum!=0) return map;
		
		List<Map<String, Object>> cols = new ArrayList<Map<String,Object>>();
		Map<String, Map<String, Object>> cols2 = new HashMap<String,Map<String,Object>>();
		for(int i=1; i<count; i++){
			LowerCaseMap<String, Object> colInfo = new LowerCaseMap<String, Object>();
			String name = rsmd.getColumnName(i).toLowerCase();
			colInfo.put("name", name);
			colInfo.put("text", rsmd.getColumnLabel(i)); 
			colInfo.put("type", rsmd.getColumnType(i));
			colInfo.put("class_name", rsmd.getColumnClassName(i));
			colInfo.put("type_name", rsmd.getColumnTypeName(i));
			colInfo.put("precision", rsmd.getPrecision(i));
			colInfo.put("scale", rsmd.getScale(i));
			colInfo.put("nullable", rsmd.isNullable(i));
			cols.add(colInfo);
			cols2.put(name, colInfo);
		}
		
		LowerCaseMap<String, Object> table_meta_data = new LowerCaseMap<String, Object>();
		table_meta_data.put("cols", cols);
		table_meta_data.put("cols2", cols2);
		map.put("table_meta_data", table_meta_data);
		
		return map;
	}
}
