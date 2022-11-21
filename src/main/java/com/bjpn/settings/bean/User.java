package com.bjpn.settings.bean;

import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import java.io.Serializable;

/**
 * <p>
 * 
 * </p>
 *
 * @author ${author}
 * @since 2022-11-10
 */
@TableName("tbl_user")
public class User implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 用户id  主键自增长 
     */
    @TableId(value = "user_id", type = IdType.AUTO)
    private Integer userId;

    /**
     * 用户账号
     */
    private String userCode;

    /**
     * 用户名
     */
    private String userName;

    /**
     * 密码
     */
    private String userPwd;

    /**
     * 用户邮箱
     */
    private String userEmail;

    /**
     * 失效时间为空的时候表示永不失效，失效时间为2018-10-10 10:10:10，则表示在该时间之前该账户可用。
     */
    private String userExpireTime;

    /**
     * 为0时表示锁定，为1时表示启用。
     */
    private String userLockState;

    /**
     * 部门名称
     */
    private String deptNo;

    /**
     * 数据插入时间
     */
    private String createTime;

    /**
     * 数据创建人
     */
    private String createBy;

    /**
     * 修改时间
     */
    private String editTime;

    /**
     * 修改人
     */
    private String editBy;


    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUserCode() {
        return userCode;
    }

    public void setUserCode(String userCode) {
        this.userCode = userCode;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserPwd() {
        return userPwd;
    }

    public void setUserPwd(String userPwd) {
        this.userPwd = userPwd;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getUserExpireTime() {
        return userExpireTime;
    }

    public void setUserExpireTime(String userExpireTime) {
        this.userExpireTime = userExpireTime;
    }

    public String getUserLockState() {
        return userLockState;
    }

    public void setUserLockState(String userLockState) {
        this.userLockState = userLockState;
    }

    public String getDeptNo() {
        return deptNo;
    }

    public void setDeptNo(String deptNo) {
        this.deptNo = deptNo;
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

    @Override
    public String toString() {
        return "User{" +
        "userId=" + userId +
        ", userCode=" + userCode +
        ", userName=" + userName +
        ", userPwd=" + userPwd +
        ", userEmail=" + userEmail +
        ", userExpireTime=" + userExpireTime +
        ", userLockState=" + userLockState +
        ", deptNo=" + deptNo +
        ", createTime=" + createTime +
        ", createBy=" + createBy +
        ", editTime=" + editTime +
        ", editBy=" + editBy +
        "}";
    }
}
