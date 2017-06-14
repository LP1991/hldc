<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
    <title>转换过程查看</title>
    <meta name="decorator" content="default"/>
    <link href="${ctxStatic}/jquery-steps/css/bootstrap.min14ed.css" rel="stylesheet">
    <style type="text/css">
        .f_td{
            overflow:hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
            max-width:100px;
            cursor: pointer;
        }
    </style>
</head>
<body class="hideScroll">
<sys:message content="${message}"/>
<input type="hidden" id="id"/>

<fieldset class="change_table_margin">
    <table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
        <tbody>
        <tr>
            <td class="width-15 active"><label class="pull-right">转换语句：</label></td>
            <td class="width-35">${dcTransDataSub.transSql}</td>
        </tr>
        </tbody>
    </table>
</fieldset>

</body>
</html>