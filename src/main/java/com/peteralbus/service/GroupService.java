package com.peteralbus.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.peteralbus.dao.GroupDao;
import com.peteralbus.dao.ParticipateDao;
import com.peteralbus.dao.UserDao;
import com.peteralbus.entity.Group;
import com.peteralbus.entity.Participate;
import com.peteralbus.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * The type Group service.
 *
 * @author peteralbus
 */
@Service
public class GroupService
{
    /**
     * The Group dao.
     */
    @Autowired
    GroupDao groupDao;
    /**
     * The User dao.
     */
    @Autowired
    UserDao userDao;
    /**
     * The Participate dao.
     */
    @Autowired
    ParticipateDao participateDao;

    /**
     * Gets group list by activity.
     *
     * @param activityId the activity id
     * @return the group list by activity
     */
    public List<Group> getGroupListByActivity(Long activityId)
    {
        QueryWrapper<Group> queryWrapper=new QueryWrapper<>();
        queryWrapper.eq("activity_id",activityId);
        List<Group> groupList=groupDao.selectList(queryWrapper);
        for(Group group:groupList)
        {
            User user=userDao.selectById(group.getLeaderId());
            group.setLeaderName(user.getRealName());
            List<Participate> memberList=this.getGroupMember(group.getGroupId());
            group.setMemberList(memberList);
            Long memberCount=this.getMemberCount(group.getGroupId());
            group.setMemberCount(memberCount);
        }
        return groupList;
    }

    /**
     * Gets by id.
     *
     * @param groupId the group id
     * @return the by id
     */
    public Group getById(Long groupId)
    {
        Group group=groupDao.selectById(groupId);
        User user=userDao.selectById(group.getLeaderId());
        group.setLeaderName(user.getRealName());
        group.setMemberCount(getMemberCount(groupId));
        return group;
    }

    /**
     * Gets member count.
     *
     * @param groupId the group id
     * @return the member count
     */
    public Long getMemberCount(Long groupId)
    {
        QueryWrapper<Participate> queryWrapper=new QueryWrapper<>();
        queryWrapper.eq("group_id",groupId);
        queryWrapper.eq("is_accept",true);
        return participateDao.selectCount(queryWrapper);
    }

    /**
     * Gets group member.
     *
     * @param groupId the group id
     * @return the group member
     */
    public List<Participate> getGroupMember(Long groupId)
    {
        QueryWrapper<Participate> queryWrapper=new QueryWrapper<>();
        queryWrapper.eq("group_id",groupId);
        List<Participate> memberList=participateDao.selectList(queryWrapper);
        for(Participate participate:memberList)
        {
            User user= userDao.selectById(participate.getUserId());
            participate.setUsername(user.getUsername());
            participate.setRealName(user.getRealName());
        }
        return memberList;
    }

    /**
     * Insert group int.
     *
     * @param group the group
     * @return the int
     */
    public int insertGroup(Group group)
    {
        return groupDao.insert(group);
    }
}
