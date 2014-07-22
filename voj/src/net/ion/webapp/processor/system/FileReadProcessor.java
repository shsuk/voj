package net.ion.webapp.processor.system;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.ion.webapp.process.ProcessInfo;
import net.ion.webapp.process.ReturnValue;
import net.ion.webapp.processor.ImplProcessor;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

import au.com.bytecode.opencsv.CSVReader;

@Service
public class FileReadProcessor extends ImplProcessor{

    public ReturnValue execute(ProcessInfo processInfo, HttpServletRequest request, HttpServletResponse response)throws Exception{
        ReturnValue returnValue = new ReturnValue();
        String path = processInfo.getString("path");
        String type = processInfo.getString("type");

        String separator = processInfo.getString("separator", ",");
        String escChr = processInfo.getString("escChr", "\"");
        String charset = processInfo.getString("charset", "euc-kr");
        String columnNames = processInfo.getString("columnName","");
        File sf = new File(path);
        
        if(!sf.exists()){
        	throw new Exception((new StringBuilder("File not found : ")).append(path).toString());
        }
        
        
        if("string".equalsIgnoreCase(type)){
            returnValue.setResult(FileUtils.readFileToString(sf, charset));
            return returnValue;
        }else if("line".equalsIgnoreCase(type)){
            returnValue.setResult(FileUtils.readLines(sf, charset));
            return returnValue;
        }
        
        returnValue.setResult(read(sf, type, separator, escChr, charset, columnNames));
        return returnValue;
    }
    
    private static List read(File f, String type, String separator, String escChr, String charset, String columnNames) throws Exception{
        
        FileInputStream fis = new FileInputStream(f);
        CSVReader reader = new CSVReader(new InputStreamReader(fis, charset),separator.charAt(0), escChr.charAt(0));
        List<String[]> list = reader.readAll();

        if("list".equalsIgnoreCase(type)){
            return list;
        }

        String[] fNames;
        int sidx = 0;
        
        if(StringUtils.isNotEmpty(columnNames)){
        	fNames = StringUtils.splitByWholeSeparator(columnNames.toLowerCase(), separator);
        }else{
        	fNames = list.get(0);
        	sidx = 1;
        	for(int i=0;i<fNames.length;i++){
        		fNames[i] = fNames[i].toLowerCase();
        	}
        }
        
        int k = fNames.length;
        List<Map<String, Object>> rows = new ArrayList<Map<String, Object>>();
        
        for(int i = sidx; i < list.size(); i++){
            if(list.get(i).length<1) break;
            
            String vals[] = list.get(i);
            
            if(fNames.length != vals.length){
            	throw new Exception((new StringBuffer("Format error : line ")).append(i + 1).toString());
            }
            
            Map<String, Object> row = new HashMap<String, Object>();

            for(int j = 0; j < k; j++) {
                row.put(fNames[j], vals[j]);
            }

            rows.add(row);
        }

        return rows;
    }
    
    public static List<Map<String, Object>> readRows(File f, String separator, String escChr, String charset, String columnNames) throws Exception{
    	return (List<Map<String, Object>>)read(f, "", separator, escChr, charset, columnNames);
    }
    
    public static List<String[]> readList(File f, String separator, String escChr, String charset, String columnNames) throws Exception{
    	return (List<String[]>)read(f, "list", separator, escChr, charset, columnNames);
    }
}
