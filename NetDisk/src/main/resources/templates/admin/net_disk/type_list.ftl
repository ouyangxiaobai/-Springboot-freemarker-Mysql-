<!DOCTYPE html>
<html lang="zh">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
<title>${siteName!""}|网盘文件管理-${title!""}</title>
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
        <a href="index.html"><img src="/admin/images/logo-sidebar.png" /></a>
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
								<li><a class="downloadfile">下载</a></li>
								<li><a class="doshare" onclick="shareFile('/net_disk/share_file')" href="javascript:void(0)">分享</a></li>
								<li><a class="menurename" href="javascript:void(0)">重命名</a></li>
								<li><a onclick="del('/net_disk/delete')" class="delete" href="javascript:void(0)">删除</a></li>
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
								
										<!--新建文件夹操作显示部分  -->
										<div class="file-one creatpath pathtextarea diplaynone" style="width: 144px;">
											<div class="file-img">
												<img src="/admin/images/fileimg/Folder.png">
											</div>
											<div class="file-name" style="text-align: left;">
												<form action="createpath">
													<input class="creatpathinput" type="text" id="new-folder-name" name="pathname" value="新建文件夹">
													<input type="hidden" name="pathid" id="current-path-id" value="${folderId!""}">
													<span class="btn btn-default" id="add-folder-btn">
														<em class="glyphicon glyphicon-ok" style="font-size: 12px;">✔</em>
													</span>
													<span class="btn btn-default">
														<em class="glyphicon glyphicon-remove cansalcreate" style="font-size: 12px;">✖</em>
													</span>
												</form>
											</div>
											<span class="file-check"> 
												<span class="iconfont icon-xuanze" style="height:1.5em;width:1.5em"></span>
											</span>
										</div>
											
										<#if fileList??>
										<#list fileList as file>
										<div class="file-one" title="${file.originalName}.${file.suffix}">
													<#if file.suffix == "zip" || file.suffix =="rar" || file.suffix =="7-Zip" || file.suffix =="7z" || file.suffix =="tar" || file.suffix =="gz">
													<div class="file-img">
														<img src="/admin/images/fileimg/ZIP.png">
													</div>
													<#elseif file.suffix == "mp4" || file.suffix == "rmvb" || file.suffix == "avi" || file.suffix == "mkv" || file.suffix == "flv" || file.suffix == "3gp" || file.suffix == "wmv">
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
<div class="row" id="aaaa" style="display:none;">
          <div class="col-lg-12">
            <div class="card">
              <div class="card-body" style="padding-bottom:0px;">
                <form action="add" id="user-add-form" method="post" class="row">
                  
                  <div class="input-group" style="margin-top:15px;margin-bottom:15px;padding-left:25px;">
                    <label class="lyear-radio radio-inline radio-primary" style="margin-left:10px;">
                    <input type="radio" name="shareType" value="1" checked="">
                    <span>加密</span>
                    <label class="lyear-radio radio-inline radio-primary" style="margin-left:45px;">
                    <input type="radio" name="shareType" value="0">
                    <span>公开</span>
                  </label></div>
                  <div class="input-group m-b-10">
                    <span class="input-group-addon">有效期</span>
                    <select name="expireTime" class="form-control" id="expireTime">
                    	<option value="0">永久有效</option>
                    	<option value="604800000">七天</option>
                    	<option value="86400000">一天</option>
                    </select>
                  </div>
                </form>
       
              </div>
            </div>
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
			
			$(".root-path").click(function(){
				$(".box-header").removeClass('selected-box-header');
				$(this).parents(".box-header").addClass('selected-box-header');
				$("input.mctoid[name='mctoid']").val(-1);
			});
			
			//移动复制文件提交按钮
			$("#mc-file-btn").click(function(){
				var id = $("input.mctoid[name='mctoid']").val();
				if(id == ''){
					showWarningMsg('请选择目标文件夹！');
					return;
				}
				var postData = {};
				if(parseInt(id) != -1){
					postData = {'targetFolderId' : id};
				}
				postData.isMove = $("input.morc[name='morc']").val();
				postData.fileIds = $("input.mcfileids[name='mcfileids']").val();
				postData.folderIds = $("input.mcpathids[name='mcpathids']").val();
				ajaxRequest('/net_disk/mc_file','post',postData,function(rst){
					if(rst.code == 0){
						showSuccessMsg('操作成功！',function(){
							window.location.reload();
						});
					}
					
				});
			});
		
});
//新建文件夹
function addFolder(url){
	$(".creatpath").removeClass("diplaynone");
	//新建文件夹按钮提交事件	
	$("#add-folder-btn").click(function(){
		var folderName = $("#new-folder-name").val();
		var currentPathId = $("#current-path-id").val();
		var data = {name:folderName};
		if(currentPathId != ''){
			data = {name:folderName,'parent.id':currentPathId};
		}
		ajaxRequest(url,'post',data,function(rst){
			if(rst.code == 0){
				showSuccessMsg('新建成功！',function(){
					window.location.reload();
				});
			}
			
		});
	});
}
//移动文件
function moveFile(url){
	var checked =$(".loadfiletype .file-one.file-one-check");
	if(checked.length < 1){
		showWarningMsg('请至少选择一项进行编辑！');
		return;
	}
	
}
//重命名文件
function renameFile(url){
	var checked =$(".loadfiletype .file-one.file-one-check");
	if(checked.length < 1){
		showWarningMsg('请至少选择一项进行编辑！');
		return;
	}
	checked.find(".filename").addClass("diplaynone");
	checked.find(".rename").removeClass("diplaynone");
}
//编辑按钮提交事件	
	$(".rename-file-btn").click(function(){
		var fileName = $(this).prevAll('input[name="name"]').val();
		var id = $(this).prevAll('input[name="id"]').val();
		var isFile = $(this).prev('input[name="isfile"]').val();
		var data = {name:fileName,id:id,isFile:isFile};
		ajaxRequest('/net_disk/rename_file','post',data,function(rst){
			if(rst.code == 0){
				showSuccessMsg('修改成功！',function(){
					window.location.reload();
				});
			}
			
		});
	});
//上传文件按钮事件
function uploadFile(url){
	$("#upload-file").click();
	
}
//开始上传文件
function uploading(){
	var filename = $("#upload-file").val();
	filename = filename.substring(filename.lastIndexOf('\\')+1,filename.length);
	var suffix = filename.substring(filename.lastIndexOf('.')+1,filename.length)
	filename = filename.substring(0,filename.lastIndexOf('.'));
	lightyear.loading('show');
	uploadingFile('upload-file',function(data){
		if(data.code == 0){
			var postData = {'folder.id':$("#current-path-id").val()};
			postData.name = data.data.filename;
			postData.size = data.data.fileSize;
			postData.md5 = data.data.md5;
			postData.contentType = data.data.contentType;
			postData.originalName = filename;
			postData.suffix = suffix;
			ajaxRequest('/net_disk/upload_file','post',postData,function(rst){
				if(rst.code == 0){
					lightyear.loading('hide');
					showSuccessMsg('上传成功！',function(){
						window.location.reload();
					});
				}
			});
			return;
		}
		data = $.parseJSON(data);
		showErrorMsg(data.msg);
	});
}
//打开编辑页面
function del(url){
	var checked =$(".loadfiletype .file-one.file-one-check");
	if(checked.length < 1){
		showWarningMsg('请至少选择一项进行删除！');
		return;
	}
	var folderIds = new Array(),fileIds = new Array();
	checkedpaths(folderIds,fileIds);
	if(folderIds.length > 0){
		showConfimMsg('删除文件夹后文件夹下的所有文件都会被删除哦，请谨慎操作！',function(){
			delRequest(url,{folderIds:folderIds.toString(),fileIds:fileIds.toString()});
		},function(){});
		return;
	}
	delRequest(url,{folderIds:folderIds.toString(),fileIds:fileIds.toString()});
	//window.location.href = url + '?id=' + $("input[type='checkbox']:checked").val();
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
//下载
function downloadFile(url){
	var checked =$(".loadfiletype .file-one.file-one-check");
	if(checked.length != 1){
		showWarningMsg('请选择一项进行下载！');
		return;
	}
	var folderIds = new Array(),fileIds = new Array();
	checkedpaths(folderIds,fileIds);
	if(folderIds.length > 0){
		showWarningMsg('请选择文件进行下载！');
		return;
	}
	window.location.href = '/download/download_file?fid='+fileIds.toString();
}
//分享文件
function shareFile(url){
	var checked =$(".loadfiletype .file-one.file-one-check");
	if(checked.length < 1){
		showWarningMsg('请至少选择一项进行分享！');
		return;
	}
	var folderIds = new Array(),fileIds = new Array();
	checkedpaths(folderIds,fileIds);
	var tips = $(checked[0]).attr('title') + '等' + checked.length + '个文件';
	postData = {folderIds:folderIds.toString(),fileIds:fileIds.toString()}
	 $.confirm({
        title: '分享文件【' + tips + '】',
        content: $("#aaaa").html(),
        buttons: {
            formSubmit: {
                text: '提交',
                btnClass: 'btn-blue',
                action: function () {
                	postData.shareType = this.$content.find("input[type='radio'][name='shareType']:checked").val();
                	postData.expireTime = this.$content.find("#expireTime").val();
                    ajaxRequest(url,'post',postData,function(rst){
						if(rst.code == 0){
							var content = '链接地址：${siteUrl!""}/share/sn/' + rst.data.sn;
							if(rst.data.shareType == 1){
								content += '   提取密码：' + rst.data.password;
							}
							showTipsMsg('分享成功！',content,function(){
								//window.location.reload();
							});
						}else{
							showErrorMsg(data.msg);
						}
					});
                }
            },
            cancel: {
                text: '取消'
            },
        }
    });
}
</script>
</body>
</html>