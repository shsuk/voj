package net.ion.webapp.utils;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Method;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;

import org.apache.commons.lang.StringUtils;
import org.springframework.core.io.ClassPathResource;
import org.springframework.util.ClassUtils;
import org.springframework.util.ReflectionUtils;
import org.springframework.util.ResourceUtils;

public class ClazzUtils {
	public static final Map<String, Class<?>> clazzs = new HashMap<String, Class<?>>(1000) ;
	public static final ClassLoader classLoader = ClassUtils.getDefaultClassLoader() ;


	public static Class<?> getClazz(String type, Class<?> i, String path, String name){
        ClassPathResource root = new ClassPathResource(StringUtils.replace(path, ".", "/"));
        try {
    		if(ResourceUtils.isJarURL(root.getURL())){
    			path = StringUtils.replace(path, ".", "/") ;
    			JarFile jarFile = new JarFile(StringUtils.substringBefore(StringUtils.substringAfter(root.getURL().getFile(), "file:/"), "!")) ;
    			Enumeration<JarEntry> entries = jarFile.entries() ;
    			while(entries.hasMoreElements()){
    				JarEntry entry = entries.nextElement() ;
    				String fileName = entry.getName() ;
    				if(fileName.startsWith(path) && fileName.endsWith(".class")){
                    	Class<?> c = getNamedClass(type, StringUtils.replace(StringUtils.substringBeforeLast(fileName, "/"), "/", "."), name, StringUtils.substringAfterLast(fileName, "/"));
                        if(c!= null && i.isAssignableFrom(c)) return c ;
    				}
    			}
    			return null ;
    		}
            File pluginRootDir = root.getFile() ;
            File[] files = pluginRootDir.listFiles();
            for(File file : files){
                if(file.isDirectory()){
                    Class<?> c = getClazz(type, i, path + "." + file.getName(), name) ;
                    if(c!= null) return c ;
                }else{
                    String fileName = file.getName() ;
                    if(fileName.endsWith(".class")){
                    	Class<?> c = getNamedClass(type, path, name, fileName);
                        if(c!= null && i.isAssignableFrom(c)) return c ;
                    }
                }

            }

        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

	private static Class<?> getNamedClass(String type, String path, String name, String fileName) {
		fileName = StringUtils.substringBeforeLast(fileName, ".class") ;
        if(fileName.equalsIgnoreCase(name) || name.equalsIgnoreCase(StringUtils.substringBefore(fileName, type))){
		    try {
		        Class<?> c = forName(path + "." + fileName) ;
		        if(c == null || c.getPackage() == null) c = forName(path + "." + fileName) ;
		        return c ;
		    } catch (ClassNotFoundException e) {
		        e.printStackTrace();
		    } catch (LinkageError e) {
		        e.printStackTrace();
		    }
		}
		return null;
	}	

	public static Class<?> getClazz(String type, String path, String name){
        ClassPathResource root = new ClassPathResource(StringUtils.replace(path, ".", "/"));
        try {
    		if(ResourceUtils.isJarURL(root.getURL())){
    			path = StringUtils.replace(path, ".", "/") ;
    			JarFile jarFile = new JarFile(StringUtils.substringBefore(StringUtils.substringAfter(root.getURL().getFile(), "file:/"), "!")) ;
    			Enumeration<JarEntry> entries = jarFile.entries() ;
    			while(entries.hasMoreElements()){
    				JarEntry entry = entries.nextElement() ;
    				String fileName = entry.getName() ;
    				if(fileName.startsWith(path) && fileName.endsWith(".class")){
                    	Class<?> c = getStaticNamedClass(type, StringUtils.replace(StringUtils.substringBeforeLast(fileName, "/"), "/", "."), name, StringUtils.substringAfterLast(fileName, "/"));
                        if(c!= null) return c ;
    				}
    			}
    			return null ;
    		}
            File pluginRootDir = root.getFile() ;
            File[] files = pluginRootDir.listFiles();
            for(File file : files){
                if(file.isDirectory()){
                    Class<?> c = getClazz(type, path + "." + file.getName(), name) ;
                    if(c!= null) return c ;
                }else{
                    String fileName = file.getName() ;
                    if(fileName.endsWith(".class")){
                    	Class<?> c = getStaticNamedClass(type, path, name, fileName);
                        if(c!= null){
                        	return c ;
                        }
                    }
                }

            }

        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

	public static String getVersionClazzName(String path, String name){
        ClassPathResource root = new ClassPathResource(StringUtils.replace(path, ".", "/"));
        name = name + "V" ;
        Integer idx = 1 ;
        try {
            File packagePath = root.getFile() ;
            File[] files = packagePath.listFiles();
            for(File file : files){
                String fileName = file.getName() ;
                if(fileName.startsWith(name) && fileName.endsWith(".class") ){
                	String ver = StringUtils.substringBetween(fileName, name, ".class") ;
                	if(StringUtils.isNotEmpty(ver) && StringUtils.isNumeric(ver) && new Integer(ver) > idx){
                		idx = new Integer(ver) ;
                	}
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return name + idx;
    }

	private static Class<?> getStaticNamedClass(String type, String path, String name, String fileName) {
		fileName = StringUtils.substringBeforeLast(fileName, ".class") ;
        if(fileName.equalsIgnoreCase(name + type)){
		    try {
		        Class<?> c = forName(path + "." + fileName) ;
		        if(c == null || c.getPackage() == null) c = forName(path + "." + fileName) ;
		        if(c != null){
                	Integer idx = 0 ;
                    ClassPathResource root = new ClassPathResource(StringUtils.replace(path, ".", "/"));
                    File packagePath = root.getFile() ;
                    File[] files = packagePath.listFiles();
                    for(File vfile : files){
                        String vfileName = vfile.getName() ;
                        if(vfileName.startsWith(c.getSimpleName()) && vfileName.endsWith(".class") ){
                        	String ver = StringUtils.substringBetween(vfileName, c.getSimpleName() + "V", ".class") ;
                        	if(StringUtils.isNotEmpty(ver) && StringUtils.isNumeric(ver) && new Integer(ver) > idx){
                        		idx = new Integer(ver) ;
                        	}
                        }
                    }
		        }
		        return c ;
		    } catch (ClassNotFoundException e) {
		        e.printStackTrace();
		    } catch (LinkageError e) {
		        e.printStackTrace();
		    } catch (IOException e) {
				e.printStackTrace();
			}
		}
		return null;
	}

	public static Class<?> forName(String name) throws ClassNotFoundException, LinkageError {
		if(!clazzs.containsKey(name)){
			Class<?> cls = ClassUtils.forName(name, classLoader) ;
			clazzs.put(name, cls) ;
			return cls ;
		}
		return clazzs.get(name);
	}	
	

	public static void reloadClass(String name, Class<?> cls) {
		clazzs.put(name, cls) ;
	}

	public static boolean isAssignableFrom(Class<?> i,	Class<?> cls) {
		for(Class<?> c : cls.getInterfaces()){
			if(i.getName().equals(c.getName())) return true ;
		}
		return false;
	}

	public static Object execute(Method exe, Object target, Object...args) {
		return ReflectionUtils.invokeMethod(exe, target, args) ;
	}

	public static Method findMethod(Class<?> cls, String methodName, int paramSize) {
		Class<?> searchType = cls;
		while (searchType != null ) {
			Method[] methods = (searchType.isInterface() ? searchType.getMethods() : searchType.getDeclaredMethods());
			for (Method method : methods) {
				if (methodName.equals(method.getName())	&& (method.getParameterTypes().length == paramSize)) {
					return method;
				}
			}
			searchType = searchType.getSuperclass();
		}
		return null;
	}

	public static Method findMethod(Class<?> cls, String methodName, Class<?>... paramTypes) {
		Class<?> searchType = cls;
		while (searchType != null ) {
			Method[] methods = (searchType.isInterface() ? searchType.getMethods() : searchType.getDeclaredMethods());
			for (Method method : methods) {
				if (methodName.equals(method.getName())	&& (method.getParameterTypes().length == paramTypes.length)) {
					for(Class<?> paramType : paramTypes){
						for(Class<?> mp : method.getParameterTypes()){
							if(paramType.getName().equals(mp.getName())) return method ;
						}
					}
				}
			}
			searchType = searchType.getSuperclass();
		}
		return null;
	}	
}
