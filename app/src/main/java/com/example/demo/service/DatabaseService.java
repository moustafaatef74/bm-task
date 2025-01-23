package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.jdbc.CannotGetJdbcConnectionException;

@Service
public class DatabaseService {

    private JdbcTemplate jdbcTemplate;

    @Autowired(required = false)
    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public boolean checkDatabaseConnection() {
        if (jdbcTemplate == null) {
            return false;
        }
        try {
            jdbcTemplate.queryForObject("SELECT 1", Integer.class);
            return true;
        } catch (CannotGetJdbcConnectionException e) {
            return false;
        }
    }
}

