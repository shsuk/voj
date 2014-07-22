package kr.or.voj.webapp.utils;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Map;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.JdbcUtils;

public class DefaultMapRowMapper implements RowMapper {
	public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
		ResultSetMetaData rsmd = rs.getMetaData();
		int columnCount = rsmd.getColumnCount();
		Map mapOfColValues = new DefaultLowerCaseMap();
		for (int i = 1; i <= columnCount; ++i) {
			String key = getColumnKey(JdbcUtils.lookupColumnName(rsmd, i));
			Object obj = getColumnValue(rs, i);
			mapOfColValues.put(key, obj);
		}
		return mapOfColValues;
	}

	protected String getColumnKey(String columnName) {
		return columnName;
	}

	protected Object getColumnValue(ResultSet rs, int index) throws SQLException {
		return JdbcUtils.getResultSetValue(rs, index);
	}
}