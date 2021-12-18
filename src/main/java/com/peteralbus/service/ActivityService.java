package com.peteralbus.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.peteralbus.dao.ActivityDao;
import com.peteralbus.dao.ManageDao;
import com.peteralbus.entity.Activity;
import com.peteralbus.entity.Manage;
import com.peteralbus.entity.User;
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
        return activityDao.selectById(activityId);
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
        return activityDao.getActivityByTeacher(teacherId);
    }
    public List<Activity> getActivities()
    {
        return activityDao.getActivities();
    }
    public int getCount()
    {
        return activityDao.getCount();
    }
}
