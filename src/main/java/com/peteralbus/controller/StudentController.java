package com.peteralbus.controller;

import com.peteralbus.entity.Activity;
import com.peteralbus.entity.Group;
import com.peteralbus.entity.User;
import com.peteralbus.service.ActivityService;
import com.peteralbus.service.GroupService;
import com.peteralbus.service.ParticipateService;
import com.peteralbus.util.PrincipalUtil;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
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
    @Autowired
    GroupService groupService;
    @Autowired
    ParticipateService participateService;
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
    @RequestMapping("/applyActivity")
    public ModelAndView applyActivity(Long activityId)
    {
        ModelAndView modelAndView=PrincipalUtil.getBasicModelAndView();
        Activity activity= activityService.getActivityById(activityId);
        modelAndView.addObject("activity",activity);
        List<Group> groupList=groupService.getGroupListByActivity(activityId);
        modelAndView.addObject("groupList",groupList);
        modelAndView.setViewName("/jsp/student/applyActivity.jsp");
        return modelAndView;
    }
    public ModelAndView manageActivity(Long activityId)
    {
        ModelAndView modelAndView=PrincipalUtil.getBasicModelAndView();
        modelAndView.setViewName("/jsp/student/manageActivity.jsp");
        return modelAndView;
    }
    @ResponseBody
    @RequestMapping("/participateWithNewGroup")
    public String participateWithNewGroup(Group group)
    {
        int result=participateService.participateWithNewGroup(group);
        if(result>0)
        {
            return "success";
        }
        else
        {
            return "error";
        }
    }
    @ResponseBody
    @RequestMapping("/participateWithOldGroup")
    public String participateWithOldGroup(Long groupId)
    {
        Group group=groupService.getById(groupId);
        if(group==null)
        {
            return "error:未找到该小组";
        }
        int result=participateService.participateWithOldGroup(group);
        if(result>0)
        {
            return "success";
        }
        else
        {
            return "error";
        }
    }
}
