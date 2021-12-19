package com.peteralbus.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.peteralbus.dao.GroupDao;
import com.peteralbus.dao.UserDao;
import com.peteralbus.entity.Group;
import com.peteralbus.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
        return groupDao.selectById(groupId);
    }
    public int insertGroup(Group group)
    {
        return groupDao.insert(group);
    }
}
