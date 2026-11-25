
package com.infoverzitet.code.controller;

import com.infoverzitet.code.model.RegistrovanKorisnik;
import com.infoverzitet.code.service.AuthService;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.infoverzitet.code.service.JwtService;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;
    private final JwtService jwtService;

    public AuthController(AuthService authService, JwtService jwtService) {
        this.authService = authService;
        this.jwtService = jwtService;
    }

    // Registracija studenta
    @PostMapping("/register/student")
    public ResponseEntity<?> registrujStudenta(
            @RequestBody StudentRequest zahtjev) {

        RegistrovanKorisnik korisnik = authService.registrujStudenta(
                zahtjev.ime(),
                zahtjev.prezime(),
                zahtjev.username(),
                zahtjev.password(),
                zahtjev.email(),
                zahtjev.fakultet(),
                zahtjev.gradStanovanja()
        );

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(podaciKorisnika(korisnik));
    }

    // Registracija poslovnog korisnika
    @PostMapping("/register/company")
    public ResponseEntity<?> registrujKompaniju(
            @RequestBody CompanyRequest zahtjev) {

        RegistrovanKorisnik korisnik =
                authService.registrujPoslovnogKorisnika(
                        zahtjev.imeKompanije(),
                        zahtjev.username(),
                        zahtjev.email(),
                        zahtjev.adresaKompanije(),
                        zahtjev.password(),
                        zahtjev.JIB(),
                        zahtjev.djelatnost()
                );

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(podaciKorisnika(korisnik));
    }

    @PostMapping("/login")
    public ResponseEntity<?> prijaviSe(@RequestBody LoginRequest zahtjev) {
        RegistrovanKorisnik korisnik = authService.prijaviSe(
                zahtjev.username(), zahtjev.password());

        String token = jwtService.generisiToken(korisnik.getUsername());

        return ResponseEntity.ok(Map.of(
                "id", korisnik.getId(),
                "username", korisnik.getUsername(),
                "email", korisnik.getEmail(),
                "status", korisnik.getStatus(),
                "verified", korisnik.isVerified(),
                "token", token
        ));
    }

    private Map<String, Object> podaciKorisnika(RegistrovanKorisnik korisnik) {
        return Map.of(
                "id", korisnik.getId(),
                "username", korisnik.getUsername(),
                "email", korisnik.getEmail(),
                "status", korisnik.getStatus(),
                "verified", korisnik.isVerified()
        );
    }

    // Obrada grešaka
    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<?> obradiGresku(
            IllegalArgumentException e) {

        return ResponseEntity.badRequest()
                .body(Map.of("poruka", e.getMessage()));
    }

    // Podaci za registraciju studenta
    public record StudentRequest(
            String ime,
            String prezime,
            String username,
            String password,
            String email,
            String fakultet,
            String gradStanovanja
    ) {
    }

    // Podaci za registraciju kompanije
    public record CompanyRequest(
            String imeKompanije,
            String username,
            String email,
            String adresaKompanije,
            String password,
            String JIB,
            String djelatnost
    ) {
    }

    // Podaci za prijavu
    public record LoginRequest(
            String username,
            String password
    ) {
    }

    @GetMapping("/test-token")
    public ResponseEntity<?> testToken() {
        return ResponseEntity.ok(
                Map.of("poruka", "JWT token je ispravan. Pristup dozvoljen.")
        );
    }
}
