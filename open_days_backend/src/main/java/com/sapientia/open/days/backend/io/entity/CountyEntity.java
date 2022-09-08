package com.sapientia.open.days.backend.io.entity;

import javax.persistence.*;
import java.io.Serial;
import java.io.Serializable;
import java.util.Set;

@Entity
@Table(name = "counties")
public class CountyEntity implements Serializable {

	@Id
	@GeneratedValue
	private long id;

	@Column(length = 100, nullable = false)
	private String name;

	@OneToMany(mappedBy = "county")
	private Set<SettlementEntity> settlements;

	@Serial
	private static final long serialVersionUID = 8633409196848736088L;

	public CountyEntity() {
	}

	public CountyEntity(String name) {
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