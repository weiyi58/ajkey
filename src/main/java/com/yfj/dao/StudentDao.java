package com.yfj.dao;

import com.yfj.domain.Student;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface StudentDao {

    int insertStudent(Student student);
    List<Student> selectStudents();

}
