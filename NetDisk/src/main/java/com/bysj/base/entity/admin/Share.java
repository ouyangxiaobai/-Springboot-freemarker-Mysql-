package com.bysj.base.entity.admin;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EntityListeners;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.springframework.data.jpa.domain.support.AuditingEntityListener;

/**
 * 后台分享实体类
 * @author Administrator
 *
 */
@Entity
@Table(name="bysj_share")
@EntityListeners(AuditingEntityListener.class)
public class Share extends BaseEntity{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public static final int ADMIN_SHARE_STATUS_ENABLE = 1;//分享状态正常可用
	public static final int ADMIN_SHARE_STATUS_CANCEL = -1;//分享状态不可用，已取消分享
	public static final int ADMIN_SHARE_STATUS_EXPIRED = -2;//分享状态不可用，已过期
	
	public static final int ADMIN_SHARE_TYPE_ENCRPT = 1;//加密分享方式
	public static final int ADMIN_SHARE_TYPE_UNENCRPT = 0;//公开分享方式
	
	@ManyToOne
	@JoinColumn(name="user_id")
	private User user;//所属用户
	
	@Column(name="sn",nullable=false,length=128,unique=true)
	private String sn;//分享编号,唯一
	
	@Column(name="title",nullable=false,length=128)
	private String title;//分享标题
	
	@Column(name="files")
	@ManyToMany
	private List<File> files;//分享所对应的文件列表
	
	@Column(name="folders")
	@ManyToMany
	private List<Folder> folders;//分享所对应的文件夹列表
	
	@Column(name="status",length=1)
	private int status = ADMIN_SHARE_STATUS_ENABLE;//分享状态,默认可用
	
	@Column(name="share_type",length=1)
	private int shareType = ADMIN_SHARE_TYPE_ENCRPT;//默认加密分享
	
	@Column(name="expire_time",length=1)
	private long expireTime = 0;//失效时间，0表示永久有效，毫秒数

	@Column(name="password",length=8)
	private String password;//分享密码

	@Column(name="save_times",length=12)
	private Integer saveTimes = 0;//文件转存次数
	
	@Column(name="view_times",length=12)
	private Integer viewTimes = 0;//浏览次数

	public String getSn() {
		return sn;
	}

	public void setSn(String sn) {
		this.sn = sn;
	}

	public List<File> getFiles() {
		return files;
	}

	public void setFiles(List<File> files) {
		this.files = files;
	}

	public List<Folder> getFolders() {
		return folders;
	}

	public void setFolders(List<Folder> folders) {
		this.folders = folders;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public int getShareType() {
		return shareType;
	}

	public void setShareType(int shareType) {
		this.shareType = shareType;
	}

	public long getExpireTime() {
		return expireTime;
	}

	public void setExpireTime(long expireTime) {
		this.expireTime = expireTime;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public Integer getSaveTimes() {
		return saveTimes;
	}

	public void setSaveTimes(Integer saveTimes) {
		this.saveTimes = saveTimes;
	}

	public Integer getViewTimes() {
		return viewTimes;
	}

	public void setViewTimes(Integer viewTimes) {
		this.viewTimes = viewTimes;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	@Override
	public String toString() {
		return "Share [user=" + user + ", sn=" + sn + ", title=" + title
				+ ", files=" + files + ", folders=" + folders + ", status="
				+ status + ", shareType=" + shareType + ", expireTime="
				+ expireTime + ", password=" + password + ", saveTimes="
				+ saveTimes + ", viewTimes=" + viewTimes + "]";
	}




	

	

	
	
	
	
	
	
}
