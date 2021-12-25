package com.peteralbus.controller;

import com.peteralbus.entity.Activity;
import com.peteralbus.entity.User;
import com.peteralbus.service.ActivityService;
import com.peteralbus.service.MessageService;
import com.peteralbus.service.UserService;
import com.peteralbus.util.PrincipalUtil;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

/**
 * The type Page controller.
 *
 * @author PeterAlbus
 */
@Controller
public class PageController
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
    /**
     * The Activity service.
     */
    @Autowired
    ActivityService activityService;
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

    /**
     * Home page model and view.
     *
     * @return the model and view
     */
    @RequestMapping("/index")
    public ModelAndView homePage()
    {
        ModelAndView modelAndView=this.basicModelAndView();
        Subject subject = SecurityUtils.getSubject();
        User user=(User)subject.getPrincipal();
        if(user.getUserClass()==1)
        {
            List<Activity> activityList=activityService.getActivityByStudent(user.getUserId());
            modelAndView.addObject("activityList",activityList);
        }
        if(user.getUserClass()==2)
        {
            List<Activity> activityList=activityService.getActivityByTeacher(user.getUserId());
            modelAndView.addObject("activityList",activityList);
        }
        if(user.getUserClass()==0)
        {
            modelAndView.addObject("activityList",null);
        }
        List<Activity> allActivities=activityService.getActivities();
        modelAndView.addObject("allActivities",allActivities);
        modelAndView.setViewName("/jsp/home.jsp");
        return modelAndView;
    }

    /**
     * User detail model and view.
     *
     * @param userId the user id
     * @return the model and view
     */
    @RequestMapping("/user")
    public ModelAndView userDetail(Long userId)
    {
        System.out.println(userId);
        User user=null;
        if(userId==null)
        {
            Subject subject = SecurityUtils.getSubject();
            user=(User)subject.getPrincipal();
        }
        else
        {
            user=userService.queryById(userId);
        }
        ModelAndView modelAndView=this.basicModelAndView();
        modelAndView.addObject("userInfo",user);
        Map<String,Long> stat=activityService.getUserStat(user);
        modelAndView.addObject("stat",stat);
        modelAndView.setViewName("/jsp/account/user.jsp");
        return modelAndView;
    }

    /**
     * User center model and view.
     *
     * @param session the session
     * @return the model and view
     */
    @RequestMapping("/userCenter")
    public ModelAndView userCenter(HttpSession session)
    {
        ModelAndView modelAndView=this.basicModelAndView();
        String message = (String) session.getAttribute("info");
        if (message != null) {
            modelAndView.addObject("info", message);
            session.removeAttribute("info");
        }
        modelAndView.setViewName("/jsp/account/userCenter.jsp");
        return modelAndView;
    }

    /**
     * Message list model and view.
     *
     * @return the model and view
     */
    @RequestMapping("/messageList")
    public ModelAndView messageList()
    {
        ModelAndView modelAndView=this.basicModelAndView();
        modelAndView.addObject("messageList",messageService.getMessage());
        modelAndView.setViewName("/jsp/message/messageList.jsp");
        return modelAndView;
    }

    /**
     * Message model and view.
     *
     * @param messageId the message id
     * @return the model and view
     */
    @RequestMapping("/message")
    public ModelAndView message(Long messageId)
    {
        ModelAndView modelAndView=this.basicModelAndView();
        modelAndView.setViewName("/jsp/message/message.jsp");
        return modelAndView;
    }

    /**
     * Read message string.
     *
     * @param messageId the message id
     * @return the string
     */
    @ResponseBody
    @RequestMapping("/readMessage")
    public String readMessage(Long messageId)
    {
        int result=messageService.readMessage(messageId);
        if(result>0)
        {
            return "success";
        }
        return "error";
    }
}
