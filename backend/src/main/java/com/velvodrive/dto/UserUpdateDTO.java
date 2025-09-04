package com.velvodrive.dto;

import lombok.Data;

@Data
public class UserUpdateDTO {
    private String photo;
    private String username;
    private String aboutYou;
    private String number;
    private String email;
}