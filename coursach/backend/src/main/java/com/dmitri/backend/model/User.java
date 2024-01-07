package com.dmitri.backend.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

@Getter
@Setter
public class User implements Serializable {

    private String login;

    private String password;
    private String name;

    public User() {}

    public User(String login, String name, String password) {
        this.login = login;
        this.password = password;
        this.name = name;
    }
}
