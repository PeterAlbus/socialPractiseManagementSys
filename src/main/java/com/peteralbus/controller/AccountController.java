package com.peteralbus.controller;

import com.peteralbus.entity.User;
import com.peteralbus.util.PrincipalUtil;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.annotation.RequiresAuthentication;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;

/**
 * The type Account controller.
 * @author PeterAlbus
 */
@Controller
public class AccountController
{
    /**
     * Login model and view.
     *
     * @return the model and view
     */
    @RequestMapping("/login")
    public ModelAndView login(HttpSession session)
    {
        ModelAndView modelAndView=new ModelAndView();
        String message = (String) session.getAttribute("info");
        if (message != null) {
            modelAndView.addObject("info", message);
            session.removeAttribute("info");
        }
        modelAndView.setViewName("/jsp/account/login.jsp");
        return modelAndView;
    }

    @RequestMapping("/register")
    public ModelAndView register()
    {
        ModelAndView modelAndView=new ModelAndView();
        modelAndView.setViewName("/jsp/account/register.jsp");
        return modelAndView;
    }

    @RequiresAuthentication
    @RequestMapping("/refuse")
    public ModelAndView refuse()
    {
        ModelAndView modelAndView= PrincipalUtil.getBasicModelAndView();
        modelAndView.setViewName("/jsp/account/refuse.jsp");
        return modelAndView;
    }

    /**
     * Logout.
     */
    @RequestMapping("/logout")
    public void logout()
    {
        /*shiro实现*/
    }

    /**
     * To home page model and view.
     *
     * @return the model and view
     */
    @RequestMapping("/toHomePage")
    public ModelAndView toHomePage()
    {
        final String roleAdmin="admin";
        ModelAndView modelAndView=new ModelAndView();
        modelAndView.setViewName("redirect: /index");
        return modelAndView;
    }
}
