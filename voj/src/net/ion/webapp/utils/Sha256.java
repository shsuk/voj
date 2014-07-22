package net.ion.webapp.utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import org.apache.commons.codec.binary.Base64;

public class Sha256 {

	public static String encrypt1(String str) {
		
		String SHA = "";

		try {
			MessageDigest sh = MessageDigest.getInstance("SHA-256");
			sh.update(str.getBytes());

			byte byteData[] = sh.digest();

			StringBuffer sb = new StringBuffer();

			for (int i = 0; i < byteData.length; i++) {
				sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
			}

			SHA = sb.toString();
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
			SHA = null;
		}

		return SHA;
	}
	public static String encrypt(String str) throws Exception {
		

		if (str == null) {
		    return "";
		}
	
		byte[] plainText = null; // 평문
		byte[] hashValue = null; // 해쉬값
		plainText = str.getBytes();
	
		MessageDigest md = MessageDigest.getInstance("SHA-256");
		hashValue = md.digest(plainText);
	
		/*
		BASE64Encoder encoder = new BASE64Encoder();
		return encoder.encode(hashValue);
		*/
		return new String(Base64.encodeBase64(hashValue));
	}

	public static void main(String[] arg) {
		try {
			String en = encrypt("1");
			System.out.println(en);
			String en1 = encrypt1("1");
			System.out.println(en1);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

}
