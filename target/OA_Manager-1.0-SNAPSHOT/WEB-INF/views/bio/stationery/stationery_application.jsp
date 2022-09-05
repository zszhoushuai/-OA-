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
            <legend>申请办公用品</legend>
        </fieldset>
        <form class="layui-form layui-form-pane" lay-filter="stationeryProposer">
            <div class="layui-form-item">
                <label class="layui-form-label">工号</label>
                <div class="layui-input-block">
                    <input type="text" name="title" autocomplete="off" lay-verify="required" placeholder=""
                           class="layui-input" value="<shiro:principal/>" disabled>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">办公用品</label>
                <div class="layui-input-block">
                    <select name="stationeryId" id="stationeryId" lay-verify="required">
                        <option></option>
                    </select>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">数量</label>
                <div class="layui-input-block">
                    <input type="text" name="stationeryCount" autocomplete="off" lay-verify="required|number"
                           placeholder="申请办公用品数量。。。" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">申请原因</label>
                <div class="layui-input-block">
                    <textarea name="explain" required lay-verify="required" placeholder="请输入"
                              class="layui-textarea"></textarea>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label layui-hide"></label>
                <div class="layui-input-block">
                    <button type="button" class="layui-btn" lay-submit lay-filter="*">保存</button>
                    <button type="reset" class="layui-btn layui-btn-primary">清空</button>
                </div>
            </div>
        </form>
        <input hidden id="contextPath" value="${pageContext.request.contextPath}" />

    </div>


</div>
<script src="${pageContext.request.contextPath}/static/lib/layui/layui.js" charset="utf-8"></script>
<script type="text/javascript">
    layui.use(['jquery', 'layer', 'form'], function () {
        let $ = layui.$;
        let layer = layui.layer;
        let form = layui.form;

        /**
         * 下拉框渲染
         */
        $.getJSON($("#contextPath").val()+ '/stationery/getStationeryAll', {'page': 1, 'limit': 99}, function (result) {
            if (result.type === 'success') {
                for (let i = 0; i < result.data.length; i++) {
                    $('#stationeryId').append('<option value="' + result.data[i].stationeryId + '">' + result.data[i].stationeryName + '</option>')
                }
                form.render('select');
            } else if (result.type === 'error') {
                layer.msg(result.msg);
            }
        });


        /**
         * 表单提交
         */
        form.on('submit(*)', function (data) {
            let msg = layer.msg('保存中，请稍后',{icon:16,time:false,shade:0.6});
            $.getJSON($("#contextPath").val()+ '/stationery/applyForOfficeSupplies', {'stationeryProposer': JSON.stringify(data.field)}, function (result) {
                setTimeout(function () {
                    layer.close(msg);
                    if (result.type === 'success') {
                        layer.msg(result.msg, {icon: 1, time: 1000}, function (index) {
                            window.location.reload();
                        });
                    } else if (result.type === 'error') {
                        layer.msg(result.msg, {icon: 2});
                    }
                },1500);
            });
        });
    });

</script>
</body>
</html>
