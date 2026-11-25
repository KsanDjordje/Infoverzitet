
package com.infoverzitet.code.service;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.util.Date;

@Service
public class JwtService {

    @Value("${app.jwt.secret}")
    private String secret;

    @Value("${app.jwt.expiration}")
    private long expiration;

    private SecretKey getKey() {
        return Keys.hmacShaKeyFor(Decoders.BASE64.decode(secret));
    }

    public String generisiToken(String username) {
        Date sada = new Date();
        Date istek = new Date(sada.getTime() + expiration);

        return Jwts.builder()
                .subject(username)
                .issuedAt(sada)
                .expiration(istek)
                .signWith(getKey())
                .compact();
    }

    public String izvuciUsername(String token) {
        return Jwts.parser()
                .verifyWith(getKey())
                .build()
                .parseSignedClaims(token)
                .getPayload()
                .getSubject();
    }

    public boolean validanToken(String token, String username) {
        return username.equals(izvuciUsername(token));
    }
}
