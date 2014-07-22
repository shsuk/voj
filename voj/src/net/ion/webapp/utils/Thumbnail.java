package net.ion.webapp.utils;

import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.geom.AffineTransform;
import java.awt.image.AffineTransformOp;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.UUID;

import javax.imageio.ImageIO;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;

import com.sun.jimi.core.Jimi;
import com.sun.jimi.core.JimiUtils;


/**
 * 윈도우가 아닌 경우 설정
 * -Djava.awt.headless=true
 * @author shsuk
 *
 */
public class Thumbnail {
	static String exts = ".gif.jpg.jpeg.bmp.tif";


	public static synchronized boolean  createThumbnail(InputStream ois, String newPath, int maxDim, String ext) {
		if(exts.indexOf(ext)<0) return false;
		if(jimiThumbnail(ois, newPath, maxDim, ext)){
			return true;
		}
		
		return myThumbnail(ois, newPath, maxDim, ext);
	}
	
	private static boolean myThumbnail(InputStream ois, String newPath, int maxDim, String ext) {
		InputStream is =null;
		
		try {
			createThumbnail(ois, newPath, maxDim);
			
		} catch (Exception e) {
			// TODO: handle exception
		}
		
		return true;		
	}
	
	private static boolean jimiThumbnail(InputStream ois, String newPath, int maxDim, String ext) {
		InputStream is = null;
		OutputStream os = null;
		String tFileName = UUID.randomUUID() + ext;
		File tFile = new File(tFileName);
		
		try {
			os = new FileOutputStream(tFile);
			IOUtils.copy(ois, os);
			
			is = new FileInputStream(tFile);
			Image image = JimiUtils.getThumbnail(is, maxDim , maxDim , Jimi.IN_MEMORY);
			
			Jimi.putImage(image, newPath);
		} catch (Exception e) {
			return false;
		}finally{
			try {
				if(is!=null) is.close();
			} catch (Exception e2) {
				is = null;
			}
			try {
				tFile.delete();
			} catch (Exception e2) {
				tFile = null;
			}
		}
		return true;
	}

	private static boolean createThumbnail(InputStream is,String newPath, int maxDim) {
		
		try {

			File fo = new File(newPath);
			String path = fo.getParent();

			File fp = new File(path);
	        if (!fp.exists()) {
	        	fp.mkdirs();
	        }

			BufferedImage inImage = ImageIO.read(is);
			if(inImage==null) return false;
			double scale = (double) maxDim / (double) inImage.getHeight(null);
			if (inImage.getWidth(null) > inImage.getHeight(null)) {
				scale = (double) maxDim / (double) inImage.getWidth(null);
			}
			if(scale > 1) scale = 1;
			
			AffineTransform affineTransform = AffineTransform.getScaleInstance(scale,scale);
			
			AffineTransformOp affineTransformOp = new AffineTransformOp(affineTransform, null);
			//AffineTransformOp affineTransformOp = new AffineTransformOp(affineTransform, new RenderingHints(RenderingHints.KEY_COLOR_RENDERING, RenderingHints.VALUE_RENDER_QUALITY));
			//AffineTransformOp affineTransformOp = new AffineTransformOp(affineTransform, new RenderingHints(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON));
			

			
	        BufferedImage outImage = affineTransformOp.filter(inImage,null);
	        
	        int scaledWidth = outImage.getWidth();
	        int scaledHeight = outImage.getHeight();
	        
	        int expectedWidth = (int)(inImage.getWidth(null) * scale);
	        int expectedHeight = (int)(inImage.getHeight(null) * scale);
	        if ( scaledWidth > expectedWidth || scaledHeight > expectedHeight )
	        	outImage = outImage.getSubimage(0,0,expectedWidth,expectedHeight);

			// JPEG-encode the image
			// and write to file.
            File f = new File(newPath);
            String fileExt = newPath.substring(newPath.lastIndexOf('.')+1);
            ImageIO.write(outImage, fileExt, f);
		} catch (IOException e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}
	private static byte[] getByteArrayUpoadFile(InputStream stream) throws IOException
    {

            ByteArrayOutputStream baos=new ByteArrayOutputStream();

            int bytesRead=0;
            byte[] buffer=new byte[8192];
            while((bytesRead=stream.read(buffer, 0, 8192)) != -1)
            {
            	baos.write(buffer, 0, bytesRead);
            }
            return baos.toByteArray();
        
    }
	
    public static void main(String[] args) throws Exception{
    	String orgPath = "D:\\eclipse-jee-juno\\eclipse\\d2a724d2-0707-4916-bfba-f75d62541e2e.png";
    	String newPath = "D:\\eclipse-jee-juno\\eclipse\\aa.jpg";
		FileInputStream fis = new FileInputStream(new File(orgPath));
		Image image = JimiUtils.getThumbnail(fis, 100 , 100 , Jimi.IN_MEMORY);
		//Image image = JimiUtils.getThumbnail(orgPath, 100 , 100 , Jimi.IN_MEMORY);

		Jimi.putImage(image, newPath);

	}
}
