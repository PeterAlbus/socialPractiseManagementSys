package com.peteralbus.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.peteralbus.dao.RecordDao;
import com.peteralbus.entity.Record;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * The type Record service.
 *
 * @author peteralbus
 */
@Service
public class RecordService
{
    /**
     * The Record dao.
     */
    @Autowired
    RecordDao recordDao;

    /**
     * Insert record int.
     *
     * @param record the record
     * @return the int
     */
    public int insertRecord(Record record)
    {
        return recordDao.insert(record);
    }

    /**
     * Select by participate list.
     *
     * @param participationId the participation id
     * @return the list
     */
    public List<Record> selectByParticipate(Long participationId)
    {
        QueryWrapper<Record> queryWrapper=new QueryWrapper<>();
        queryWrapper.eq("participation_id",participationId);
        return recordDao.selectList(queryWrapper);
    }
}
