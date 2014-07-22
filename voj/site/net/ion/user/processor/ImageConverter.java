package net.ion.user.processor;

import java.awt.Graphics2D;
import java.awt.geom.RoundRectangle2D;
import java.awt.image.BufferedImage;
import java.awt.image.renderable.ParameterBlock;
import java.io.File;

import javax.imageio.ImageIO;
import javax.media.jai.Interpolation;
import javax.media.jai.JAI;
import javax.media.jai.RenderedOp;

import com.sun.media.jai.codec.FileSeekableStream;

import net.ion.webapp.process.ProcessInitialization;

public class ImageConverter{

	public void convert(float width, float height, FileSeekableStream stream, File dest) throws Exception {	
		
		/* Create an operator to decode the image file. */
		RenderedOp src = JAI.create("stream", stream);

		Interpolation interp = Interpolation.getInstance(Interpolation.INTERP_BILINEAR);
		ParameterBlock pb = new ParameterBlock();
		pb.addSource(src);
		pb.add(width / src.getWidth()); // x scale factor
		pb.add(height / src.getHeight()); // y scale factor
		pb.add(0.0F); // x translate
		pb.add(0.0F); // y translate
		pb.add(interp); // interpolation method
		/* Create an operator to scale image1. */
		RenderedOp scaled = JAI.create("scale", pb);

		try{
			JAI.create("filestore", scaled, dest.getPath(), "PNG", null);
		}catch(Exception e){
			e.printStackTrace() ;
		}finally{
			src.dispose() ;
			scaled.dispose() ;
		}
		
		BufferedImage image = ImageIO.read(dest);
		BufferedImage mask = ImageIO.read(new File(ProcessInitialization.getWebRoot(), "/sl/images/" + (int)width + ".png"));

	    RoundRectangle2D.Double round = new RoundRectangle2D.Double(0,0,image.getWidth(), image.getHeight(), 20, 20) ;

	    BufferedImage tmp = new BufferedImage(image.getWidth(), image.getHeight(), BufferedImage.TYPE_INT_ARGB);
	    Graphics2D g2 = tmp.createGraphics();
	    g2.setClip(round) ;
	    g2.drawImage(image, 0, 0, null);
	    g2.drawImage(mask, 0, 0, null);        
	    g2.dispose();
	    ImageIO.write(tmp, "png", dest);
	    
	}

}

