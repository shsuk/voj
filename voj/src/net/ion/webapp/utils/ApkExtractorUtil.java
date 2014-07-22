package net.ion.webapp.utils;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintStream;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;

import android.content.res.AXmlResourceParser;

public class ApkExtractorUtil{
	
	public static void main(String[] args) {
		String path="N:/com.nhn.android.ndrive.apk";
		String manifestPath="N:/com.nhn.android.ndrive.AndroidManifest.xml";
		
		ApkExtractorUtil ex = new ApkExtractorUtil();
		try {
			ex.extract(path, manifestPath);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public void extract(String path, String manifestPath)throws Exception {
    
    	
		String package_nm = null ;
		File apk = new File(path) ;
        JarFile jar = null;
        PrintStream out = null ;
        InputStream in = null ;
        try {
        	File manifest = new File(manifestPath) ;
        	if(!manifest.getParentFile().exists()){
        		manifest.getParentFile().mkdirs() ;
        	}
        	out = new PrintStream(new FileOutputStream(manifest)) ;
            jar = new JarFile(apk);
            JarEntry entry = jar.getJarEntry("AndroidManifest.xml") ;
            in = jar.getInputStream(entry) ;
		
	    	AXmlResourceParser parser;
	        StringBuilder indent;
	        parser = new AXmlResourceParser();
	        parser.open(in);
	        indent = new StringBuilder(10);
//    	        String indentStep = "\t";
	        int type;

			while(true){
				type = parser.next();
		        if(type == 1) break ;
		        switch(type)
		        {
		        case 0: // '\0'
		            log("<?xml version=\"1.0\" encoding=\"utf-8\"?>", new Object[0], out);
		            break;
	
		        case 2: // '\002'
		            log("%s<%s%s", new Object[] {
		                indent, getNamespacePrefix(parser.getPrefix()), parser.getName()
		            }, out);
		            indent.append("\t");
		            int namespaceCountBefore = parser.getNamespaceCount(parser.getDepth() - 1);
		            int namespaceCount = parser.getNamespaceCount(parser.getDepth());
		            for(int i = namespaceCountBefore; i != namespaceCount; i++)
		                log("%sxmlns:%s=\"%s\"", new Object[] {
		                    indent, parser.getNamespacePrefix(i), parser.getNamespaceUri(i)
		                }, out);
	
		            for(int i = 0; i != parser.getAttributeCount(); i++){
		            	String attrName =parser.getAttributeName(i)  ;
		            	String attrValue = getAttributeValue(parser, i) ;
		            	if("package".equals(attrName) && package_nm == null){
		            		package_nm = attrValue ;
		            	}
		                log("%s%s%s=\"%s\"", new Object[] {
		                    indent, getNamespacePrefix(parser.getAttributePrefix(i)), parser.getAttributeName(i), getAttributeValue(parser, i)
		                }, out);
		            }
		            log("%s>", new Object[] {
		                indent
		            }, out);
		            break;
	
		        case 3: // '\003'
		            indent.setLength(indent.length() - "\t".length());
		            log("%s</%s%s>", new Object[] {
		                indent, getNamespacePrefix(parser.getPrefix()), parser.getName()
		            }, out);
		            break;
	
		        case 4: // '\004'
		            log("%s%s", new Object[] {
		                indent, parser.getText()
		            }, out);
		            break;
		        }
			}
    	
	        
        }finally{
            if(jar != null) try {jar.close() ;} catch (IOException e) {}
			if(in != null){
				try {in.close() ;} catch (IOException e) {}
			}
			if(out != null){
				out.close() ;
			}
        }
    }

    private static String getNamespacePrefix(String prefix)
    {
        if(prefix == null || prefix.length() == 0)
            return "";
        else
            return (new StringBuilder(String.valueOf(prefix))).append(":").toString();
    }

    private static String getAttributeValue(AXmlResourceParser parser, int index)
    {
        int type = parser.getAttributeValueType(index);
        int data = parser.getAttributeValueData(index);
        if(type == 3)
            return parser.getAttributeValue(index);
        if(type == 2)
            return String.format("?%s%08X", new Object[] {
                getPackage(data), Integer.valueOf(data)
            });
        if(type == 1)
            return String.format("@%s%08X", new Object[] {
                getPackage(data), Integer.valueOf(data)
            });
        if(type == 4)
            return String.valueOf(Float.intBitsToFloat(data));
        if(type == 17)
            return String.format("0x%08X", new Object[] {
                Integer.valueOf(data)
            });
        if(type == 18)
            return data == 0 ? "false" : "true";
        if(type == 5)
            return (new StringBuilder(String.valueOf(Float.toString(complexToFloat(data))))).append(DIMENSION_UNITS[data & 0xf]).toString();
        if(type == 6)
            return (new StringBuilder(String.valueOf(Float.toString(complexToFloat(data))))).append(FRACTION_UNITS[data & 0xf]).toString();
        if(type >= 28 && type <= 31)
            return String.format("#%08X", new Object[] {
                Integer.valueOf(data)
            });
        if(type >= 16 && type <= 31)
            return String.valueOf(data);
        else
            return String.format("<0x%X, type 0x%02X>", new Object[] {
                Integer.valueOf(data), Integer.valueOf(type)
            });
    }

    private static String getPackage(int id)
    {
        if(id >>> 24 == 1)
            return "android:";
        else
            return "";
    }

    private static void log(String format, Object arguments[], PrintStream out)
    {
    	out.printf(format, arguments);
    	out.println();
    }

    public static float complexToFloat(int complex)
    {
        return (float)(complex & 0xffffff00) * RADIX_MULTS[complex >> 4 & 3];
    }

    private static final float RADIX_MULTS[] = {
        0.00390625F, 3.051758E-005F, 1.192093E-007F, 4.656613E-010F
    };
    private static final String DIMENSION_UNITS[] = {
        "px", "dip", "sp", "pt", "in", "mm", "", ""
    };
    private static final String FRACTION_UNITS[] = {
        "%", "%p", "", "", "", "", "", ""
    };
}
