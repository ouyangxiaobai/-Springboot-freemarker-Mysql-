//显示成功信息
function showSuccessMsg(msg,callback){
	$.confirm({
        title: '成功',
        content: msg,
        type: 'green',
        typeAnimated: false,
        buttons: {
            omg: {
                text: '确定！',
                btnClass: 'btn-green',
                action: function(){
                	callback();
        		}
            }
        }
    });
}
//显示错误信息
function showErrorMsg(msg){
	$.confirm({
        title: '错误',
        content: msg,
        type: 'red',
        typeAnimated: false,
        buttons: {
            omg: {
                text: '知道了！',
                btnClass: 'btn-red',
                action: function(){
                	
        		}
            }
        }
    });
}
//显示警告信息
function showWarningMsg(msg){
	$.confirm({
        title: '警告',
        content: msg,
        type: 'red',
        typeAnimated: false,
        buttons: {
            omg: {
                text: '知道了！',
                btnClass: 'btn-red',
                action: function(){
                	
        		}
            }
        }
    });
}
//显示确认信息
function showConfimMsg(msg,callbackOk,callbackNo){
	 $.alert({
	        title: '确认框',
	        content: msg,
			buttons: {
				confirm: {
					text: '确认',
					btnClass: 'btn-primary',
					action: function(){
						callbackOk();
					}
				},
				cancel: {
					text: '取消',
					action: function () {
						callbackNo();
					}
				}
			}
	    });
}
//显示确认信息
function showTipsMsg(title,content,callbackOk){
	 $.alert({
	        title: title,
	        content: content,
			buttons: {
				confirm: {
					text: '确认',
					btnClass: 'btn-primary',
					action: function(){
						callbackOk();
					}
				}
			}
	    });
}
//表单验证公用方法，传表单form的id进来即可
function checkForm(formId){
	var flag = true;
	$("#"+formId).find(".required").each(function(i,e){
		if($(e).val() == ''){
			showWarningMsg($(e).attr('tips'));
			flag = false;
			return false;
		}
	});
	return flag;
}
//统一图片上传方法
function upload(showPictureImg,input){
	//formdata
	var formData = new FormData();
	formData.append('photo',document.getElementById('select-file').files[0]);
	$.ajax({
		url:'/upload/upload_photo',
		contentType:false,
		processData:false,
		data:formData,
		type:'POST',
		success:function(data){
				if(data.code == 0){
					showSuccessMsg('图片上传成功!',function(){
						$("#"+showPictureImg).attr('src','/photo/view?filename=' + data.data);
						$("#"+input).val(data.data);
					})
				}else{
					data = $.parseJSON(data);
					showErrorMsg(data.msg);
				}
			},
			error:function(data){
				alert('网络错误!');
			}
	});
}
var xhr=new XMLHttpRequest(); xhr.upload.onprogress=function(e){}
var xhrOnProgress=function(fun) {
	xhrOnProgress.onprogress = fun; //绑定监听
	//使用闭包实现监听绑
	return function() {
		//通过$.ajaxSettings.xhr();获得XMLHttpRequest对象
		var xhr = $.ajaxSettings.xhr();
		//判断监听函数是否为函数
		if (typeof xhrOnProgress.onprogress !== 'function')
			return xhr;
		//如果有监听函数并且xhr对象支持绑定时就把监听函数绑定上去
		if (xhrOnProgress.onprogress && xhr.upload) {
			xhr.upload.onprogress = xhrOnProgress.onprogress;
		}
		return xhr;
	}
}
//统一文件上传方法
function uploadingFile(fileInputId,callBack){
	//formdata
	var formData = new FormData();
	formData.append('file',document.getElementById(fileInputId).files[0]);
	$.ajax({
		url:'/upload/upload_file',
		contentType:false,
		processData:false,
		data:formData,
		type:'POST',
		success:function(data){
			callBack(data);
		},
		xhr:xhrOnProgress(function(e){
			console.log(e);
			var loaded = e.loaded;
			var total = e.total;
			var per = loaded / total * 100;
			per = per.toFixed(2);
			$("#show-progress").attr('aria-valuenow',per);
			$("#show-progress").css({'width':per + '%'})
			$("#show-progress").text(per + '%')
		}),
		error:function(data){
			alert('网络错误!');
			console.log(data);
		}
	});
}
/**
 *    侦查附件上传情况,这个方法大概0.05-0.1秒执行一次
 */
function progressBar(evt) {
    var loaded = evt.loaded; //已经上传大小情况
    var tot = evt.total; //附件总大小
    var per = Math.floor(100 * loaded / tot); //已经上传的百分比
    //这里可以绘制进度条
    console.log(loaded+'--'+tot+'--'+per);
}
//统一ajax请求
function ajaxRequest(url,requestType,data,callback){
	$.ajax({
		url:url,
		type:requestType,
		data:data,
		dataType:'json',
		success:function(rst){
			if(rst.code == 0){
				callback(rst);
			}else{
				showErrorMsg(rst.msg);
			}
		},
		error:function(data){
			alert('网络错误!');
		}
	});
}
$(document).ready(function(){
	$("#order-auth-btn").click(function(){
		$.confirm({
	        title: '订单验证提示',
	        content: '' +
	        '<form action="" class="formName">' +
	        '<div class="form-group">' +
	        '<input type="text" placeholder="请输入订单编号" class="orderSn form-control" required maxlength="18" /><br/>' +
	        '<input type="text" placeholder="请输入订单手机号" class="phone form-control" maxlength="11" required />' +
	        '</div>' +
	        '</form>',
	        buttons: {
	            formSubmit: {
	                text: '提交',
	                btnClass: 'btn-blue',
	                action: function () {
	                    var orderSn = this.$content.find('.orderSn').val();
	                    if(!orderSn){
	                        $.alert('请您输入订单编号');
	                        return false;
	                    }
	                    var phone = this.$content.find('.phone').val();
	                    if(!phone){
	                    	$.alert('请您输入订单手机号');
	                    	return false;
	                    }
	                    ajaxRequest('/system/auth_order','post',{orderSn:orderSn,phone:phone},function(){
	                    	showSuccessMsg('验证成功！',function(){});
	                    	window.location.reload();
	                    });
	                    return false;
	                }
	            },
	            cancel: {
	                text: '取消'
	            },
	        },
	        onContentReady: function () {
	            var jc = this;
	            this.$content.find('form').on('submit', function (e) {
	                e.preventDefault();
	                jc.$$formSubmit.trigger('click');
	            });
	        }
	    });
	});
	
});