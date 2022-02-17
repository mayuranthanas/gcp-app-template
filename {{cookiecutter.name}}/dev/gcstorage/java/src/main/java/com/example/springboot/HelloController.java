package com.example.springboot;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;

import com.google.cloud.storage.Blob;
import com.google.cloud.storage.BlobId;
import com.google.cloud.storage.BlobInfo;
import com.google.cloud.storage.Bucket;
import com.google.cloud.storage.Storage;
import com.google.cloud.storage.StorageOptions;

import java.util.List;
import java.util.Arrays;

@RestController
public class HelloController {

	@Autowired
    	private Environment environment;
	 
	@RequestMapping("/")
	public String index() {
		String ret = "<h2>Hello World from Spring Boot + Google Cloud Storage!</h2><br/>";
	
		String storage_bucket = environment.getProperty("storage.bucket");
		ret += "<h3>Bucket: " + storage_bucket + "</h3><br/>";
		try
		{
		StorageOptions.Builder optionsBuilder = StorageOptions.newBuilder();
		Storage storage = optionsBuilder.build().getService();
		Bucket bucket = storage.get(storage_bucket);
		if (bucket == null) {
		  ret += "Bucket not found!";
   		  return ret;
  		}
		ret += "<h4>Blobs:<br/>===========</h4><br/>";	 
	        for (Blob blob : bucket.list().iterateAll()) {
	          ret += blob + "<br/>";
	        }  		
		}catch (Exception ex){
			// ToDo: log the exception here
		}
		return ret;
	}

}
