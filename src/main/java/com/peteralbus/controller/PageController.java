package com.peteralbus.controller;

import com.peteralbus.entity.User;
import com.peteralbus.service.MessageService;
import com.peteralbus.util.PrincipalUtil;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

/**
 * The type Page controller.
 * @author PeterAlbus
 */
@Controller
public class PageController
{
    @Autowired
    MessageService messageService;
    /**
     * Home page model and view.
     *
     * @return the model and view
     */
    private ModelAndView basicModelAndView()
    {
        ModelAndView modelAndView=PrincipalUtil.getBasicModelAndView();
        modelAndView.addObject("messageCount",messageService.getNewMessageCount());
        modelAndView.addObject("newMessageList",messageService.getNewMessage());
        return modelAndView;
    }
    @RequestMapping("/index")
    public ModelAndView homePage()
    {
        ModelAndView modelAndView=this.basicModelAndView();
        modelAndView.setViewName("/jsp/home.jsp");
        return modelAndView;
    }
    @RequestMapping("/messageList")
    public ModelAndView messageList()
    {
        ModelAndView modelAndView=this.basicModelAndView();
        modelAndView.setViewName("/jsp/message/messageList.jsp");
        return modelAndView;
    }
    @RequestMapping("/message")
    public ModelAndView message(Long messageId)
    {
        ModelAndView modelAndView=this.basicModelAndView();
        modelAndView.setViewName("/jsp/message/message.jsp");
        return modelAndView;
    }
}
