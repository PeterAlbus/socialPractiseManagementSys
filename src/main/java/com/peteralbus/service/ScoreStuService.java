package com.peteralbus.service;

import com.peteralbus.dao.ParticipateDao;
import com.peteralbus.dao.ScoreStuDao;
import com.peteralbus.entity.Participate;
import com.peteralbus.entity.ScoreStu;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * The type Score stu service.
 *
 * @author peteralbus
 */
@Service
public class ScoreStuService
{
    /**
     * The Score stu dao.
     */
    @Autowired
    ScoreStuDao scoreStuDao;
    /**
     * The Participate dao.
     */
    @Autowired
    ParticipateDao participateDao;

    /**
     * Insert int.
     *
     * @param scoreStu the score stu
     * @return the int
     */
    public int insert(ScoreStu scoreStu)
    {
        if(scoreStuDao.insert(scoreStu)>0)
        {
            Participate participate=participateDao.selectById(scoreStu.getParticipationId());
            participate.setFinished(true);
            return participateDao.updateById(participate);
        }
        return 0;
    }
}
