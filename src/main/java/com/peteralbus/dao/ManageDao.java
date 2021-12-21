package com.peteralbus.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.peteralbus.entity.Manage;
import org.apache.ibatis.annotations.Mapper;

/**
 * The interface Manage dao.
 * @author PeterAlbus
 */
@Mapper
public interface ManageDao extends BaseMapper<Manage>
{
    /**
     * Restore int.
     *
     * @param activityId the activity id
     * @return the int
     */
    int restore(Long activityId);
}
