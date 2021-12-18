package com.peteralbus.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.peteralbus.entity.Activity;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * The interface Activity dao.
 *
 * @author PeterAlbus
 */
@Mapper
public interface ActivityDao extends BaseMapper<Activity>
{
    /**
     * Gets activity by teacher.
     *
     * @param userId the user id
     * @return the activity by teacher
     */
    List<Activity> getActivityByTeacher(Long userId);

    /**
     * Gets activities.
     *
     * @return the activities
     */
    List<Activity> getActivities();

    /**
     * Gets count.
     *
     * @return the count
     */
    int getCount();
}
