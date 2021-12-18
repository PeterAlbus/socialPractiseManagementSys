package com.peteralbus.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.peteralbus.entity.Record;
import org.apache.ibatis.annotations.Mapper;

/**
 * The interface Record dao.
 * @author PeterAlbus
 */
@Mapper
public interface RecordDao extends BaseMapper<Record>
{
}
