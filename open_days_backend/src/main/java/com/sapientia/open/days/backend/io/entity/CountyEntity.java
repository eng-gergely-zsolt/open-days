package com.sapientia.open.days.backend.io.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Set;

@Entity
@Table(name = "counties")
@SuppressWarnings("unused")
public class CountyEntity implements Serializable {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private long id;

	@Column(length = 100, unique = true, nullable = false)
	private String name;

	@OneToMany(mappedBy = "county")
	private Set<SettlementEntity> settlements;

	public CountyEntity() {}

	public CountyEntity(long id, String name) {
		this.id = id;
		this.name = name;
	}

	public long getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public Set<SettlementEntity> getSettlements() {
		return settlements;
	}

	public void setId(long id) {
		this.id = id;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setSettlements(Set<SettlementEntity> settlements) {
		this.settlements = settlements;
	}
}