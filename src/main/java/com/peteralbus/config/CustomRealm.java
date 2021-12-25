package com.peteralbus.config;

import com.peteralbus.entity.User;
import com.peteralbus.service.UserService;
import org.apache.shiro.authc.*;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.util.ByteSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.HashSet;
import java.util.Set;

/**
 * The type Custom realm.
 *
 * @author PeterAlbus
 */
@Component
public class CustomRealm extends AuthorizingRealm
{
    /**
     * The User service.
     */
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
        String principal = (String) token.getPrincipal();
        User user=userService.queryByUsername(principal);
        if(user==null)
        {
            throw new UnknownAccountException("用户名不存在!");
        }
        String credentials = user.getPassword();
        String salt = user.getUserSalt();
        return new SimpleAuthenticationInfo(user,credentials,ByteSource.Util.bytes(salt),getName());
    }


}
