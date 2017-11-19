<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" pageEncoding="utf-8" isELIgnored="false" %>

<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <title>超市账单管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/jsp/css/public.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/jsp/css/style.css"/>
    <%--<link rel="stylesheet" href="${pageContext.request.contextPath}/js/bootstrap/css/bootstrap.min.css"/>--%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/easyui/themes/icon.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/easyui/themes/default/easyui.css"/>

    <%--<script type="text/javascript" src="${pageContext.request.contextPath}/js/jQuery1.11.1.js"></script>--%>
    <%--<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.pagination.js"></script>--%>
    <%--<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-migrate-1.2.0.js"></script>--%>
    <script type="text/javascript" src="${pageContext.request.contextPath}/easyui/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/easyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/easyui/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript">
        var url;
        $(function ($) {
            function load() {
                $('#test').datagrid({
                    title:'用户管理',     //布局的标题名称
                    iconCls:'icon-save',  //图标样式
                    width:'100%',
                    height:450,
                    nowrap: true,
                    striped: true,
                    url:"${pageContext.request.contextPath}/userList?userName="+$("[name=uname]").val(),
                    sortName: 'code',
                    sortOrder: 'desc',
                    pageSize:2,
                    idField:'id',  //指示哪个字段是标识字段。
                    pageList: [2, 5, 10, 15],
                    frozenColumns:[[
                        {field:'ck',checkbox:true},  //控制复选框是否显示
                        { field: 'id', width: 50, hidden: true },
                        {title:'用户编码',field:'userCode',width:80,sortable:true}
                    ]],
                    columns:[[ //Column是一个数组对象，它的每个元素也是一个数组。元素数组的元素是一个配置对象，它定义了每个列的字段。
                        {field:'userName',title:'用户名称',width:80}, //title 标题文本
                        {field:'gender',title:'性别',width:50,  //field：列的字段名
                            formatter:function(value){
                                if(value==2){
                                    return "男";
                                }else{
                                    return "女";
                                }
                            }
                        },
                        {field:'birthday',title:'年龄',width:50,
                            /*formatter:function(value){
                                return jsGetAge(value);
                            }*/
                        },
                        {field:'phone',title:'电话',width:100},
                        {field:'address',title:'地址',width:180},
                        {field:'userType',title:'用户类型',width:200,
                            formatter:function(value){
                                if(value==1){
                                    return "系统管理员";
                                }else if(value==2){
                                    return "经理";
                                }else{
                                    return "普通员工";
                                }
                            }
                        }
                    ]],
                    pagination:true, //rows: 每页显示的数据量 page:第几页  显示分页
                    rownumbers:true, //带有行号的列
                    singleSelect:false,
                    toolbar:[{
                        text:'添加',
                        iconCls:'icon-add',
                        handler:function(){
                            openUserAddDialog();
                        }
                    },{
                        id: 'btnDelete',
                        text:'删除',
                        iconCls:'icon-remove',
                        disabled:false,
                        handler:function(){
                            deletedata();
                        }
                    },{
                        text:'修改',
                        iconCls:'icon-edit',
                        disabled:false,
                        handler:function(){
                            open2();
                        }
                    }]
                });
            }
            $(function () {
                load();
                $('#addUser').dialog({
                    title:'添加用户',
                    collapsible:false,
                    resizable:true,
                    //小弹层的OK
                    buttons:[{
                        text:'保存',
                        iconCls:'icon-ok',
                        handler:function(){
                            updaUser();
                        }
                    }, {
                        text:'取消',
                        iconCls:'icon-cancel',
                        handler:function(){
                            $('#addUser').dialog('close');
                        }
                    }]
                });
                $('#addUser').dialog('close');
            })
            var btnServlet=function () {
                load();
                $('#test').datagrid({
                    pageNumber:1
                });
            }


            $(function () {
                load();
                $("#uname").click(function () {
                    alert("#uname");
                    load();
                })
            })

            //添加用户信息
            function openUserAddDialog() {
                $('#addUser').dialog('open');
                url = "${pageContext.request.contextPath}/addUsers";
            }

           function deletedata() {
                //返回选中多行  
                var selRow = $('#test').datagrid('getSelections')
                //判断是否选中行  
                if (selRow.length==0) {
                    $.messager.alert("提示", "请选择要删除的行！", "info");
                    return;
                }else{
                    var temID="";
                    //批量获取选中行的评估模板ID  
                    for (i = 0; i < selRow.length;i++) {
                        if (temID =="") {
                            temID = selRow[i].id;
                        } else {
                            temID = selRow[i].id + "," + temID;
                        }
                    }
                    $.messager.confirm('提示', '是否删除选中数据?', function (r) {
                        if (!r) {
                            return;
                        }
                        //提交  
                        $.ajax({
                            type: "POST",
                            async: false,
                            url: "${pageContext.request.contextPath}/delUser?ids=" + temID,
                            data: temID,
                            success: function (result) {
                                if (result==true) {
                                    $("#test").datagrid("reload");
                                    $.messager.alert("提示", "恭喜您，信息删除成功！", "info");
                                } else {
                                    $.messager.alert("提示", "删除失败，请重新操作！", "info");
                                    return;
                                }
                            }
                        });
                    });
                }
            };


            /*修改*/
            function open2(){
                var selRow = $('#test').datagrid('getSelections')
                //判断是否选中行  
                if (selRow.length==0) {
                    $.messager.alert("提示", "请选择要修改的行！", "info");
                    return;
                }
                if (selRow.length>1) {
                    $.messager.alert("提示", "不能同时修改多行！", "info");
                    return;
                }
                var row =selRow[0];
                $("#addUser").dialog().dialog("setTitle","修改用户信息");
                $("#userADD").form("load",row);
                alert("row.id-->"+row.id);
                url="/updateUser/"+row.id;
            }
        })

        //保存用户信息
        function updaUser() {
            $.ajax({
                url: url,
                type:"post",
                data:$("#userADD").serialize(),
                success: function (result) {
                    if (result == true) {
                        alert("修改成功！");
                       /* $.messager.alert("小可爱提示", "保存成功！");*/
                        resetValue();
                        $("#test").datagrid("reload");
                        $("#addUser").dialog("close");
                    } else {
                        alert("修改失败！");
                      /*  $.messager.alert("小可爱提示", "保存失败！");*/
                    }
                }
            });
        }

        //修改后清空输入框内的内容
        function resetValue() {
            $("#userId").val('');
            $("#userName").val('');
            $("#gender").val('');
            $("#phone").val('');
            $("#address").val('');
            $("#roleName").val('');
        }

        //年龄
        function jsGetAge(strBirthday) {
            var returnAge;
            var strBirthdayArr=strBirthday.split("-");
            var birthYear = strBirthdayArr[0];
            var birthMonth = strBirthdayArr[1];
            var birthDay = strBirthdayArr[2];
            var d = new Date();
            var nowYear = d.getFullYear();
            var nowMonth = d.getMonth() + 1;
            var nowDay = d.getDate();
            if(nowYear == birthYear){
                returnAge = 0;//同年 则为0岁
            }else{
                var ageDiff = nowYear - birthYear ; //年之差
                if(ageDiff > 0){
                    if(nowMonth == birthMonth){
                        var dayDiff = nowDay - birthDay;//日之差
                        if(dayDiff < 0){
                            returnAge = ageDiff - 1;
                        }else{
                            returnAge = ageDiff ;
                        }
                    }else{
                        var monthDiff = nowMonth - birthMonth;//月之差
                        if(monthDiff < 0){
                            returnAge = ageDiff - 1;
                        } else{
                            returnAge = ageDiff ;
                        }
                    } }else{
                    returnAge = -1;//返回-1 表示出生日期输入错误 晚于今天
                }
            }
            return returnAge;//返回周岁年龄
        }
    </script>

</head>
<body>
<!--头部-->
    <header class="publicHeader">
        <h1>超市账单管理系统</h1>
        <div class="publicHeaderR">
            <p><span>下午好！</span><span style="color: #fff21b"> Admin</span> , 欢迎你！</p>
            <a href="login.html">退出</a>
        </div>
    </header>
<!--时间-->
    <section class="publicTime">
        <span id="time">2015年1月1日 11:11  星期一</span>
        <a href="#">温馨提示：为了能正常浏览，请使用高版本浏览器！（IE10+）</a>
    </section>
<!--主体内容-->
    <section class="publicMian ">
        <div class="left">
            <h2 class="leftH2"><span class="span1"></span>功能列表 <span></span></h2>
            <nav>
                <ul class="list">
                    <li><a href="billList.html">账单管理</a></li>
                    <li><a href="providerList.html">供应商管理</a></li>
                    <li  id="active"><a href="userList.html">用户管理</a></li>
                    <li><a href="password.html">密码修改</a></li>
                    <li><a href="login.html">退出系统</a></li>
                </ul>
            </nav>
        </div>
        <div class="right">
            <div class="location">
                <strong>你现在所在的位置是:</strong>
                <span>用户管理页面</span>
            </div>
            <div class="search">
                <span>用户名：</span>
                <input type="text" name="uname" placeholder="请输入用户名"/>
                <input type="button"  id="uname"   value="查询"/>
                <a href="${pageContext.request.contextPath}/jsp/userAdd.jsp">添加用户</a>
            </div>
            <!--用户-->
            <table id="test">
                
            </table>
           <div  class="pagination" id="pagination" style="margin:4px 0 0 0" ></div>
        </div>
    </section>

<!--点击删除按钮后弹出的页面-->
<div class="zhezhao"></div>
<div class="remove" id="removeUse">
    <div class="removerChid">
        <h2>提示</h2>
        <div class="removeMain">
            <p>你确定要删除该用户吗？</p>
            <a href="#" id="yes">确定</a>
            <a href="#" id="no">取消</a>
        </div>
    </div>
</div>

    <footer class="footer">
        版权归北大青鸟
    </footer>
<div  id="addUser" style="width:700px;padding:30px 60px;font-size: 17px;">
    <form id="userADD">
        <!--div的class 为error是验证错误，ok是验证成功-->
        <div class="">
            <label for="userId">用户编码：</label>
            <input type="text" name="userCode" id="userId"/>
            <span>*请输入用户编码，且不能重复</span>
        </div>
        <div>
            <label for="userName">用户名称：</label>
            <input type="text" name="userName" id="userName"/>
            <span >*请输入用户名称</span>
        </div>
        <div>
            <label for="userpassword">用户密码：</label>
            <input type="text" name="userPassword" id="userpassword"/>
            <span>*密码长度必须大于6位小于20位</span>

        </div>
        <div>
            <label for="userRemi">确认密码：</label>
            <input type="text" name="userRemi" id="userRemi"/>
            <span>*请输入确认密码</span>
        </div>
        <div>
            <label >用户性别：</label>

            <select name="gender">
                <option value="1">男</option>
                <option value="0">女</option>
            </select>
            <span></span>
        </div>
        <div>
            <label for="data">出生日期：</label>
            <input type="text" name="birthday" id="data"/>
            <span >*</span>
        </div>
        <div>
            <label for="userphone">用户电话：</label>
            <input type="text" name="phone" id="userphone"/>
            <span >*</span>
        </div>
        <div>
            <label for="userAddress">用户地址：</label>
            <input type="text" name="address" id="userAddress"/>
        </div>
        <div>
            <label >用户类别：</label>
            <input type="radio" name="userType" value="1"/>管理员
            <input type="radio" name="userType" value="2"/>经理
            <input type="radio" name="userType" value="3"/>普通用户
        </div>
    </form>

</div>

<script src="js/jquery.js"></script>
<script src="js/js.js"></script>
<script src="js/time.js"></script>

</body>
</html>