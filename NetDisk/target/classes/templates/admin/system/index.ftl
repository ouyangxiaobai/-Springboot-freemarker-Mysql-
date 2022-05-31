<!DOCTYPE html>
<html lang="zh">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
<title>后台管理系统主页</title>
<#include "../common/header.ftl"/>

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
          <div class="col-sm-6 col-lg-3">
            <div class="card bg-primary">
              <div class="card-body clearfix">
                <div class="pull-right">
                  <p class="h6 text-white m-t-0">文件夹数</p>
                  <p class="h3 text-white m-b-0">${folderSize!"0"}</p>
                </div>
                <div class="pull-left"> <span class="img-avatar img-avatar-48 bg-translucent"><i class="mdi mdi-folder fa-1-5x"></i></span> </div>
              </div>
            </div>
          </div>
          
          <div class="col-sm-6 col-lg-3">
            <div class="card bg-danger">
              <div class="card-body clearfix">
                <div class="pull-right">
                  <p class="h6 text-white m-t-0">文件数</p>
                  <p class="h3 text-white m-b-0">${fileSize!"0"}</p>
                </div>
                <div class="pull-left"> <span class="img-avatar img-avatar-48 bg-translucent"><i class="mdi mdi-file fa-1-5x"></i></span> </div>
              </div>
            </div>
          </div>
          
          <div class="col-sm-6 col-lg-3">
            <div class="card bg-success">
              <div class="card-body clearfix">
                <div class="pull-right">
                  <p class="h6 text-white m-t-0">分享数</p>
                  <p class="h3 text-white m-b-0">${shareCount!"0"}</p>
                </div>
                <div class="pull-left"> <span class="img-avatar img-avatar-48 bg-translucent"><i class="mdi mdi-webhook fa-1-5x"></i></span> </div>
              </div>
            </div>
          </div>
          
          <div class="col-sm-6 col-lg-3">
            <div class="card bg-purple">
              <div class="card-body clearfix">
                <div class="pull-right">
                  <p class="h6 text-white m-t-0">存储空间</p>
                  <p class="h3 text-white m-b-0"><#if storageSize??>${storageSize/1024/1024/1024}<#else>0</#if>G/<font color="red" title="总共">${user.role.storageSize}</font>G</p>
                </div>
                <div class="pull-left"> <span class="img-avatar img-avatar-48 bg-translucent"><i class="mdi mdi-database fa-1-5x"></i></span> </div>
              </div>
            </div>
          </div>
        </div>

        <div class="row">
          
          <div class="col-lg-6"> 
            <div class="card">
              <div class="card-header">
                <h4>空间使用情况(单位：GB)</h4>
              </div>
              <div class="card-body" align="center">
                <canvas id="chart-pie" ></canvas>
              </div>
            </div>
          </div>
          
          <div class="col-lg-6"> 
            <div class="card">
              <div class="card-header">
                <h4>每日分享数</h4>
              </div>
              <div class="card-body">
                <canvas class="js-chartjs-lines"></canvas>
              </div>
            </div>
          </div>
           
        </div>
        <div class="row">
          
          <div class="col-lg-12"> 
            <div class="card">
              <div class="card-header">
                <h4>文件下载排行榜</h4>
              </div>
              <div class="card-body">
                <canvas class="js-chartjs-bars" id="chart-hbar-1"></canvas>
              </div>
            </div>
          </div>
        </div>
      </div>
      
    </main>
    <!--End 页面主要内容-->
  </div>
</div>
<#include "../common/footer.ftl"/>
<script type="text/javascript" src="/admin/js/perfect-scrollbar.min.js"></script>
<script type="text/javascript" src="/admin/js/main.min.js"></script>
<!--图表插件-->
<script type="text/javascript" src="/admin/js/Chart.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	var $dashChartBarsCnt  = jQuery( '.js-chartjs-bars' )[0].getContext( '2d' ),
        $dashChartLinesCnt = jQuery( '.js-chartjs-lines' )[0].getContext( '2d' );
    var $dashChartLinesData = {
		labels: [<#if shareStatsEncrpt??><#list shareStatsEncrpt as stats>'${stats[1]}',</#list></#if>],
		datasets: [
			{
				label: '私密分享数',
				data: [<#if shareStatsEncrpt??><#list shareStatsEncrpt as stats>'${stats[0]}',</#list></#if>],
				fill: false,
	            borderWidth: 3,
	            pointRadius: 4,
	            borderColor: "#36a2eb",
	            backgroundColor: "#36a2eb",
	            pointBackgroundColor: "#36a2eb",
	            pointBorderColor: "#36a2eb",
	            pointHoverBackgroundColor: "#fff",
	            pointHoverBorderColor: "#36a2eb",
			},
			{
				label: '公开分享数',
				data: [<#if shareStatsUnEncrpt??><#list shareStatsUnEncrpt as stats>'${stats[0]}',</#list></#if>],
				fill: false,
	            borderWidth: 3,
	            pointRadius: 4,
	            borderColor: "#ff6384",
	            backgroundColor: "#ff6384",
	            pointBackgroundColor: "#ff6384",
	            pointBorderColor: "#ff6384",
	            pointHoverBackgroundColor: "#fff",
	            pointHoverBorderColor: "#ff6384",
			}
		]
	};
    
    
    
    var myLineChart = new Chart($dashChartLinesCnt, {
        type: 'line',
        data: $dashChartLinesData,
    });
    
    new Chart($("#chart-pie"), {
	    type: 'pie',
	    data: {
	        labels: ["可用空间", "已用空间"],
	        datasets: [{
	            <#if storageSize??>
	            data: [${user.role.storageSize-storageSize/1024/1024/1024}, ${storageSize/1024/1024/1024}],
	            <#else>
	            data: [${user.role.storageSize}, 0],
	            </#if>
	            backgroundColor: ['rgba(54, 162, 235, 1)', 'rgba(255, 206, 86, 1)']
	        }]
	    }
	});
	
	new Chart($("#chart-hbar-1"), {
	    type: 'line',
	    data: {
	        labels: [<#if topFiles??><#list topFiles as topFile>'${topFile.originalName}.${topFile.suffix}',</#list></#if>],
	        datasets: [{
	            label: "文件下载排行榜前十",
	            backgroundColor: "rgba(51,202,185,0.5)",
	            borderColor: "rgba(0,0,0,0)",
	            hoverBackgroundColor: "rgba(51,202,185,0.7)",
	            hoverBorderColor: "rgba(0,0,0,0)",
	            data: [<#if topFiles??><#list topFiles as topFile>'${topFile.downloadTimes}',</#list></#if>]
	        }]
	    },
	    options: {
	        scales: {
	            xAxes: [{
	                ticks: {
	                    beginAtZero: true
	                }
	            }]
	        }
	    }
	});
});

</script>
</body>
</html>