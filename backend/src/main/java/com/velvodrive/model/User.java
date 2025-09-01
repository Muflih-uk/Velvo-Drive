package com.velvodrive.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
@Table(name = "users")

public class User{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    private String username;
    private String email;
    private String password;
}