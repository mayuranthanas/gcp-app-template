package com.example.springboot;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;


@RestController
public class HelloController {

	@Autowired
    	private Environment environment;
	
	@RequestMapping("/")
	public String index() {
		return "<h3>Hello World from Spring Boot!<h3><br/><p>Query <a href='./cache'>/cache</a> to access Memorystore Redis.</p>";
	}

	@RequestMapping("/cache")
	public String cache(){
		String redip = environment.getProperty("redis.ip");
		Jedis jedis = new Jedis(redip, 6379);
		jedis.set("java_key1","Cached Data");
		String cdata = jedis.get("java_key1");
		jedis.close();
		
		return "Hello World from Spring Boot Cache: " + cdata + " from: " + redip;
	}

}