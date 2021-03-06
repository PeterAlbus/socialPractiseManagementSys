package com.peteralbus.controller;

import com.peteralbus.entity.*;
import com.peteralbus.service.*;
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
import java.util.Map;

/**
 * The type Teacher controller.
 *
 * @author PeterAlbus
 */
@Controller
@RequiresRoles(value={"teacher","admin"}, logical= Logical.OR)
@RequestMapping("/teacher")
public class TeacherController
{
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
    /**
     * The Group service.
     */
    @Autowired
    GroupService groupService;
    /**
     * The Record service.
     */
    @Autowired
    RecordService recordService;
    /**
     * The Score group service.
     */
    @Autowired
    ScoreGroupService scoreGroupService;
    /**
     * The Score stu service.
     */
    @Autowired
    ScoreStuService scoreStuService;
    /**
     * The Message service.
     */
    @Autowired
    MessageService messageService;
    /**
     * The Participate service.
     */
    @Autowired
    ParticipateService participateService;
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
        Subject subject = SecurityUtils.getSubject();
        User user=(User)subject.getPrincipal();
        List<Activity> activityList=activityService.getActivityByTeacher(user.getUserId());
        modelAndView.addObject("activityList",activityList);
        List<Activity> allActivities=activityService.getActivities();
        modelAndView.addObject("allActivities",allActivities);
        modelAndView.setViewName("/jsp/teacher/activity.jsp");
        return modelAndView;
    }

    /**
     * Activity detail model and view.
     *
     * @param activityId the activity id
     * @return the model and view
     */
    @RequestMapping("/activityDetail")
    public ModelAndView activityDetail(Long activityId)
    {
        ModelAndView modelAndView=this.basicModelAndView();
        Activity activity=activityService.getActivityById(activityId);
        modelAndView.addObject("activity",activity);
        modelAndView.setViewName("/jsp/teacher/activityDetail.jsp");
        return modelAndView;
    }

    /**
     * Modify activity model and view.
     *
     * @param activityId the activity id
     * @return the model and view
     */
    @RequestMapping("/modifyActivity")
    public ModelAndView modifyActivity(Long activityId)
    {
        ModelAndView modelAndView=this.basicModelAndView();
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

    /**
     * Manage group model and view.
     *
     * @param groupId the group id
     * @return the model and view
     */
    @RequestMapping("/manageGroup")
    public ModelAndView manageGroup(Long groupId)
    {
        ModelAndView modelAndView=this.basicModelAndView();
        Subject subject = SecurityUtils.getSubject();
        User user=(User)subject.getPrincipal();
        Group group=groupService.getById(groupId);
        Activity activity= activityService.getActivityById(group.getActivityId());
        List<Participate> memberList=groupService.getGroupMember(group.getGroupId());
        List<Record> recordList=recordService.selectByGroup(groupId);
        modelAndView.addObject("group",group);
        modelAndView.addObject("memberList",memberList);
        modelAndView.addObject("recordList",recordList);
        modelAndView.addObject("activity",activity);
        modelAndView.addObject("isFinished",memberList.get(0).getFinished());
        modelAndView.addObject("isScored",scoreGroupService.getScored(user.getUserId(),groupId));
        Map<String,Double> map=groupService.getScore(groupId);
        modelAndView.addObject("score",map);
        modelAndView.setViewName("/jsp/teacher/manageGroup.jsp");
        return modelAndView;
    }

    /**
     * Add activity string.
     *
     * @param activity the activity
     * @return the string
     */
    @ResponseBody
    @RequestMapping("/addActivity")
    public String addActivity(Activity activity)
    {
        try
        {
            int result=activityService.addActivity(activity);
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

    /**
     * Update activity string.
     *
     * @param activity the activity
     * @return the string
     */
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

    /**
     * Delete activity string.
     *
     * @param activityId the activity id
     * @return the string
     */
    @ResponseBody
    @RequestMapping("/deleteActivity")
    public String deleteActivity(Long activityId)
    {
        try
        {
            int result=activityService.deleteActivity(activityId);
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

    /**
     * Add teacher to activity string.
     *
     * @param userId     the user id
     * @param activityId the activity id
     * @return the string
     */
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
            messageService.sendMessage(userId,"??????",
                    "????????????????????????","?????????????????????????????????????????????????????????id???"+activityId+"???");
            return "success";
        }
        return "error";
    }

    /**
     * Sets read.
     *
     * @param recordId the record id
     * @return the read
     */
    @ResponseBody
    @RequestMapping("/setRead")
    public String setRead(Long recordId)
    {
        int result= recordService.setRead(recordId);
        if(result>0)
        {
            return "success";
        }
        return "error";
    }

    /**
     * Score stu string.
     *
     * @param scoreStu the score stu
     * @return the string
     */
    @ResponseBody
    @RequestMapping("/scoreStu")
    public String scoreStu(ScoreStu scoreStu)
    {
        int result=scoreStuService.insert(scoreStu);
        Participate participate= participateService.getById(scoreStu.getParticipationId());
        if(result>0)
        {
            messageService.sendMessage(participate.getUserId(),"??????",
                    "????????????????????????","?????????????????????????????????????????????????????????????????????????????????id???"+participate.getActivityId()+"???");
            return "success";
        }
        return "error";
    }

    /**
     * Score group string.
     *
     * @param scoreGroup the score group
     * @return the string
     */
    @ResponseBody
    @RequestMapping("/scoreGroup")
    public String scoreGroup(ScoreGroup scoreGroup)
    {
        if(scoreGroupService.getScored(scoreGroup.getTeacherId(),scoreGroup.getGroupId()))
        {
            return "error";
        }
        int result=scoreGroupService.insert(scoreGroup);
        if(result>0)
        {
            return "success";
        }
        return "error";
    }
}
