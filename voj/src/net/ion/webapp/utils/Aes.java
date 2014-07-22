package net.ion.webapp.utils;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.Cipher;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.lang.StringUtils;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

public class Aes {
	/**
	 * 설치시 주의 사항 
	 * http://danhobak-textcube.blogspot.com/2010/03/aes-256-%EC%95%94%ED%98%B8%ED%99%94-%EC%98%A4%EB%A5%98.html 참고
	 *		JDK 6 : http://www.oracle.com/technetwork/java/javase/downloads/jce-6-download-429243.html
     *		JDK 7 : http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html
	 * security 폴더에 256비트 암호화 모듈 파일이 있음
	 * 압축풀고 java 버전에 맞는
	 * local_policy.jar, US_export_policy.jar 파일을
	 * %JAVA_HOME%\jre\lib\security 안에 복사해야 합니다. 
	 * 복사하지 않고 사용할경우 AES128 로 암호화 되거나 키사이즈 오류가 발생합니다.
	 */

	private static final String ALGORITHM = "AES";

	private static final String CIPHER_GETINSTANCE = "AES/CBC/PKCS5Padding";

	private static final BASE64Encoder ENCODER_64 = new BASE64Encoder();

	private static final BASE64Decoder DECODER_64 = new BASE64Decoder();
	private static byte[] ENCRYPTION_KEY = null;

	static byte[] ivSpec1 = new byte[] { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };

	
	public void setKey(String keyVal) throws IOException {
		keyVal = Aes.getKeyDecode(keyVal);
		BASE64Encoder d64 = new BASE64Encoder();
		byte[] key = d64.encode(keyVal.getBytes()).getBytes();
		
		while(key.length < 32){
			key = d64.encode(key).getBytes();
		}
		ENCRYPTION_KEY = key;
	}
	
	private static byte[] getKey(){

		return ENCRYPTION_KEY;
	}
	private static synchronized Cipher getCipherInstance(boolean encoder)
			throws NoSuchAlgorithmException, NoSuchPaddingException,
			IOException, InvalidKeyException,
			InvalidAlgorithmParameterException {
		Cipher CIPHER_ENCODER;
		Cipher CIPHER_DECODER;
		synchronized (ALGORITHM) {
			//if (CIPHER_ENCODER == null || CIPHER_DECODER == null) {
				CIPHER_ENCODER = Cipher.getInstance(CIPHER_GETINSTANCE);
				CIPHER_DECODER = Cipher.getInstance(CIPHER_GETINSTANCE);
				//byte[] keyBytes = new byte[32];
				byte[] keyBytes = new byte[16];
				byte[] b = getKey();
				int len = b.length;
				if (len > keyBytes.length) {
					len = keyBytes.length;
				}
				System.arraycopy(b, 0, keyBytes, 0, len);
				SecretKeySpec keySpec = new SecretKeySpec(keyBytes, ALGORITHM);
				IvParameterSpec ivSpec = new IvParameterSpec(ivSpec1);
				CIPHER_ENCODER.init(Cipher.ENCRYPT_MODE, keySpec, ivSpec);
				CIPHER_DECODER.init(Cipher.DECRYPT_MODE, keySpec, ivSpec);
			//}
		}
		if (encoder) {
			return CIPHER_ENCODER;
		} else {
			return CIPHER_DECODER;
		}

	}

	public static String encrypt(final String msg) throws IOException,
			NoSuchAlgorithmException, GeneralSecurityException {
		String encryptedMsg = "";
		byte[] encrypt = getCipherInstance(true).doFinal(msg.getBytes("UTF-8"));
		encryptedMsg = ENCODER_64.encode(encrypt);
		return encryptedMsg;
	}
	public static String decrypt(final String msg) throws IOException, NoSuchAlgorithmException, GeneralSecurityException {
		//System.out.println("-------------------------------" + msg );
		//decryptedMsg = DECODER_64.decodeBuffer(str);
		byte[] decrypt = DECODER_64.decodeBuffer(msg);
		byte[] decrypted = getCipherInstance(false).doFinal(decrypt);
		String decryptedMsg = new String(decrypted, "UTF-8");
		//System.out.println("-------------------------------" + decryptedMsg );
		return decryptedMsg;
	}
	public static String security(String val, String type){
		type=type.toLowerCase();
		
		try {
			val = decrypt(val);
		} catch (Exception e) {
			e.printStackTrace();
		}
		if("email".equals(type)){
			int at=val.indexOf("@");
			val = StringUtils.substring(val,0 ,at-3) + "***" + StringUtils.substring(val,at,val.length());
		}else if("name".equals(type)){
			int l = val.length()==2 ? 1 : 2;
			val = StringUtils.rightPad(val.substring(0,l), val.length(), "*");
		}else if("tel".equals(type)){
			String[] tels = val.split("-");
			if(tels.length==3){
				val = tels[0] + "-" + StringUtils.substring(tels[1],0, tels[1].length()-2) + "**-*" +StringUtils.substring(tels[2],1);
			}else {
				val = StringUtils.substring(val,0, 5) + "***" +StringUtils.substring(val,8,val.length());
			}
		}else if("com_num".equals(type)){
			val = StringUtils.substring(val,0, val.length()-3) + "***";
		}else if("biz_num".equals(type)){
			val = StringUtils.substring(val,0, 3) + "-" + StringUtils.substring(val,3, 5) + "-" + StringUtils.substring(val,5, val.length());
		}else{
			val = Function.masking(val, type);
		}
		return val;
	}
	
	public static String getKeyDecode(String msg){
		
		return getKeyDec(getKeyDec(getKeyDec(msg)));
	}
	private static String getKeyDec(String msg){
		try {
			byte[] decode = DECODER_64.decodeBuffer(msg);
			msg = new String(decode, "UTF-8");
			msg = StringUtils.reverse(msg);
			return msg;
		} catch (Exception e) {
		}
		
		return "";
	}

	public static String getKeyEncode(String msg){
		return getKeyEnc(getKeyEnc(getKeyEnc(msg)));
	}
	private static String getKeyEnc(String msg){
		msg = StringUtils.reverse(msg);
		msg = ENCODER_64.encodeBuffer(msg.getBytes());
		return msg;
	}

	public static void main(String[] arg) {
		try {
			String key = "vojesus1";
			String newkey = getKeyEncode(key).trim();
			System.out.println(key + ":" + newkey);
			
			key = getKeyDecode(newkey).trim();
			System.out.println(key);
			
			key = "dptnakdmf0254";
			newkey = getKeyEncode(key);
			System.out.println(key + ":" + newkey);
			
			key = getKeyDecode(newkey);
			System.out.println(key);
			

			//String tel = security("02212377774", "tel");
			//System.out.println(tel);
/*
			Aes aes = new Aes();
			aes.setKey("kibot2openecho");
			String en = encrypt("333122fqw02000-010200187232002000-01020018723-010200187232002000-010200187232002000-01020018723-010200187232002000-01234567890123456710200187232002000-01020018723-010200187232002000-010200187232002000-01020018723-01020018723");
			System.out.println(en);
			System.out.println(decrypt(en));
*/
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

}
