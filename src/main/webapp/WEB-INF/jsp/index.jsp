<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
	<meta charset="UTF-8">
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
		  rel="stylesheet"/>

	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript"
			src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

	<script type="text/javascript">

		$(function(){
			$("#searchBtn").click(function () {
				pageList(1, 2);
			});
			//定制字段
			$("#definedColumns > li").click(function(e) {
				//防止下拉菜单消失
				e.stopPropagation();
			});

			//为删除按钮绑定事件，执行市场活动删除操作
			$("#deleteBtn").click(function () {
				//找到复选框中所有打勾选项
				var $xz = $("input[name=xz]:checked");

				if ($xz.length==0){
					alert("请选择要删除的记录")

				}else{
					//alert($xz.length)

					if (confirm("确定删除？")){
						//拼接参数
						var param = "";
						//将$xz中的每一个dom对象遍历处理，取其value值，
						for (var i= 0;i<$xz.length;i++){
							param +="id="+ $($xz[i]).val();

							if (i<$xz.length-1){
								param += "&";
							}
						}

						//alert(param)
						$.ajax({

							url:"workbench/customer/delete.do",
							data:
							param

							,
							type:"post",
							dataType:"json",
							success:function (data) {

								if (data.success){
									pageList(1
											,$("#customerPage").bs_pagination('getOption', 'rowsPerPage'));



								}else {
									alert("删除市场信息失败")
								}

							}
						})
					}

				}


			})
			//为创建按钮绑定事件，打开添加操作的模态窗口
			$("#addBtn").click(function () {

				$(".time").datetimepicker({
					minView: "month",
					language: 'zh-CN',
					format: 'yyyy-mm-dd',
					autoclose: true,
					todayBtn: true,
					pickerPosition: "bottom-left"
				});
				//操作模态窗口的方式

				//需要操作的模态窗口的jquery对象，调用modal方法，为该方法传递参数，show打开，hide关闭

				//发出后台请求，
				$.ajax({

					url: "query.do",
					type: "get",
					dataType: "json",
					success: function (data) {

						var html = "<option> </option>";

						//遍历出的每一个n，都是一个user对象
						$.each(data, function (i, n) {
							html += "<option value='" + n.id + "'>" + n.name + "</option>";


						})
						$("#create-owner").html(html);

						//将当前登录的用户，设置为下拉框默认的选项
						//取得当前登录的用户id
						//js中使用el表达式，el表达式必须套用在字符串中
						var id = "${user.id}";

						$("#create-owner").val(id);

						//所有者下拉框处理完毕后，打开模态窗口
						$("#createCustomerModal").modal("show");

					}
				})

			})


			pageList(1, 2);
		});
		function pageList(pageNo, pageSize) {


			//查询前,将隐藏域中保存的信息取出来，重新赋予到搜索框中

			$.ajax({

				url: "query.do",
				data: {
					"pageNo": pageNo,
					"pageSize": pageSize,
					"name": $.trim($("#search-name").val()),
					"owner": $.trim($("#search-owner").val()),
					"website": $.trim($("#search-website").val()),
					"phone": $.trim($("#search-phone").val())

				},
				type: "get",
				dataType: "json",
				success: function (data) {
					/*
                    data
                    需要的市场活动信息列表
                    {{市场活动列表}，{2}}
                    总记录数：
                    {"tptal":10}
                     */
					var html = "";

					$.each(data, function (i, n) {
						html += '<tr class="active">> ';
						html += '<td><input type="checkbox" name="xz" value="' + n.cdkey + '"/></td>';
						html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/customer/detail.do?id='+n.id+'\';">' + n.registerTime + '</a></td>';
						html += '<td>' + n.owner + '</td>';
						html += '<td>' + n.phone + '</td>';
						html += '<td>' + n.website + '</td>';
						html += '</tr>';

					})
					$("#customerBody").html(html);

					//计算总页数
					var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
					//数据处理完毕之后，结合分页查询，对前端展现分页信息
					$("#customerPage").bs_pagination({
						currentPage: pageNo, // 页码
						rowsPerPage: pageSize, // 每页显示的记录条数
						maxRowsPerPage: 20, // 每页最多显示的记录条数
						totalPages: totalPages, // 总页数
						totalRows: data.total, // 总记录条数

						visiblePageLinks: 3, // 显示几个卡片

						showGoToPage: true,
						showRowsPerPage: true,
						showRowsInfo: true,
						showRowsDefaultInfo: true,

						//该回调函数在点击分页组件时触发

						onChangePage : function(event, data){
							pageList(data.currentPage , data.rowsPerPage);
						}
					});



				}
			})

		}
	</script>
</head>
<body>




<div>
	<div style="position: relative; left: 10px; top: -10px;">
		<div class="page-header">
			<h3>卡密列表</h3>
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
						<input class="form-control" id="search-name" type="text">
					</div>
				</div>

				<div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">所有者</div>
						<input class="form-control" id="search-owner" type="text">
					</div>
				</div>

				<div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">公司座机</div>
						<input class="form-control" id="search-phone" type="text">
					</div>
				</div>

				<div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">公司网站</div>
						<input class="form-control" id="search-website" type="text">
					</div>
				</div>

				<button type="button" class="btn btn-default" id="searchBtn">查询</button>

			</form>
		</div>
		<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
			<div class="btn-group" style="position: relative; top: 18%;">
				<button type="button" class="btn btn-primary" id="addBtn" ><span class="glyphicon glyphicon-plus"></span> 创建</button>
				<button type="button" class="btn btn-default" data-toggle="modal" data-target="#editCustomerModal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				<button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
			</div>

		</div>
		<div style="position: relative;top: 10px;">
			<table class="table table-hover">
				<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" /></td>
					<td>名称</td>
					<td>所有者</td>
					<td>公司座机</td>
					<td>公司网站</td>
				</tr>
				</thead>
				<tbody id="cdkeyBody">
										<tr>
											<td><input type="checkbox" /></td>
											<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点</a></td>
											<td>${keylist.cdkey}</td>
											<td>010-84846003</td>
											<td>http://www.bjpowernode.com</td>
										</tr>
				                        <tr class="active">
				                            <td><input type="checkbox" /></td>
				                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点</a></td>
				                            <td>zhangsan</td>
				                            <td>010-84846003</td>
				                            <td>http://www.bjpowernode.com</td>
				                        </tr>
				</tbody>
			</table>
		</div>

		<div style="height: 50px; position: relative;top: 30px;">
			<div id="customerPage">

			</div>

		</div>

	</div>

</div>
</body>
</html>