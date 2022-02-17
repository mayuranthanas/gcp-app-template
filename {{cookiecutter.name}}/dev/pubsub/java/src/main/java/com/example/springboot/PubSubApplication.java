package com.example.springboot;

import java.io.IOException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import com.google.api.core.ApiFuture;
import com.google.cloud.pubsub.v1.Publisher;
import com.google.protobuf.ByteString;
import com.google.pubsub.v1.PubsubMessage;
import com.google.pubsub.v1.TopicName;
import java.io.IOException;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
@SpringBootApplication
public class PubSubApplication {

  private static final Log LOGGER = LogFactory.getLog(PubSubApplication.class);

  @Autowired
  private Environment environment;
	
  public static void main(String[] args) {
     SpringApplication.run(PubSubApplication.class, args);
  }  
}
