package com.peteralbus.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.peteralbus.dao.ScoreGroupDao;
import com.peteralbus.entity.ScoreGroup;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * The type Score group service.
 *
 * @author peteralbus
 */
@Service
public class ScoreGroupService
{
    /**
     * The Score group dao.
     */
    @Autowired
    ScoreGroupDao scoreGroupDao;

    /**
     * Insert int.
     *
     * @param scoreGroup the score group
     * @return the int
     */
    public int insert(ScoreGroup scoreGroup)
    {
        return scoreGroupDao.insert(scoreGroup);
    }

    /**
     * Gets scored.
     *
     * @param teacherId the teacher id
     * @param groupId   the group id
     * @return the scored
     */
    public Boolean getScored(Long teacherId,Long groupId)
    {
        QueryWrapper<ScoreGroup> queryWrapper=new QueryWrapper<>();
        queryWrapper.eq("teacher_id",teacherId);
        queryWrapper.eq("group_id",groupId);
        return scoreGroupDao.selectCount(queryWrapper) > 0;
    }
}
