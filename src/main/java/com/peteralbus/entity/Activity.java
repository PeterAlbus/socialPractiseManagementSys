package com.peteralbus.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * The type Activity.
 * @author PeterAlbus
 */
@TableName("activity")
public class Activity implements Serializable
{
    @TableId(type= IdType.ASSIGN_ID)
    private Long activityId;
    private String activityName;
    private String activityType;
    private String activityIntroduction;
    private Integer minPeople;
    private Integer maxPeople;
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
    @TableField(exist = false)
    private List<User> teacherList;

    public Long getActivityId()
    {
        return activityId;
    }

    public void setActivityId(Long activityId)
    {
        this.activityId = activityId;
    }

    public String getActivityName()
    {
        return activityName;
    }

    public void setActivityName(String activityName)
    {
        this.activityName = activityName;
    }

    public String getActivityType()
    {
        return activityType;
    }

    public void setActivityType(String activityType)
    {
        this.activityType = activityType;
    }

    public String getActivityIntroduction()
    {
        return activityIntroduction;
    }

    public void setActivityIntroduction(String activityIntroduction)
    {
        this.activityIntroduction = activityIntroduction;
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

    public String getFormattedCreateDate(){
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        return getGmtCreate().format(formatter);
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

    public List<User> getTeacherList()
    {
        return teacherList;
    }

    public void setTeacherList(List<User> teacherList)
    {
        this.teacherList = teacherList;
    }

    public Integer getMinPeople()
    {
        return minPeople;
    }

    public void setMinPeople(Integer minPeople)
    {
        this.minPeople = minPeople;
    }

    public Integer getMaxPeople()
    {
        return maxPeople;
    }

    public void setMaxPeople(Integer maxPeople)
    {
        this.maxPeople = maxPeople;
    }

    @Override
    public String toString()
    {
        return "Activity{" +
                "activityId=" + activityId +
                ", activityName='" + activityName + '\'' +
                ", activityType='" + activityType + '\'' +
                ", activityIntroduction='" + activityIntroduction + '\'' +
                ", minPeople=" + minPeople +
                ", maxPeople=" + maxPeople +
                ", version=" + version +
                ", gmtCreate=" + gmtCreate +
                ", gmtModified=" + gmtModified +
                ", isDelete=" + isDelete +
                ", teacherList=" + teacherList +
                '}';
    }
}
