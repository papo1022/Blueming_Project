package com.kh.blueming.member.model.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

//사원 대시보드에 띄울 용도로 사용할 VO 클래스
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class MemberProfile {
    private int memberId;
    private String name;
    private String email;
    private String departmentName;
    private String positionName;
}
