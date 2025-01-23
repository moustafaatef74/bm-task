package com.example.demo.controller;

import com.example.demo.service.DatabaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class LiveController {

    private final DatabaseService databaseService;

    @Autowired
    public LiveController(DatabaseService databaseService) {
        this.databaseService = databaseService;
    }

    @GetMapping("/live")
    public String getLiveStatus() {
        return databaseService.checkDatabaseConnection() ? "Well done" : "Maintenance";
    }
}

