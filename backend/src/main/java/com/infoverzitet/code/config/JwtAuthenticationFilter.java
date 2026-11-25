
package com.infoverzitet.code.config;

import com.infoverzitet.code.service.JwtService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtService jwtService;

    public JwtAuthenticationFilter(JwtService jwtService) {
        this.jwtService = jwtService;
    }

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain)
            throws ServletException, IOException {

        String zaglavlje = request.getHeader("Authorization");

        if (zaglavlje == null || !zaglavlje.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        String token = zaglavlje.substring(7);

        try {
            String username = jwtService.izvuciUsername(token);

            if (username != null &&
                    SecurityContextHolder.getContext().getAuthentication() == null) {

                User korisnik = new User(
                        username,
                        "",
                        Collections.emptyList()
                );

                UsernamePasswordAuthenticationToken autentifikacija =
                        new UsernamePasswordAuthenticationToken(
                                korisnik,
                                null,
                                korisnik.getAuthorities()
                        );

                autentifikacija.setDetails(
                        new WebAuthenticationDetailsSource()
                                .buildDetails(request)
                );

                SecurityContextHolder.getContext()
                        .setAuthentication(autentifikacija);
            }

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        filterChain.doFilter(request, response);
    }
}
