package com.peteralbus.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * The type Record.
 * @author PeterAlbus
 */
@TableName("record")
public class Record implements Serializable
{
    @TableId(type= IdType.ASSIGN_ID)
    private Long recordId;
    private Long participationId;
    private String recordTitle;
    private String recordContent;
    private Boolean isRead;
    @TableField(exist = false)
    private String authorName;
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

    public Long getRecordId()
    {
        return recordId;
    }

    public void setRecordId(Long recordId)
    {
        this.recordId = recordId;
    }

    public Long getParticipationId()
    {
        return participationId;
    }

    public void setParticipationId(Long participationId)
    {
        this.participationId = participationId;
    }

    public String getRecordTitle()
    {
        return recordTitle;
    }

    public void setRecordTitle(String recordTitle)
    {
        this.recordTitle = recordTitle;
    }

    public String getRecordContent()
    {
        return recordContent;
    }

    public void setRecordContent(String recordContent)
    {
        this.recordContent = recordContent;
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

    public String getAuthorName()
    {
        return authorName;
    }

    public void setAuthorName(String authorName)
    {
        this.authorName = authorName;
    }

    @Override
    public String toString()
    {
        return "Record{" +
                "recordId=" + recordId +
                ", participationId=" + participationId +
                ", recordTitle='" + recordTitle + '\'' +
                ", recordContent='" + recordContent + '\'' +
                ", isRead=" + isRead +
                ", version=" + version +
                ", gmtCreate=" + gmtCreate +
                ", gmtModified=" + gmtModified +
                ", isDelete=" + isDelete +
                '}';
    }
}
