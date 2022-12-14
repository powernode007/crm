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
                    alert("??????????????????")
                    return;
                }
                if (startTime == "" || endTime == "") {
                    alert("??????????????????")
                    return;
                }
                if (startTime > endTime) {
                    alert("????????????????????????????????????")
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
                forceParse: 0,//?????????0?????????????????????1899???????????????????????????
                language: 'zh-CN',//????????????
                format: 'yyyy-mm-dd',//????????????
                minView: "month",//????????????????????????
                initialDate: new Date(),//?????????????????????
                autoclose: true,//??????????????????
                todayBtn: true,//??????????????????
                clearBtn: true//????????????????????????
            })
        })
    </script>

    <%--=============================================================================================================--%>
    <%--?????????????????????--%>
    <script>
        $(function () {
            //???????????????????????????????????????????????????????????????
            findAllActivityByLikePage(1);
            //??????????????????????????????????????????
            $("#chaxun").click(function () {
                findAllActivityByLikePage(1);
            })
        })

        function findAllActivityByLikePage(pageNum) {
            //?????????????????????????????????
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
                //?????????????????????
                var $showPage = $("#showPage");
                var htmlStr = "";
                if (pageInfo.isFirstPage) {
                    htmlStr += "<li class='disabled'><a href='#'>??????</a></li>"
                } else {
                    htmlStr += "<li ><a href='javascript:findAllActivityByLikePage(1)'>??????</a></li>"
                }
                if (pageInfo.hasPreviousPage) {
                    htmlStr += "<li ><a href='javascript:findAllActivityByLikePage(" + pageInfo.prePage + ")'>?????????</a></li>"
                } else {
                    htmlStr += "<li class='disabled'><a href='#'>?????????</a></li>"
                }
                for (var i = pageInfo.navigateFirstPage; i <= pageInfo.navigateLastPage; i++) {
                    if (pageInfo.pageNum == i) {
                        htmlStr += "<li class='active' ><a href='javascript:findAllActivityByLikePage(" + i + ")'>" + i + "</a></li>"
                    } else {
                        htmlStr += "<li ><a href='javascript:findAllActivityByLikePage(" + i + ")'>" + i + "</a></li>"
                    }
                }
                if (pageInfo.hasNextPage) {
                    htmlStr += "<li ><a href='javascript:findAllActivityByLikePage(" + pageInfo.nextPage + ")'>?????????</a></li>"
                } else {
                    htmlStr += "<li class='disabled'><a href='#'>?????????</a></li>"
                }
                if (pageInfo.isLastPage) {
                    htmlStr += "<li class='disabled'><a href='#'>??????</a></li>"
                } else {
                    htmlStr += "<li ><a href='javascript:findAllActivityByLikePage(" + pageInfo.pages + ")'>??????</a></li>"
                }
                $showPage.html(htmlStr);
            }, "json")
        }
    </script>
    <%--???????????????????????????--%>
    <script>
        //????????????  ?????????
        $(function () {
            $("#exportActivityAllBtn").click(function () {
                window.location.href = "${pageContext.request.contextPath}/index.jsp"
                window.location.href = "${pageContext.request.contextPath}/workbench/activity/exportActivityAll.action"
            })
            $("#checkAll").click(function () {
                //?????????????????? ???????????????????????????  ??????  ??????????????????????????????
                var checkFlag = $("#checkAll").prop("checked")
                $(".checkActivity").prop("checked", checkFlag)
            })
            //??????????????????
            $("#exportActivityXzBtn").click(function () {
                //?????????  ?????????????????????
                var $checkActivity = $(".checkActivity:checked");

                if ($checkActivity.size() == 0) {
                    alert("???????????????????????????")
                    return;
                } else {
                    //??????  id
                    var ids = "";
                    $.each($checkActivity, function (i, checkActivity) {
                        var id = checkActivity.value;
                        ids += id + ",";
                    })
                    // alert(ids);
                    window.location.href = "${pageContext.request.contextPath}/workbench/activity/exportActivityChecked.action?ids=" + ids
                }
            });
            //????????????excel
            $("#importActivityBtn").click(function () {
                var $fileName = $("#activityFile").val()
                var fileTypeName = $fileName.substring($fileName.lastIndexOf("."))
                if (fileTypeName != ".xls" && fileTypeName != ".xlsx") {
                    alert("?????????????????????xls???xlsx?????????")
                    return;
                }
                //1?????????????????????
                //jquery?????????dom??????????????????dom????????????file??????
                var importExcel = $("#activityFile")[0].files[0]
                //2,??????????????????  $.get???$.post?????????????????????????????????
                //????????????   ????????????????????????
                //contentType:false   ???????????????  ????????????????????????url?????? ???????????????????????????????????????????????????
                //??????????????????  ????????????????????????  ?????????????????????
                //processData:false,//??????????????????ajax?????????????????????????????????????????????????????????????????????????????????
                // ??????processData=false???????????????????????????
                //??????formData ?????????????????????
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
        //????????????
        $(function () {

            $("#editActivityBut").click(function () {
                var $checkActivity = $(".checkActivity:checked");//????????????????????????
                //??????  1????????????
                if ($checkActivity.size() > 0) {
                    if ($checkActivity.size() > 1) {
                        alert("??????????????????????????????????????????????????????")
                    }
                    var id = $checkActivity[0].value;

                    $.post("${pageContext.request.contextPath}/workbench/activity/selectById.action", "activityId=" + id, function (activity) {
                        //?????????????????????

                        $.post("${pageContext.request.contextPath}/settings/user/findAllUser.action", function (userList) {

                            var $editSelect = $("#edit-marketActivityOwner");
                            //??????????????????????????????
                            $editSelect.empty();

                            $.each(userList, function (i, user) {
                                //????????????  ?????? ??????????????????????????????   ???????????????????????????
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
                            //???????????????????????????
                            $("#editActivityModal").modal("show");
                            update(activity);
                        }, "json")
                    }, "json")
                } else {
                    alert("????????????????????????????????????")
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

//????????????
            $("#removeButton").click(function () {
                // var a= new Set();
                // var arrId = [];
                var ids = "";
                var $checkActivity = $(".checkActivity:checked");
                if ($checkActivity.size() == 0) {
                    alert("????????????????????????????????????")
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

<!-- ????????????????????????????????? -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">??</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">??????????????????</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form" id="createActivityForm">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">?????????<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-marketActivityOwner" name="activityOwner">
                                <%--<option>zhangsan</option>--%>
                                <%--<option>lisi</option>--%>
                                <%--<option>wangwu</option>--%>
                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">??????<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-marketActivityName" name="activityName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startTime" class="col-sm-2 control-label">????????????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myDate" id="create-startTime"
                                   name="activityStartDate">
                        </div>
                        <label for="create-endTime" class="col-sm-2 control-label">????????????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myDate" id="create-endTime" name="activityEndDate">
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">??????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost" name="activityCost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">??????</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-describe"
                                      name="activityDescription"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" id="close" data-dismiss="modal">??????</button>
                <button type="button" class="btn btn-primary" id="save">??????</button>
            </div>
        </div>
    </div>
</div>

<!-- ????????????????????????????????? -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">??</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">??????????????????</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form" id="form2">

                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">?????????<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" name="activityOwner" id="edit-marketActivityOwner">
                                <%--<option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>--%>
                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">??????<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-marketActivityName" value="?????????">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">????????????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control " id="edit-startTime" value="2020-10-10">
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">????????????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control " id="edit-endTime" value="2020-10-20">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">??????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost" value="5,000">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">??????</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe">????????????Marketing??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????</textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
                <button type="button" class="btn btn-primary" id="updateData">??????</button>
            </div>
        </div>
    </div>
</div>

<!-- ????????????????????????????????? -->
<div class="modal fade" id="importActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">??</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">??????????????????</h4>
            </div>
            <div class="modal-body" style="height: 350px;">
                <div style="position: relative;top: 20px; left: 50px;">
                    ??????????????????????????????
                    <small style="color: gray;">[?????????.xls???.xlsx??????]</small>
                </div>
                <div style="position: relative;top: 40px; left: 50px;">
                    <input type="file" id="activityFile">
                </div>
                <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;">
                    <h3>????????????</h3>
                    <ul>
                        <li>???????????????Excel????????????????????????XLS/XLSX????????????</li>
                        <li>?????????????????????????????????????????????</li>
                        <li>????????????????????????????????????5MB???</li>
                        <li>?????????????????????????????????????????????yyyy-MM-dd?????????</li>
                        <li>????????????????????????????????????????????????yyyy-MM-dd HH:mm:ss????????????</li>
                        <li>?????????????????????????????????UTF-8 (?????????)????????????????????????????????????????????????????????????????????????</li>
                        <li>??????????????????????????????????????????????????????????????????????????????</li>
                    </ul>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
                <button id="importActivityBtn" type="button" class="btn btn-primary">??????</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>??????????????????</h3>
        </div>
    </div>
</div>
<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">??????</div>
                        <input class="form-control" type="text" id="name" name="activityName">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">?????????</div>
                        <input class="form-control" type="text" id="owner" name="activityOwner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">????????????</div>
                        <input class="form-control" type="text" id="startTime" name="activityStartDate"/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">????????????</div>
                        <input class="form-control" type="text" id="endTime" name="activityEndDate">
                    </div>
                </div>

                <input type="button" class="btn btn-default" id="chaxun" value="??????"></input>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" data-toggle="modal" id="create"><span
                        class="glyphicon glyphicon-plus"></span> ??????
                </button>
                <button type="button" class="btn btn-default" data-toggle="modal"
                        id="editActivityBut"><span
                        class="glyphicon glyphicon-pencil"></span> ??????
                </button>
                <button type="button" class="btn btn-danger" id="removeButton"><span
                        class="glyphicon glyphicon-minus"></span> ??????
                </button>
            </div>
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal">
                    <span class="glyphicon glyphicon-import"></span> ??????????????????????????????
                </button>
                <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-export"></span> ????????????????????????????????????
                </button>
                <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-export"></span> ????????????????????????????????????
                </button>
            </div>
        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="checkAll"/></td>
                    <td>??????</td>
                    <td>?????????</td>
                    <td>????????????</td>
                    <td>????????????</td>
                </tr>
                </thead>
                <tbody id="biaoge">
                <%--<tr class="active">--%>
                <%--<td><input type="checkbox"/></td>--%>
                <%--<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">?????????</a></td>--%>
                <%--<td>zhangsan</td>--%>
                <%--<td>2020-10-10</td>--%>
                <%--<td>2020-10-20</td>--%>
                <%--</tr>--%>

                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">
            <div>
                <button type="button" class="btn btn-default" style="cursor: default;">???<b>50</b>?????????</button>
            </div>
            <div class="btn-group" style="position: relative;top: -34px; left: 110px;">
                <button type="button" class="btn btn-default" style="cursor: default;">??????</button>
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
                <button type="button" class="btn btn-default" style="cursor: default;">???/???</button>
            </div>
            <div style="position: relative;top: -88px; left: 285px;">
                <nav>
                    <ul class="pagination" id="showPage">
                        <%--<li class="disabled"><a href="#">??????</a></li>--%>
                        <%--<li class="disabled"><a href="#">?????????</a></li>--%>
                        <%--<li class="active"><a href="#">1</a></li>--%>
                        <%--<li><a href="#">2</a></li>--%>
                        <%--<li><a href="#">3</a></li>--%>
                        <%--<li><a href="#">4</a></li>--%>
                        <%--<li><a href="#">5</a></li>--%>
                        <%--<li><a href="#">?????????</a></li>--%>
                        <%--<li class="disabled"><a href="#">??????</a></li>--%>
                    </ul>
                </nav>
            </div>
        </div>

    </div>

</div>
</body>
</html>