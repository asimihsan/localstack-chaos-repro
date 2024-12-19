# LocalStack Chaos API Issue Reproduction

This repository demonstrates an issue with LocalStack Pro's Chaos API where configured faults are
not being applied to S3 operations.

## Prerequisites

- Docker and Docker Compose
- AWS CLI
- curl
- Valid LocalStack Pro auth token

## Steps to Reproduce

1. Clone this repository
2. Set the `LOCALSTACK_AUTH_TOKEN` environment variable with your LocalStack Pro auth token
3. Start LocalStack:
   ```bash
   docker-compose up -d
   ```
4. Wait for LocalStack to be fully started (about 30 seconds)
5. Confirm you see this in the output:
  ```shell
  localstack-1  | 2024-12-19T15:36:45.806  INFO --- [  MainThread] l.p.c.b.licensingv2        : Successfully requested and activated new license 1ee0f20e-b315-4b3d-8328-9ef774723714:pro 🔑✅
  ```
6. Run test:
   ```bash
   ./test.sh
   ```

## Expected Behavior
After configuring the chaos fault, all S3 operations should fail.

## Actual Behavior
The S3 operations continue to work successfully despite the configured fault. You can verify the
fault configuration is set by checking the GET response from the chaos API endpoint, but the
configuration appears to have no effect on S3 operations.

```shell
❯ ./test.sh
Creating test bucket...
make_bucket: test-bucket

Verifying bucket exists...
2024-12-19 10:38:30 test-bucket

Configuring chaos fault for all S3 operations...
[{"service": "s3", "probability": 1.0}]
Verifying fault configuration...
[{"service": "s3", "probability": 1.0}]
Trying multiple S3 operations that should all fail:
1. Listing buckets...
2024-12-19 10:38:30 test-bucket
2. Creating another bucket...
make_bucket: test-bucket-2
3. Putting an object...
upload: ./test.txt to s3://test-bucket/test.txt
4. Getting an object...
download: s3://test-bucket/test.txt to ./test2.txt
```
