package com.bjpn.workbench.bean;

import com.github.pagehelper.PageInfo;

import java.util.Objects;

public class LikeCustomer {


    private PageInfo<Customer> pageInfoLike;
    private String likeName;
    private String likeOwner;
    private String likePhone;
    private String likeWebsite;

    @Override
    public String toString() {
        return "LikeCustomer{" +
                "pageInfoLikeCustomer=" + pageInfoLike +
                ", likeName='" + likeName + '\'' +
                ", likeOwner='" + likeOwner + '\'' +
                ", likePhone='" + likePhone + '\'' +
                ", likeWebsite='" + likeWebsite + '\'' +
                '}';
    }

    public PageInfo<Customer> getPageInfoLike() {
        return pageInfoLike;
    }

    public void setPageInfoLike(PageInfo<Customer> pageInfoLike) {
        this.pageInfoLike = pageInfoLike;
    }

    public String getLikeName() {
        return likeName;
    }

    public void setLikeName(String likeName) {
        this.likeName = likeName;
    }

    public String getLikeOwner() {
        return likeOwner;
    }

    public void setLikeOwner(String likeOwner) {
        this.likeOwner = likeOwner;
    }

    public String getLikePhone() {
        return likePhone;
    }

    public void setLikePhone(String likePhone) {
        this.likePhone = likePhone;
    }

    public String getLikeWebsite() {
        return likeWebsite;
    }

    public void setLikeWebsite(String likeWebsite) {
        this.likeWebsite = likeWebsite;
    }
}
