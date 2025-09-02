package com.velvodrive.controller;

import com.velvodrive.model.ChatMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@Controller
public class ChatController {
    @Autowired
    private SimpMessagingTemplate simpMessagingTemplate;

    @MessageMapping("/chat.sendMessage")

    @SendTo("/topic/public")
    public ChatMessage sendMessage(@Payload ChatMessage chatMessage){
        return chatMessage;
    }

    @MessageMapping("/private.chat")
    public void sendPrivateMessage(@Payload ChatMessage chatMessage) {
        String destination = "/user/" + chatMessage.getRecipient() + "/queue/private";
        simpMessagingTemplate.convertAndSend(destination, chatMessage);
    }
}