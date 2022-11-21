package com.bjpn.workbench.bean;

import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import java.io.Serializable;
import java.util.Objects;

/**
 * <p>
 * 
 * </p>
 *
 * @author ${author}
 * @since 2022-11-11
 */
@TableName("tbl_activity")
public class Activity implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 市场活动id
     */
    @TableId(value = "activity_id", type = IdType.AUTO)
    private Integer activityId;

    /**
     * 用户的id
     */
    private Integer activityOwner;

    /**
     * 市场活动的名字
     */
    private String activityName;

    /**
     * 市场活动的开始时间
     */
    private String activityStartDate;

    /**
     * 市场活动的结束时间
     */
    private String activityEndDate;

    /**
     * 市场活动的成本
     */
    private String activityCost;

    /**
     * 市场活动的描述
     */
    private String activityDescription;

    private String createTime;

    private String createBy;

    private String editTime;

    private String editBy;

    private String activityBeizhu;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Activity activity = (Activity) o;
        return Objects.equals(activityId, activity.activityId) &&
                Objects.equals(activityOwner, activity.activityOwner) &&
                Objects.equals(activityName, activity.activityName) &&
                Objects.equals(activityStartDate, activity.activityStartDate) &&
                Objects.equals(activityEndDate, activity.activityEndDate) &&
                Objects.equals(activityCost, activity.activityCost) &&
                Objects.equals(activityDescription, activity.activityDescription) &&
                Objects.equals(createTime, activity.createTime) &&
                Objects.equals(createBy, activity.createBy) &&
                Objects.equals(editTime, activity.editTime) &&
                Objects.equals(editBy, activity.editBy) &&
                Objects.equals(activityBeizhu, activity.activityBeizhu);
    }

    @Override
    public int hashCode() {
        return Objects.hash(activityId, activityOwner, activityName, activityStartDate, activityEndDate, activityCost, activityDescription, createTime, createBy, editTime, editBy, activityBeizhu);
    }

    @Override
    public String toString() {
        return "Activity{" +
                "activityId=" + activityId +
                ", activityOwner=" + activityOwner +
                ", activityName='" + activityName + '\'' +
                ", activityStartDate='" + activityStartDate + '\'' +
                ", activityEndDate='" + activityEndDate + '\'' +
                ", activityCost='" + activityCost + '\'' +
                ", activityDescription='" + activityDescription + '\'' +
                ", createTime='" + createTime + '\'' +
                ", createBy='" + createBy + '\'' +
                ", editTime='" + editTime + '\'' +
                ", editBy='" + editBy + '\'' +
                ", activityBeizhu='" + activityBeizhu + '\'' +
                '}';
    }

    public String getActivityBeizhu() {
        return activityBeizhu;
    }

    public void setActivityBeizhu(String activityBeizhu) {
        this.activityBeizhu = activityBeizhu;
    }

    public Integer getActivityId() {
        return activityId;
    }

    public void setActivityId(Integer activityId) {
        this.activityId = activityId;
    }

    public Integer getActivityOwner() {
        return activityOwner;
    }

    public void setActivityOwner(Integer activityOwner) {
        this.activityOwner = activityOwner;
    }

    public String getActivityName() {
        return activityName;
    }

    public void setActivityName(String activityName) {
        this.activityName = activityName;
    }

    public String getActivityStartDate() {
        return activityStartDate;
    }

    public void setActivityStartDate(String activityStartDate) {
        this.activityStartDate = activityStartDate;
    }

    public String getActivityEndDate() {
        return activityEndDate;
    }

    public void setActivityEndDate(String activityEndDate) {
        this.activityEndDate = activityEndDate;
    }

    public String getActivityCost() {
        return activityCost;
    }

    public void setActivityCost(String activityCost) {
        this.activityCost = activityCost;
    }

    public String getActivityDescription() {
        return activityDescription;
    }

    public void setActivityDescription(String activityDescription) {
        this.activityDescription = activityDescription;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getCreateBy() {
        return createBy;
    }

    public void setCreateBy(String createBy) {
        this.createBy = createBy;
    }

    public String getEditTime() {
        return editTime;
    }

    public void setEditTime(String editTime) {
        this.editTime = editTime;
    }

    public String getEditBy() {
        return editBy;
    }

    public void setEditBy(String editBy) {
        this.editBy = editBy;
    }

}
