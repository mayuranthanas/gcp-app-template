package com.example.springboot;

import java.io.IOException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import com.google.api.core.ApiFuture;
import com.google.protobuf.ByteString;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.FirestoreOptions;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.cloud.firestore.QuerySnapshot;
import com.google.cloud.firestore.WriteResult;

import java.io.IOException;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
@SpringBootApplication
public class FirestoreApplication {

  private static final Log LOGGER = LogFactory.getLog(FirestoreApplication.class);

  @Autowired
  private Environment environment;
	
  public static void main(String[] args) {
     SpringApplication.run(FirestoreApplication.class, args);
  }  
}
