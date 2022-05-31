package com.bysj.base.controller.common;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.IOException;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.bysj.base.entity.admin.File;
import com.bysj.base.service.admin.FileService;

/**
 * 下载控制器统一管理类
 * @author llq
 *
 */
@RequestMapping("/download")
@Controller
public class DownloadController {

	@Autowired
	private FileService fileService;
	
	@Value("${bysj.upload.file.path}")
	private String uploadFilePath;//文件保存位置
	
	/**
	 * 统一文件下载方法
	 * @param fid
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/download_file")
	public void downloadFile(Long fid,HttpServletRequest request,HttpServletResponse response){
		if(fid != null){
			File file = fileService.find(fid);
			if(file != null){
				response.setContentLength(file.getSize().intValue());
				response.setContentType(file.getContentType());
				try {
					response.setHeader("Content-Disposition","attachment;filename=" + new String(file.getOriginalName().getBytes("UTF-8"), "ISO8859-1")+"."+file.getSuffix());
					writefile(response, new java.io.File(uploadFilePath+file.getName()));
				} catch (Exception e) {
					e.printStackTrace();
				}
				//下载次数+1
				file.setDownloadTimes(file.getDownloadTimes()+1);
				fileService.save(file);
			}
		}
	}
	
	
	/**
	 * 写文件 方法
	 * 
	 * @param response
	 * @param file
	 * @throws IOException 
	 */
	public void writefile(HttpServletResponse response, java.io.File file) {
		byte[] buff = new byte[1024];
		FileInputStream fis = null;
		BufferedInputStream bis = null;
		try {
			fis = new FileInputStream(file);
			bis = new BufferedInputStream(fis);
			ServletOutputStream outputStream = response.getOutputStream();
			int i = bis.read(buff);
			while(i != -1){
				outputStream.write(buff, 0, i);
				i = bis.read(buff);
			}
			bis.close();
			fis.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
}
