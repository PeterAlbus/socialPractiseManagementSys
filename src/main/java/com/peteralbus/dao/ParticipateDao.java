package com.peteralbus.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.peteralbus.entity.Participate;
import org.apache.ibatis.annotations.Mapper;

/**
 * The interface Participate dao.
 * @author PeterAlbus
 */
@Mapper
public interface ParticipateDao extends BaseMapper<Participate>
{
    /**
     * Restore int.
     *
     * @param activityId the activity id
     * @return the int
     */
    int restore(Long activityId);
}
