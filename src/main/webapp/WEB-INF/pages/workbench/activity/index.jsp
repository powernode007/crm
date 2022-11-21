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
            var x;
            $("#create").click(function () {

                $("#createActivityForm")[0].reset()
                $("#create-marketActivityOwner").empty()

                $.post("${pageContext.request.contextPath}/settings/user/findAllUser.action", function (UserList) {
                    $.each(UserList, function (i, user) {

                        $("#create-marketActivityOwner").append("<option selected='selected' value=" + user.userId + ">" + user.userName + "</option>")

                    })
                }, "json")
                $("#createActivityModal").modal("show");
            })


            $("#save").click(function () {

                var format = $("#createActivityForm").serialize();
                var ActivityName = $("#create-marketActivityName").val();
                var startTime = $("#create-startTime").val();
                var endTime = $("#create-endTime").val();
                if (ActivityName == "") {
                    alert("名称不能为空")
                    return;
                }
                if (startTime == "" || endTime == "") {
                    alert("日期不能为空")
                    return;
                }
                if (startTime > endTime) {
                    alert("结束日期不能早于开始日期")
                    return;
                }

                $.post("${pageContext.request.contextPath}/workbench/activity/toAdd.action", format, function (message) {
                    if (message.messageCode == 5) {
                        alert(message.messageStr)
                        $("#createActivityModal").modal("hide");
                        window.location.href = window.location.href;
                    } else {
                        alter(message.messageStr)
                    }
                }, "json")

            })
            $(".myDate").datetimepicker({
                forceParse: 0,//设置为0，时间不会跳转1899，会显示当前时间。
                language: 'zh-CN',//显示中文
                format: 'yyyy-mm-dd',//显示格式
                minView: "month",//设置只显示到月份
                initialDate: new Date(),//初始化当前日期
                autoclose: true,//选中自动关闭
                todayBtn: true,//显示今日按钮
                clearBtn: true//是否显示清空按钮
            })
        })
    </script>

    <%--=============================================================================================================--%>
    <%--模糊查询带分页--%>
    <script>
        $(function () {
            //如果不模糊查询，则在页面加载完毕之后就执行
            findAllActivityByLikePage(1);
            //如果模糊查询，则点击事件执行
            $("#chaxun").click(function () {
                findAllActivityByLikePage(1);
            })
        })

        function findAllActivityByLikePage(pageNum) {
            //获取模糊查询关键字的值
            var likeActivityName = $("#name").val()
            var likeActivityOwner = $("#owner").val()
            var likeStartDate = $("#startTime").val()
            var likeEndDate = $("#endTime").val()
            var data = {
                "pageNum": pageNum,
                "likeActivityName": likeActivityName,
                "likeActivityOwner": likeActivityOwner,
                "likeStartDate": likeStartDate,
                "likeEndDate": likeEndDate
            };
            $.post("${pageContext.request.contextPath}/workbench/activity/findAllActivityByLikePage.action", data, function (likeActivity) {
                $("#name").val(likeActivity.likeActivityName)
                $("#owner").val(likeActivity.likeActivityOwner)
                $("#startTime").val(likeActivity.likeStartDate)
                $("#endTime").val(likeActivity.likeEndDate)
                var $biaoge = $("#biaoge")
                $biaoge.empty()
                var pageInfo = likeActivity.pageInfoLike;
                x = pageInfo.pageNum;
                $.each(pageInfo.list, function (i, activity) {
                    $.post("${pageContext.request.contextPath}/settings/user/findUserById.action", "userId=" + activity.activityOwner, function (user) {
                        $biaoge.append("<tr class='active' >" +
                            "<td><input type='checkbox' class='checkActivity' value='" + activity.activityId + "' /></td>" +
                            "<td><a href='${pageContext.request.contextPath}/workbench/activity/showPingLun.action?activityId=" + activity.activityId + " style='text-decoration: none; cursor: pointer;'  >" + activity.activityName + "</a></td>" +
                            "<td>" + user.userName + "</td>" +
                            "<td>" + activity.activityStartDate + "</td>" +
                            "<td>" + activity.activityEndDate + "</td>"
                        )
                    }, "json")
                })
                //分页信息的拼装
                var $showPage = $("#showPage");
                var htmlStr = "";
                if (pageInfo.isFirstPage) {
                    htmlStr += "<li class='disabled'><a href='#'>首页</a></li>"
                } else {
                    htmlStr += "<li ><a href='javascript:findAllActivityByLikePage(1)'>首页</a></li>"
                }
                if (pageInfo.hasPreviousPage) {
                    htmlStr += "<li ><a href='javascript:findAllActivityByLikePage(" + pageInfo.prePage + ")'>上一页</a></li>"
                } else {
                    htmlStr += "<li class='disabled'><a href='#'>上一页</a></li>"
                }
                for (var i = pageInfo.navigateFirstPage; i <= pageInfo.navigateLastPage; i++) {
                    if (pageInfo.pageNum == i) {
                        htmlStr += "<li class='active' ><a href='javascript:findAllActivityByLikePage(" + i + ")'>" + i + "</a></li>"
                    } else {
                        htmlStr += "<li ><a href='javascript:findAllActivityByLikePage(" + i + ")'>" + i + "</a></li>"
                    }
                }
                if (pageInfo.hasNextPage) {
                    htmlStr += "<li ><a href='javascript:findAllActivityByLikePage(" + pageInfo.nextPage + ")'>下一页</a></li>"
                } else {
                    htmlStr += "<li class='disabled'><a href='#'>下一页</a></li>"
                }
                if (pageInfo.isLastPage) {
                    htmlStr += "<li class='disabled'><a href='#'>末页</a></li>"
                } else {
                    htmlStr += "<li ><a href='javascript:findAllActivityByLikePage(" + pageInfo.pages + ")'>末页</a></li>"
                }
                $showPage.html(htmlStr);
            }, "json")
        }
    </script>
    <%--市场活动的文件下载--%>
    <script>
        //批量下载  全下载
        $(function () {
            $("#exportActivityAllBtn").click(function () {
                window.location.href = "${pageContext.request.contextPath}/index.jsp"
                window.location.href = "${pageContext.request.contextPath}/workbench/activity/exportActivityAll.action"
            })
            $("#checkAll").click(function () {
                //点击全选按钮 根据全选按钮的状态  改变  页面其它复选框的状态
                var checkFlag = $("#checkAll").prop("checked")
                $(".checkActivity").prop("checked", checkFlag)
            })
            //选择导出按钮
            $("#exportActivityXzBtn").click(function () {
                //点击时  要先获取选中项
                var $checkActivity = $(".checkActivity:checked");

                if ($checkActivity.size() == 0) {
                    alert("请选择要导出的信息")
                    return;
                } else {
                    //获取  id
                    var ids = "";
                    $.each($checkActivity, function (i, checkActivity) {
                        var id = checkActivity.value;
                        ids += id + ",";
                    })
                    // alert(ids);
                    window.location.href = "${pageContext.request.contextPath}/workbench/activity/exportActivityChecked.action?ids=" + ids
                }
            });
            //异步导入excel
            $("#importActivityBtn").click(function () {
                var $fileName = $("#activityFile").val()
                var fileTypeName = $fileName.substring($fileName.lastIndexOf("."))
                if (fileTypeName != ".xls" && fileTypeName != ".xlsx") {
                    alert("文件类型只能为xls或xlsx！！！")
                    return;
                }
                //1、获取文件内容
                //jquery对象转dom对象，然后用dom对象获得file对象
                var importExcel = $("#activityFile")[0].files[0]
                //2,文件异步上传  $.get和$.post只能使用默认的传值方式
                //异步上传   需要改变传值方式
                //contentType:false   默认情况下  请求会被统一进行url编码 参数就会参照编码变进行一次编码操作
                //异步文件上传  不能改变编码格式  文件是字节传输
                //processData:false,//默认请求下，ajax每次向后台发送请求，都会把多有的参数统一转化成字符串，
                // 设置processData=false，可以阻止这种行为
                //使用formData 把数据进行封装
                var formData = new FormData()
                formData.append("importFile", importExcel)

                $.ajax({
                    type: "post",
                    url: "${pageContext.request.contextPath}/workbench/activity/importActivityExcel.action",
                    data: formData,
                    dataType: "json",
                    contentType: false,
                    processData: false,
                    success: function (message) {
                        if (message.messageCode == 5) {
                            alert(message.messageStr)
                            $("#importActivityModal").modal("hide")

                        } else {
                            alert(message.messageStr)
                        }
                    }
                })
            })
        })
    </script>
    <script>
        //异步修改
        $(function () {

            $("#editActivityBut").click(function () {
                var $checkActivity = $(".checkActivity:checked");//获取当前页选中项
                //判断  1条或多条
                if ($checkActivity.size() > 0) {
                    if ($checkActivity.size() > 1) {
                        alert("您选中了多条市场活动，默认修改第一条")
                    }
                    var id = $checkActivity[0].value;

                    $.post("${pageContext.request.contextPath}/workbench/activity/selectById.action", "activityId=" + id, function (activity) {
                        //获取所有者信息

                        $.post("${pageContext.request.contextPath}/settings/user/findAllUser.action", function (userList) {

                            var $editSelect = $("#edit-marketActivityOwner");
                            //清空下拉菜单的下拉项
                            $editSelect.empty();

                            $.each(userList, function (i, user) {
                                //数据回显  就是 原来市场活动的所有者   还得显示所有者是谁
                                if (activity.activityOwner == user.userId) {
                                    $editSelect.append("<option  value='" + user.userId + "' selected='selected' >" + user.userName + "</option>")
                                } else {
                                    $editSelect.append("<option value='" + user.userId + "'>" + user.userName + "</option>")
                                }

                            })
                            var activityId = activity.activityId;
                            $("#edit-marketActivityName").val(activity.activityName)
                            $("#edit-startTime").val(activity.activityStartDate)
                            $("#edit-endTime").val(activity.activityEndDate)
                            $("#edit-cost").val(activity.activityCost)
                            $("#edit-describe").val(activity.activityDescription)
                            //展示修改的模态窗口
                            $("#editActivityModal").modal("show");
                            update(activity);
                        }, "json")
                    }, "json")
                } else {
                    alert("请选择要修改的市场活动项")
                    return;
                }
            })

            function update(activity) {
                $("#updateData").click(function () {
                    var activityId = activity.activityId;
                    var activityOwner = $("#edit-marketActivityOwner").val()
                    var activityName = $("#edit-marketActivityName").val()
                    var activityStartDate = $("#edit-startTime").val()
                    var activityEndDate = $("#edit-endTime").val()
                    var activityCost = $("#edit-cost").val()
                    var activityDescription = $("#edit-describe").val()
                    data = {
                        "activityId": activityId,
                        "activityOwner": activityOwner,
                        "activityName": activityName,
                        "activityStartDate": activityStartDate,
                        "activityEndDate": activityEndDate,
                        "activityCost": activityCost,
                        "activityDescription": activityDescription
                    }


                    $.post("${pageContext.request.contextPath}/workbench/activity/updateById.action", data, function (message) {
                        if (message.messageCode == 5) {
                            alert(message.messageStr)
                            $("#editActivityModal").modal("hide")
                            findAllActivityByLikePage(x);
                        } else {
                            alert(message.messageStr)
                        }
                    }, "json")
                })
            }

//异步删除
            $("#removeButton").click(function () {
                // var a= new Set();
                // var arrId = [];
                var ids = "";
                var $checkActivity = $(".checkActivity:checked");
                if ($checkActivity.size() == 0) {
                    alert("请勾选要删除的数据！！！")
                } else {
                    $.each($checkActivity, function (i, checkActivity) {
                        var id = $(checkActivity).val()
                        ids += id + ",";
                    })
                    $.post("${pageContext.request.contextPath}/workbench/activity/removeById.action", "ids=" + ids, function (message) {
                        if (message.messageCode == 5) {
                            alert(message.messageStr)
                            findAllActivityByLikePage(x);
                        } else {
                            alert(message.messageStr)
                        }
                    }, "json")
                }

            })

        })

    </script>


</head>
<body>

<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form" id="createActivityForm">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-marketActivityOwner" name="activityOwner">
                                <%--<option>zhangsan</option>--%>
                                <%--<option>lisi</option>--%>
                                <%--<option>wangwu</option>--%>
                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-marketActivityName" name="activityName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myDate" id="create-startTime"
                                   name="activityStartDate">
                        </div>
                        <label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myDate" id="create-endTime" name="activityEndDate">
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost" name="activityCost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-describe"
                                      name="activityDescription"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" id="close" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="save">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form" id="form2">

                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" name="activityOwner" id="edit-marketActivityOwner">
                                <%--<option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>--%>
                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control " id="edit-startTime" value="2020-10-10">
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control " id="edit-endTime" value="2020-10-20">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost" value="5,000">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateData">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 导入市场活动的模态窗口 -->
<div class="modal fade" id="importActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
            </div>
            <div class="modal-body" style="height: 350px;">
                <div style="position: relative;top: 20px; left: 50px;">
                    请选择要上传的文件：
                    <small style="color: gray;">[仅支持.xls或.xlsx格式]</small>
                </div>
                <div style="position: relative;top: 40px; left: 50px;">
                    <input type="file" id="activityFile">
                </div>
                <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;">
                    <h3>重要提示</h3>
                    <ul>
                        <li>操作仅针对Excel，仅支持后缀名为XLS/XLSX的文件。</li>
                        <li>给定文件的第一行将视为字段名。</li>
                        <li>请确认您的文件大小不超过5MB。</li>
                        <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                        <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                        <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                        <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                    </ul>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
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
                        <input class="form-control" type="text" id="name" name="activityName">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="owner" name="activityOwner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control" type="text" id="startTime" name="activityStartDate"/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control" type="text" id="endTime" name="activityEndDate">
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
                <button type="button" class="btn btn-default" data-toggle="modal"
                        id="editActivityBut"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="removeButton"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal">
                    <span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）
                </button>
                <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）
                </button>
                <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）
                </button>
            </div>
        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="checkAll"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="biaoge">
                <%--<tr class="active">--%>
                <%--<td><input type="checkbox"/></td>--%>
                <%--<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>--%>
                <%--<td>zhangsan</td>--%>
                <%--<td>2020-10-10</td>--%>
                <%--<td>2020-10-20</td>--%>
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