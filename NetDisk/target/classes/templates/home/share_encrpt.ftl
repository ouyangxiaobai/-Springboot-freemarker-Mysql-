<!DOCTYPE html>
<html lang="zh">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
<title>提取文件页面</title>
<#include "../admin/common/header.ftl"/>
<style>
.lyear-wrapper {
    position: relative;
}
.lyear-login {
    display: flex !important;
    min-height: 100vh;
    align-items: center !important;
    justify-content: center !important;
}
.login-center {
    background: #fff;
    min-width: 38.25rem;
    padding: 2.14286em 3.57143em;
    border-radius: 5px;
    margin: 2.85714em 0;
}
.login-header {
    margin-bottom: 1.5rem !important;
}
.login-center .has-feedback.feedback-left .form-control {
    padding-left: 38px;
    padding-right: 12px;
}
.login-center .has-feedback.feedback-left .form-control-feedback {
    left: 0;
    right: auto;
    width: 38px;
    height: 38px;
    line-height: 38px;
    z-index: 4;
    color: #dcdcdc;
}
.login-center .has-feedback.feedback-left.row .form-control-feedback {
    left: 15px;
}
</style>
</head>
  
<body>
<div class="row lyear-wrapper">
  <div class="lyear-login">
    <div class="login-center">
      <div class="login-header text-center">
        <img alt="light year admin" class="img-avatar img-avatar-48 m-r-10" src="/photo/view?filename=${share.user.headPic}">
      	【${share.user.username}】给您私密分享了文件!
      </div>
      <form id="login-form" method="post">
        <div class="form-group has-feedback feedback-left row">
          <div class="col-xs-7">
            <input type="password" name="password" id="password" maxlength="4" class="form-control required" placeholder="请输入提取码" tips="请填写提取码" >
            <span class="mdi mdi-lock form-control-feedback" aria-hidden="true"></span>
          </div>
          <div class="col-xs-5">
            <button class="btn btn-block btn-primary" type="button" id="submit-btn">立即提取</button>
          </div>
        </div>
      </form>
      <hr>
      <footer class="col-sm-12 text-center">
        <p class="m-b-0">Copyright © 20XX. All right reserved</p>
      </footer>
    </div>
  </div>
</div>
<#include "../admin/common/footer.ftl"/>
<script type="text/javascript">
$(document).ready(function(){
	$("#submit-btn").click(function(){
		if(!checkForm("login-form")){
			return;
		}
		var password = $("#password").val();
		$.ajax({
			url:'/share/verify_pwd',
			type:'POST',
			data:{sn:'${share.sn}',password:password},
			dataType:'json',
			success:function(data){
				if(data.code == 0){
					window.location.reload();
				}else{
					showErrorMsg(data.msg);
				}
			},
			error:function(data){
				alert('网络错误!');
			}
		});
	});
});

</script>
</body>
</html>