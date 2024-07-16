ways to apply the S3 lifecycle policy using the AWS CLI and different scripting languages like Bash and PowerShell.

### Using AWS CLI

1. Save the JSON policy to a file, e.g., `lifecycle-policy.json`.

```json
{
    "Rules": [
        {
            "ID": "MoveToGlacierAndExpire",
            "Filter": {
                "Prefix": ""
            },
            "Status": "Enabled",
            "Transitions": [
                {
                    "Days": 30,
                    "StorageClass": "GLACIER"
                }
            ],
            "Expiration": {
                "Days": 365
            },
            "NoncurrentVersionExpiration": {
                "NoncurrentDays": 365
            }
        }
    ]
}
```

2. Apply the policy using the AWS CLI:

```sh
aws s3api put-bucket-lifecycle-configuration --bucket your-bucket-name --lifecycle-configuration file://lifecycle-policy.json
```

Replace `your-bucket-name` with the name of your S3 bucket.

### Using Bash Script

Save the following Bash script to a file, e.g., `apply-lifecycle.sh`, and run it.

```bash
#!/bin/bash

BUCKET_NAME="your-bucket-name"

cat <<EOL > lifecycle-policy.json
{
  "Rules": [
    {
      "ID": "Transition to Glacier and Expire",
      "Prefix": "",
      "Status": "Enabled",
      "Transitions": [
        {
          "Days": 30,
          "StorageClass": "GLACIER"
        }
      ],
      "Expiration": {
        "Days": 365
      }
    }
  ]
}
EOL

aws s3api put-bucket-lifecycle-configuration --bucket $BUCKET_NAME --lifecycle-configuration file://lifecycle-policy.json

echo "Lifecycle policy applied to bucket: $BUCKET_NAME"
```

Make the script executable and run it:

```sh
chmod +x apply-lifecycle.sh
./apply-lifecycle.sh
```

### Using PowerShell

Save the following PowerShell script to a file, e.g., `Apply-LifecyclePolicy.ps1`, and run it.

```powershell
$bucketName = "your-bucket-name"

$lifecyclePolicy = @"
{
  "Rules": [
    {
      "ID": "Transition to Glacier and Expire",
      "Prefix": "",
      "Status": "Enabled",
      "Transitions": [
        {
          "Days": 30,
          "StorageClass": "GLACIER"
        }
      ],
      "Expiration": {
        "Days": 365
      }
    }
  ]
}
"@

$lifecyclePolicy | Out-File -FilePath "lifecycle-policy.json"

aws s3api put-bucket-lifecycle-configuration --bucket $bucketName --lifecycle-configuration file://lifecycle-policy.json

Write-Output "Lifecycle policy applied to bucket: $bucketName"
```

Run the PowerShell script:

```powershell
.\Apply-LifecyclePolicy.ps1
```

These scripts will apply the specified lifecycle policy to your S3 bucket. Make sure to replace `your-bucket-name` with your actual S3 bucket name.
ands in s3 we hav only day based policy's there is no options to delete in hours if you want to delete in hour yoou can use lambda trigger event for that option