package com.kh.blueming.member.model.dao;

import java.util.List;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.blueming.common.model.vo.PageInfo;
import com.kh.blueming.member.model.vo.OngoingCourse;

@Repository
public class OngoingCourseDao {

    public int selectCourseCount(SqlSessionTemplate sqlSession, int memberId) {

        return sqlSession.selectOne(
                "ongoingCourseMapper.selectCourseCount",
                memberId);
    }

    public List<OngoingCourse> selectMyCourseList(
            SqlSessionTemplate sqlSession,
            PageInfo pi,
            int memberId) {

        int offset =
                (pi.getCurrentPage() - 1)
                * pi.getBoardLimit();

        RowBounds rowBounds =
                new RowBounds(offset,
                              pi.getBoardLimit());

        return sqlSession.selectList(
                "ongoingCourseMapper.selectMyCourseList",
                memberId,
                rowBounds);
    }
}