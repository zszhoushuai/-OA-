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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/public.css" media="all">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/lib/font-awesome-4.7.0/css/font-awesome.css">
</head>
<body>
<div class="layuimini-container layui-col-space30">
    <div class="layuimini-main">
        <fieldset class="layui-elem-field layui-field-title">
            <legend>仓库列表</legend>
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
        <input value="${pageContext.request.contextPath}" id="contextPath" hidden>
    </div>
</div>
<script src="${pageContext.request.contextPath}/static/lib/layui/layui.js" charset="utf-8"></script>
<script src="${pageContext.request.contextPath}/static/js/common.js" charset="utf-8"></script>
<script>
    layui.use(['table', 'layer', 'jquery', 'form'], function (table, layer, $, form) {

        /**
         * 初始化表格
         */
        table.render({
            elem: '#tableId',
            url: $("#contextPath").val()+'/stationery/getStationeryAll',
            toolbar: '#toolbar',
            page: true, //开启分页
            cols: [[ //表头
                {type: 'checkbox', width: 80, fixed: 'left'}
                , {field: 'stationeryName', title: '办公用品名称', align: 'center', width: 180, fixed: 'left'}
                , {field: 'stationeryCount', title: '数量', align: 'center', width: 80}
                , {field: 'stationeryClassify', title: '分类', align: 'center', width: 130}
                , {title: '创建时间', align: 'center', width: 170, templet: d => timestampToTime(d.creationTime)}
                , {field: 'stationeryExplain', title: '说明', align: 'center'}
                , {title: '操作', align: 'center', width: 130, templet: '#tool', fixed: 'right'}
            ]],
            id: 'tableId',
        });

        /**
         *  表头点击操作
         */
        table.on('toolbar(tableId)', function (obj) {
            let checkStatus = table.checkStatus(obj.config.id);
            switch (obj.event) {
                case 'refresh':
                    window.location.reload();
                    break;
                case 'add':
                    layer.open({
                        type: 1,
                        title: '新建办公用品',
                        area: ['50%', '80%'],
                        shade: 0.3,
                        shadeClose: false,
                        content: '<div id="stationery"></div>',
                        success: function (layero, index) {
                            $('#stationery').html('<form class="layui-form layui-form-pane" lay-filter="addStationery">            <div class="layui-form-item">                <label class="layui-form-label">名称</label>                <div class="layui-input-block">                    <input type="text" name="stationeryName" autocomplete="off" lay-verify="required" class="layui-input">                </div>            </div>            <div class="layui-form-item">                <label class="layui-form-label">分类</label>                <div class="layui-input-block">                    <input type="text" name="stationeryClassify" autocomplete="off" lay-verify="required" placeholder=""                           class="layui-input">                </div>            </div>            <div class="layui-form-item">                <label class="layui-form-label">数量</label>                <div class="layui-input-block">                    <input type="text" name="stationeryCount" autocomplete="off" lay-verify="required|number"                           class="layui-input">                </div>            </div>            <div class="layui-form-item">                <label class="layui-form-label">说明</label>                <div class="layui-input-block">                    <textarea name="stationeryExplain" required lay-verify="required" placeholder="请输入"                              class="layui-textarea"></textarea>                </div>            </div>            <div class="layui-form-item">                <label class="layui-form-label layui-hide"></label>                <div class="layui-input-block">                    <button type="button" class="layui-btn" lay-submit lay-filter="addStationery">保存</button>                    <button type="reset" class="layui-btn layui-btn-primary">清空</button>                </div>            </div>        </form>');
                        },
                        end: a => table.reload('tableId'),
                    });
                    break;
                case 'storageOfOfficeSupplies':
                    layer.open({
                        type: 1,
                        title: '办公用品入库',
                        area: ['50%', '80%'],
                        shade: 0.3,
                        shadeClose: false,
                        content: '<div id="storageStationery"></div>',
                        success: function (layero, index) {
                            $('#storageStationery').html('<form class="layui-form layui-form-pane" lay-filter="storageStationery">  <div class="layui-form-item">    <label class="layui-form-label">名称</label>    <div class="layui-input-block">       <select name="stationeryId" id="stationeryId"><option></option></select>    </div>  </div>  <div class="layui-form-item">    <label class="layui-form-label">数量</label>    <div class="layui-input-block">      <input type="text" name="stationeryCount" autocomplete="off" lay-verify="required|number" class="layui-input">   </div>  </div>  <div class="layui-form-item">    <label class="layui-form-label">说明</label>    <div class="layui-input-block">      <textarea name="stationeryExplain" required lay-verify="required" placeholder="请输入" class="layui-textarea"></textarea>    </div>  </div>  <div class="layui-form-item">    <label class="layui-form-label layui-hide"></label>    <div class="layui-input-block">      <button type="button" class="layui-btn" lay-submit lay-filter="storageStationery">保存</button>      <button type="reset" class="layui-btn layui-btn-primary">清空</button></div>  </div></form>');
                            $.getJSON($("#contextPath").val()+'/stationery/getStationeryAll', {
                                'page': 1,
                                'limit': 99
                            }, function (result) {
                                if (result.type === 'success') {
                                    for (let i = 0; i < result.data.length; i++) {
                                        $('#stationeryId').append('<option value="' + result.data[i].stationeryId + '">' + result.data[i].stationeryName + '</option>')
                                    }
                                    form.render('select');
                                } else if (result.type === 'error') {
                                    layer.msg(result.msg);
                                }
                            });
                        },
                        end: a => table.reload('tableId'),
                    });
                    break;
                case 'storageRecordOfOfficeSupplies':
                    table.reload('tableId', {
                        url: $("#contextPath").val()+'/stationery/getStationeryAddHistory',
                        page: true, //开启分页
                        cols: [[ //表头
                            {type: 'checkbox', width: 80, fixed: 'left'}
                            , {field: 'stationeryName', title: '办公用品名称', align: 'center', width: 180, fixed: 'left'}
                            , {field: 'stationeryCount', title: '数量', align: 'center', width: 80}
                            , {
                                title: '创建时间',
                                align: 'center',
                                width: 170,
                                templet: d => timestampToTime(d.creationTime)
                            }
                            , {field: 'stationeryExplain', title: '说明', align: 'center'}
                            , {title: 'caozuo'}
                        ]],
                    });
                    break;
            };
        });

        /**
         * 表格每行操作
         */
        table.on('tool(tableId)', function (obj) {
            if (obj.event === 'edit') {
                layer.open({
                    type: 1,
                    title: '修改办公用品信息',
                    area: ['50%', '80%'],
                    shade: 0.3,
                    shadeClose: false,
                    content: '<div id="stationery"></div>',
                    success: function (layero, index) {
                        $('#stationery').html('<form class="layui-form layui-form-pane" lay-filter="updateStationery">            <div class="layui-form-item">                <label class="layui-form-label">名称</label>                <div class="layui-input-block">                    <input type="text" name="stationeryName" autocomplete="off" lay-verify="required" value="' + obj.data.stationeryName + '" class="layui-input"></div></div><div class="layui-form-item">                <label class="layui-form-label">分类</label>                <div class="layui-input-block">                    <input type="text" name="stationeryClassify" autocomplete="off" lay-verify="required" value="' + obj.data.stationeryClassify + '" class="layui-input">                </div>            </div>            <div class="layui-form-item">                <label class="layui-form-label">数量</label>                <div class="layui-input-block">                    <input type="text" name="stationeryCount" autocomplete="off" lay-verify="required|number" value="' + obj.data.stationeryCount + '" class="layui-input">                </div>            </div>            <div class="layui-form-item">                <label class="layui-form-label">说明</label>                <div class="layui-input-block">                    <textarea name="stationeryExplain" required lay-verify="required" class="layui-textarea">' + obj.data.stationeryExplain + '</textarea>                </div>            </div>            <div class="layui-form-item">                <label class="layui-form-label layui-hide"></label>                <div class="layui-input-block">                    <button type="button" class="layui-btn" lay-submit lay-filter="updateStationery">保存</button>                    <button type="reset" class="layui-btn layui-btn-primary">清空</button></div></div><input type="hidden" name="stationeryId" value="' + obj.data.stationeryId + '"></form>');
                    },
                    end: a => table.reload('tableId'),
                });
            } else if (obj.event === 'delete') {
                layer.confirm('确定是否删除【' + obj.data.stationeryName + '】？', {iocn: 3, title: '删除'}, function (index) {
                    $.getJSON($("#contextPath").val()+'/stationery/deleteStationery', {'stationeryId': stationeryId}, function (result) {
                        if (result.type === 'success') {
                            layer.msg(result.msg, {icon: 1, time: 1000}, function () {
                                layer.closeAll();
                            });
                        } else if (result.type === 'error') {
                            layer.msg(result.msg, {icon: 2});
                        }
                    });
                });
            }
        });

        /**
         * 添加办公用品表单
         */
        form.on('submit(addStationery)', function (data) {
            $.getJSON($("#contextPath").val()+'/stationery/addStationery', {'stationery': JSON.stringify(data.field)}, function (result) {
                if (result.type === 'success') {
                    layer.msg(result.msg, {icon: 1, time: 1000}, function () {
                        layer.closeAll();
                    });
                } else if (result.type === 'error') {
                    layer.msg(result.msg, {icon: 2});
                }
            });
        });

        /**
         * 修改办公用品信息
         */
        form.on('submit(updateStationery)', function (data) {
            $.getJSON($("#contextPath").val()+'/stationery/updateStationery', {'stationery': JSON.stringify(data.field)}, function (result) {
                if (result.type === 'success') {
                    layer.msg(result.msg, {icon: 1, time: 1000}, function () {
                        layer.closeAll();
                    });
                } else if (result.type === 'error') {
                    layer.msg(result.msg, {icon: 2});
                }
            });
        });

        /**
         * 办公用品入库
         */
        form.on('submit(storageStationery)', function (data) {
            console.log(data.field);
            $.getJSON($("#contextPath").val()+'/stationery/addStationeryAdd', {'stationeryAdd': JSON.stringify(data.field)}, function (result) {
                if (result.type === 'success') {
                    layer.msg(result.msg, {icon: 1, time: 1000}, function () {
                        layer.closeAll();
                    });
                } else if (result.type === 'error') {
                    layer.msg(result.msg, {icon: 2});
                }
            });
        });


    });
</script>
</body>
</html>
