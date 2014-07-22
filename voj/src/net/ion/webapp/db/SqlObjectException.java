package net.ion.webapp.db;

import java.util.Arrays;
import java.util.Map;

import org.springframework.core.NestedRuntimeException;

public class SqlObjectException extends NestedRuntimeException{

    private static final long serialVersionUID = 5687354288672226307L;

    @SuppressWarnings("unchecked")
    public SqlObjectException(String sql, Map inParams, Throwable cause){
        super(sql + " : " + inParams.toString(), cause) ;
    }

    public SqlObjectException(String sql, Object[] params, Throwable cause) {
        super(sql + " : " + Arrays.asList(params).toString(), cause);
    }
}
