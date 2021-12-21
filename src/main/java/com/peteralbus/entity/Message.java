package com.peteralbus.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * The type Message.
 * @author peteralbus
 */
public class Message implements Serializable
{
    @TableId(type= IdType.ASSIGN_ID)
    private Long messageId;
    private String messageTitle;
    private Long messageReceiver;
    private String messageSender;
    private String messageContent;
    private Boolean isRead;
    @Version
    private Integer version;
    @TableField(fill = FieldFill.INSERT)
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime gmtCreate;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime gmtModified;
    @TableLogic
    private Integer isDelete;

    public Long getMessageId()
    {
        return messageId;
    }

    public void setMessageId(Long messageId)
    {
        this.messageId = messageId;
    }

    public String getMessageTitle()
    {
        return messageTitle;
    }

    public void setMessageTitle(String messageTitle)
    {
        this.messageTitle = messageTitle;
    }

    public Long getMessageReceiver()
    {
        return messageReceiver;
    }

    public void setMessageReceiver(Long messageReceiver)
    {
        this.messageReceiver = messageReceiver;
    }

    public String getMessageSender()
    {
        return messageSender;
    }

    public void setMessageSender(String messageSender)
    {
        this.messageSender = messageSender;
    }

    public String getMessageContent()
    {
        return messageContent;
    }

    public void setMessageContent(String messageContent)
    {
        this.messageContent = messageContent;
    }

    public Boolean getRead()
    {
        return isRead;
    }

    public void setRead(Boolean read)
    {
        isRead = read;
    }

    public Integer getVersion()
    {
        return version;
    }

    public void setVersion(Integer version)
    {
        this.version = version;
    }

    public LocalDateTime getGmtCreate()
    {
        return gmtCreate;
    }

    public void setGmtCreate(LocalDateTime gmtCreate)
    {
        this.gmtCreate = gmtCreate;
    }

    public LocalDateTime getGmtModified()
    {
        return gmtModified;
    }

    public void setGmtModified(LocalDateTime gmtModified)
    {
        this.gmtModified = gmtModified;
    }

    public Integer getIsDelete()
    {
        return isDelete;
    }

    public void setIsDelete(Integer isDelete)
    {
        this.isDelete = isDelete;
    }

    @Override
    public String toString()
    {
        return "Message{" +
                "messageId=" + messageId +
                ", messageTitle='" + messageTitle + '\'' +
                ", messageReceiver=" + messageReceiver +
                ", messageSender='" + messageSender + '\'' +
                ", messageContent='" + messageContent + '\'' +
                ", isRead=" + isRead +
                ", version=" + version +
                ", gmtCreate=" + gmtCreate +
                ", gmtModified=" + gmtModified +
                ", isDelete=" + isDelete +
                '}';
    }
}
