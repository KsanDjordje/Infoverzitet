
package com.infoverzitet.code.service;

import com.infoverzitet.code.model.*;
import com.infoverzitet.code.repository.*;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@Service
public class AuthService {

    private final RegistrovanKorisnikRepository korisnikRepository;
    private final ObicanKorisnikRepository obicanRepository;
    private final StudentRepository studentRepository;
    private final PoslovniKorisnikRepository poslovniRepository;

    private final BCryptPasswordEncoder passwordEncoder =
            new BCryptPasswordEncoder();

    public AuthService(RegistrovanKorisnikRepository korisnikRepository,
                       ObicanKorisnikRepository obicanRepository,
                       StudentRepository studentRepository,
                       PoslovniKorisnikRepository poslovniRepository) {

        this.korisnikRepository = korisnikRepository;
        this.obicanRepository = obicanRepository;
        this.studentRepository = studentRepository;
        this.poslovniRepository = poslovniRepository;
    }

    @Transactional
    public RegistrovanKorisnik registrujStudenta(
            String ime, String prezime, String username,
            String password, String email, String fakultet,
            String gradStanovanja) {

        provjeriPodatke(username, email);

        RegistrovanKorisnik korisnik = new RegistrovanKorisnik();
        korisnik.setUsername(username);
        korisnik.setEmail(email);
        korisnik.setPassword(passwordEncoder.encode(password));

        korisnik = korisnikRepository.save(korisnik);

        ObicanKorisnik obican = new ObicanKorisnik();
        obican.setRegistrovanKorisnik(korisnik);
        obican = obicanRepository.save(obican);

        Student student = new Student();
        student.setObicanKorisnik(obican);
        student.setIme(ime);
        student.setPrezime(prezime);
        student.setFakultet(fakultet);
        student.setGradStanovanja(gradStanovanja);

        studentRepository.save(student);

        return korisnik;
    }

    @Transactional
    public RegistrovanKorisnik registrujPoslovnogKorisnika(
            String imeKompanije, String username, String email,
            String adresaKompanije, String password,
            String JIB, String djelatnost) {

        provjeriPodatke(username, email);

        RegistrovanKorisnik korisnik = new RegistrovanKorisnik();
        korisnik.setUsername(username);
        korisnik.setEmail(email);
        korisnik.setPassword(passwordEncoder.encode(password));

        korisnik = korisnikRepository.save(korisnik);

        ObicanKorisnik obican = new ObicanKorisnik();
        obican.setRegistrovanKorisnik(korisnik);
        obican = obicanRepository.save(obican);

        PoslovniKorisnik poslovni = new PoslovniKorisnik();
        poslovni.setObicanKorisnik(obican);
        poslovni.setImeKompanije(imeKompanije);
        poslovni.setAdresaKompanije(adresaKompanije);
        poslovni.setJIB(JIB);
        poslovni.setDjelatnost(djelatnost);

        poslovniRepository.save(poslovni);

        return korisnik;
    }

    private void provjeriPodatke(String username, String email) {

        if (korisnikRepository.findByUsername(username).isPresent()) {
            throw new IllegalArgumentException(
                    "Korisničko ime je već zauzeto.");
        }

        if (korisnikRepository.findByEmail(email).isPresent()) {
            throw new IllegalArgumentException(
                    "Email je već registrovan.");
        }
    }

    public RegistrovanKorisnik prijaviSe(String username, String password) {

        RegistrovanKorisnik korisnik = korisnikRepository
                .findByUsername(username)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Pogrešno korisničko ime ili lozinka."));

        if (!passwordEncoder.matches(password, korisnik.getPassword())) {
            throw new IllegalArgumentException(
                    "Pogrešno korisničko ime ili lozinka.");
        }

        if (!"aktivan".equals(korisnik.getStatus())) {
            throw new IllegalArgumentException(
                    "Korisnički račun nije aktivan.");
        }

        return korisnik;
    }
}
