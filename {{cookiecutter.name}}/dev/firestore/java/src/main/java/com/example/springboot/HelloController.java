package com.example.springboot;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.google.api.core.ApiFuture;
import com.google.protobuf.ByteString;
import com.google.auth.oauth2.GoogleCredentials;

import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.FirestoreOptions;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.cloud.firestore.QuerySnapshot;
import com.google.cloud.firestore.WriteResult;

import com.google.common.collect.ImmutableMap;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import java.text.DateFormat;  
import java.text.SimpleDateFormat;  
import java.util.Date;  
import java.util.Calendar;  

import java.io.IOException;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

@RestController
public class HelloController {
	
	@Autowired
    	private Environment environment;
	
		
	@RequestMapping("/")
	public String index() {
		String ret = "<h3>Firestore Sample from Spring Boot!<h3><br/>";
		ret += "<p><a href='./firestore'>Try Firestore</a>.</p>";
		return ret;
	}

	private Firestore db;

	private void setupFirestoreHandler(String project_id) throws Exception{
		// setup Firestore handler
		FirestoreOptions firestoreOptions =
        FirestoreOptions.getDefaultInstance().toBuilder()
            .setProjectId(project_id)
            .setCredentials(GoogleCredentials.getApplicationDefault())
            .build();
    	Firestore db = firestoreOptions.getService();
		this.db = db;
	}

	@RequestMapping("/firestore")
	public String firestore() throws Exception {
		
		String collection_nm = environment.getProperty("collection.name");
		String document_nm = "sample-doc-from-java";
		String project_id = environment.getProperty("project.id.np");
		
		
		String ret = "<h1>Firestore Spring Boot Java Sample</h1><br>";
		ret += String.format("<h3>Collection: %s</h3><br>", collection_nm);
		ret += String.format("<h4>Document: %s</h4><br>", document_nm);
		ret += "<br>===========<br>";
		
		setupFirestoreHandler(project_id);

		ret += "Checking existing sample Document...<br>";
		// check if sample document exists...
		DocumentReference docRef = db.collection(collection_nm).document(document_nm);
		ApiFuture<DocumentSnapshot> future = docRef.get();
		DocumentSnapshot document = future.get();
		if (document.exists()) {
			// delete existing sample document (if any)
			ApiFuture<WriteResult> writeResult = db.collection(collection_nm).document(document_nm).delete();
			ret += "Deleted existing sample Document...<br>";
		}
		TimeUnit.SECONDS.sleep(1);
		ret += "Creating Sample Document...<br>";
		// Add sample data to document
		Map<String, String> docData = new HashMap<>();
		docData.put("app", "Sample Spring Boot Java for Firestore");
		docData.put("project", "Starter-Kit");
		docData.put("message", "Hello Firestore from Java!");
		Date date = Calendar.getInstance().getTime();  
		DateFormat dateFormat = new SimpleDateFormat("yyyy-mm-dd hh:mm:ss");  
		docData.put("time-stamp", dateFormat.format(date));
		
		ApiFuture<WriteResult> wfuture = db.collection(collection_nm).document(document_nm).set(docData);
		ret += String.format("Created: %s<br>", document_nm);
		ret += "===========<br>";
		TimeUnit.SECONDS.sleep(2);
		ret += String.format("Query Sample Document: %s<br>", document_nm);
		DocumentReference rdocRef = db.collection(collection_nm).document(document_nm);
		ApiFuture<DocumentSnapshot> rfuture = rdocRef.get();
		DocumentSnapshot rdocument = rfuture.get();
		if (rdocument.exists()){
			Map<String, Object> rdata = rdocument.getData();
			if(rdata.size()>0){
				for(Map.Entry<String,Object> entry: rdata.entrySet()){
					ret += entry.getKey() + ": " + entry.getValue() + "<br>";
				}
			}
		}

		return ret;
	}

}