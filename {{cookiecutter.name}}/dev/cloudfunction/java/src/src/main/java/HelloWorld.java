
import com.google.cloud.functions.HttpFunction;
import com.google.cloud.functions.HttpRequest;
import com.google.cloud.functions.HttpResponse;
import java.io.BufferedWriter;
import java.io.IOException;
import java.util.logging.Logger;

public class HelloWorld implements HttpFunction {

  private static final Logger logger = Logger.getLogger(HelloWorld.class.getName());

  @Override
  public void service(HttpRequest request, HttpResponse response)
      throws IOException {
    System.out.println("I am a log to stdout!");
    System.err.println("I am a log to stderr!");

    logger.info("I am an info log!");
    logger.warning("I am a warning log!");

    BufferedWriter writer = response.getWriter();
    writer.write("Hello World from Java!");
  }
}