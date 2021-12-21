package com.peteralbus.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.peteralbus.entity.Group;
import org.apache.ibatis.annotations.Mapper;

/**
 * The interface Group dao.
 *
 * @author PeterAlbus
 */
@Mapper
public interface GroupDao extends BaseMapper<Group>
{
    /**
     * Restore int.
     *
     * @param activityId the activity id
     * @return the int
     */
    int restore(Long activityId);
}
