package net.ion.webapp.utils;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

public class CryptAES
{	
	/**
	 * 입력받은 사용자 비밀번호로 SECRET KEY 생성 리턴한다.
	 * 
	 * @param _pass	비밀번호
	 * @return
	 */
	private static byte[] getSecretKey(String _pass){	
		
		byte[] pass = _pass.getBytes();
		byte[] secretKey = new byte[16];
		
		for(int i=0;i<16;i++){				
			if(i<pass.length){
				secretKey[i] = pass[i];
			}
			else{
				secretKey[i] = 0;
			}				
		}		
		return secretKey;		
	}
	
    /**
     * hex to byte[] : 16진수 문자열을 바이트 배열로 변환한다.
     * 
     * @param hex    hex string
     * @return
     */
    private static byte[] hexToByteArray(String hex) {
        if (hex == null || hex.length() == 0) {
            return null;
        }

        byte[] ba = new byte[hex.length() / 2];
        for (int i = 0; i < ba.length; i++) {
            ba[i] = (byte) Integer.parseInt(hex.substring(2 * i, 2 * i + 2), 16);
        }
        return ba;
    }

    /**
     * byte[] to hex : unsigned byte(바이트) 배열을 16진수 문자열로 바꾼다.
     * 
     * @param ba        byte[]
     * @return
     */
    private static String byteArrayToHex(byte[] ba) {
        if (ba == null || ba.length == 0) {
            return null;
        }

        StringBuffer sb = new StringBuffer(ba.length * 2);
        String hexNumber;
        for (int x = 0; x < ba.length; x++) {
            hexNumber = "0" + Integer.toHexString(0xff & ba[x]);

            sb.append(hexNumber.substring(hexNumber.length() - 2));
        }
        return sb.toString();
    } 

    /**
     * AES 방식의 암호화
     * 
     * @param _pass
     * @return
     * @throws Exception
     */
    public static String encrypt(String value) throws Exception {

        return encrypt(value, value);
    }
    public static String encrypt(String value, String key) throws Exception {

        // use key coss2
    	SecretKeySpec skeySpec = new SecretKeySpec(getSecretKey(key), "AES");

        // Instantiate the cipher
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.ENCRYPT_MODE, skeySpec);

        byte[] encrypted = cipher.doFinal(value.getBytes());
        return byteArrayToHex(encrypted);
    }

    /**
     * AES 방식의 복호화
     * 
     * @param message
     * @return
     * @throws Exception
     */
    public static String decrypt(String encrypted, String _pass) throws Exception {

        // use key coss2
        SecretKeySpec skeySpec = new SecretKeySpec(getSecretKey(_pass), "AES");

        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.DECRYPT_MODE, skeySpec);
        byte[] original = cipher.doFinal(hexToByteArray(encrypted));
        String originalString = new String(original);
        return originalString;
    }
    
    public static void main(String[] args)
    {
        try {
            String pass = "manager";
        	String encrypt = encrypt(pass);
            System.out.println("origin str = "+ pass);
            System.out.println("encrypt str = "+encrypt);
            
            String decrypt = decrypt(encrypt, pass);
            System.out.println("decrypt str = "+decrypt);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }

}
