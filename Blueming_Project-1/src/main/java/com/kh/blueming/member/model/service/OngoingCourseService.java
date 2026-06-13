package com.kh.blueming.member.model.service;

import java.util.List;

import com.kh.blueming.common.model.vo.PageInfo;
import com.kh.blueming.member.model.vo.OngoingCourse;

public interface OngoingCourseService {

    int selectCourseCount(int memberId);

    List<OngoingCourse> selectMyCourseList(PageInfo pi, int memberId);
}