package com.peteralbus.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.peteralbus.entity.Message;
import org.apache.ibatis.annotations.Mapper;

/**
 * The interface Message dao.
 * @author peteralbus
 */
@Mapper
public interface MessageDao extends BaseMapper<Message>
{
}
