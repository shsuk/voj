package net.ion.webapp.db;

import java.util.List;
import java.util.Map;

import javax.sql.DataSource;


public interface SqlObject<T> {
	public static final String RESULT = "RESULT" ;
	public List<?> getDeclaredInputParameters();
    public T execute(Object... params);
    public T executeMap(Map<String,Object> params);
    
    public void setDataSource( DataSource ds );
}
