package com.velvodrive.model;

import lombok.Data;

@Data
public class ChatMessage {
    private String content;
    private String sender;
    private String recipient;
    private MessageType type;

    public enum MessageType {
        CHAT,
        JOIN,
        LEAVE
    }
}
