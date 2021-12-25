package com.peteralbus.controller;

import com.peteralbus.entity.User;
import com.peteralbus.service.MessageService;
import com.peteralbus.service.UserService;
import com.peteralbus.util.Md5Util;
import com.peteralbus.util.PrincipalUtil;
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
import javax.servlet.http.HttpSession;
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
    /**
     * The User service.
     */
    @Autowired
    UserService userService;
    /**
     * The Message service.
     */
    @Autowired
    MessageService messageService;

    private ModelAndView basicModelAndView()
    {
        ModelAndView modelAndView= PrincipalUtil.getBasicModelAndView();
        modelAndView.addObject("messageCount",messageService.getNewMessageCount());
        modelAndView.addObject("newMessageList",messageService.getNewMessage());
        return modelAndView;
    }

    /**
     * Login string.
     *
     * @param username   the username
     * @param password   the password
     * @param rememberMe the remember me
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
            subject.getSession().setTimeout(86400000);
        }
        catch (IncorrectCredentialsException ie){
            return "登陆失败：密码错误！";
        }
        catch(Exception e){
            e.printStackTrace();
            return "登陆失败："+e.getMessage();
        }
        return "success";
    }

    /**
     * Register string.
     *
     * @param user the user
     * @return the string
     */
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

    /**
     * Update user string.
     *
     * @param user the user
     * @return the string
     */
    @ResponseBody
    @RequestMapping("/updateUser")
    public String updateUser(User user)
    {
        Subject subject = SecurityUtils.getSubject();
        User oldUser=(User)subject.getPrincipal();
        oldUser.setUsername(user.getUsername());
        oldUser.setUserPhone(user.getUserPhone());
        oldUser.setRealName(user.getRealName());
        oldUser.setAvatarSrc(user.getAvatarSrc());
        if(userService.updateUser(oldUser)>0)
        {
            return "success";
        }
        else
        {
            return "error";
        }
    }

    /**
     * Change password model and view.
     *
     * @param oldPassword the old password
     * @param newPassword the new password
     * @param session     the session
     * @return the model and view
     */
    @RequestMapping("/changePassword")
    public ModelAndView changePassword(String oldPassword, String newPassword, HttpSession session)
    {
        ModelAndView modelAndView=new ModelAndView();
        Subject subject = SecurityUtils.getSubject();
        User user=(User)subject.getPrincipal();
        if(!user.getPassword().equals(Md5Util.md5Hash(oldPassword,user.getUserSalt())))
        {
            session.setAttribute("info","原密码错误!");
            modelAndView.setViewName("redirect:/userCenter");
            return modelAndView;
        }
        user.setPassword(newPassword);
        try
        {
            int result=userService.updateUserPassword(user);
            if(result>0)
            {
                session.setAttribute("info","修改密码成功,请重新登录!");
                modelAndView.setViewName("redirect:/login");
            }
            else
            {
                session.setAttribute("info","修改失败!");
                modelAndView.setViewName("redirect:/userCenter");
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
            session.setAttribute("info",e.getMessage());
            modelAndView.setViewName("redirect:/userCenter");
        }
        return modelAndView;
    }

    /**
     * Delete user model and view.
     *
     * @return the model and view
     */
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
