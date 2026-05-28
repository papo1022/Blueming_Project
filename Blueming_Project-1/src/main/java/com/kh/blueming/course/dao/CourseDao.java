package com.kh.blueming.course.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.blueming.course.model.vo.Course;

@Repository
public class CourseDao {

    public ArrayList<Course> selectCourseList(SqlSessionTemplate sqlSession,
                                              int currentPage,
                                              int courseLimit,
                                              String keyword,
                                              String sort) {
        HashMap<String, String> map = new HashMap<>();
        map.put("keyword", keyword);
        map.put("sort", sort);

        int offset = (currentPage - 1) * courseLimit;
        RowBounds rowBounds = new RowBounds(offset, courseLimit);

        return (ArrayList) sqlSession.selectList("courseMapper.selectCourseList", map, rowBounds);
    }

}
