package com.peteralbus.config;

import com.peteralbus.entity.User;
import com.peteralbus.service.UserService;
import com.peteralbus.util.Md5Util;
import org.apache.shiro.authc.*;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthenticatingRealm;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.util.ByteSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.HashSet;
import java.util.Set;

/**
 * The type Custom realm.
 * @author PeterAlbus
 */
@Component
public class CustomRealm extends AuthorizingRealm
{
    @Autowired
    UserService userService;
    @Override
    public void setName(String name) {
        super.setName("customRealm");
    }

    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principalCollection)
    {
        User principal= (User) principalCollection.getPrimaryPrincipal();
        Set<String> roles=new HashSet<>();
        if(principal.getUserClass()==0)
        {
            roles.add("admin");
        }
        if(principal.getUserClass()==1)
        {
            roles.add("student");
        }
        if(principal.getUserClass()==2)
        {
            roles.add("teacher");
        }
        return new SimpleAuthorizationInfo(roles);
    }

    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException
    {
        // token是用户输入的用户名和密码
        // 第一步从token中取出用户名
        String principal = (String) token.getPrincipal();
        User user=userService.queryByUsername(principal);
        // 第二步：根据用户输入的userCode从数据库查询用户信息
        if(user==null)
        {
            throw new UnknownAccountException("用户名不存在!");
        }
        // 从数据库查询到密码
        String credentials = user.getPassword();
        //盐
        String salt = user.getUserSalt();

        // 如果查询到,返回认证信息AuthenticationInfo
        return new SimpleAuthenticationInfo(user,credentials,ByteSource.Util.bytes(salt),getName());
    }


}
