package com.peteralbus.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.peteralbus.dao.ActivityDao;
import com.peteralbus.dao.GroupDao;
import com.peteralbus.dao.ManageDao;
import com.peteralbus.dao.ParticipateDao;
import com.peteralbus.entity.*;
import com.sun.org.apache.xpath.internal.operations.Bool;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Wrapper;
import java.util.List;

/**
 * The type Activity service.
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
    public int addTeacherToActivity(Long teacherId,Long activityId)
    {
        Manage manage=new Manage();
        manage.setActivityId(activityId);
        manage.setUserId(teacherId);
        return manageDao.insert(manage);
    }
    public Activity getActivityById(Long activityId)
    {
        Activity activity=activityDao.selectById(activityId);
        activity.setTeacherList(activityDao.getTeacherList(activityId));
        return activity;
    }
    public Boolean checkIsManage(Long teacherId,Long activityId)
    {
        QueryWrapper<Manage> queryWrapper=new QueryWrapper<Manage>();
        queryWrapper.eq("user_id",teacherId);
        queryWrapper.eq("activity_id",activityId);
        Manage manage=manageDao.selectOne(queryWrapper);
        return manage != null;
    }
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
    public int getCount()
    {
        return activityDao.getCount();
    }
}
