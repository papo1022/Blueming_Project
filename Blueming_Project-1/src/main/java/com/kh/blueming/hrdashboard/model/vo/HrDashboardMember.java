package com.kh.blueming.hrdashboard.model.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class HrDashboardMember {

	private String name;
	private String departmentName;
	private String positionName;
	private String email;
	private int avgProgressRate;
}
