
package com.infoverzitet.code.model;

import jakarta.persistence.*;

@Entity
@Table(name = "obicankorisnik")
public class ObicanKorisnik {

    @Id
    @Column(name = "idRegistrovanKorisnik")
    private Integer id;

    @OneToOne
    @MapsId
    @JoinColumn(name = "idRegistrovanKorisnik")
    private RegistrovanKorisnik registrovanKorisnik;

    public ObicanKorisnik() {
    }

    public RegistrovanKorisnik getRegistrovanKorisnik() {
        return registrovanKorisnik;
    }

    public void setRegistrovanKorisnik(RegistrovanKorisnik registrovanKorisnik) {
        this.registrovanKorisnik = registrovanKorisnik;
    }
}
