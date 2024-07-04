To read the resume data from S3 within your Spring Boot application, you need to follow these steps:

1. **Set Up S3 Event Notification** (if you need real-time updates).
2. **Use AWS SDK for Java** to interact with S3.
3. **Implement a Scheduled Task** (optional) to periodically check for new files.
4. **Fetch and Process the Resumes** from S3.

### Step-by-Step Implementation:

#### 1. Add Dependencies to `pom.xml`

Make sure you have the necessary AWS SDK dependencies in your `pom.xml`:

```xml
<dependency>
    <groupId>com.amazonaws</groupId>
    <artifactId>aws-java-sdk-s3</artifactId>
    <version>1.12.409</version>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter</artifactId>
    <version>2.7.5</version>
</dependency>
```

#### 2. Configure AWS Credentials

Ensure that your application has access to AWS credentials. You can configure this through environment variables, the AWS credentials file, or IAM roles if running on an AWS EC2 instance.

#### 3. Create the S3 Service

Create a service to interact with S3:

```java
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.ObjectListing;
import com.amazonaws.services.s3.model.S3Object;
import com.amazonaws.services.s3.model.S3ObjectSummary;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class S3Service {

    private final AmazonS3 s3Client;
    private static final String BUCKET_NAME = "YourBucketName";
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

    public S3Service() {
        // Replace with your actual access key and secret key
        BasicAWSCredentials awsCreds = new BasicAWSCredentials("access_key", "secret_key");
        this.s3Client = AmazonS3ClientBuilder.standard()
                .withRegion("us-east-1")
                .withCredentials(new AWSStaticCredentialsProvider(awsCreds))
                .build();
    }

    public List<String> getRecentFilesContent() {
        List<String> fileContents = new ArrayList<>();
        long currentTimeMillis = System.currentTimeMillis();
        long startTimeMillis = currentTimeMillis - (5 * 60 * 1000); // 5 minutes ago

        ObjectListing objectListing = s3Client.listObjects(BUCKET_NAME);
        for (S3ObjectSummary summary : objectListing.getObjectSummaries()) {
            Date lastModified = summary.getLastModified();
            if (lastModified.getTime() >= startTimeMillis) {
                S3Object s3Object = s3Client.getObject(BUCKET_NAME, summary.getKey());
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(s3Object.getObjectContent()))) {
                    StringBuilder fileContent = new StringBuilder();
                    String line;
                    while ((line = reader.readLine()) != null) {
                        fileContent.append(line).append("\n");
                    }
                    fileContents.add(fileContent.toString());
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        return fileContents;
    }
}
```

#### 4. Create a Controller to Access the Service

Create a controller to expose an endpoint to retrieve the resume data:

```java
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class S3Controller {

    private final S3Service s3Service;

    public S3Controller(S3Service s3Service) {
        this.s3Service = s3Service;
    }

    @GetMapping("/recent-resumes")
    public List<String> getRecentResumes() {
        return s3Service.getRecentFilesContent();
    }
}
```

#### 5. (Optional) Implement a Scheduled Task

If you want to periodically fetch the data rather than on-demand, you can implement a scheduled task:

```java
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class ScheduledTask {

    private final S3Service s3Service;

    public ScheduledTask(S3Service s3Service) {
        this.s3Service = s3Service;
    }

    @Scheduled(fixedRate = 300000) // 5 minutes in milliseconds
    public void fetchRecentResumes() {
        List<String> recentResumes = s3Service.getRecentFilesContent();
        // Process the resumes as needed
        recentResumes.forEach(System.out::println);
    }
}
```

#### 6. Enable Scheduling in Your Spring Boot Application

Add the `@EnableScheduling` annotation to your main application class to enable scheduling:

```java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

### Summary

- **S3 Event Notification**: Optionally set up to CloudWatch Logs if needed for real-time tracking.
- **Spring Boot Application**: Use the AWS SDK to fetch recent files from S3.
- **Scheduled Task**: Optionally implement for periodic fetching.
- **Controller**: Expose an endpoint to access the recent resume data.

