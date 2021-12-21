package com.peteralbus.controller;

import com.peteralbus.entity.Activity;
import com.peteralbus.service.ActivityService;
import com.peteralbus.util.PrincipalUtil;
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
@RequestMapping("/admin")
public class AdminController
{
    @Autowired
    ActivityService activityService;
    @RequestMapping("/activities")
    public ModelAndView activities()
    {
        ModelAndView modelAndView=PrincipalUtil.getBasicModelAndView();
        List<Activity> activityList=activityService.adminActivityList();
        modelAndView.addObject("activityList",activityList);
        modelAndView.setViewName("/jsp/admin/activities.jsp");
        return modelAndView;
    }
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
}
