package com.peteralbus.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.peteralbus.dao.*;
import com.peteralbus.entity.*;
import com.sun.org.apache.xpath.internal.operations.Bool;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Wrapper;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

/**
 * The type Activity service.
 *
 * @author PeterAlbus
 */
@Service
public class ActivityService
{
    @Autowired
    private ActivityDao activityDao;
    @Autowired
    private GroupDao groupDao;
    @Autowired
    private ParticipateDao participateDao;
    @Autowired
    private ManageDao manageDao;
    @Autowired
    private RecordDao recordDao;

    /**
     * Add activity int.
     *
     * @param activity the activity
     * @return the int
     */
    public int addActivity(Activity activity)
    {
        Subject subject = SecurityUtils.getSubject();
        User user=(User)subject.getPrincipal();
        activityDao.insert(activity);
        Manage manage=new Manage();
        manage.setActivityId(activity.getActivityId());
        manage.setUserId(user.getUserId());
        return manageDao.insert(manage);
    }

    /**
     * Update activity int.
     *
     * @param activity the activity
     * @return the int
     */
    public int updateActivity(Activity activity)
    {
        Activity old=activityDao.selectById(activity.getActivityId());
        old.setActivityName(activity.getActivityName());
        old.setActivityType(activity.getActivityType());
        old.setActivityIntroduction(activity.getActivityIntroduction());
        old.setMaxPeople(activity.getMaxPeople());
        old.setMinPeople(activity.getMinPeople());
        return activityDao.updateById(old);
    }

    /**
     * Add teacher to activity int.
     *
     * @param teacherId  the teacher id
     * @param activityId the activity id
     * @return the int
     */
    public int addTeacherToActivity(Long teacherId,Long activityId)
    {
        Manage manage=new Manage();
        manage.setActivityId(activityId);
        manage.setUserId(teacherId);
        return manageDao.insert(manage);
    }

    /**
     * Gets activity by id.
     *
     * @param activityId the activity id
     * @return the activity by id
     */
    public Activity getActivityById(Long activityId)
    {
        Activity activity=activityDao.selectById(activityId);
        activity.setTeacherList(activityDao.getTeacherList(activityId));
        return activity;
    }

    /**
     * Check is manage boolean.
     *
     * @param teacherId  the teacher id
     * @param activityId the activity id
     * @return the boolean
     */
    public Boolean checkIsManage(Long teacherId,Long activityId)
    {
        QueryWrapper<Manage> queryWrapper=new QueryWrapper<Manage>();
        queryWrapper.eq("user_id",teacherId);
        queryWrapper.eq("activity_id",activityId);
        Manage manage=manageDao.selectOne(queryWrapper);
        return manage != null;
    }

    /**
     * Gets activity by teacher.
     *
     * @param teacherId the teacher id
     * @return the activity by teacher
     */
    public List<Activity> getActivityByTeacher(Long teacherId)
    {
        List<Activity> activityList=activityDao.getActivityByTeacher(teacherId);
        for(Activity activity:activityList)
        {
            List<User> teacherList=activityDao.getTeacherList(activity.getActivityId());
            activity.setTeacherList(teacherList);
        }
        return activityList;
    }

    /**
     * Gets activity by student.
     *
     * @param studentId the student id
     * @return the activity by student
     */
    public List<Activity> getActivityByStudent(Long studentId)
    {
        List<Activity> activityList=activityDao.getActivityByStudent(studentId);
        for(Activity activity:activityList)
        {
            List<User> teacherList=activityDao.getTeacherList(activity.getActivityId());
            activity.setTeacherList(teacherList);
        }
        return activityList;
    }

    /**
     * Gets activities.
     *
     * @return the activities
     */
    public List<Activity> getActivities()
    {
        List<Activity> activityList=activityDao.selectList(null);
        for(Activity activity:activityList)
        {
            List<User> teacherList=activityDao.getTeacherList(activity.getActivityId());
            activity.setTeacherList(teacherList);
        }
        return activityList;
    }

    /**
     * Gets teacher list.
     *
     * @param activityId the activity id
     * @return the teacher list
     */
    public List<User> getTeacherList(Long activityId)
    {
        return activityDao.getTeacherList(activityId);
    }

    /**
     * Gets count.
     *
     * @return the count
     */
    public int getCount()
    {
        return activityDao.getCount();
    }

    /**
     * Delete activity int.
     *
     * @param activityId the activity id
     * @return the int
     */
    public int deleteActivity(Long activityId)
    {
        int result=0;
        QueryWrapper<Manage> manageQueryWrapper=new QueryWrapper<>();
        manageQueryWrapper.eq("activity_id",activityId);
        result=manageDao.delete(manageQueryWrapper);
        QueryWrapper<Participate> participateQueryWrapper=new QueryWrapper<>();
        participateQueryWrapper.eq("activity_id",activityId);
        List<Participate> participateList=participateDao.selectList(participateQueryWrapper);
        for(Participate participate:participateList)
        {
            QueryWrapper<Record> recordQueryWrapper=new QueryWrapper<>();
            recordQueryWrapper.eq("participation_id",participate.getParticipationId());
            result=recordDao.delete(recordQueryWrapper);
        }
        result=participateDao.delete(participateQueryWrapper);
        QueryWrapper<Group> groupQueryWrapper=new QueryWrapper<>();
        groupQueryWrapper.eq("activity_id",activityId);
        result=groupDao.delete(groupQueryWrapper);
        result=activityDao.deleteById(activityId);
        return result;
    }

    /**
     * Admin activity list list.
     *
     * @return the list
     */
    public List<Activity> adminActivityList()
    {
        return activityDao.adminActivityList();
    }

    /**
     * Restore int.
     *
     * @param activityId the activity id
     * @return the int
     */
    public int restore(Long activityId)
    {
        int result=0;
        result=activityDao.restore(activityId);
        manageDao.restore(activityId);
        groupDao.restore(activityId);
        participateDao.restore(activityId);
        QueryWrapper<Participate> participateQueryWrapper=new QueryWrapper<>();
        participateQueryWrapper.eq("activity_id",activityId);
        List<Participate> participateList=participateDao.selectList(participateQueryWrapper);
        for(Participate participate:participateList)
        {
            recordDao.restore(participate.getParticipationId());
        }
        return result;
    }

    /**
     * Gets user stat.
     *
     * @param user the user
     * @return the user stat
     */
    public Map<String,Long> getUserStat(User user)
    {
        Map<String,Long> stat=new TreeMap<>();
        if(user.getUserClass()==0)
        {
            stat.put("activityCount", 0L);
        }
        if(user.getUserClass()==1)
        {
            QueryWrapper<Participate> participateQueryWrapper=new QueryWrapper<>();
            participateQueryWrapper.eq("user_id",user.getUserId());
            Long activityCount=participateDao.selectCount(participateQueryWrapper);
            stat.put("activityCount", activityCount);
        }
        if(user.getUserClass()==2)
        {
            QueryWrapper<Manage> manageQueryWrapper=new QueryWrapper<>();
            manageQueryWrapper.eq("user_id",user.getUserId());
            Long activityCount=manageDao.selectCount(manageQueryWrapper);
            stat.put("activityCount", activityCount);
        }
        QueryWrapper<Group> groupQueryWrapper=new QueryWrapper<>();
        groupQueryWrapper.eq("leader_id",user.getUserId());
        Long groupCount=groupDao.selectCount(groupQueryWrapper);
        stat.put("groupCount",groupCount);
        return stat;
    }
}
