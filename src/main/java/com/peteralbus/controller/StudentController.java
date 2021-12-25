package com.peteralbus.controller;

import com.peteralbus.entity.*;
import com.peteralbus.service.*;
import com.peteralbus.util.PrincipalUtil;
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
 * The type Student controller.
 * @author peteralbus
 */
@Controller
@RequiresRoles(value={"student","admin"}, logical= Logical.OR)
@RequestMapping("/student")
public class StudentController
{
    @Autowired
    MessageService messageService;
    @Autowired
    ActivityService activityService;
    @Autowired
    GroupService groupService;
    @Autowired
    ParticipateService participateService;
    @Autowired
    RecordService recordService;
    private ModelAndView basicModelAndView()
    {
        ModelAndView modelAndView=PrincipalUtil.getBasicModelAndView();
        modelAndView.addObject("messageCount",messageService.getNewMessageCount());
        modelAndView.addObject("newMessageList",messageService.getNewMessage());
        return modelAndView;
    }
    @RequestMapping("/activities")
    public ModelAndView activities()
    {
        ModelAndView modelAndView=this.basicModelAndView();
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
        ModelAndView modelAndView=this.basicModelAndView();
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
        ModelAndView modelAndView=this.basicModelAndView();
        Subject subject = SecurityUtils.getSubject();
        User user=(User)subject.getPrincipal();
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
        if(participate.getFinished())
        {
            Map<String,Double> map=groupService.getScore(group.getGroupId());
            modelAndView.addObject("score",map);
            modelAndView.setViewName("/jsp/student/activityResult.jsp");
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
        Participate participate=participateService.getById(record.getParticipationId());
        List<User> teacherList=activityService.getTeacherList(participate.getActivityId());
        for(User user:teacherList)
        {
            messageService.sendMessage(user.getUserId(),"系统",
                    "新的活动记录","你管理的活动有学生提交了新的活动记录！（活动id："+participate.getActivityId()+"）");
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
        Participate participate=participateService.getById(participateId);
        messageService.sendMessage(participate.getUserId(),"系统",
                "小组申请通过通知","先前申请社会实践小组的申请通过了！快去看看！（活动id："+participate.getActivityId()+"）");
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
        Participate participate=participateService.getById(participateId);
        messageService.sendMessage(participate.getUserId(),"系统",
                "小组申请拒绝通知","很遗憾，你加入小组的申请被组长拒绝了（活动id："+participate.getActivityId()+"）");
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
        if(groupService.getMemberCount(groupId)>=activityService.getActivityById(group.getActivityId()).getMaxPeople())
        {
            return "toManyMembers";
        }
        int result=participateService.participateWithOldGroup(group);
        if(result>0)
        {
            messageService.sendMessage(group.getLeaderId(),"系统",
                    "新的小组申请","你的小组"+group.getGroupName()+"有新的组员想要申请加入！你可以前往该活动的管理页面查看（活动id："+group.getActivityId()+"）");
            return "success";
        }
        else
        {
            return "error";
        }
    }
    @ResponseBody
    @RequestMapping("/deleteParticipate")
    public String deleteActivity(Long participationId)
    {
        try
        {
            int result=participateService.deleteParticipate(participationId);
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
            e.printStackTrace();
            return "error:"+e.getMessage();
        }
    }
}
