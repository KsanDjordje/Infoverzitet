package com.infoverzitet.code.repository;

import com.infoverzitet.code.model.ObicanKorisnik;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ObicanKorisnikRepository
        extends JpaRepository<ObicanKorisnik, Integer> {
}