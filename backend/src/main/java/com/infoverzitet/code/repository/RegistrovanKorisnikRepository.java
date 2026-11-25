
package com.infoverzitet.code.repository;

import com.infoverzitet.code.model.RegistrovanKorisnik;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RegistrovanKorisnikRepository
        extends JpaRepository<RegistrovanKorisnik, Integer> {

    Optional<RegistrovanKorisnik> findByUsername(String username);

    Optional<RegistrovanKorisnik> findByEmail(String email);
}
