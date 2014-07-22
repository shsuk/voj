package net.ion.webapp.db;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import net.ion.webapp.process.ProcessInitialization;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;

public class DataSourceUtils {
	private static Map<String, DataSource> dataSourceMap = null;
	private static List<DataSource> dataSourceList = null;
	
	public static List<DataSource> getDataSourceList() {
		return dataSourceList;
	}
	public static Map<String, DataSource> getDataSource() {
		return dataSourceMap;
	}
	public static void init(ApplicationContext ctx) throws BeansException {
		//default data source를 먼저 배치한다.
		String dds = ProcessInitialization.getDsName();
		
		if(StringUtils.isNotEmpty(dds)){
			DataSource dataSource = (DataSource) ctx.getBean(dds);
			
			if(dataSource!=null){
				DataSourceUtils.addDataSource(dds, dataSource);
			}			
		}
		
		String[] dataSourcesList = ctx.getBeanNamesForType(DataSource.class);

		for(String dataSourceName : dataSourcesList){
			if(StringUtils.equals(dds, dataSourceName)) continue;
			
			DataSource dataSource = (DataSource) ctx.getBean(dataSourceName);
			DataSourceUtils.addDataSource(dataSourceName, dataSource);
		}
	}

	public static void addDataSource(String id, DataSource datasource) {
		if(dataSourceMap==null) dataSourceMap = new HashMap<String, DataSource>();
		if(dataSourceList==null) dataSourceList = new ArrayList<DataSource>();
		dataSourceMap.put(id, datasource);
		dataSourceList.add(datasource);
	}
	
	public static DataSource getDataSource(String id) throws Exception {
		DataSource dataSource = null;
		
		if(StringUtils.isEmpty(id)) {
			dataSource = dataSourceMap.get(ProcessInitialization.getDsName());
		}else{
			dataSource = dataSourceMap.get(id);
		}
		
		if(dataSource==null){
			throw new Exception(id + " 데이타 소스가 없습니다.");
		}
		
		return dataSource;
	}
}
