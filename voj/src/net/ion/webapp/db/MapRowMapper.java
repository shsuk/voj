package net.ion.webapp.db;

import java.sql.Clob;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Date;

import net.ion.webapp.utils.LowerCaseMap;

import org.springframework.jdbc.core.simple.ParameterizedRowMapper;

class MapRowMapper implements ParameterizedRowMapper<LowerCaseMap<String, Object>> {

	@Override
	public LowerCaseMap<String, Object> mapRow(ResultSet rs, int rowNum) throws SQLException {
		
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
		return map;
	}
}
