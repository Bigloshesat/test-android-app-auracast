package com.bluebridge.utils;

public class ByteUtil {

    public static byte hexToByte(String hex) {
        return (byte) Integer.parseInt(hex, 16);
    }

    public static byte[] hexToByteArray(String hex) {
        int hexlen = hex.length();
        byte[] result;
        if (hexlen % 2 == 1) {
            hexlen++;
            result = new byte[(hexlen / 2)];
            hex = "0" + hex;
        } else {
            result = new byte[(hexlen / 2)];
        }
        int j = 0;
        for (int i = 0; i < hexlen; i += 2) {
            result[j] = hexToByte(hex.substring(i, i + 2));
            j++;
        }
        return result;
    }

    public static String bytesToHex(byte[] bytes) {
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < bytes.length; i++) {
            String hex = Integer.toHexString(bytes[i] & 0xFF);
            if (hex.length() < 2) {
                sb.append(0);
            }
            sb.append(hex);
        }
        return sb.toString();
    }
}
