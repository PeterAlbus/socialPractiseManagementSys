package com.peteralbus.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.peteralbus.dao.MessageDao;
import com.peteralbus.entity.Message;
import com.peteralbus.entity.User;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * The type Message service.
 *
 * @author peteralbus
 */
@Service
public class MessageService
{
    /**
     * The Message dao.
     */
    @Autowired
    MessageDao messageDao;

    /**
     * Gets message.
     *
     * @return the message
     */
    public List<Message> getMessage()
    {
        Subject subject = SecurityUtils.getSubject();
        User user=(User)subject.getPrincipal();
        QueryWrapper<Message> queryWrapper=new QueryWrapper<>();
        queryWrapper.eq("message_receiver",user.getUserId());
        return messageDao.selectList(queryWrapper);
    }

    /**
     * Gets new message.
     *
     * @return the new message
     */
    public List<Message> getNewMessage()
    {
        Subject subject = SecurityUtils.getSubject();
        User user=(User)subject.getPrincipal();
        QueryWrapper<Message> queryWrapper=new QueryWrapper<>();
        queryWrapper.eq("message_receiver",user.getUserId());
        queryWrapper.eq("is_read",false);
        return messageDao.selectList(queryWrapper);
    }

    /**
     * Gets new message count.
     *
     * @return the new message count
     */
    public Long getNewMessageCount()
    {
        Subject subject = SecurityUtils.getSubject();
        User user=(User)subject.getPrincipal();
        QueryWrapper<Message> queryWrapper=new QueryWrapper<>();
        queryWrapper.eq("message_receiver",user.getUserId());
        queryWrapper.eq("is_read",false);
        return messageDao.selectCount(queryWrapper);
    }

    /**
     * Send message int.
     *
     * @param targetId the target id
     * @param sender   the sender
     * @param title    the title
     * @param content  the content
     * @return the int
     */
    public int sendMessage(Long targetId,String sender,String title,String content)
    {
        Message message=new Message();
        message.setMessageSender(sender);
        message.setMessageReceiver(targetId);
        message.setMessageTitle(title);
        message.setMessageContent(content);
        message.setRead(false);
        return messageDao.insert(message);
    }

    /**
     * Read message int.
     *
     * @param messageId the message id
     * @return the int
     */
    public int readMessage(Long messageId)
    {
        Message message=messageDao.selectById(messageId);
        message.setRead(true);
        return messageDao.updateById(message);
    }
}
