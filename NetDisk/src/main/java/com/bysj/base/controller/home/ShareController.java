package com.bysj.base.controller.home;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bysj.base.bean.CodeMsg;
import com.bysj.base.bean.Result;
import com.bysj.base.constant.SessionConstant;
import com.bysj.base.entity.admin.File;
import com.bysj.base.entity.admin.Folder;
import com.bysj.base.entity.admin.Share;
import com.bysj.base.entity.admin.User;
import com.bysj.base.service.admin.FileService;
import com.bysj.base.service.admin.FolderService;
import com.bysj.base.service.admin.ShareService;
import com.bysj.base.util.SessionUtil;

/**
 * 前端控制器
 * @author llq
 *
 */
@RequestMapping("/share")
@Controller
public class ShareController {

	@Autowired
	private FolderService folderService;
	@Autowired
	private FileService fileService;
	@Autowired
	private ShareService shareService;

	private Logger log = LoggerFactory.getLogger(ShareController.class);
	
	/**
	 * 打开分享页面
	 * @param sn
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/sn/{sn}")
	public String list(@PathVariable("sn")String sn,Long folderId,Model model){
		Share share = shareService.find(sn);
		if(share == null){
			log.info("分享已删除！");
			model.addAttribute("msg", "啊哦，你来晚了，分享的文件已经被删除了，下次要早点哟。");
			return "home/error";
		}
		//防止定时任务没执行，再次检查是否过期
		if(share.getExpireTime() != 0){
			if(System.currentTimeMillis() - share.getCreateTime().getTime() > share.getExpireTime()){
				share.setStatus(Share.ADMIN_SHARE_STATUS_EXPIRED);
				shareService.save(share);
			}
		}
		//判断分享是否过期
		if(share.getStatus() == Share.ADMIN_SHARE_STATUS_EXPIRED){
			model.addAttribute("msg", "啊哦，你来晚了，分享的文件已经过期了，下次要早点哟。");
			return "home/error";
		}
		
		model.addAttribute("share", share);
		model.addAttribute("folderId", folderId);
		if(share.getShareType() == Share.ADMIN_SHARE_TYPE_ENCRPT){
			//加密分享，检查是否输入密码
			if(SessionUtil.get(SessionConstant.SESSION_USER_SHARE_KEY+share.getSn()) == null){
				//表示密码未输入或失效，跳转到输入密码的界面
				return "home/share_encrpt";
			}
			
		}
		if(folderId == null){
			model.addAttribute("folders", share.getFolders());
			model.addAttribute("files", share.getFiles());
		}else{
			//表示进入某个文件夹中了
			model.addAttribute("folders", folderService.findChildFolder(folderService.find(folderId), false));
			model.addAttribute("files", fileService.findByFolder(share.getUser(), folderService.find(folderId), false));
		}
		User user = (User)SessionUtil.get(SessionConstant.SESSION_USER_LOGIN_KEY);
		if(user != null){
			model.addAttribute("rootFolders",folderService.findAllRootFolder(user,false));
		}
		return "home/share";
	}
	
	/**
	 * 私密分享验证密码
	 * @return
	 */
	@RequestMapping(value="/verify_pwd",method=RequestMethod.POST)
	@ResponseBody
	public Result<Boolean> addFolder(@RequestParam(name="sn",required=true)String sn, @RequestParam(name="password",required=true)String password){
		Share share = shareService.find(sn);
		if(share == null){
			return Result.error(CodeMsg.DATA_ERROR);
		}
		if(!password.equals(share.getPassword())){
			return Result.error(CodeMsg.SHARE_PASSWORD_ERROR);
		}
		SessionUtil.set(SessionConstant.SESSION_USER_SHARE_KEY + sn,true);
		return Result.success(true);
	}
	
	/**
	 * 保存文件到网盘
	 * @param targetFolderId
	 * @param fileIds
	 * @param folderIds
	 * @return
	 */
	@RequestMapping(value="/save_file",method=RequestMethod.POST)
	@ResponseBody
	public Result<Boolean> saveFile(Long targetFolderId, String fileIds, String folderIds){
		Folder targetFolder = null;
		if(targetFolderId != null){
			targetFolder = new Folder();
			targetFolder.setId(targetFolderId);
		}
		User user = (User)SessionUtil.get(SessionConstant.SESSION_USER_LOGIN_KEY);
		if(!StringUtils.isEmpty(fileIds)){
			//处理文件
			String[] split = fileIds.split(",");
			for(String id : split){
				File file = fileService.find(Long.valueOf(id));
				File saveFile = new File();
				BeanUtils.copyProperties(file, saveFile, "id","user","folder");
				saveFile.setUser(user);
				saveFile.setFolder(targetFolder);
				fileService.save(saveFile);
			}
		}
		if(!StringUtils.isEmpty(folderIds)){
			//处理文件夹
			String[] split = folderIds.split(",");
			for(String id : split){
				//首先保存选中的目录至指定目录下
				Folder folder = folderService.find(Long.valueOf(id));
				Folder saveFolder = new Folder();
				BeanUtils.copyProperties(folder, saveFolder, "id","user","parent");
				saveFolder.setUser(user);
				saveFolder.setParent(targetFolder);
				saveFolder = folderService.save(saveFolder);
				//log.info(saveFolder.getName());
				//接下来将该文件夹下的文件保存过来
				List<File> findByFolder = fileService.findByFolder(folder.getUser(), folder, false);
				for(File file : findByFolder){
					File saveFile = new File();
					BeanUtils.copyProperties(file, saveFile, "id","user","folder");
					saveFile.setUser(user);
					saveFile.setFolder(saveFolder);
					fileService.save(saveFile);
				}
				//最后去递归获取改目录下的子目录
				getChilderFolder(folder, saveFolder, user);
			}
		}
		return Result.success(true);
	}
	
	private void getChilderFolder(Folder parent,Folder targetFolder,User user){
		List<Folder> childFolder = folderService.findChildFolder(parent, false);
		if(childFolder == null || childFolder.size() == 0)return;
		for(Folder f : childFolder){
			//首先将这些子目录保存过来
			Folder saveFolder = new Folder();
			BeanUtils.copyProperties(f, saveFolder, "id","user","parent");
			saveFolder.setUser(user);
			saveFolder.setParent(targetFolder);
			saveFolder = folderService.save(saveFolder);
			//接下来将该文件夹下的文件保存过来
			List<File> findByFolder = fileService.findByFolder(f.getUser(), f, false);
			for(File file : findByFolder){
				File saveFile = new File();
				BeanUtils.copyProperties(file, saveFile, "id","user","folder");
				saveFile.setUser(user);
				saveFile.setFolder(saveFolder);
				fileService.save(saveFile);
			}
			//最后去递归获取子目录
			getChilderFolder(f, saveFolder, user);
		}
	}
}
