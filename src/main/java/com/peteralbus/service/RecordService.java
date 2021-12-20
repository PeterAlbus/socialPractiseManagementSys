package com.peteralbus.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.peteralbus.dao.RecordDao;
import com.peteralbus.entity.Record;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * The type Record service.
 * @author peteralbus
 */
@Service
public class RecordService
{
    @Autowired
    RecordDao recordDao;
    public int insertRecord(Record record)
    {
        return recordDao.insert(record);
    }
    public List<Record> selectByParticipate(Long participationId)
    {
        QueryWrapper<Record> queryWrapper=new QueryWrapper<>();
        queryWrapper.eq("participation_id",participationId);
        return recordDao.selectList(queryWrapper);
    }
}
