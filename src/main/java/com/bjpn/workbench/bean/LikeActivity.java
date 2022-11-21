package com.bjpn.workbench.bean;

import com.github.pagehelper.PageInfo;

import java.util.Objects;

public class LikeActivity {
    private PageInfo<Activity> pageInfoLike;
    private String likeActivityName;
    private String likeActivityOwner;
    private String likeStartDate;
    private String likeEndDate;

    @Override
    public String toString() {
        return "LikeActivity{" +
                "pageInfoLike=" + pageInfoLike +
                ", likeActivityName='" + likeActivityName + '\'' +
                ", likeActivityOwner='" + likeActivityOwner + '\'' +
                ", likeStartDate='" + likeStartDate + '\'' +
                ", likeEndDate='" + likeEndDate + '\'' +
                '}';
    }

    public PageInfo<Activity> getPageInfoLike() {
        return pageInfoLike;
    }

    public void setPageInfoLike(PageInfo<Activity> pageInfoLike) {
        this.pageInfoLike = pageInfoLike;
    }

    public String getLikeActivityName() {
        return likeActivityName;
    }

    public void setLikeActivityName(String likeActivityName) {
        this.likeActivityName = likeActivityName;
    }

    public String getLikeActivityOwner() {
        return likeActivityOwner;
    }

    public void setLikeActivityOwner(String likeActivityOwner) {
        this.likeActivityOwner = likeActivityOwner;
    }

    public String getLikeStartDate() {
        return likeStartDate;
    }

    public void setLikeStartDate(String likeStartDate) {
        this.likeStartDate = likeStartDate;
    }

    public String getLikeEndDate() {
        return likeEndDate;
    }

    public void setLikeEndDate(String likeEndDate) {
        this.likeEndDate = likeEndDate;
    }
}
