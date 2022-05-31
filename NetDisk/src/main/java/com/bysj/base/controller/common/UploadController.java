package com.bysj.base.controller.common;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.codec.digest.DigestUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.bysj.base.bean.CodeMsg;
import com.bysj.base.bean.Result;
import com.bysj.base.constant.SessionConstant;
import com.bysj.base.entity.admin.User;
import com.bysj.base.service.admin.FileService;
import com.bysj.base.util.SessionUtil;
import com.bysj.base.util.StringUtil;

/**
 * 公用的上传类
 * @author Administrator
 *
 */
@RequestMapping("/upload")
@Controller
public class UploadController {

	@Value("${bysj.upload.photo.sufix}")
	private String uploadPhotoSufix;
	
	@Value("${bysj.upload.photo.maxsize}")
	private long uploadPhotoMaxSize;
	
	@Value("${bysj.upload.photo.path}")
	private String uploadPhotoPath;//图片文件保存位置
	
	@Value("${bysj.upload.file.maxsize}")
	private long uploadFileMaxSize;
	
	@Value("${bysj.upload.file.path}")
	private String uploadFilePath;//文件保存位置
	
	@Autowired
	private FileService fileService;
	
	private Logger log = LoggerFactory.getLogger(UploadController.class);
	
	/**
	 * 图片统一上传类
	 * @param photo
	 * @return
	 */
	@RequestMapping(value="/upload_photo",method=RequestMethod.POST)
	@ResponseBody
	public Result<String> uploadPhoto(@RequestParam(name="photo",required=true)MultipartFile photo){
		//判断文件类型是否是图片
		String originalFilename = photo.getOriginalFilename();
		//获取文件后缀
		String suffix = originalFilename.substring(originalFilename.lastIndexOf("."),originalFilename.length());
		if(!uploadPhotoSufix.contains(suffix.toLowerCase())){
			return Result.error(CodeMsg.UPLOAD_PHOTO_SUFFIX_ERROR);
		}
		if(photo.getSize()/1024 > uploadPhotoMaxSize){
			CodeMsg codeMsg = CodeMsg.UPLOAD_PHOTO_ERROR;
			codeMsg.setMsg("图片大小不能超过" + (uploadPhotoMaxSize/1024) + "M");
			return Result.error(codeMsg);
		}
		//准备保存文件
		File filePath = new File(uploadPhotoPath);
		if(!filePath.exists()){
			//若不存在文件夹，则创建一个文件夹
			filePath.mkdir();
		}
		filePath = new File(uploadPhotoPath + "/" + StringUtil.getFormatterDate(new Date(), "yyyyMMdd"));
		//判断当天日期的文件夹是否存在，若不存在，则创建
		if(!filePath.exists()){
			//若不存在文件夹，则创建一个文件夹
			filePath.mkdir();
		}
		String filename = StringUtil.getFormatterDate(new Date(), "yyyyMMdd") + "/" + System.currentTimeMillis() + suffix;
		try {
			photo.transferTo(new File(uploadPhotoPath+"/"+filename));
		} catch (IllegalStateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		log.info("图片上传成功，保存位置：" + uploadPhotoPath + filename);
		return Result.success(filename);
	}
	
	/**
	 * 文件统一上传类
	 * @param file
	 * @return
	 */
	@RequestMapping(value="/upload_file",method=RequestMethod.POST)
	@ResponseBody
	public Result<Map<String, String>> uploadFile(@RequestParam(name="file",required=true)MultipartFile file){
		//获取文件原始名称
		String originalFilename = file.getOriginalFilename();
		//获取文件后缀
		String suffix = originalFilename.substring(originalFilename.lastIndexOf("."),originalFilename.length());
		
		if(file.getSize()/1024 > uploadFileMaxSize){
			CodeMsg codeMsg = CodeMsg.UPLOAD_PHOTO_ERROR;
			codeMsg.setMsg("文件大小不能超过" + (uploadFileMaxSize/1024) + "M");
			return Result.error(codeMsg);
		}
		//检查用户空间是否够用
		User user = (User)SessionUtil.get(SessionConstant.SESSION_USER_LOGIN_KEY);
		if(user.getRole().getStorageSize()*1024*1024*1024 < file.getSize()){
			CodeMsg codeMsg = CodeMsg.UPLOAD_PHOTO_ERROR;
			codeMsg.setMsg("空间大小不足，请升级用户等级！");
			return Result.error(codeMsg);
		}
		Long storageSize = fileService.getStorageSize(user);
		if(storageSize == null){
			storageSize = 0l;
		}
		long used = (storageSize + file.getSize());
		long total =  user.getRole().getStorageSize()*1024*1024*1024;
		if(used> total){
			CodeMsg codeMsg = CodeMsg.UPLOAD_PHOTO_ERROR;
			codeMsg.setMsg("空间大小不足，请升级用户等级！");
			return Result.error(codeMsg);
		}
		//准备保存文件
		File filePath = new File(uploadFilePath);
		if(!filePath.exists()){
			//若不存在文件夹，则创建一个文件夹
			filePath.mkdir();
		}
		filePath = new File(uploadFilePath + "/" + StringUtil.getFormatterDate(new Date(), "yyyyMMdd"));
		//判断当天日期的文件夹是否存在，若不存在，则创建
		if(!filePath.exists()){
			//若不存在文件夹，则创建一个文件夹
			filePath.mkdir();
		}
		String md5Hex = null;
		try {
			//计算文件的md5值
			md5Hex = DigestUtils.md5Hex(file.getInputStream());
			log.info("md5hex:"+md5Hex);
			//根据md5查找文件是否已经存在
			List<com.bysj.base.entity.admin.File> findByMd5 = fileService.findByMd5(md5Hex);
			if(findByMd5 != null && findByMd5.size() >0){
				//表示该文件已经被上传过
				log.info("该文件已经被上传过，添加引用，源文件md5:"+md5Hex);
				Map<String, String> ret = new HashMap<String, String>();
				ret.put("fileSize", file.getSize()+"");
				ret.put("filename", findByMd5.get(0).getName());
				ret.put("contentType", findByMd5.get(0).getContentType());
				ret.put("md5", md5Hex);
				return Result.success(ret);
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		String filename = StringUtil.getFormatterDate(new Date(), "yyyyMMdd") + "/" + System.currentTimeMillis() + suffix;
		try {
			file.transferTo(new File(uploadFilePath+"/"+filename));
		} catch (IllegalStateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		log.info("文件上传成功，保存位置：" + uploadFilePath + filename);
		Map<String, String> ret = new HashMap<String, String>();
		ret.put("fileSize", file.getSize()+"");
		ret.put("filename", filename);
		ret.put("md5", md5Hex);
		ret.put("contentType", file.getContentType());
		return Result.success(ret);
	}
}
