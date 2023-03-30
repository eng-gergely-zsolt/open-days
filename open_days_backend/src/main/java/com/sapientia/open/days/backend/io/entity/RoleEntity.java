package com.sapientia.open.days.backend.io.entity;

import javax.persistence.*;
import java.io.Serial;
import java.io.Serializable;
import java.util.Collection;
import java.util.Set;

@Entity
@Table(name = "roles")
@SuppressWarnings("unused")
public class RoleEntity implements Serializable {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private long id;

	@Column(nullable = false, length = 20)
	private String name;

	@ManyToMany(mappedBy = "roles")
	private Collection<UserEntity> users;

	@Serial
	private static final long serialVersionUID = 1773859640689567294L;

	public RoleEntity() {
	}

	public RoleEntity(String name) {
		this.name = name;
	}

	@ManyToMany(cascade = {CascadeType.PERSIST}, fetch = FetchType.EAGER)
	@JoinTable(name = "roles_authorities",
			joinColumns = @JoinColumn(name = "roles_id", referencedColumnName = "id"),
			inverseJoinColumns = @JoinColumn(name = "authorities_id", referencedColumnName = "id"))
	private Set<AuthorityEntity> authorities;

	public long getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public Collection<UserEntity> getUsers() {
		return users;
	}

	public Set<AuthorityEntity> getAuthorities() {
		return authorities;
	}

	public void setId(long id) {
		this.id = id;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setUsers(Collection<UserEntity> users) {
		this.users = users;
	}

	public void setAuthorities(Set<AuthorityEntity> authorities) {
		this.authorities = authorities;
	}
}