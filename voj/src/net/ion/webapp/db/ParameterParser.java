package net.ion.webapp.db;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;

public class ParameterParser {
    static final String ThothParamPatternString = "(\\@\\{((\\\\}|[^}])*)\\})(([ ]+[inIN]+[ ]+)([^\\(][\\w]*))*";
    static final Pattern thothParamPattern = Pattern.compile(ThothParamPatternString);
    static final String ConstantParamPatternString = "(\\#\\{((\\\\}|[^}])*)\\})(([ ]+[inIN]+[ ]+)([^\\(][\\w]*))*";
    static final Pattern constantParamPattern = Pattern.compile(ConstantParamPatternString);
    //static final String DefParamPatterString = "\\?" ;
    //static final Pattern defParamPattern = Pattern.compile(DefParamPatterString);
    //static final String PackageParamPatternString = "(v\\_([\\w]+))(([ ]+[inIN]+[ ]+)([^\\(][\\w]*))";
    //static final Pattern packageParamPattern = Pattern.compile(PackageParamPatternString) ;
    
    //static final String ThothEscapePatternString = "\\@\\{(\\\\}|[^}])*\\}" ;
    //static final Pattern thothEscapePattern = Pattern.compile(ThothEscapePatternString);
    //static final String ConstantEscapePatternString = "\\'[^']*\\'" ;
    //static final Pattern constantEscapePattern = Pattern.compile(ConstantEscapePatternString);
    
    public static String getParamList(String sql, List<String[]> paramList, List<String> paramConstantList) {

        Matcher matcher = thothParamPattern.matcher(sql) ;
        while (matcher.find()) {
            String paramName = matcher.group(2).trim() ;
            String paramType = StringUtils.isBlank(matcher.group(6))? "UNKNOWN" :  matcher.group(6).trim().toUpperCase();
            //paramList.add(paramName + ","+ DBUtils.getSqlType(paramType)+ ","+ paramType);
            String[] paramInfo = {paramName,paramType};
            paramList.add(paramInfo);
            sql = StringUtils.replace(sql, matcher.group(0), ":" + paramInfo[0]) ;
        }        
        
	    Matcher cMatcher = constantParamPattern.matcher(sql) ;
	    while (cMatcher.find()) {
	        String paramName = cMatcher.group(2).trim() ;
	        paramConstantList.add(paramName);
	    }        
	    
	    return sql ;
	}
}
