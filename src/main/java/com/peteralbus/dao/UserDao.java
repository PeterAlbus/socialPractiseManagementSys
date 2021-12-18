package com.peteralbus.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.peteralbus.entity.User;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * The interface User dao.
 * @author PeterAlbus
 */
@Mapper
public interface UserDao extends BaseMapper<User>
{
}
