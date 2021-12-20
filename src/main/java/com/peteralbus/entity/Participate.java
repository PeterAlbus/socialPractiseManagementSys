package com.peteralbus.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * The type Participate.
 * @author PeterAlbus
 */
@TableName("participate")
public class Participate implements Serializable
{
    @TableId(type= IdType.ASSIGN_ID)
    private Long participationId;
    private Long userId;
    @TableField(exist = false)
    private String username;
    @TableField(exist = false)
    private String realName;
    private Long activityId;
    private Long groupId;
    private Boolean isFinished;
    private Boolean isAccept;
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

    public Long getParticipationId()
    {
        return participationId;
    }

    public void setParticipationId(Long participationId)
    {
        this.participationId = participationId;
    }

    public Long getUserId()
    {
        return userId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public Long getActivityId()
    {
        return activityId;
    }

    public void setActivityId(Long activityId)
    {
        this.activityId = activityId;
    }

    public Long getGroupId()
    {
        return groupId;
    }

    public void setGroupId(Long groupId)
    {
        this.groupId = groupId;
    }

    public Boolean getFinished()
    {
        return isFinished;
    }

    public void setFinished(Boolean finished)
    {
        isFinished = finished;
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

    public Boolean getAccept()
    {
        return isAccept;
    }

    public void setAccept(Boolean accept)
    {
        isAccept = accept;
    }

    public String getUsername()
    {
        return username;
    }

    public void setUsername(String username)
    {
        this.username = username;
    }

    public String getRealName()
    {
        return realName;
    }

    public void setRealName(String realName)
    {
        this.realName = realName;
    }

    @Override
    public String toString()
    {
        return "Participate{" +
                "participationId=" + participationId +
                ", userId=" + userId +
                ", activityId=" + activityId +
                ", groupId=" + groupId +
                ", isFinished=" + isFinished +
                ", isAccept=" + isAccept +
                ", version=" + version +
                ", gmtCreate=" + gmtCreate +
                ", gmtModified=" + gmtModified +
                ", isDelete=" + isDelete +
                '}';
    }
}
