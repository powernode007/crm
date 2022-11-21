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
 * @since 2022-11-19
 */
@TableName("tbl_customer_remark")
public class CustomerRemark implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private String id;

    @TableField("noteContent")
    private String noteContent;

    @TableField("createBy")
    private String createBy;

    @TableField("createTime")
    private String createTime;

    @TableField("editBy")
    private String editBy;

    @TableField("editTime")
    private String editTime;

    @TableField("editFlag")
    private String editFlag;

    @TableField("customerId")
    private String customerId;


    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNoteContent() {
        return noteContent;
    }

    public void setNoteContent(String noteContent) {
        this.noteContent = noteContent;
    }

    public String getCreateBy() {
        return createBy;
    }

    public void setCreateBy(String createBy) {
        this.createBy = createBy;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getEditBy() {
        return editBy;
    }

    public void setEditBy(String editBy) {
        this.editBy = editBy;
    }

    public String getEditTime() {
        return editTime;
    }

    public void setEditTime(String editTime) {
        this.editTime = editTime;
    }

    public String getEditFlag() {
        return editFlag;
    }

    public void setEditFlag(String editFlag) {
        this.editFlag = editFlag;
    }

    public String getCustomerId() {
        return customerId;
    }

    public void setCustomerId(String customerId) {
        this.customerId = customerId;
    }

    @Override
    public String toString() {
        return "CustomerRemark{" +
        "id=" + id +
        ", noteContent=" + noteContent +
        ", createBy=" + createBy +
        ", createTime=" + createTime +
        ", editBy=" + editBy +
        ", editTime=" + editTime +
        ", editFlag=" + editFlag +
        ", customerId=" + customerId +
        "}";
    }
}
