package com.peteralbus.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.peteralbus.entity.Activity;
import com.peteralbus.entity.User;
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
     * Gets activity by student.
     *
     * @param userId the user id
     * @return the activity by student
     */
    List<Activity> getActivityByStudent(Long userId);

    /**
     * Gets teacher list.
     *
     * @param activityId the activity id
     * @return the teacher list
     */
    List<User> getTeacherList(Long activityId);

    /**
     * Admin activity list list.
     *
     * @return the list
     */
    List<Activity> adminActivityList();

    /**
     * Restore int.
     *
     * @param activityId the activity id
     * @return the int
     */
    int restore(Long activityId);

    /**
     * Gets count.
     *
     * @return the count
     */
    int getCount();
}
