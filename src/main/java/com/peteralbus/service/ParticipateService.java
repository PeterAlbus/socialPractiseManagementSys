package com.peteralbus.service;

import com.peteralbus.dao.ParticipateDao;
import com.peteralbus.entity.Participate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ParticipateService
{
    @Autowired
    ParticipateDao participateDao;
    public int insertParticipate(Participate participate)
    {
        return participateDao.insert(participate);
    }
}
