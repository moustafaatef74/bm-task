package com.example.demo.config;

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

@Configuration
@ConditionalOnProperty(name = "spring.datasource.url", havingValue = "", matchIfMissing = true)
@Import(DataSourceAutoConfiguration.class)
public class DatabaseConfig {
}

