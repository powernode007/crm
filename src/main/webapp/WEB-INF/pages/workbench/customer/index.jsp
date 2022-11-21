<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">

    <link href="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css"
          rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css"
          type="text/css" rel="stylesheet"/>

    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <script type="text/javascript">

        $(function () {

            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });

        });

    </script>
    <script>
        $(function () {
            $("#create").click(function () {
                $("#createCustomerModal").modal("show")
                $.post("${pageContext.request.contextPath}/settings/user/findAllUser.action", function (UserList) {
                        $("#create-customerOwner").empty()
                        $.each(UserList, function (i, user) {
                            $("#create-customerOwner").append("<option value=" + user.userId + ">" + user.userName + "</option>")
                        })

                    }
                    , "json")
            })

            $("#save").click(function () {
                var format = $("#formCreateData").serialize();
                $.post("${pageContext.request.contextPath}/workbench/customer/toAddCustomer.action", format, function (message) {
                    if (message.messageCode == 5) {
                        alert(message.messageStr)
                        $("#createCustomerModal").modal("hide")
                        window.location.href = window.location.href;
                    } else {
                        alter(message.messageStr)
                    }
                }, "json")

            })
        })
    </script>

    <%--模糊查询带分页--%>
    <script>
        $(function () {
            //在页面加载完成后，定义一个全局变量pnum，所有script标签在页面加载完成后都可用这个变量
            var pnum;
            //如果不模糊查询，则在页面加载完毕之后就执行
            findAllCustomerByLikePage(1);
            //如果模糊查询，则点击事件执行
            $("#chaxun").click(function () {
                findAllCustomerByLikePage(1);
            })
        })

        function findAllCustomerByLikePage(pageNum) {
            //获取模糊查询关键字的值
            var likeName = $("#name1").val()
            var likeOwner = $("#owner1").val()
            var likeWebsite = $("#website1").val()
            var likePhone = $("#phone1").val()

            var data = {
                "pageNum": pageNum,
                "likeName": likeName,
                "likeOwner": likeOwner,
                "likeWebsite": likeWebsite,
                "likePhone": likePhone
            };
            $.post("${pageContext.request.contextPath}/workbench/customer/findAllCustomerByLikePage.action", data, function (likeCustomer) {

                //查询后回显数据
                $("#name1").val(likeCustomer.likeName)
                $("#owner1").val(likeCustomer.likeOwner)
                $("#website1").val(likeCustomer.likeWebsite)
                $("#phone1").val(likeCustomer.likePhone)
                var $biaoge = $("#biaoge")
                $biaoge.empty()
                var pageInfo = likeCustomer.pageInfoLike;
                pnum = pageInfo.pageNum;
                $.each(pageInfo.list, function (i, customer) {
                    $.post("${pageContext.request.contextPath}/settings/user/findUserById.action", "userId=" + customer.owner, function (user) {
                        $biaoge.append("<tr class='active' >" +
                            "<td><input type='checkbox' class='checkCustomer' value='" + customer.id + "' /></td>" +
                            "<td><a href='${pageContext.request.contextPath}/workbench/activity/showPingLun.action?activityId=" + customer.id + " style='text-decoration: none; cursor: pointer;'  >" + customer.name + "</a></td>" +
                            "<td>" + user.userName + "</td>" +
                            "<td>" + customer.phone + "</td>" +
                            "<td>" + customer.website + "</td>"
                        )
                    }, "json")
                })
                //分页信息的拼装
                var $showPage = $("#showPage");
                var htmlStr = "";
                if (pageInfo.isFirstPage) {
                    htmlStr += "<li class='disabled'><a href='#'>首页</a></li>"
                } else {
                    htmlStr += "<li ><a href='javascript:findAllCustomerByLikePage(1)'>首页</a></li>"
                }
                if (pageInfo.hasPreviousPage) {
                    htmlStr += "<li ><a href='javascript:findAllCustomerByLikePage(" + pageInfo.prePage + ")'>上一页</a></li>"
                } else {
                    htmlStr += "<li class='disabled'><a href='#'>上一页</a></li>"
                }
                for (var i = pageInfo.navigateFirstPage; i <= pageInfo.navigateLastPage; i++) {
                    if (pageInfo.pageNum == i) {
                        htmlStr += "<li class='active' ><a href='javascript:findAllCustomerByLikePage(" + i + ")'>" + i + "</a></li>"
                    } else {
                        htmlStr += "<li ><a href='javascript:findAllCustomerByLikePage(" + i + ")'>" + i + "</a></li>"
                    }
                }
                if (pageInfo.hasNextPage) {
                    htmlStr += "<li ><a href='javascript:findAllCustomerByLikePage(" + pageInfo.nextPage + ")'>下一页</a></li>"
                } else {
                    htmlStr += "<li class='disabled'><a href='#'>下一页</a></li>"
                }
                if (pageInfo.isLastPage) {
                    htmlStr += "<li class='disabled'><a href='#'>末页</a></li>"
                } else {
                    htmlStr += "<li ><a href='javascript:findAllCustomerByLikePage(" + pageInfo.pages + ")'>末页</a></li>"
                }
                $showPage.html(htmlStr);
            }, "json")
        }
    </script>
    <script>
        //异步修改
        $(function () {

            $("#editCustomerBut").click(function () {

                var $checkCustomer = $(".checkCustomer:checked");//获取当前页选中项
                //判断  1条或多条
                if ($checkCustomer.size() > 0) {
                    if ($checkCustomer.size() > 1) {
                        alert("您选中了多条市场活动，默认修改第一条")
                    }
                    var id = $checkCustomer[0].value;//===========================================  var id = $($checkCustomer[0]).val();

                    $.post("${pageContext.request.contextPath}/workbench/customer/selectById.action", "customerId=" + id, function (customer) {
                        //获取所有者信息

                        $.post("${pageContext.request.contextPath}/settings/user/findAllUser.action", function (userList) {

                            var $editSelect = $("#edit-customerOwner");
                            //清空下拉菜单的下拉项
                            $editSelect.empty();

                            $.each(userList, function (i, user) {
                                //数据回显  就是 原来市场活动的所有者   还得显示所有者是谁
                                if (customer.owner == user.userId) {
                                    $editSelect.append("<option  value='" + user.userId + "' selected='selected' >" + user.userName + "</option>")
                                } else {
                                    $editSelect.append("<option value='" + user.userId + "'>" + user.userName + "</option>")
                                }

                            })

                            $("#edit-customerName").val(customer.name)
                            $("#edit-website").val(customer.website)
                            $("#edit-phone").val(customer.phone)
                            $("#edit-describe").val(customer.description)
                            $("#create-contactSummary1").val(customer.contactSummary)
                            $("#create-nextContactTime2").val(customer.nextContactTime)
                            $("#create-address").val(customer.address)
                            //展示修改的模态窗口
                            $("#editCustomerModal").modal("show");
                            update(customer);
                        }, "json")
                    }, "json")
                } else {
                    alert("请选择要修改的市场活动项")
                    return;
                }
            })

            function update(customer) {

                $("#updateData").click(function () {
                    var id = customer.id;
                    var owner = $("#edit-customerOwner").val()
                    var name = $("#edit-customerName").val()
                    var website = $("#edit-website").val();
                    var phone = $("#edit-phone").val();
                    var description = $("#edit-describe").val();
                    var contactSummary = $("#create-contactSummary1").val();
                    var nextContactTime = $("#create-nextContactTime2").val();
                    var address = $("#create-address").val();
                    data = {
                        "id": id,
                        "owner": owner,
                        "name": name,
                        "website": website,
                        "phone": phone,
                        "description": description,
                        "contactSummary": contactSummary,
                        "nextContactTime": nextContactTime,
                        "address": address
                    }


                    $.post("${pageContext.request.contextPath}/workbench/customer/updateById.action", data, function (message) {

                        if (message.messageCode == 5) {
                            alert(message.messageStr)
                            $("#editCustomerModal").modal("hide")
                            findAllCustomerByLikePage(pnum);
                        } else {
                            alert(message.messageStr)
                        }
                    }, "json")
                })
            }

        })
    </script>
    <script>
        //异步删除
        $(function () {
            $("#removeBut").click(function () {
                // alert("???")
                var ids = "";
                var $checkCustomer = $(".checkCustomer:checked");
                if ($checkCustomer.size() == 0) {
                    alert("请勾选要删除的数据！！！")
                } else {
                    if (confirm("您确定删除吗？")) {
                        $.each($checkCustomer, function (i, checkCustomer) {
                            var id = $(checkCustomer).val()
                            ids += id + ",";
                        })
                        $.post("${pageContext.request.contextPath}/workbench/customer/removeById.action", "ids=" + ids, function (message) {
                            if (message.messageCode == 5) {
                                alert(message.messageStr)
                                findAllCustomerByLikePage(pnum);
                            } else {
                                alert(message.messageStr)
                            }
                        }, "json")
                    }
                }
            })
        })


    </script>
    <%--<script>--%>
       <%--$(function () {--%>
           <%--alert(pnum)--%>
       <%--})--%>
    <%--</script>--%>
</head>
<body>

<!-- 创建客户的模态窗口 -->
<div class="modal fade" id="createCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form" id="formCreateData">

                    <div class="form-group">
                        <label for="create-customerOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-customerOwner" name="owner">
                                <%--<option>zhangsan</option>--%>
                                <%--<option>lisi</option>--%>
                                <%--<option>wangwu</option>--%>
                            </select>
                        </div>
                        <label for="create-customerName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-customerName" name="name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website" name="website">
                        </div>
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone" name="phone">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-describe" name="description"></textarea>
                        </div>
                    </div>
                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-contactSummary"
                                          name="contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-nextContactTime"
                                       name="nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address1" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address1" name="address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="save">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改客户的模态窗口 -->
<div class="modal fade" id="editCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-customerOwner">
                                <%--<option>zhangsan</option>--%>
                                <%--<option>lisi</option>--%>
                                <%--<option>wangwu</option>--%>
                            </select>
                        </div>
                        <label for="edit-customerName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-customerName" value="动力节点">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website"
                                   value="http://www.bjpowernode.com">
                        </div>
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" value="010-84846003">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contactSummary1" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-contactSummary1"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime2" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-nextContactTime2">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address">北京大兴大族企业湾</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="updateData">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>客户列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="name1" name="name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="owner1" name="owner">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input class="form-control" type="text" id="phone1" name="phone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司网站</div>
                        <input class="form-control" type="text" id="website1" name="website">
                    </div>
                </div>

                <input type="button" class="btn btn-default" id="chaxun" value="查询"></input>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" data-toggle="modal" id="create"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" data-toggle="modal" id="editCustomerBut"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="removeBut"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>公司座机</td>
                    <td>公司网站</td>
                </tr>
                </thead>
                <tbody id="biaoge">
                <%--<tr>--%>
                <%--<td><input type="checkbox"/></td>--%>
                <%--<td><a style="text-decoration: none; cursor: pointer;"--%>
                <%--onclick="window.location.href='detail.html';">动力节点</a></td>--%>
                <%--<td>zhangsan</td>--%>
                <%--<td>010-84846003</td>--%>
                <%--<td>http://www.bjpowernode.com</td>--%>
                <%--</tr>--%>

                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">
            <div>
                <button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
            </div>
            <div class="btn-group" style="position: relative;top: -34px; left: 110px;">
                <button type="button" class="btn btn-default" style="cursor: default;">显示</button>
                <div class="btn-group">
                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                        10
                        <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu">
                        <li><a href="#">20</a></li>
                        <li><a href="#">30</a></li>
                    </ul>
                </div>
                <button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
            </div>
            <div style="position: relative;top: -88px; left: 285px;">
                <nav>
                    <ul class="pagination" id="showPage">
                        <%--<li class="disabled"><a href="#">首页</a></li>--%>
                        <%--<li class="disabled"><a href="#">上一页</a></li>--%>
                        <%--<li class="active"><a href="#">1</a></li>--%>
                        <%--<li><a href="#">2</a></li>--%>
                        <%--<li><a href="#">3</a></li>--%>
                        <%--<li><a href="#">4</a></li>--%>
                        <%--<li><a href="#">5</a></li>--%>
                        <%--<li><a href="#">下一页</a></li>--%>
                        <%--<li class="disabled"><a href="#">末页</a></li>--%>
                    </ul>
                </nav>
            </div>
        </div>

    </div>

</div>
</body>
</html>