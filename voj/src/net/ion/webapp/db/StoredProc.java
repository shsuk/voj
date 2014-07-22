package net.ion.webapp.db;

import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

import oracle.jdbc.OracleTypes;

import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.object.StoredProcedure;

public class StoredProc extends StoredProcedure{

	private Map<String, Object> paramMap;

	public StoredProc(DataSource ds, String spName)
	{
		super(ds, spName);
	}
	
	public Map<String, Object> getParamMap() {
		if (paramMap == null)
			paramMap = new HashMap<String, Object>();
		return paramMap;
	}
	
	public StoredProc addParam(String name, int paramType, Object value) {
		declareParameter(new SqlParameter(name, paramType));
		getParamMap().put(name, value);
		return this;
	}
	
	public StoredProc addStrParam(String name, String value) {
		return addParam(name, OracleTypes.VARCHAR, value);
	}
	
	public StoredProc addIntParam(String name, Integer value) {
		return addParam(name, OracleTypes.INTEGER, value);
	}
	
	public StoredProc addLongParam(String name, Long value) {
		return addParam(name, OracleTypes.NUMBER, value);
	}
	
	public StoredProc addDoubleParam(String name, Double value) {
		return addParam(name, OracleTypes.NUMBER, value);
	}
	
	public StoredProc addOutParam(String name, int paramType) {
		declareParameter(new SqlOutParameter(name, paramType));
		return this;
	}
	
	public Map exec() {
		return execute(getParamMap());
	}

}
