
package com.infoverzitet.code.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "registrovankorisnik")
public class RegistrovanKorisnik {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idRegistrovanKorisnik")
    private Integer id;

    private String username;
    private String email;
    private String password;
    private String status;

    @Column(name = "is_verified")
    private boolean verified;

    public void setVerified(boolean verified) {
        this.verified = verified;
    }

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    public RegistrovanKorisnik() {
    }

    @PrePersist
    public void prijeCuvanja() {
        if (status == null) {
            status = "aktivan";
        }
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }

    public Integer getId() {
        return id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getStatus() {
        return status;
    }

    public boolean isVerified() {
        return verified;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
}
