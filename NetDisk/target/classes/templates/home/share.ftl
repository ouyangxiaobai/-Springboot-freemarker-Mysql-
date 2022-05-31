<!DOCTYPE html>
<html lang="zh">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
<title>用户【${share.user.username!""}】分享文件-${share.title!""}</title>
<#include "../admin/common/header.ftl"/>
<link href="/admin/css/iconfont.css" rel="stylesheet">
<link href="/admin/css/filebox.css" rel="stylesheet">
<link href="/admin/css/filemodal.css" rel="stylesheet">
<link href="/admin/css/box.css" rel="stylesheet">
<style type="text/css">
td{
	vertical-align:middle;
}
a {
	color: black;
}

a:hover {
	text-decoration: none;
}

.bgc-w {
	background-color: #fff;
}

.box .nav-stacked>li {
	border-bottom: 1px solid #f4f4f4;
	margin: 0;
}

.nav-stacked>li>a {
	border-radius: 0;
	border-top: 0;
	border-left: 3px solid transparent;
	color: #444;
}
.nav>li>a:hover {
	background-color: #eee;
	text-decoration: none;
}

li.activee>a {
	border-left-color: #3c8dbc !important;
}

.des {
	border: none;
	color: #9e9e9e;
}
.menu{
	position: fixed;
    left:0;
    top:0;
    min-width:114px;
    background-color: #fff;
    display: none;
    z-index:30;
    box-shadow:0 0 10px #999999;
    border-radius: 5px;
}
.menu .nav li a{
	padding:5px 15px;
}
.menu a.disabled{
	pointer-events: none;
    filter: alpha(opacity=50); /*IE滤镜，透明度50%*/
    -moz-opacity: 0.5; /*Firefox私有，透明度50%*/
    opacity: 0.5; /*其他，透明度50%*/
}
.pathtextarea .creatpathinput{
	height:23px;
	width:78px;
	font-size: 12px;
	border: 1px solid rgba(58,140,255,.3);
	border-radius: 2px;
	padding-top: 0px;
    padding-left: 4px;
}
 .pathtextarea .creatpathinput:focus{
	outline: none; 
	border: 1px solid #0099CC;
	border-radius: 2px;
} 
.pathtextarea .btn-default{
	padding: 0px 4px 0px 4px;
	border:1px solid rgba(58,140,255,.3);
	color: #3b8cff;
}
.pathtextarea .btn-default:hover{
	background-color: #fff !important;
}
.reback{
	width: 120px;
	height: 127px;
	float: left;
	margin: 4px 0 0 6px;
	text-align: center;
	border: 1px solid #fff;
	position: relative;
	cursor:pointer;
}
.modalajax{
	cursor:pointer;
}
.selected-box-header{
	background: #e5f0fb;
}
</style>
</head>
  
<body>
<div class="lyear-layout-web">
  <div class="lyear-layout-container">
  	<!--左侧导航-->
    <aside class="lyear-layout-sidebar" style="bottom:unset;">
      
      <!-- logo -->
      <div id="logo" class="sidebar-header">
        <a href=""><img src="/admin/images/logo-sidebar.png"/></a>
      </div>
      
    </aside>
    <!--End 左侧导航-->
   	<!--头部信息-->
    <header class="lyear-layout-header">
      
      <nav class="navbar navbar-default">
        <div class="topbar">
          
          <div class="topbar-left">
            <span class="navbar-page-title" id="sharer-id" data-key="${share.user.id}">【${share.user.username!""}】给您分享了如下文件： </span>
          </div>
          
          <ul class="topbar-right">
            <#if bysj_user??>
            <li class="dropdown dropdown-profile" id="logined-id" data-key="${bysj_user.id}">
              <a href="javascript:void(0)" data-toggle="dropdown">
                 <#if bysj_user.headPic??>
                 <#if bysj_user.headPic?length gt 0>
                	<img class="img-avatar img-avatar-48 m-r-10" src="/photo/view?filename=${bysj_user.headPic}" alt="${bysj_user.username!""}" />
                 <#else>
                 	<img class="img-avatar img-avatar-48 m-r-10" src="/admin/images/default-head.jpg" alt="${bysj_user.username!""}" />
                 </#if>
                 </#if>
                <span>${bysj_user.username!""} <span class="caret"></span></span>
              </a>
              <ul class="dropdown-menu dropdown-menu-right">
                <li> <a href="/system/update_userinfo"><i class="mdi mdi-account"></i> 个人信息</a> </li>
                <li> <a href="/system/update_pwd"><i class="mdi mdi-lock-outline"></i> 修改密码</a> </li>
                <li class="divider"></li>
                <li> <a href="/system/logout"><i class="mdi mdi-logout-variant"></i> 退出登录</a> </li>
              </ul>
            </li>
            <#else>
             <li class="dropdown dropdown-profile" id="un-login">
              <a href="javascript:void(0)" data-toggle="dropdown">
                 <img class="img-avatar img-avatar-48 m-r-10" src="/admin/images/default-head.jpg" />
                <span>请先登录<span class="caret"></span></span>
              </a>
              <ul class="dropdown-menu dropdown-menu-right">
                <li> <a href="/system/login"><i class="mdi mdi-login-variant"></i> 登录</a> </li>
              </ul>
            </li>
            </#if>
          </ul>
          
        </div>
      </nav>
      
    </header>
    <!--End 头部信息-->
    <!--页面主要内容-->
    <main class="lyear-layout-content" style="padding-left:0px;">
      
      <div class="container-fluid">
        
        <div class="row">
          <div class="col-lg-12">
            <div class="card">
              <div class="card-toolbar clearfix">
                <a class="btn btn-primary m-r-5" href="javascript:void(0)" onClick="saveFile('/net_disk/mc_file')"><i class="mdi mdi-arrow-right-box"></i>保存到网盘</a>
                <a class="btn btn-primary" href="javascript:void(0)" onClick="downloadFile('/net_disk/download')"><i class="mdi mdi-arrow-collapse-down"></i>下载</a>
              	<#if folderId??>
              	<a class="btn btn-default" href="javascript:window.history.go(-1)"><i class="mdi mdi-subdirectory-arrow-left" style="font-size:16px;"></i>返回上一级</a>
              	</#if>
              </div>
              <div class="card-body">

                <div class="table-responsive">
                  <table class="table table-bordered">
                    <thead>
                      <tr>
                        <th>
                          <label class="lyear-checkbox checkbox-primary">
                            <input type="checkbox" id="check-all"><span></span>
                          </label>
                        </th>
                        <th>分享文件</th>
                        <th>下载次数</th>
                        <th>分享次数</th>
                        <th>大小</th>
                        <th>分享时间</th>
                      </tr>
                    </thead>
                    <tbody>
                      <#if folders??>
                      <#list folders as folder>
                      <#if folder.isTrash == false>
                      <tr>
                        <td style="vertical-align:middle;">
                          <label class="lyear-checkbox checkbox-primary">
                            <input type="checkbox" name="folderIds" value="${folder.id}"><span></span>
                          </label>
                        </td>
                        <td style="vertical-align:middle;cursor:pointer;" class="folder-td" data-key="/share/sn/${share.sn}?folderId=${folder.id}">
                        	<img src="/admin/images/fileimg/Folder.png" width="30px">
                        	${folder.name}
                        </td>
                        <td style="vertical-align:middle;">--</td>
                        <td style="vertical-align:middle;">--</td>
                        <td style="vertical-align:middle;">--</td>
                        <td style="vertical-align:middle;">${share.createTime}</td>
                      </tr>
                      </#if>
                    </#list>
					</#if>
                      <#if files??>
                      <#list files as file>
                      <#if file.isTrash == false>
                      <tr>
                        <td style="vertical-align:middle;">
                          <label class="lyear-checkbox checkbox-primary">
                            <input type="checkbox" name="fileIds" value="${file.id}"><span></span>
                          </label>
                        </td>
                        <td style="vertical-align:middle;">
                        	<#if file.suffix == "zip" || file.suffix =="rar" || file.suffix =="7-Zip" || file.suffix =="7z" || file.suffix =="tar" || file.suffix =="gz">
								<img src="/admin/images/fileimg/ZIP.png" width="30px">
							<#elseif file.suffix == "mp4" || file.suffix == "rmvb" || file.suffix == "avi" || file.suffix == "mkv" || file.suffix == "flv" || file.suffix == "3gp" || file.suffix == "wmv">
									<a href="javascript:void(0)" class="player"><img src="/admin/images/fileimg/Video.png" width="30px" /></a>
							<#elseif file.suffix == "pdf">
									<img src="/admin/images/fileimg/PDF.png" width="30px"/>
							<#elseif file.suffix == "mp3" || file.suffix =="aiff" >
									<img src="/admin/images/fileimg/Music.png" width="30px" />
							<#elseif file.suffix == "jpeg" || file.suffix == "png" || file.suffix == "gif" || file.suffix == "jpg" >
									<img src="/photo/view_file?filename=${file.name}" style="height:31px;width:30px;"/>
							<#elseif file.suffix == "txt">
									<img src="/admin/images/fileimg/Text.png" width="30px" />
							<#elseif file.suffix == "doc" || file.suffix == "docx">
									<img src="/admin/images/fileimg/word.png" width="30px" />
							<#elseif file.suffix == "exe" || file.suffix == "bat" || file.suffix == "dll">
									<img src="/admin/images/fileimg/exe.png" width="30px" />
							<#elseif file.suffix == "xls" || file.suffix == "xlsx" || file.suffix == "xlt">
									<img src="/admin/images/fileimg/excel.png" width="30px" />
							<#else>
									<img src="/admin/images/fileimg/unknow.png" width="30px" />
							</#if>
                        	${file.originalName!""}.${file.suffix!""}
                        </td>
                        <td style="vertical-align:middle;">${file.downloadTimes!""}</td>
                        <td style="vertical-align:middle;">${file.shareTimes!""}</td>
                        <td style="vertical-align:middle;">
                        	<#if (file.size > 1024) && (file.size < 1048576)>
                        	${file.size/1024}KB
                        	<#elseif (file.size > 1048576) && (file.size < 1073741824)>
                        	${file.size/1024/1024}MB
                        	<#elseif (file.size > 1073741824)>
                        	${file.size/1024/1024/1024}GB
                        	</#if>
                        </td>
                        <td style="vertical-align:middle;">${share.createTime}</td>
                      </tr>
					</#if>
                    </#list>
					</#if>
                    <#if files??&& (files?size > 0)>
                    <#else>
                    <#if folders??&& (folders?size > 0)>
                    <#else>
                    <tr align="center"><td colspan="6">这里空空如也！</td></tr>
                    </#if>
                    </#if>
                    </tbody>
                  </table>
                </div>
               
              </div>
            </div>
          </div>
          
        </div>
        
      </div>
      
    </main>
    <!--End 页面主要内容-->
  </div>
</div>
<!--复制移动模态框-->
<!-- 移动复制模态框 -->
	<div class="modal fade in" id="thismodal" data-backdrop="static">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-body box no-padding" style="display: none;">
					<div class="box-header">
						<h3 class="box-title mc-title" style="font-size:15px;"></h3>
					</div>
					<div class="box-body no-padding" style="height:100%;">
						<div class="box-header" style="padding:3px 0 3px 0;">
							<span class="btn btn-default btn-xs des mm"> 
								<i class="mdi mdi-plus"></i>
							</span>
							<img class="mcfloorimg" src="/admin/images/fileimg/Folder.png" />
							<h3 class="box-title root-path" style="font-size:12px;cursor:pointer;">全部文件</h3>
							<input class="mctopathid" type="hidden" value="33333" />
						</div>
						<ul class="nav nav-pills nav-stacked mm" style="padding-left:15px;">
							<#if rootFolders??>
							<#list rootFolders as path>
								<div class="pathidcompare" pathId="${path.id}">
									<div class="box-header no-padding">
										<span class="btn btn-default btn-xs des mm"> 
											<i class="mdi mdi-plus"></i>
										</span>
										<span class="openpath modalajax">
											<img class="mcfloorimg" src="/admin/images/fileimg/Folder.png" />
											<h3 class="box-title" style="font-size:12px;">${path.name}</h3>
											<input class="mctopathid" type="hidden" value="${path.id}" />
										</span>
									</div>
									<ul class="nav nav-pills nav-stacked mm modalajaxdata" style="padding-left:15px;display:none;">
										
									</ul>
								</div>
							</#list>
							</#if>
						</ul>
					</div>
					<div class="box-footer" style="text-align:right;">
						<input class="userrootpath" type="hidden" name="userrootpath" value=""/>
						<form action="/net_disk/mc_file" method="post">
							<input class="mctoid" type="hidden" name="mctoid" value=""/>
							<input class="mcfileids" type="hidden" name="mcfileids" value=""/>
							<input class="mcpathids" type="hidden" name="mcpathids" value=""/>
							<input type="hidden" name="pathid" value=""/>
							<input class="morc" type="hidden" name="morc" value=""/>
							<span type="submit" class="btn btn-primary" id="save-file-btn"
								>确定</span>
							<button type="button" class="btn btn-default mcmodalcancle"
								data-dismiss="modal">取消</button>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>

<#include "../admin/common/footer.ftl"/>
<script type="text/javascript" src="/admin/js/file/filejs.js"></script>
<script type="text/javascript" src="/admin/js/file/fileajax.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	// 复选框全选
	$("#check-all").change(function () {
		$("input[type='checkbox']").prop('checked', $(this).prop("checked"));
	});
	$(".folder-td").click(function(){
		window.location.href = $(this).attr('data-key');
	});
	$(".root-path").click(function(){
		$(".box-header").removeClass('selected-box-header');
		$(this).parents(".box-header").addClass('selected-box-header');
		$("input.mctoid[name='mctoid']").val(-1);
	});
	
	//保存文件提交按钮
	$("#save-file-btn").click(function(){
		var id = $("input.mctoid[name='mctoid']").val();
		if(id == ''){
			showWarningMsg('请选择目标文件夹！');
			return;
		}
		var postData = {};
		if(parseInt(id) != -1){
			postData = {'targetFolderId' : id};
		}
		var fileIds = new Array(),folderIds = new Array();
		$("input[type='checkbox'][name='fileIds']:checked").each(function(i,e){
			fileIds[i] = $(e).val();
		})
		$("input[type='checkbox'][name='folderIds']:checked").each(function(i,e){
			folderIds[i] = $(e).val();
		})
		postData.fileIds = fileIds.toString();
		postData.folderIds = folderIds.toString();
		ajaxRequest('/share/save_file','post',postData,function(rst){
			if(rst.code == 0){
				showConfimMsg('保存成功，是否马上去查看？',function(){
					window.location.href = '/net_disk/list?folderId=' + (id == -1 ? '' : id);
				},function(){window.location.reload();});
			}
			
		});
	});
});
function del(url){
	if($("input[type='checkbox']:checked").length != 1){
		showWarningMsg('请选择一条数据进行删除！');
		return;
	}
	var id = $("input[type='checkbox']:checked").val();
	$.confirm({
        title: '确定删除？',
        content: '删除后数据不可恢复，请慎重！',
        buttons: {
            confirm: {
                text: '确认',
                action: function(){
                    deleteReq(id,url);
                }
            },
            cancel: {
                text: '关闭',
                action: function(){
                    
                }
            }
        }
    });
}
//打开保存页面
function saveFile(url){
	var fileChecked = $("input[type='checkbox'][name='fileIds']:checked");
	var folderChecked =$("input[type='checkbox'][name='folderIds']:checked");
	if(fileChecked.length < 1 && folderChecked.length < 1){
		showWarningMsg('请至少选择一项进行保存！');
		return;
	}
	if($("#un-login").length != 0){
		showWarningMsg('请先登录再进行保存！');
		return;
	}
	if($("#sharer-id").attr('data-key') == $("#logined-id").attr('data-key')){
		showWarningMsg('别闹了大兄弟，这是你自己分享的文件，你还保存个啥子？');
		return;
	}
	$("#thismodal").modal("toggle");
	$('#thismodal .modal-body').css('display', 'block');
	$("#thismodal .mc-title").html("保存到");
	$(".box-header").removeClass('selected-box-header');
	$(this).parents(".box-header").removeClass('selected-box-header');
}
//下载
function downloadFile(url){
	var checked =$("input[type='checkbox'][name='fileIds']:checked");
	if(checked.length != 1){
		showWarningMsg('请选择一项文件进行下载！（文件夹不支持下载哦！）');
		return;
	}
	window.location.href = '/download/download_file?fid='+checked.val();
}
</script>
</body>
</html>