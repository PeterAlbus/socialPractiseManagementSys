package com.peteralbus.controller;

import com.peteralbus.entity.*;
import com.peteralbus.service.ActivityService;
import com.peteralbus.service.GroupService;
import com.peteralbus.service.ParticipateService;
import com.peteralbus.service.RecordService;
import com.peteralbus.util.PrincipalUtil;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.UnauthorizedException;
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
    @Autowired
    RecordService recordService;
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
        Subject subject = SecurityUtils.getSubject();
        User user=(User)subject.getPrincipal();
        Activity activity= activityService.getActivityById(activityId);
        Participate participate=participateService.getByUserAndActivity(user.getUserId(), activityId);
        if(participate!=null)
        {
            return new ModelAndView("redirect: /student/manageActivity?activityId="+activityId);
        }
        modelAndView.addObject("activity",activity);
        List<Group> groupList=groupService.getGroupListByActivity(activityId);
        modelAndView.addObject("groupList",groupList);
        modelAndView.setViewName("/jsp/student/applyActivity.jsp");
        return modelAndView;
    }
    @RequestMapping("/manageActivity")
    public ModelAndView manageActivity(Long activityId)
    {
        ModelAndView modelAndView=PrincipalUtil.getBasicModelAndView();
        Subject subject = SecurityUtils.getSubject();
        User user=(User)subject.getPrincipal();
        modelAndView.addObject("userId",user.getUserId());
        Activity activity= activityService.getActivityById(activityId);
        Participate participate=participateService.getByUserAndActivity(user.getUserId(), activityId);
        if(participate==null)
        {
            throw new UnauthorizedException();
        }
        Group group=groupService.getById(participate.getGroupId());
        Long memberCount=groupService.getMemberCount(group.getGroupId());
        List<Participate> memberList=groupService.getGroupMember(group.getGroupId());
        modelAndView.addObject("participationId",participate.getParticipationId());
        modelAndView.addObject("group",group);
        modelAndView.addObject("memberList",memberList);
        if(participate.getAccept())
        {
            if(memberCount<activity.getMinPeople())
            {
                modelAndView.addObject("currentStatus","正在等待小组成员数量达到要求");
                modelAndView.setViewName("/jsp/student/waitGroup.jsp");
            }
            else
            {
                List<Record> recordList=recordService.selectByParticipate(participate.getParticipationId());
                modelAndView.addObject("recordList",recordList);
                modelAndView.setViewName("/jsp/student/manageActivity.jsp");
            }
        }
        else
        {
            modelAndView.addObject("currentStatus","正在等待组长通过您的申请");
            modelAndView.setViewName("/jsp/student/waitGroup.jsp");
        }
        modelAndView.addObject("activity",activity);
        return modelAndView;
    }
    @ResponseBody
    @RequestMapping("/insertRecord")
    public String insertRecord(Record record)
    {
        record.setRead(false);
        int result= recordService.insertRecord(record);
        if(result<=0)
        {
            return "error";
        }
        return "success";
    }
    @ResponseBody
    @RequestMapping("/acceptJoin")
    public String acceptJoin(Long participateId)
    {
        int result=participateService.acceptJoin(participateId);
        if(result<=0)
        {
            return "error";
        }
        return "success";
    }
    @ResponseBody
    @RequestMapping("/refuseJoin")
    public String refuseJoin(Long participateId)
    {
        int result=participateService.refuseJoin(participateId);
        if(result<=0)
        {
            return "error";
        }
        return "success";
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
