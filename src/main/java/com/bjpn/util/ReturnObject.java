package com.bjpn.util;

import java.util.Objects;

//这是一个工具类  用来给异步登录  注册  添加  修改  删除  提供统一的回执
public class ReturnObject {
    private int messageCode;
    private String messageStr;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ReturnObject that = (ReturnObject) o;
        return messageCode == that.messageCode &&
                Objects.equals(messageStr, that.messageStr);
    }

    @Override
    public int hashCode() {
        return Objects.hash(messageCode, messageStr);
    }

    public int getMessageCode() {
        return messageCode;
    }

    public void setMessageCode(int messageCode) {
        this.messageCode = messageCode;
    }

    public String getMessageStr() {
        return messageStr;
    }

    public void setMessageStr(String messageStr) {
        this.messageStr = messageStr;
    }

    public ReturnObject(int messageCode, String messageStr) {
        this.messageCode = messageCode;
        this.messageStr = messageStr;
    }
    public ReturnObject(){}

    @Override
    public String toString() {
        return "ReturnObject{" +
                "messageCode=" + messageCode +
                ", messageStr='" + messageStr + '\'' +
                '}';
    }
}
