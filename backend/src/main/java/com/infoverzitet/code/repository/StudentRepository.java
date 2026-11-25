package com.infoverzitet.code.repository;

import com.infoverzitet.code.model.Student;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StudentRepository
        extends JpaRepository<Student, Integer> {
}