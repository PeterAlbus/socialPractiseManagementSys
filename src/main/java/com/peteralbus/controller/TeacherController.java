package com.peteralbus.controller;

import com.peteralbus.entity.Activity;
import com.peteralbus.entity.Group;
import com.peteralbus.entity.User;
import com.peteralbus.service.ActivityService;
import com.peteralbus.service.GroupService;
import com.peteralbus.service.UserService;
import com.peteralbus.util.PrincipalUtil;
import net.bytebuddy.implementation.bytecode.Throw;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.UnauthorizedException;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

/**
 * The type Teacher controller.
 * @author PeterAlbus
 */
@Controller
@RequestMapping("/teacher")
public class TeacherController
{
    @Autowired
    ActivityService activityService;
    @Autowired
    UserService userService;
    @Autowired
    GroupService groupService;
    @RequiresRoles(value={"teacher"}, logical= Logical.OR)
    @RequestMapping("/activities")
    public ModelAndView activities()
    {
        ModelAndView modelAndView= PrincipalUtil.getBasicModelAndView();
        Subject subject = SecurityUtils.getSubject();
        User user=(User)subject.getPrincipal();
        List<Activity> activityList=activityService.getActivityByTeacher(user.getUserId());
        modelAndView.addObject("activityList",activityList);
        System.out.println(activityList);
        List<Activity> allActivities=activityService.getActivities();
        modelAndView.addObject("allActivities",allActivities);
        modelAndView.setViewName("/jsp/teacher/activity.jsp");
        return modelAndView;
    }
    @RequestMapping("/activityDetail")
    public ModelAndView activityDetail(Long activityId)
    {
        ModelAndView modelAndView= PrincipalUtil.getBasicModelAndView();
        Activity activity=activityService.getActivityById(activityId);
        modelAndView.addObject("activity",activity);
        modelAndView.setViewName("/jsp/teacher/activityDetail.jsp");
        return modelAndView;
    }
    @RequestMapping("/modifyActivity")
    public ModelAndView modifyActivity(Long activityId)
    {
        ModelAndView modelAndView=PrincipalUtil.getBasicModelAndView();
        Subject subject = SecurityUtils.getSubject();
        User user=(User)subject.getPrincipal();
        if(!activityService.checkIsManage(user.getUserId(), activityId))
        {
            throw new UnauthorizedException();
        }
        Activity activity=activityService.getActivityById(activityId);
        List<Group> groupList=groupService.getGroupListByActivity(activityId);
        List<User> teacherList=userService.getTeacherList();
        modelAndView.addObject("groupList",groupList);
        modelAndView.addObject("activity",activity);
        modelAndView.addObject("teacherList",teacherList);
        modelAndView.setViewName("/jsp/teacher/modifyActivity.jsp");
        return modelAndView;
    }
    @ResponseBody
    @RequestMapping("/addActivity")
    public String addActivity(Activity activity)
    {
        try
        {
            int result=activityService.updateActivity(activity);
            if(result>0)
            {
                return "success";
            }
            else
            {
                return "error";
            }
        }
        catch (Exception e)
        {
            return "error:"+e.getMessage();
        }
    }
    @ResponseBody
    @RequestMapping("/updateActivity")
    public String updateActivity(Activity activity)
    {
        try
        {
            int result=activityService.updateActivity(activity);
            if(result>0)
            {
                return activity.getActivityId().toString();
            }
            else
            {
                return "error:didn't do any change";
            }
        }
        catch (Exception e)
        {
            return "error:"+e.getMessage();
        }
    }
    @ResponseBody
    @RequestMapping("/addTeacherToActivity")
    public String addTeacherToActivity(Long userId,Long activityId)
    {
        if(activityService.checkIsManage(userId,activityId))
        {
            return "exist";
        }
        int result=activityService.addTeacherToActivity(userId,activityId);
        if(result>0)
        {
            return "success";
        }
        return "error";
    }
}
