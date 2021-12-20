package com.peteralbus.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.peteralbus.dao.GroupDao;
import com.peteralbus.dao.ParticipateDao;
import com.peteralbus.entity.Group;
import com.peteralbus.entity.Participate;
import com.peteralbus.entity.User;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.UnauthorizedException;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * The type Participate service.
 * @author peteralbus
 */
@Service
public class ParticipateService
{
    /**
     * The Participate dao.
     */
    @Autowired
    ParticipateDao participateDao;
    /**
     * The Group dao.
     */
    @Autowired
    GroupDao groupDao;

    /**
     * Gets by user and activity.
     *
     * @param userId     the user id
     * @param activityId the activity id
     * @return the by user and activity
     */
    public Participate getByUserAndActivity(Long userId,Long activityId)
    {
        QueryWrapper<Participate> queryWrapper=new QueryWrapper<>();
        queryWrapper.eq("user_id",userId);
        queryWrapper.eq("activity_id",activityId);
        return participateDao.selectOne(queryWrapper);
    }

    /**
     * Insert participate int.
     *
     * @param participate the participate
     * @return the int
     */
    public int insertParticipate(Participate participate)
    {
        return participateDao.insert(participate);
    }

    /**
     * Participate with new group int.
     *
     * @param group the group
     * @return the int
     */
    public int participateWithNewGroup(Group group)
    {
        Subject subject = SecurityUtils.getSubject();
        User user=(User)subject.getPrincipal();
        group.setLeaderId(user.getUserId());
        int result=groupDao.insert(group);
        if(result>0)
        {
            Participate participate=new Participate();
            participate.setUserId(group.getLeaderId());
            participate.setGroupId(group.getGroupId());
            participate.setActivityId(group.getActivityId());
            participate.setFinished(false);
            participate.setAccept(true);
            result=participateDao.insert(participate);
        }
        return result;
    }

    /**
     * Participate with old group int.
     *
     * @param group the group
     * @return the int
     */
    public int participateWithOldGroup(Group group)
    {
        Subject subject = SecurityUtils.getSubject();
        User user=(User)subject.getPrincipal();
        Participate participate=new Participate();
        participate.setUserId(user.getUserId());
        participate.setGroupId(group.getGroupId());
        participate.setActivityId(group.getActivityId());
        participate.setFinished(false);
        participate.setAccept(false);
        return participateDao.insert(participate);
    }

    /**
     * Accept join int.
     *
     * @param participateId the participate id
     * @return the int
     */
    public int acceptJoin(Long participateId)
    {
        Participate participate=participateDao.selectById(participateId);
        Subject subject = SecurityUtils.getSubject();
        User user=(User)subject.getPrincipal();
        if(groupDao.selectById(participate.getGroupId()).getLeaderId().equals(user.getUserId()))
        {
            participate.setAccept(true);
            return participateDao.updateById(participate);
        }
        else
        {
            throw new UnauthorizedException();
        }
    }

    /**
     * Refuse join int.
     *
     * @param participateId the participate id
     * @return the int
     */
    public int refuseJoin(Long participateId)
    {
        Participate participate=participateDao.selectById(participateId);
        Subject subject = SecurityUtils.getSubject();
        User user=(User)subject.getPrincipal();
        if(groupDao.selectById(participate.getGroupId()).getLeaderId().equals(user.getUserId()))
        {
            return participateDao.deleteById(participate);
        }
        else
        {
            throw new UnauthorizedException();
        }
    }
}
