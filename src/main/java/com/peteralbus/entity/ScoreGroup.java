package com.peteralbus.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * The type Score group.
 * @author PeterAlbus
 */
@TableName("score_group")
public class ScoreGroup implements Serializable
{
    @TableId(type= IdType.ASSIGN_ID)
    private Long scoreId;
    private Long groupId;
    private Long teacherId;
    private Double scoreValue;
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

    public Long getScoreId()
    {
        return scoreId;
    }

    public void setScoreId(Long scoreId)
    {
        this.scoreId = scoreId;
    }

    public Long getGroupId()
    {
        return groupId;
    }

    public void setGroupId(Long groupId)
    {
        this.groupId = groupId;
    }

    public Long getTeacherId()
    {
        return teacherId;
    }

    public void setTeacherId(Long teacherId)
    {
        this.teacherId = teacherId;
    }

    public Double getScoreValue()
    {
        return scoreValue;
    }

    public void setScoreValue(Double scoreValue)
    {
        this.scoreValue = scoreValue;
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
        return "ScoreGroup{" +
                "scoreId=" + scoreId +
                ", groupId=" + groupId +
                ", teacherId=" + teacherId +
                ", scoreValue=" + scoreValue +
                ", version=" + version +
                ", gmtCreate=" + gmtCreate +
                ", gmtModified=" + gmtModified +
                ", isDelete=" + isDelete +
                '}';
    }
}
