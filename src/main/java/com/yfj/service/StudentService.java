package com.yfj.service;

import com.yfj.domain.Student;
import org.springframework.stereotype.Service;

import java.util.List;
public interface StudentService {

    int addStudent(Student student);
    List<Student> findStudents();

}
