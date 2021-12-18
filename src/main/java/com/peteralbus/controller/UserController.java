package com.peteralbus.controller;

import com.peteralbus.entity.User;
import com.peteralbus.service.UserService;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.*;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.util.SavedRequest;
import org.apache.shiro.web.util.WebUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * The type User controller.
 *
 * @author PeterAlbus
 */
@Controller
@RequestMapping("/user")
public class UserController
{
    @Autowired
    UserService userService;
    /**
     * Login string.
     *
     * @param username the username
     * @param password the password
     * @return the string
     */
    @ResponseBody
    @RequestMapping("/login")
    public String login(String username, String password,Boolean rememberMe)
    {
        Subject subject = SecurityUtils.getSubject();
        UsernamePasswordToken token=new UsernamePasswordToken(username,password);
        token.setRememberMe(rememberMe);
        try {
            subject.login(token);
        }
        catch(Exception ae){
            return "登陆失败："+ae.getMessage();
        }
        return "success";
    }
    @ResponseBody
    @RequestMapping("/register")
    public String register(User user)
    {
        if(user.getUserClass()!=1&&user.getUserClass()!=2)
        {
            return "注册的用户身份非法!";
        }
        try
        {
            int result=userService.insertUser(user);
            if(result>0)
            {
                return "success";
            }
            else
            {
                return "注册失败!";
            }
        }
        catch (DuplicateKeyException e)
        {
            return "用户名或手机号已被使用!";
        }
        catch (Exception e)
        {
            return "注册失败:"+e.getMessage();
        }
    }
    @RequestMapping("/changePassword")
    public ModelAndView changePassword(String password)
    {
        ModelAndView modelAndView=new ModelAndView();
        Subject subject = SecurityUtils.getSubject();
        User user=(User)subject.getPrincipal();
        user.setPassword(password);
        try
        {
            int result=userService.updateUserPassword(user);
            if(result>0)
            {
                modelAndView.addObject("info","修改密码成功,请重新登录!");
                modelAndView.setViewName("redirect:/logout");
            }
            else
            {
                modelAndView.addObject("info","修改失败!");
                modelAndView.setViewName("/jsp/account/login.jsp");
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        return modelAndView;
    }
    @RequestMapping("/deleteUser")
    public ModelAndView deleteUser()
    {
        ModelAndView modelAndView=new ModelAndView();
        User user=userService.queryByUsername("PeterAlbus");
        int result=userService.deleteUser(user);
        modelAndView.setViewName("/jsp/account/login.jsp");
        return modelAndView;
    }
}
