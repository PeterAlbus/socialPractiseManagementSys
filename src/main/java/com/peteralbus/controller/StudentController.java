package com.peteralbus.controller;

import com.peteralbus.entity.Activity;
import com.peteralbus.entity.User;
import com.peteralbus.service.ActivityService;
import com.peteralbus.util.PrincipalUtil;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

/**
 * The type Student controller.
 * @author peteralbus
 */
@Controller
@RequestMapping("/student")
public class StudentController
{
    @Autowired
    ActivityService activityService;
    @RequestMapping("/activities")
    public ModelAndView activities()
    {
        ModelAndView modelAndView=PrincipalUtil.getBasicModelAndView();
        Subject subject = SecurityUtils.getSubject();
        User user=(User)subject.getPrincipal();
        List<Activity> activityList=activityService.getActivityByStudent(user.getUserId());
        modelAndView.addObject("activityList",activityList);
        List<Activity> allActivities=activityService.getActivities();
        modelAndView.addObject("allActivities",allActivities);
        modelAndView.setViewName("/jsp/student/activities.jsp");
        return modelAndView;
    }
}
