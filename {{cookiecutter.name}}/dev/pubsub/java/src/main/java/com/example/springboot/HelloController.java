package com.example.springboot;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.google.api.core.ApiFuture;
import com.google.cloud.pubsub.v1.Publisher;
import com.google.protobuf.ByteString;

import com.google.pubsub.v1.PubsubMessage;
import com.google.pubsub.v1.TopicName;

import com.google.cloud.pubsub.v1.AckReplyConsumer;
import com.google.cloud.pubsub.v1.MessageReceiver;
import com.google.cloud.pubsub.v1.Subscriber;
import com.google.pubsub.v1.ProjectSubscriptionName;

import java.io.IOException;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;
import java.util.ArrayList;
import java.util.List;

@RestController
public class HelloController {
	
	@Autowired
    	private Environment environment;
	
		
	@RequestMapping("/")
	public String index() {
		String ret = "<h3>PubSub Sample from Spring Boot!<h3><br/>";
		ret += "<p><a href='./pubsub'>Try PubSub</a>.</p>";
		return ret;
	}

	@RequestMapping("/pubsub")
	public String pubsub() 
		throws Exception, IOException, ExecutionException, InterruptedException {
		
		String topic_nm = environment.getProperty("topic.name");
		String subscription_nm = environment.getProperty("Subscription.name");
		String project_id = environment.getProperty("project.id.np");
		String topic_path = String.format("projects/%1$s/topics/%2$s", project_id, topic_nm);
		int messageCount = 3;
		String ret = "<h1>Spring Boot Java Sample</h1><br>";
		ret += String.format("<h3>Topic: %s</h3><br>", topic_nm);
		ret += "<p>Publishing Messages</p><br>===========<br>";
		
		Publisher publisher = null;
		// publish 3 messages
		publisher = Publisher.newBuilder(topic_path).build();
		try{
			for (int i = 0; i < messageCount; i++) {
				String message = String.format("Message # %d", i);
				ByteString data = ByteString.copyFromUtf8(message);

				PubsubMessage pubsubMessage = PubsubMessage.newBuilder().setData(data).build();
				ApiFuture<String> messageIdFuture = publisher.publish(pubsubMessage);
				String messageId = messageIdFuture.get();			

				ret += String.format("<p>%s</p>", message);
			}
		}finally {
			if (publisher != null) {
			// When finished with the publisher, shutdown to free up resources.
			publisher.shutdown();
			publisher.awaitTermination(1, TimeUnit.MINUTES);
			}
		}

		List<String> lstMsg = new ArrayList<String>();
		ret += "<br>===========<br>";
		ret += String.format("Listening for messages on subscription: %s<br>", subscription_nm);

		// instantiate a message receiver to subscription and listen for messages for 10 seconds
		ProjectSubscriptionName subscriptionName =
        	ProjectSubscriptionName.of(project_id, subscription_nm);

		// Instantiate an asynchronous message receiver.
		MessageReceiver receiver =
        (PubsubMessage message, AckReplyConsumer consumer) -> {
          // Handle incoming message, then ack the received message.
          System.out.println("Id: " + message.getMessageId());
          System.out.println("Data: " + message.getData().toStringUtf8());
		  lstMsg.add(message.getData().toStringUtf8());
          consumer.ack();
        };

		Subscriber subscriber = null;
		try {
			subscriber = Subscriber.newBuilder(subscriptionName, receiver).build();
			// Start the subscriber.
			subscriber.startAsync().awaitRunning();
			System.out.printf("Listening for messages on %s:\n", subscriptionName.toString());
			// Allow the subscriber to run for 10s unless an unrecoverable error occurs.
			subscriber.awaitTerminated(10, TimeUnit.SECONDS);
		} catch (TimeoutException timeoutException) {
			// Shut down the subscriber after 30s. Stop receiving messages.
			subscriber.stopAsync();
		}
		if(lstMsg.size()> 0){
			for(String msg: lstMsg){
				ret += String.format("%s<br>", msg);
			}			
		}

		return ret;
	}

}