<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>layui</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/lib/layui/css/layui.css" media="all">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/public.css">
</head>
<body>
<div class="layuimini-container layui-col-space30">

    <div class="layuimini-main">
        <fieldset class="layui-elem-field layui-field-title">
            <legend>申请办公用品记录</legend>
        </fieldset>
        <!-- 表格 -->
        <table class="layui-hide" id="tableId" lay-filter="tableId"></table>
        <!-- 工具栏 -->
        <script type="text/html" id="tool">
            <a class="layui-btn layui-btn-xs data-count-edit" lay-event="edit">编辑</a>
            <a class="layui-btn layui-btn-xs layui-btn-danger data-count-delete" lay-event="delete">删除</a>
        </script>
        <!-- 表格头部工具栏 -->
        <script type="text/html" id="toolbar">
            <div class="layui-btn-container">
                <button class="layui-btn layui-btn-sm layui-bg-blue" lay-event="refresh">刷新</button>
                <button class="layui-btn layui-btn-sm" lay-event="add">新建办公用品</button>
                <button class="layui-btn layui-btn-sm" lay-event="storageOfOfficeSupplies">入库办公用品</button>
                <button class="layui-btn layui-btn-sm" lay-event="storageRecordOfOfficeSupplies">入库办公用品记录</button>
            </div>
        </script>
        <input hidden id="contextPath" value="${pageContext.request.contextPath}" />

    </div>


</div>
<script src="${pageContext.request.contextPath}/static/lib/layui/layui.js" charset="utf-8"></script>
<script src="${pageContext.request.contextPath}/static/js/common.js" charset="utf-8"></script>
<script type="text/javascript">
    layui.use(['jquery', 'layer', 'form', 'table'], function () {
        let $ = layui.$;
        let layer = layui.layer;
        let form = layui.form;
        let table = layui.table;
        /**
         * 表格渲染
         */
        table.render({
            elem: '#tableId',
            url:$("#contextPath").val()+ '/stationery/getHistoryOfOfficeSupplies',
            page: true, //开启分页
            cols: [[ //表头
                {type: 'checkbox', width: 80, fixed: 'left'}
                , {field: 'stationeryName', title: '办公用品名称', align: 'center', width: 180, fixed: 'left'}
                , {field: 'stationeryCount', title: '数量', align: 'center', width: 80}
                , {field: 'explain', title: '说明', align: 'center'}
                , {field: 'approveEmployeeName', title: '审批人', align: 'center'}
                , {
                    field: 'approve', title: '审批状态', width: 140, align: 'center', templet: function (d) {
                        console.log(d);
                        return d.approve === 0 ? '【未审批】' : d.approve === 1 ? '【审批通过】' : '【审批不通过】';
                    }
                }
                , {field: 'receipt', title: '审批回执', align: 'center'}
                , {title: '创建时间', align: 'center', width: 170, templet: d => timestampToTime(d.creationTime)}
            ]],
        });


    });

</script>
</body>
</html>
