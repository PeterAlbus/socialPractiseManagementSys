package com.peteralbus;

import org.apache.shiro.crypto.hash.SimpleHash;
import org.apache.shiro.util.ByteSource;
import org.junit.Test;

public class HashTest
{
    @Test
    public void md5Hash()
    {
        String credentials="123456";
        String salt="MU8asOu";
        String hashAlgorithmName="MD5";
        int hashIterations=1;
        SimpleHash hashed=new SimpleHash("MD5", credentials, ByteSource.Util.bytes(salt),hashIterations);
        System.out.println(hashed);
        System.out.println(hashed.toBase64());
        System.out.println(hashed.toHex());
    }
}
