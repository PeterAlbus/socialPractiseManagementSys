package com.peteralbus.controller;

import com.peteralbus.entity.Activity;
import com.peteralbus.entity.User;
import com.peteralbus.service.ActivityService;
import com.peteralbus.service.MessageService;
import com.peteralbus.service.UserService;
import com.peteralbus.util.PrincipalUtil;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

/**
 * The type Admin controller.
 *
 * @author PeterAlbus
 */
@Controller
@RequiresRoles(value={"admin"}, logical= Logical.OR)
@RequestMapping("/admin")
public class AdminController
{
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
     * The User service.
     */
    @Autowired
    UserService userService;
    private ModelAndView basicModelAndView()
    {
        ModelAndView modelAndView=PrincipalUtil.getBasicModelAndView();
        modelAndView.addObject("messageCount",messageService.getNewMessageCount());
        modelAndView.addObject("newMessageList",messageService.getNewMessage());
        return modelAndView;
    }

    /**
     * Activities model and view.
     *
     * @return the model and view
     */
    @RequestMapping("/activities")
    public ModelAndView activities()
    {
        ModelAndView modelAndView=this.basicModelAndView();
        List<Activity> activityList=activityService.adminActivityList();
        modelAndView.addObject("activityList",activityList);
        modelAndView.setViewName("/jsp/admin/activities.jsp");
        return modelAndView;
    }

    /**
     * Users model and view.
     *
     * @return the model and view
     */
    @RequestMapping("/users")
    public ModelAndView users()
    {
        ModelAndView modelAndView=this.basicModelAndView();
        List<User> userList=userService.getUserList();
        modelAndView.addObject("userList",userList);
        modelAndView.setViewName("/jsp/admin/users.jsp");
        return modelAndView;
    }

    /**
     * Restore activity string.
     *
     * @param activityId the activity id
     * @return the string
     */
    @ResponseBody
    @RequestMapping("/restoreActivity")
    public String restoreActivity(Long activityId)
    {
        if(activityService.restore(activityId)>0)
        {
            return "success";
        }
        return "error";
    }

    /**
     * Reset password string.
     *
     * @param userId the user id
     * @return the string
     */
    @ResponseBody
    @RequestMapping("/resetPassword")
    public String resetPassword(Long userId)
    {
        User user=userService.queryById(userId);
        user.setPassword("123456");
        if(userService.updateUserPassword(user)>0)
        {
            return "success";
        }
        return "error";
    }

    /**
     * Sets admin.
     *
     * @param userId the user id
     * @return the admin
     */
    @ResponseBody
    @RequestMapping("/setAdmin")
    public String setAdmin(Long userId)
    {
        if(userService.setAdmin(userId)>0)
        {
            return "success";
        }
        return "error";
    }
}
