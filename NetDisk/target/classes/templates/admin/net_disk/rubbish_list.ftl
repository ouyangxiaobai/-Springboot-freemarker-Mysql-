<!DOCTYPE html>
<html lang="zh">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
<title>网盘回收站文件管理</title>
<#include "../common/header.ftl"/>
<link href="/admin/css/iconfont.css" rel="stylesheet">
<link href="/admin/css/filebox.css" rel="stylesheet">
<link href="/admin/css/filemodal.css" rel="stylesheet">
<link href="/admin/css/box.css" rel="stylesheet">
<style type="text/css">
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
    <aside class="lyear-layout-sidebar">
      
      <!-- logo -->
      <div id="logo" class="sidebar-header">
        <a href="index.html"><img src="/admin/images/logo-sidebar.png" title="${siteName!""}" alt="${siteName!""}" /></a>
      </div>
      <div class="lyear-layout-sidebar-scroll"> 
        <#include "../common/left-menu.ftl"/>
      </div>
      
    </aside>
    <!--End 左侧导航-->
    
    <#include "../common/header-menu.ftl"/>
    
    <!--页面主要内容-->
    <main class="lyear-layout-content">
      
      <div class="container-fluid">
        
        <div class="row">
          <div class="col-lg-12">
            <div class="card">
              <div class="card-toolbar clearfix">
                <#include "../common/third-menu.ftl"/>
              </div>
              <div class="card-body">
                <!--开始-->
				<div class="loadfiletype">
					<div class="menu" style="display: none;">
						<ul class="nav nav-pills nav-stacked" style="padding:5px 0 5px 0;">
								<li><a class="filereturnback" href="javascript:restoreFile('/net_disk/restore_file')">还原</a></li>
								<li><a onclick="forceDel('/net_disk/force_delete')" class="delete" href="javascript:void(0)">删除</a></li>
						</ul>
					</div>
					<div class="bgc-w box box-primary" style="height: 695px;border-top:0px;">
						<!--盒子头-->
						<div class="box-header" style="border-bottom:0px;padding:0px;">
						</div>
						<!--盒子身体-->
						<div class="box-body no-padding">
							
							<div class="file-box" style="overflow-y: auto;">
								<div class="boxcontain" style="height: auto;">
											<#if folderList??>
											<#list folderList as folder>
											<div class="file-one">
												<div class="file-img path" title="${folder.name}">
														<a>
															<img src="/admin/images/fileimg/Folder.png">
														</a>
												</div>
												<div class="file-name path">
												
														<div class="filename">
															<a href="list?folderId=${folder.id}" style="font-size: 12px;">${folder.name}</a>
														</div>
													
													<div class="pathtextarea rename diplaynone" style="position: absolute;top: 97px;left: -5px;z-index:100;">
															<form action="rename">
																<input class="creatpathinput" type="text" name="name" value="${folder.name}">
																<input type="hidden" name="id" value="${folder.id}">
																<input type="hidden" name="isfile" value="false">
																<span class="btn btn-default rename-file-btn">
																	<em class="glyphicon glyphicon-ok" style="font-size: 12px;">✔</em>
																</span>
																<span class="btn btn-default">
																	<em class="glyphicon glyphicon-remove cansalcreate" style="font-size: 12px;">✖</em>
																</span>
															</form>
													</div>
												</div>
												<input type="hidden" class="pathmessage" value="${folder.id}">
												<span class="file-check"> 
													<span class="iconfont icon-xuanze" style="height:1.5em;width:1.5em"></span>
												</span>
											</div>
										</#list>
										</#if>
										<#if fileList??>
										<#list fileList as file>
										<div class="file-one" title="${file.originalName}.${file.suffix}">
													<#if file.suffix == "zip" || file.suffix =="rar" || file.suffix =="7-Zip">
													<div class="file-img">
														<img src="/admin/images/fileimg/ZIP.png">
													</div>
													<#elseif file.suffix == "mp4" || file.suffix == "rmvb" || file.suffix == "avi">
														<div class="file-img">
															<img src="/admin/images/fileimg/Video.png" />
														</div>
													<#elseif file.suffix == "pdf">
														<div class="file-img">
															<img src="/admin/images/fileimg/PDF.png" />
														</div>
													<#elseif file.suffix == "mp3" || file.suffix =="aiff" >
														<div class="file-img">
															<img src="/admin/images/fileimg/Music.png" />
														</div>
													<#elseif file.suffix == "jpeg" || file.suffix == "png" || file.suffix == "gif" || file.suffix == "jpg" >
														<div class="file-img">
															<img src="/photo/view_file?filename=${file.name}" style="height:71px;width:56px;"/>
														</div>
													<#elseif file.suffix == "txt">
														<div class="file-img">
															<img src="/admin/images/fileimg/Text.png" />
														</div>
													<#elseif file.suffix == "doc" || file.suffix == "docx">
														<div class="file-img">
															<img src="/admin/images/fileimg/word.png" />
														</div>
													<#elseif file.suffix == "exe" || file.suffix == "bat" || file.suffix == "dll">
														<div class="file-img">
															<img src="/admin/images/fileimg/exe.png" />
														</div>
													<#elseif file.suffix == "xls" || file.suffix == "xlsx" || file.suffix == "xlt">
														<div class="file-img">
															<img src="/admin/images/fileimg/excel.png" />
														</div>
													<#else>
														<div class="file-img">
															<img src="/admin/images/fileimg/unknow.png" />
														</div>
													</#if>
											<div class="file-name">
												<div class="filename" title="${file.originalName}.${file.suffix}">
													<a>${file.originalName}</a>
												</div>
												<div class="pathtextarea rename diplaynone" style="position: absolute;top: 97px;left: -5px;z-index:100;">
													<form action="rename">
														<input class="creatpathinput" type="text" name="name" value="${file.originalName}">
														<input type="hidden" name="id" value="${file.id}">
														<input type="hidden" name="isfile" value="true">
														<span class="btn btn-default rename-file-btn">
															<em class="glyphicon glyphicon-ok" style="font-size: 12px;">✔</em>
														</span>
														<span class="btn btn-default">
															<em class="glyphicon glyphicon-remove cansalcreate" style="font-size: 12px;">✖</em>
														</span>
													</form>
												</div>
											</div>
											<input type="hidden" class="filemessage" value="${file.id}">
											<span class="file-check"> 
												<span class="iconfont icon-xuanze" style="height:1.5em;width:1.5em"></span>
											</span>
										</div>
										</#list>
										</#if>
										<#if folderId??>
										<!--返回上页开始-->
										<div class="reback" onclick="javascript:window.history.go(-1);">
											<div class="file-img">
												<img src="/admin/images/fileimg/back.png" />
											</div>
											<div class="file-name">
												<div class="filename">
													<a>返回上一页</a>
												</div>
											</div>
										</div>
										<!--返回上页结束-->
										</#if>
								</div>
							</div>
						</div>
					</div>			</div>                
                <!--结束-->
              </div>
            </div>
          </div>
          
        </div>
        
      </div>
      <!--上传文件隐藏框-->
      <input type="file" name="uploadFile" id="upload-file" style="display:none;" onchange="uploading()">
    </main>
    <!--End 页面主要内容-->
  </div>
</div>

<#include "../common/footer.ftl"/>
<script type="text/javascript" src="/admin/js/perfect-scrollbar.min.js"></script>
<script type="text/javascript" src="/admin/js/lightyear.js"></script>
<script type="text/javascript" src="/admin/js/main.min.js"></script>
<script type="text/javascript" src="/admin/js/file/filejs.js"></script>
<script type="text/javascript" src="/admin/js/file/fileajax.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	/*
			 * 收縮
			 */
			$("body").on("click",".des",function(){
				console.log("aaaa");
				var $this = $(this).children();

				var $ul = $(this).parents(".box-header").next();

				if($(this).hasClass("mm")) {
					if($this.hasClass("mdi-window-minimize")) {
						$this.removeClass("mdi-window-minimize").addClass("mdi-plus");
					} else {
						$this.removeClass("mdi-plus").addClass("mdi-window-minimize");
					}
					$ul.slideToggle(1000);
				} else {
					if($this.hasClass("mdi-window-minimize")) {
						$this.removeClass("mdi-window-minimize").addClass("mdi-plus");
					} else {

						$this.removeClass("mdi-plus").addClass("mdi-window-minimize");
					}
					$ul.slideToggle(1000);
				}
			});
			
			$(".nav.mm").on("click", "li", function() {
				$(this).parent().children(".activee").removeClass("activee");
				$(this).addClass("activee");
			});
			
			$(".uploadfile input").bind("change",function(){
				$(".fileuploadform").submit();
			});
			
		
});
//还原
function restoreFile(url){
	var checked =$(".loadfiletype .file-one.file-one-check");
	if(checked.length < 1){
		showWarningMsg('请至少选择一项进行还原！');
		return;
	}
	var folderIds = new Array(),fileIds = new Array();
	checkedpaths(folderIds,fileIds);
	var postData = {folderIds:folderIds.toString(),fileIds:fileIds.toString()};
	ajaxRequest(url,'post',postData,function(rst){
		if(rst.code == 0){
			showSuccessMsg('还原成功！',function(){
				window.location.reload();
			});
		}else{
			showErrorMsg(data.msg);
		}
	});
}

//删除
function forceDel(url){
	var checked =$(".loadfiletype .file-one.file-one-check");
	if(checked.length != 1){
		showWarningMsg('请选择一项进行删除！');
		return;
	}
	var folderIds = new Array(),fileIds = new Array();
	checkedpaths(folderIds,fileIds);
	showConfimMsg('删除后不可恢复，请谨慎操作！',function(){
			delRequest(url,{folderId:folderIds.toString(),fileId:fileIds.toString()});
	},function(){});
}
function delRequest(url,postData){
	ajaxRequest(url,'post',postData,function(rst){
		if(rst.code == 0){
			showSuccessMsg('删除成功！',function(){
				window.location.reload();
			});
		}else{
			showErrorMsg(data.msg);
		}
	});
}
</script>
</body>
</html>