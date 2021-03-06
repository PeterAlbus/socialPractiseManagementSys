package com.peteralbus.util;

import org.apache.shiro.crypto.hash.SimpleHash;
import org.apache.shiro.util.ByteSource;

import java.util.Random;

/**
 * The type Md 5 util.
 *
 * @author PeterAlbus
 */
public class Md5Util
{
    /**
     * Md 5 hash string.
     *
     * @param credentials the credentials
     * @param salt        the salt
     * @return the string
     */
    public static String md5Hash(String credentials, String salt)
    {
        String hashAlgorithmName="MD5";
        int hashIterations=1;
        return new SimpleHash(hashAlgorithmName, credentials, ByteSource.Util.bytes(salt),hashIterations).toHex();
    }

    /**
     * Get salt string.
     *
     * @param n the n
     * @return the string
     */
    public static String getSalt(int n){
        char[] chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~!@#$%^&*()_+".toCharArray();
        int length = chars.length;
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < n; i++){
            char c = chars[new Random().nextInt(length)];
            sb.append(c);
        }
        return sb.toString();
    }
}
