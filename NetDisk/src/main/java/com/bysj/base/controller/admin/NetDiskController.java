package com.bysj.base.controller.admin;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.apache.commons.lang3.StringUtils;
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
import com.bysj.base.bean.PageBean;
import com.bysj.base.bean.Result;
import com.bysj.base.constant.SessionConstant;
import com.bysj.base.entity.admin.File;
import com.bysj.base.entity.admin.Folder;
import com.bysj.base.entity.admin.Share;
import com.bysj.base.entity.admin.User;
import com.bysj.base.service.admin.FileService;
import com.bysj.base.service.admin.FolderService;
import com.bysj.base.service.admin.MenuService;
import com.bysj.base.service.admin.OperaterLogService;
import com.bysj.base.service.admin.ShareService;
import com.bysj.base.util.CpachaUtil;
import com.bysj.base.util.FileTypeUtil;
import com.bysj.base.util.SessionUtil;
import com.bysj.base.util.ValidateEntityUtil;
/**
 * 后台文件管理控制器
 * @author Administrator
 *
 */
@RequestMapping("/net_disk")
@Controller
public class NetDiskController {

	@Autowired
	private MenuService menuService;
	@Autowired
	private FolderService folderService;
	@Autowired
	private FileService fileService;

	@Autowired
	private OperaterLogService operaterLogService;
	@Autowired
	private ShareService shareService;
	@Value("${bysj.upload.file.path}")
	private String uploadFilePath;//文件保存位置
	/**
	 * 全部文件列表展示页面
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/list")
	public String list(Long folderId,Model model){
		User user = (User)SessionUtil.get(SessionConstant.SESSION_USER_LOGIN_KEY);
		List<Folder> folderList = null;
		List<File> fileList = null;
		//说明是根目录
		if(folderId == null){
			folderList = folderService.findAllRootFolder(user,false);
			fileList = fileService.findAllRootFile(user,false);
		}else {
			//说明不是根目录
			Folder folder = folderService.find(folderId);
			folderList = folderService.findByFolder(user, folder,false);
			fileList = fileService.findByFolder(user, folder,false);
		}
		model.addAttribute("title","文件列表");
		model.addAttribute("folderList",folderList);
		model.addAttribute("fileList",fileList);
		model.addAttribute("folderId",folderId);
		model.addAttribute("rootFolders",folderService.findAllRootFolder(user,false));
		return "admin/net_disk/list";
	}
	
	/**
	 * 按照文件类型搜索文件
	 * @param type
	 * @param model
	 * @return
	 */
	@RequestMapping(value={"/doc_list/{type}","/music_list/{type}","/image_list/{type}","/video_list/{type}","/zip_list/{type}","/other_list/{type}"})
	public String typeList(@PathVariable("type")String type,Model model){
		User user = (User)SessionUtil.get(SessionConstant.SESSION_USER_LOGIN_KEY);
		model.addAttribute("title",type+"类型文件列表");
		if(type == null){
			model.addAttribute("fileList",fileService.findByFileType(user, FileTypeUtil.getFileSuffix(""), false));
			return "admin/net_disk/type_list";
		}
		model.addAttribute("fileList",fileService.findByFileType(user, FileTypeUtil.getFileSuffix(type), true));
		return "admin/net_disk/type_list";
	}
	
	/**
	 * 文件夹添加页面
	 * @return
	 */
	@RequestMapping(value="/add_folder",method=RequestMethod.POST)
	@ResponseBody
	public Result<Boolean> addFolder(Folder folder){
		CodeMsg validate = ValidateEntityUtil.validate(folder);
		if(validate.getCode() != CodeMsg.SUCCESS.getCode()){
			return Result.error(validate);
		}
		User user = (User)SessionUtil.get(SessionConstant.SESSION_USER_LOGIN_KEY);
		folder.setUser(user);
		if(folderService.save(folder) == null){
			return Result.error(CodeMsg.ADD_ERROR);
		}
		return Result.success(true);
	}
	
	/**
	 * 重命名
	 * @param name
	 * @param id
	 * @param isFile
	 * @return
	 */
	@RequestMapping(value="/rename_file",method=RequestMethod.POST)
	@ResponseBody
	public Result<Boolean> renameFile(String name,Long id,Boolean isFile){
		if(StringUtils.isEmpty(name)){
			return Result.error(CodeMsg.DATA_ERROR);
		}
		if(isFile){
			//若是文件
			File file = fileService.find(id);
			if(file == null){
				return Result.error(CodeMsg.ADMIN_FILE_NO_EXIST);
			}
			file.setOriginalName(name);
			if(fileService.save(file) == null){
				return Result.error(CodeMsg.EDIT_ERROR);
			}
			return Result.success(true);
		}
		Folder folder = folderService.find(id);
		if(folder == null){
			return Result.error(CodeMsg.ADMIN_FOLDER_NO_EXIST);
		}
		folder.setName(name);
		if(folderService.save(folder) == null){
			return Result.error(CodeMsg.EDIT_ERROR);
		}
		return Result.success(true);
	}
	
	/**
	 * 文件添加提交表单处理
	 * @return
	 */
	@RequestMapping(value="/upload_file",method=RequestMethod.POST)
	@ResponseBody
	public Result<Boolean> add(File file){
		if(file == null){
			Result.error(CodeMsg.DATA_ERROR);
		}
		//用统一验证实体方法验证是否合法
		CodeMsg validate = ValidateEntityUtil.validate(file);
		if(validate.getCode() != CodeMsg.SUCCESS.getCode()){
			return Result.error(validate);
		}
		if(file.getFolder() != null){
			if(file.getFolder().getId() == null){
				file.setFolder(null);
			}
		}
		//表示验证都通过，开始添加数据库
		User user = (User)SessionUtil.get(SessionConstant.SESSION_USER_LOGIN_KEY);
		file.setUser(user);
		if(fileService.save(file) == null){
			Result.error(CodeMsg.ADD_ERROR);
		}
		//数据库添加操作成功,记录日志
		operaterLogService.add("添加文件信息【" + file.getOriginalName() + "】");
		return Result.success(true);
	}
	
	/**
	 * 获取文件夹下子文件夹页面
	 * @param model
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/get_folder")
	@ResponseBody
	public String getFolder(Model model,@RequestParam(name="id",required=true)Long id){
		Folder folder = folderService.find(id);
		if(folder == null){
			return "id error";
		}
		List<Folder> findChildFolder = folderService.findChildFolder(folder,false);
		if(findChildFolder == null || findChildFolder.size() == 0){
			return "该文件夹下无子文件夹";
		}
		String retString = "";
		for(Folder f: findChildFolder){
			String html = "<div class=\"pathidcompare\" pathId=\"" + f.getId() + "\">";
			html += "<div class=\"box-header no-padding\">";
			html += "<span class=\"btn btn-default btn-xs des mm\">"; 
			html += "<i class=\"mdi mdi-plus\"></i>";
			html += "</span><span class=\"openpath modalajax\"><img class=\"mcfloorimg\" src=\"/admin/images/fileimg/Folder.png\" />";
			html += "<h3 class=\"box-title\" style=\"font-size:12px;\">" + f.getName() + "</h3>";
			html += "<input class=\"mctopathid\" type=\"hidden\" value=\"" + f.getId() + "\" /></span></div>";
			html += "<ul class=\"nav nav-pills nav-stacked mm modalajaxdata\" style=\"padding-left:15px;display:none;\"></ul></div>";		
			retString += html;
		}
		return retString;
	}
	
	/**
	 * 文件编辑页面表单提交处理
	 * @return
	 */
	@RequestMapping(value="/mc_file",method=RequestMethod.POST)
	@ResponseBody
	public Result<Boolean> mcFile(Long targetFolderId,String fileIds,String folderIds,Boolean isMove){
		Folder targetFolder = folderService.find(targetFolderId);
		if(isMove){
			if(!StringUtils.isEmpty(fileIds)){
				//文件id不为空
				String[] split = fileIds.split(",");
				for(String id : split){
					moveFile(targetFolder, Long.valueOf(id), true);
				}
			}
			if(!StringUtils.isEmpty(folderIds)){
				//文件id不为空
				String[] split = folderIds.split(",");
				for(String id : split){
					moveFile(targetFolder, Long.valueOf(id), false);
				}
			}
			return Result.success(true);
		}
		//表示是复制文件
		if(!StringUtils.isEmpty(fileIds)){
			//文件id不为空
			String[] split = fileIds.split(",");
			for(String id : split){
				copyFile(targetFolder, Long.valueOf(id), true);
			}
		}
		if(!StringUtils.isEmpty(folderIds)){
			//文件id不为空
			String[] split = folderIds.split(",");
			for(String id : split){
				copyFile(targetFolder, Long.valueOf(id), false);
			}
		}
		return Result.success(true);
	}
	
	private void moveFile(Folder tarFolder,Long id,Boolean isFile){
		if(isFile){
			//移动文件
			File file = fileService.find(id);
			file.setFolder(tarFolder);
			fileService.save(file);
			return;
		}
		Folder folder = folderService.find(id);
		folder.setParent(tarFolder);
		folderService.save(folder);
	}
	
	private void copyFile(Folder tarFolder,Long id,Boolean isFile){
		if(isFile){
			//若是文件
			File file = fileService.find(id);
			File target = new File();
			BeanUtils.copyProperties(file, target,"id","createTime","updateTime");
			target.setFolder(tarFolder);
			fileService.save(target);
			return ;
		}
		Folder folder = folderService.find(id);
		Folder target = new Folder();
		BeanUtils.copyProperties(folder, target, "id","createTime","updateTime");
		target.setParent(tarFolder);
		folderService.save(target);
	}
	
	/**
	 * 删除文件信息
	 * @return
	 */
	@RequestMapping(value="/delete",method=RequestMethod.POST)
	@ResponseBody
	public Result<Boolean> delete(String folderIds,String fileIds){
		if(!StringUtils.isEmpty(folderIds)){
			String[] split = folderIds.split(",");
			List<Long> ids = new ArrayList<Long>();
			for(String id : split){
				Folder folder = folderService.find(Long.valueOf(id));
				ids.add(folder.getId());
				folder.setIsTrash(true);
				folderService.save(folder);
				getAllChildrenIds(folder, ids);
			}
			System.out.println(ids);
			//批量删除这些文件夹下的所有文件
			fileService.batchUpdateFileStatus(true, ids);
			//批量删除文件夹及子文件夹
			folderService.batchUpdateFolderStatus(true, ids);
		}
		if(!StringUtils.isEmpty(fileIds)){
			String[] split = fileIds.split(",");
			for(String id : split){
				File file = fileService.find(Long.valueOf(id));
				file.setIsTrash(true);
				fileService.save(file);
			}
		}
		return Result.success(true);
	}
	
	/**
	 * 从回收站还原文件
	 * @param folderIds
	 * @param fileIds
	 * @return
	 */
	@RequestMapping(value="/restore_file",method=RequestMethod.POST)
	@ResponseBody
	public Result<Boolean> restoreFile(String folderIds,String fileIds){
		if(!StringUtils.isEmpty(folderIds)){
			String[] split = folderIds.split(",");
			List<Long> ids = new ArrayList<Long>();
			for(String id : split){
				Folder folder = folderService.find(Long.valueOf(id));
				ids.add(folder.getId());
				folder.setIsTrash(false);
				folderService.save(folder);
				getAllChildrenIds(folder, ids);
			}
			System.out.println(ids);
			//批量恢复这些文件夹下的所有文件
			fileService.batchUpdateFileStatus(false, ids);
			//批量恢复文件夹及子文件夹
			folderService.batchUpdateFolderStatus(false, ids);
		}
		if(!StringUtils.isEmpty(fileIds)){
			String[] split = fileIds.split(",");
			for(String id : split){
				File file = fileService.find(Long.valueOf(id));
				file.setIsTrash(false);
				fileService.save(file);
			}
		}
		return Result.success(true);
	}
	
	/**
	 * 递归获取目录下的所有子目录
	 * @param folder
	 * @param ids
	 */
	private void getAllChildrenIds(Folder folder,List<Long> ids){
		List<Folder> findChildFolder = folderService.findChildFolder(folder, false);
		if(findChildFolder == null || findChildFolder.size() == 0)return;
		for(Folder f : findChildFolder){
			ids.add(f.getId());
			getAllChildrenIds(f,ids);
		}
	}
	
	/**
	 * 回收站页面
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/rubbish_list")
	public String rubbishList(Model model){
		User user = (User)SessionUtil.get(SessionConstant.SESSION_USER_LOGIN_KEY);
		model.addAttribute("title","回收站文件列表");
		model.addAttribute("folderList",folderService.findByUserAndIsTrash(user,true));
		model.addAttribute("fileList",fileService.findByUserAndIsTrash(user,true));
		return "admin/net_disk/rubbish_list";
	}
	
	/**
	 * 分享文件
	 * @param share
	 * @param folderIds
	 * @param fileIds
	 * @return
	 */
	@RequestMapping(value="/share_file",method=RequestMethod.POST)
	@ResponseBody
	public Result<Share> shareFile(Share share,String folderIds,String fileIds){
		String title = "共";
		if(!StringUtils.isEmpty(folderIds)){
			String[] split = folderIds.split(",");
			List<Folder> folders = new ArrayList<Folder>();
			for(String id : split){
				Folder folder = folderService.find(Long.valueOf(id));
				folders.add(folder);
			}
			share.setFolders(folders);
			title += split.length + "个文件夹";
		}
		if(!StringUtils.isEmpty(fileIds)){
			String[] split = fileIds.split(",");
			List<File> files = new ArrayList<File>();
			for(String id : split){
				File file = fileService.find(Long.valueOf(id));
				files.add(file);
				//分享次数加1
				file.setShareTimes(file.getShareTimes()+1);
				fileService.save(file);
			}
			share.setFiles(files);
			title += "," + split.length + "个文件！";
		}
		//设置分享sn
		share.setSn(UUID.randomUUID().toString());
		if(share.getShareType() == Share.ADMIN_SHARE_TYPE_ENCRPT){
			//表示需要加密，生成密码
			share.setPassword(new CpachaUtil(4).generatorVCode());
		}
		share.setTitle(title);
		User user = (User)SessionUtil.get(SessionConstant.SESSION_USER_LOGIN_KEY);
		share.setUser(user);
		shareService.save(share);
		return Result.success(share);
	}
	
	/**
	 * 我的分享列表页面
	 * @param pageBean
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/share_list")
	public String shareList(PageBean<Share>pageBean,Model model){
		User user = (User)SessionUtil.get(SessionConstant.SESSION_USER_LOGIN_KEY);
		model.addAttribute("title","我的分享列表");
		model.addAttribute("pageBean",shareService.findPage(user, pageBean));
		return "admin/net_disk/share_list";
	}
	
	/**
	 * 批量取消分享
	 * @param ids
	 * @return
	 */
	@RequestMapping(value="/cancel_share",method=RequestMethod.POST)
	@ResponseBody
	public Result<Boolean> cancelShare(String ids){
		if(!StringUtils.isEmpty(ids)){
			String[] split = ids.split(",");
			for(String id : split){
				Share share = shareService.find(Long.valueOf(id));
				share.setStatus(Share.ADMIN_SHARE_STATUS_CANCEL);
				shareService.save(share);
			}
		}
		
		return Result.success(true);
	}
	
	/**
	 * 批量删除
	 * @param ids
	 * @return
	 */
	@RequestMapping(value="/del_share",method=RequestMethod.POST)
	@ResponseBody
	public Result<Boolean> deleteShare(String ids){
		if(!StringUtils.isEmpty(ids)){
			String[] split = ids.split(",");
			for(String id : split){
				shareService.delete(Long.valueOf(id));
			}
		}
		
		return Result.success(true);
	}
	
	/**
	 * 彻底删除文件
	 * @param folderId
	 * @param fileId
	 * @return
	 */
	@RequestMapping(value="/force_delete",method=RequestMethod.POST)
	@ResponseBody
	public Result<Boolean> forceDelete(String folderId,String fileId){
		if(!StringUtils.isEmpty(folderId)){
			try {
				folderService.delete(Long.valueOf(folderId));
			} catch (Exception e) {
				return Result.error(CodeMsg.ADMIN_FOLDER_DELETE_ERROR);
			}
		}
		if(!StringUtils.isEmpty(fileId)){
			try {
				File file = fileService.find(Long.valueOf(fileId));
				fileService.delete(Long.valueOf(fileId));
				List<File> findByMd5 = fileService.findByMd5(file.getMd5());
				if(findByMd5 != null && findByMd5.size() < 1){
					//说明没有同类映射文件，可删除磁盘文件
					String filename = uploadFilePath + file.getName();
					try {
						new java.io.File(filename).delete();
					} catch (Exception e) {
						return Result.error(CodeMsg.ADMIN_FILE_DISK_DELETE_ERROR);
					}
				}
				
			} catch (Exception e) {
				return Result.error(CodeMsg.ADMIN_FILE_DELETE_ERROR);
			}
		}
		return Result.success(true);
	}
}
