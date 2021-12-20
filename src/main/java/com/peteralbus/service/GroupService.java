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
 * @author peteralbus
 */
@Service
public class GroupService
{
    @Autowired
    GroupDao groupDao;
    @Autowired
    UserDao userDao;
    @Autowired
    ParticipateDao participateDao;
    public List<Group> getGroupListByActivity(Long activityId)
    {
        QueryWrapper<Group> queryWrapper=new QueryWrapper<>();
        queryWrapper.eq("activity_id",activityId);
        List<Group> groupList=groupDao.selectList(queryWrapper);
        for(Group group:groupList)
        {
            User user=userDao.selectById(group.getLeaderId());
            group.setLeaderName(user.getRealName());
        }
        return groupList;
    }
    public Group getById(Long groupId)
    {
        Group group=groupDao.selectById(groupId);
        User user=userDao.selectById(group.getLeaderId());
        group.setLeaderName(user.getRealName());
        group.setMemberCount(getMemberCount(groupId));
        return group;
    }
    public Long getMemberCount(Long groupId)
    {
        QueryWrapper<Participate> queryWrapper=new QueryWrapper<>();
        queryWrapper.eq("group_id",groupId);
        queryWrapper.eq("is_accept",true);
        return participateDao.selectCount(queryWrapper);
    }
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
    public int insertGroup(Group group)
    {
        return groupDao.insert(group);
    }
}
