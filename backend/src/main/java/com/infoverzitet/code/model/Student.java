
package com.infoverzitet.code.model;

import jakarta.persistence.*;

@Entity
@Table(name = "student")
public class Student {

    @Id
    @Column(name = "idRegistrovanKorisnik")
    private Integer id;

    @OneToOne
    @MapsId
    @JoinColumn(name = "idRegistrovanKorisnik")
    private ObicanKorisnik obicanKorisnik;

    private String ime;
    private String prezime;

    @Column(name = "grad_stanovanja")
    private String gradStanovanja;

    private String fakultet;

    public Student() {
    }

    public void setObicanKorisnik(ObicanKorisnik obicanKorisnik) {
        this.obicanKorisnik = obicanKorisnik;
    }

    public void setIme(String ime) {
        this.ime = ime;
    }

    public void setPrezime(String prezime) {
        this.prezime = prezime;
    }

    public void setGradStanovanja(String gradStanovanja) {
        this.gradStanovanja = gradStanovanja;
    }

    public void setFakultet(String fakultet) {
        this.fakultet = fakultet;
    }
}
