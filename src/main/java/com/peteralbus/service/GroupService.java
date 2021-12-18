package com.peteralbus.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.peteralbus.dao.GroupDao;
import com.peteralbus.entity.Group;
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
    public List<Group> getGroupListByActivity(Long activityId)
    {
        QueryWrapper<Group> queryWrapper=new QueryWrapper<>();
        queryWrapper.eq("activity_id",activityId);
        return groupDao.selectList(queryWrapper);
    }
    public int insertGroup(Group group)
    {
        return groupDao.insert(group);
    }
}
