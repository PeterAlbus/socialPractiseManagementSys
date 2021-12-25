package com.peteralbus.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.peteralbus.dao.GroupDao;
import com.peteralbus.dao.ParticipateDao;
import com.peteralbus.dao.RecordDao;
import com.peteralbus.dao.UserDao;
import com.peteralbus.entity.Group;
import com.peteralbus.entity.Participate;
import com.peteralbus.entity.Record;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
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
     * The Group dao.
     */
    @Autowired
    GroupDao groupDao;
    /**
     * The Participate dao.
     */
    @Autowired
    ParticipateDao participateDao;
    /**
     * The User dao.
     */
    @Autowired
    UserDao userDao;

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

    /**
     * Select by group list.
     *
     * @param groupId the group id
     * @return the list
     */
    public List<Record> selectByGroup(Long groupId)
    {
        Group group= groupDao.selectById(groupId);
        QueryWrapper<Participate> queryWrapper=new QueryWrapper<>();
        queryWrapper.eq("group_id",groupId);
        List<Participate> participateList=participateDao.selectList(queryWrapper);
        List<Record> recordList=new ArrayList<>();
        for(Participate participate:participateList)
        {
            List<Record> records=this.selectByParticipate(participate.getParticipationId());
            for(Record record:records)
            {
                record.setAuthorName(userDao.selectById(participate.getUserId()).getRealName());
            }
            recordList.addAll(records);
        }
        return recordList;
    }

    /**
     * Sets read.
     *
     * @param recordId the record id
     * @return the read
     */
    public int setRead(Long recordId)
    {
        Record record=recordDao.selectById(recordId);
        record.setRead(true);
        return recordDao.updateById(record);
    }
}
