package net.ion.webapp.db;

import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.object.SqlCall;

public class SqlFunction<T> extends SqlCall implements SqlObject<T>{
	public SqlFunction(DataSource ds, String sql, List<SqlParameter> paramList, SqlOutParameter returnType) {
    	this(sql, paramList, returnType) ;
    	setDataSource(ds) ;
        compile() ;
    }

    public SqlFunction(String sql, List<SqlParameter> paramList, SqlOutParameter returnType) {
        setFunction(true) ;
		sql = "{? = call " + sql + "}";
		setSql(sql) ;
        setSqlReadyForUse(true) ;

        declareParameter(returnType) ;
        for(SqlParameter param : paramList){
            declareParameter(param);
        }
    }
    
    public Map<String, Object> execute(Map<String, ?> inParams){
        try {
    		validateParameters(inParams.values().toArray());
    		return getJdbcTemplate().call(newCallableStatementCreator(inParams), getDeclaredParameters());
    	} catch (DataAccessException e) {
            throw new SqlObjectException(getSql(), inParams, e) ;
        }
    }

	@SuppressWarnings("unchecked")
	public T execute(Object... params){
		Map<String, Object> result = execute(ParamCreator.createParamMapFromArray(getJdbcTemplate().getDataSource(), getDeclaredInputParameters(), params)) ;
        return  (T) result.get(RESULT) ;
    }

    @SuppressWarnings("unchecked")
	public T executeMap(Map<String, Object> params) {
        Map result = execute(ParamCreator.createParamMapFromMap(getJdbcTemplate().getDataSource(), getDeclaredInputParameters(), params)) ;
        return  (T) result.get(RESULT) ;
    }

    public List<SqlParameter> getDeclaredInputParameters() {
		List<SqlParameter> delaredParams = getDeclaredParameters() ;
		return delaredParams.subList(1, delaredParams.size());
	}
	
	@Override
	protected boolean allowsUnusedParameters() {
		return true;
	}

}
