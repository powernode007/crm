package com.bjpn.workbench.bean;

import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableField;
import java.io.Serializable;

/**
 * <p>
 * 
 * </p>
 *
 * @author ${author}
 * @since 2022-11-18
 */
@TableName("tbl_beizhu")
public class Beizhu implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "beizhu_id", type = IdType.AUTO)
    private Integer beizhuId;

    private String beizhuName;

    private String beizhuTime;

    private String beizhuOwner;

    private String beizhuPinglun;

    @TableField("beizhu_editFlag")
    private String beizhuEditflag;

    @TableField("beizhu_editTime")
    private String beizhuEdittime;

    @TableField("beizhu_editBy")
    private String beizhuEditby;

    @TableField("beizhu_activityId")
    private String beizhuActivityid;

    @TableField("beizhu_noteContent")
    private String beizhuNotecontent;


    public Integer getBeizhuId() {
        return beizhuId;
    }

    public void setBeizhuId(Integer beizhuId) {
        this.beizhuId = beizhuId;
    }

    public String getBeizhuName() {
        return beizhuName;
    }

    public void setBeizhuName(String beizhuName) {
        this.beizhuName = beizhuName;
    }

    public String getBeizhuTime() {
        return beizhuTime;
    }

    public void setBeizhuTime(String beizhuTime) {
        this.beizhuTime = beizhuTime;
    }

    public String getBeizhuOwner() {
        return beizhuOwner;
    }

    public void setBeizhuOwner(String beizhuOwner) {
        this.beizhuOwner = beizhuOwner;
    }

    public String getBeizhuPinglun() {
        return beizhuPinglun;
    }

    public void setBeizhuPinglun(String beizhuPinglun) {
        this.beizhuPinglun = beizhuPinglun;
    }

    public String getBeizhuEditflag() {
        return beizhuEditflag;
    }

    public void setBeizhuEditflag(String beizhuEditflag) {
        this.beizhuEditflag = beizhuEditflag;
    }

    public String getBeizhuEdittime() {
        return beizhuEdittime;
    }

    public void setBeizhuEdittime(String beizhuEdittime) {
        this.beizhuEdittime = beizhuEdittime;
    }

    public String getBeizhuEditby() {
        return beizhuEditby;
    }

    public void setBeizhuEditby(String beizhuEditby) {
        this.beizhuEditby = beizhuEditby;
    }

    public String getBeizhuActivityid() {
        return beizhuActivityid;
    }

    public void setBeizhuActivityid(String beizhuActivityid) {
        this.beizhuActivityid = beizhuActivityid;
    }

    public String getBeizhuNotecontent() {
        return beizhuNotecontent;
    }

    public void setBeizhuNotecontent(String beizhuNotecontent) {
        this.beizhuNotecontent = beizhuNotecontent;
    }

    @Override
    public String toString() {
        return "Beizhu{" +
        "beizhuId=" + beizhuId +
        ", beizhuName=" + beizhuName +
        ", beizhuTime=" + beizhuTime +
        ", beizhuOwner=" + beizhuOwner +
        ", beizhuPinglun=" + beizhuPinglun +
        ", beizhuEditflag=" + beizhuEditflag +
        ", beizhuEdittime=" + beizhuEdittime +
        ", beizhuEditby=" + beizhuEditby +
        ", beizhuActivityid=" + beizhuActivityid +
        ", beizhuNotecontent=" + beizhuNotecontent +
        "}";
    }
}
