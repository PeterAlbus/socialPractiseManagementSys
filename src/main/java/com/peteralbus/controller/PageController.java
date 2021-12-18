package com.peteralbus.controller;

import com.peteralbus.entity.User;
import com.peteralbus.util.PrincipalUtil;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * The type Page controller.
 * @author PeterAlbus
 */
@Controller
public class PageController
{
    /**
     * Home page model and view.
     *
     * @return the model and view
     */
    @RequestMapping("/index")
    public ModelAndView homePage()
    {
        ModelAndView modelAndView= PrincipalUtil.getBasicModelAndView();
        modelAndView.setViewName("/jsp/home.jsp");
        return modelAndView;
    }
}
