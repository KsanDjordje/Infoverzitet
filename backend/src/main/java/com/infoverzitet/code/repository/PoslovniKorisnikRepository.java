package com.infoverzitet.code.repository;

import com.infoverzitet.code.model.PoslovniKorisnik;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PoslovniKorisnikRepository
        extends JpaRepository<PoslovniKorisnik, Integer> {
}