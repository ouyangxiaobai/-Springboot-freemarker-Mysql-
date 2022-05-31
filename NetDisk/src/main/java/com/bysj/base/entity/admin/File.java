package com.bysj.base.entity.admin;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EntityListeners;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import com.bysj.base.annotion.ValidateEntity;

/**
 * 后台文件实体类
 * @author Administrator
 *
 */
@Entity
@Table(name="bysj_file")
@EntityListeners(AuditingEntityListener.class)
public class File extends BaseEntity{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@ManyToOne
	@JoinColumn(name="user_id")
	private User user;//所属用户
	
	
	@ValidateEntity(required=true,requiredLeng=true,minLength=1,maxLength=128,errorRequiredMsg="文件名称不能为空!",errorMinLengthMsg="文件名称长度需大于1!",errorMaxLengthMsg="文件名称长度不能大于128!")
	@Column(name="name",nullable=false,length=128)
	private String name;//文件名称
	
	@Column(name="original_name",nullable=false,length=128)
	private String originalName;//原始文件名称
	
	@ManyToOne
	@JoinColumn(name="folder_id")
	private Folder folder;//文件所属文件夹
	
	@ValidateEntity(required=false)
	@Column(name="path",length=512)
	private String path;//文件路径
	
	@ValidateEntity(required=false)
	@Column(name="content_type",length=512)
	private String contentType;//文件类型
	
	@ValidateEntity(required=false)
	@Column(name="suffix",length=12)
	private String suffix;//文件后缀
	
	
	@ValidateEntity(required=false)
	@Column(name="size",length=12)
	private Long size;//文件大小

	@Column(name="is_trash")
	private Boolean isTrash = false;//是否放入回收站
	
	@Column(name="md5",length=128)
	private String md5;//文件md5值
	
	@Column(name="down_times",length=12)
	private Integer downloadTimes = 0;//文件下载次数
	
	@Column(name="share_times",length=12)
	private Integer shareTimes = 0;//文件分享次数
	
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Folder getFolder() {
		return folder;
	}

	public void setFolder(Folder folder) {
		this.folder = folder;
	}

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public String getContentType() {
		return contentType;
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

	public String getSuffix() {
		return suffix;
	}

	public void setSuffix(String suffix) {
		this.suffix = suffix;
	}

	public Long getSize() {
		return size;
	}

	public void setSize(Long size) {
		this.size = size;
	}

	public Boolean getIsTrash() {
		return isTrash;
	}

	public void setIsTrash(Boolean isTrash) {
		this.isTrash = isTrash;
	}

	public String getOriginalName() {
		return originalName;
	}

	public void setOriginalName(String originalName) {
		this.originalName = originalName;
	}

	public String getMd5() {
		return md5;
	}

	public void setMd5(String md5) {
		this.md5 = md5;
	}

	public Integer getDownloadTimes() {
		return downloadTimes;
	}

	public void setDownloadTimes(Integer downloadTimes) {
		this.downloadTimes = downloadTimes;
	}

	public Integer getShareTimes() {
		return shareTimes;
	}

	public void setShareTimes(Integer shareTimes) {
		this.shareTimes = shareTimes;
	}

	@Override
	public String toString() {
		return "File [user=" + user + ", name=" + name + ", originalName="
				+ originalName + ", folder=" + folder + ", path=" + path
				+ ", contentType=" + contentType + ", suffix=" + suffix
				+ ", size=" + size + ", isTrash=" + isTrash + ", md5=" + md5
				+ ", downloadTimes=" + downloadTimes + ", shareTimes="
				+ shareTimes + "]";
	}

	
	
	
}
