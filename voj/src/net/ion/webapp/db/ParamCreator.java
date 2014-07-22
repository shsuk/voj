package net.ion.webapp.db;

import java.lang.reflect.Field;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import oracle.jdbc.pool.OracleDataSource;

import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.core.support.SqlLobValue;
import org.springframework.jdbc.support.lob.OracleLobHandler;

public class ParamCreator {

	private static SimpleDateFormat DateFormater = new SimpleDateFormat("yyyyMMdd HHmmss");

	public static Map<String, Object> createParamMapFromMap(DataSource dataSource, List<? extends SqlParameter> declaredParams, Map<String, Object> paramMap) {
        Map<String, Object> inParams = new LinkedHashMap<String, Object>();
		for (int i = 0; i < declaredParams.size(); i++) {
			SqlParameter declaredParam = (SqlParameter) declaredParams.get(i);
			inParams.put(declaredParam.getName(), convertValueToSqlType(dataSource, declaredParam, paramMap.get(declaredParam.getName())));
		}
		return inParams;
	}

    public static Map<String, Object> createParamMapFromArray(DataSource dataSource, List<? extends SqlParameter> declaredParams, Object[] params) {
        Map<String, Object> inParams = new LinkedHashMap<String, Object>();
        for (int i = 0; i < declaredParams.size(); i++) {
            SqlParameter delaredParam = (SqlParameter) declaredParams.get(i);
            inParams.put(delaredParam.getName() , convertValueToSqlType(dataSource, delaredParam, params[i])) ;

        }
        return inParams;
    }


	public static Object convertValueToSqlType(DataSource dataSource, Field field, Object value) {
		return convertValueToSqlType(null,field,value);
	}


	public static Object convertValueToSqlType(DataSource dataSource, SqlParameter parameter, Object value) {
        if (value==null) return null;
	    
	    if(parameter.getSqlType() == Types.CHAR && value instanceof Boolean){
            value = (Boolean) value ? "T" : "F";
        }
	    
	    if(parameter.getSqlType() == Types.VARCHAR && value instanceof Date){
        	value = DateFormater.format((Date)value);
        }

        switch (parameter.getSqlType()) {
        case Types.CLOB:
            if (value instanceof String) {
                if(dataSource instanceof OracleDataSource){
                    return new SqlLobValue((String) value, new OracleLobHandler());
                }
                return new SqlLobValue((String) value);
            }
        case Types.BLOB:
            if (value instanceof byte[]) {
                if(dataSource instanceof OracleDataSource){
                    return new SqlLobValue((byte[]) value, new OracleLobHandler());
                }
                return new SqlLobValue((byte[]) value) ;
            }            
        case Types.FLOAT:
            return new Float( String.valueOf(value) );
        default:
            return value;
        }

	}


//	public static Object convertValueToRequiredType(Object value, Class<?> requiredType) {
//		if (String.class.equals(requiredType)) {
//			return value.toString();
//		} else if (Number.class.isAssignableFrom(requiredType)) {
//			if (value instanceof Number) {
//				// Convert original Number to target Number class.
//				return NumberUtils.convertNumberToTargetClass(((Number) value), requiredType);
//			} else {
//				// Convert stringified value to target Number class.
//				return NumberUtils.parseNumber(value.toString(), requiredType);
//			}
//		} else {
//			throw new IllegalArgumentException("Value [" + value + "] is of type [" + value.getClass().getName()
//					+ "] and cannot be converted to required type [" + requiredType.getName() + "]");
//		}
//	}

}
