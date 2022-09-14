package com.sapientia.open.days.backend.io.entity;

import javax.persistence.*;
import java.io.Serial;
import java.io.Serializable;
import java.util.Set;

@Entity
@SuppressWarnings("unused")
@Table(name = "authorities")
public class AuthorityEntity implements Serializable {

	@Serial
	private static final long serialVersionUID = 7226990133576874679L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private long id;

	@Column(nullable = false, length = 20)
	private String name;

	@ManyToMany(mappedBy = "authorities")
	private Set<RoleEntity> roles;

	public AuthorityEntity() {
	}

	public AuthorityEntity(String name) {
		this.name = name;
	}

	public long getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public Set<RoleEntity> getRoles() {
		return roles;
	}

	public void setId(long id) {
		this.id = id;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setRoles(Set<RoleEntity> roles) {
		this.roles = roles;
	}
}