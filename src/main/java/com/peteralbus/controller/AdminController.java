package com.peteralbus.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * The type Admin controller.
 *
 * @author PeterAlbus
 */
@Controller
@RequestMapping("/admin")
public class AdminController
{
    /**
     * Admin home page model and view.
     *
     * @return the model and view
     */
    @RequestMapping("/index")
    public ModelAndView adminHomePage()
    {
        return new ModelAndView("/jsp/admin/home.jsp");
    }
}
