
package com.infoverzitet.code.model;

import jakarta.persistence.*;

@Entity
@Table(name = "poslovnikorisnik")
public class PoslovniKorisnik {

    @Id
    @Column(name = "idRegistrovanKorisnik")
    private Integer id;

    @OneToOne
    @MapsId
    @JoinColumn(name = "idRegistrovanKorisnik")
    private ObicanKorisnik obicanKorisnik;

    @Column(name = "ime_kompanije")
    private String imeKompanije;

    @Column(name = "adresa_kompanije")
    private String adresaKompanije;

    private String JIB;
    private String djelatnost;

    public PoslovniKorisnik() {
    }

    public void setObicanKorisnik(ObicanKorisnik obicanKorisnik) {
        this.obicanKorisnik = obicanKorisnik;
    }

    public void setImeKompanije(String imeKompanije) {
        this.imeKompanije = imeKompanije;
    }

    public void setAdresaKompanije(String adresaKompanije) {
        this.adresaKompanije = adresaKompanije;
    }

    public void setJIB(String JIB) {
        this.JIB = JIB;
    }

    public void setDjelatnost(String djelatnost) {
        this.djelatnost = djelatnost;
    }
}
