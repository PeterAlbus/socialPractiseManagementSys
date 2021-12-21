package com.peteralbus.service;

import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.peteralbus.dao.*;
import com.peteralbus.entity.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    @Autowired
    ScoreGroupDao scoreGroupDao;

    @Autowired
    ScoreStuDao scoreStuDao;

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
            group.setFinished(memberList.get(0).getFinished());
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

    public Map<String,Double> getScore(Long groupId)
    {
        Map<String,Double> map=new HashMap<>();
        QueryWrapper<ScoreGroup> queryWrapper=new QueryWrapper<>();
        queryWrapper.eq("group_id",groupId);
        List<ScoreGroup> scoreGroupList=scoreGroupDao.selectList(queryWrapper);
        double sum=0;
        for(ScoreGroup scoreGroup:scoreGroupList)
        {
            map.put(userDao.selectById(scoreGroup.getTeacherId()).getRealName()+"-小组评分:",scoreGroup.getScoreValue());
            sum+=scoreGroup.getScoreValue();
        }
        map.put("小组总评分:",sum/scoreGroupList.size());
        List<Participate> memberList=this.getGroupMember(groupId);
        for(Participate member:memberList)
        {
            QueryWrapper<ScoreStu> scoreStuQueryWrapper=new QueryWrapper<>();
            scoreStuQueryWrapper.eq("participation_id",member.getParticipationId());
            List<ScoreStu> scoreStuList=scoreStuDao.selectList(scoreStuQueryWrapper);
            sum=0;
            for(ScoreStu scoreStu:scoreStuList)
            {
                map.put(userDao.selectById(scoreStu.getTeacherId()).getRealName()+"-"+member.getRealName()+":",scoreStu.getScoreValue());
                sum+=scoreStu.getScoreValue();
            }
            map.put(member.getRealName()+"总评分:",sum/scoreStuList.size());
        }
        return map;
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
