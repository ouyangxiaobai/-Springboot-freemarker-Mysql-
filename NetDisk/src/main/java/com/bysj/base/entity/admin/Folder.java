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
 * 后台文件夹实体类
 * @author Administrator
 *
 */
@Entity
@Table(name="bysj_folder")
@EntityListeners(AuditingEntityListener.class)
public class Folder extends BaseEntity{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@ManyToOne
	@JoinColumn(name="user_id")
	private User user;//所属用户
	
	
	@ValidateEntity(required=true,requiredLeng=true,minLength=1,maxLength=64,errorRequiredMsg="文件夹名称不能为空!",errorMinLengthMsg="文件夹名称长度需大于1!",errorMaxLengthMsg="文件夹名称长度不能大于64!")
	@Column(name="name",nullable=false,length=64)
	private String name;//文件夹名称
	
	@ManyToOne
	@JoinColumn(name="parent_id")
	private Folder parent;//文件夹父分类
	
	@ValidateEntity(required=false)
	@Column(name="path",length=512)
	private String path;//文件夹路径

	@Column(name="is_trash")
	private Boolean isTrash = false;//是否放入回收站

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

	public Folder getParent() {
		return parent;
	}

	public void setParent(Folder parent) {
		this.parent = parent;
	}

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public Boolean getIsTrash() {
		return isTrash;
	}

	public void setIsTrash(Boolean isTrash) {
		this.isTrash = isTrash;
	}

	@Override
	public String toString() {
		return "Folder [user=" + user + ", name=" + name + ", parent=" + parent
				+ ", path=" + path + ", isTrash=" + isTrash + "]";
	}
	

	
	
	
}
