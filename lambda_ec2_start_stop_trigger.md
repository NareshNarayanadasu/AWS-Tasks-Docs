Certainly! Here's the guide formatted in Markdown for easier readability and usage:

---

## Create a Lambda Function to Manage EC2 Instances

### Step 1: IAM Role Creation

#### Navigate to IAM Console:
1. Go to AWS Management Console and open the IAM console.
2. **Create a Role:**
   - Click on "Roles" in the left-hand menu.
   - Click "Create role".
   - Choose "AWS service" as the type of trusted entity, and select "Lambda" as the service that will use this role.
   - Click "Next: Permissions".
   - Attach policies like `AmazonEC2FullAccess` and `CloudWatchEventsFullAccess` (for simplicity; adjust permissions based on your security requirements).
   - Click "Next: Tags" (optional) and then "Next: Review".
   - Name the role (e.g., `LambdaManageEC2Role`) and add a description.
   - Click "Create role".

### Step 2: Lambda Function Creation

#### Navigate to Lambda Console:
1. Go to AWS Management Console and open the Lambda console.
2. **Create Function:**
   - Click on "Create function".
   - Choose "Author from scratch".
   - Provide a name (e.g., `ManageEC2Instances`), choose Python runtime, and select the IAM role (`LambdaManageEC2Role`) created earlier.
   - Click "Create function".

#### Write Lambda Function Code:
```python
import boto3

def lambda_handler(event, context):
    # EC2 instance ID to manage
    instance_id = 'your-instance-id'
    
    # Event details
    event_name = event['detail']['eventName']
    
    # Create EC2 client
    ec2 = boto3.client('ec2')
    
    if event_name == 'StopInstances':
        # Stop EC2 instance
        ec2.stop_instances(InstanceIds=[instance_id])
        print(f'Stopping instance {instance_id}')
    elif event_name == 'StartInstances':
        # Start EC2 instance
        ec2.start_instances(InstanceIds=[instance_id])
        print(f'Starting instance {instance_id}')
    else:
        print(f'Unsupported event: {event_name}')
```

Replace `'your-instance-id'` with the actual instance ID you want to manage.

#### Save and Deploy:
Save the Lambda function by clicking "Deploy" in the upper right corner.

### Step 3: Configure EventBridge (CloudWatch Events) Trigger

#### Navigate to EventBridge (CloudWatch Events) Console:
1. Go to AWS Management Console and open the EventBridge console.

#### Create Rules for Start and Stop Events:
- **For stopping instances:**
   - Click on "Create rule".
   - Name the rule (`StopEC2Instances`).
   - For "Event Source", choose "Event pattern".
   - Use the following pattern to capture EC2 stop events:
     ```json
     {
       "source": ["aws.ec2"],
       "detail-type": ["EC2 Instance State-change Notification"],
       "detail": {
         "state": ["stopping"]
       }
     }
     ```
   - Add target by choosing "Lambda function" and selecting your Lambda function (`ManageEC2Instances`).
   - Click "Create rule".

- **For starting instances (similar steps as above):**
   - Name the rule (`StartEC2Instances`).
   - Use the following pattern to capture EC2 start events:
     ```json
     {
       "source": ["aws.ec2"],
       "detail-type": ["EC2 Instance State-change Notification"],
       "detail": {
         "state": ["running"]
       }
     }
     ```
   - Add target by choosing "Lambda function" and selecting your Lambda function (`ManageEC2Instances`).
   - Click "Create rule".

---

This Markdown guide provides a structured approach to creating a Lambda function to manage EC2 instances based on triggers from EventBridge (CloudWatch Events). Adjust the instance ID and permissions as per your specific requirements.