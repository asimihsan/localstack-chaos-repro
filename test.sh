#!/usr/bin/env bash

set -euo pipefail

export AWS_ACCESS_KEY_ID=foo
export AWS_SECRET_ACCESS_KEY=bar

echo "Creating test bucket..."
aws --endpoint-url=http://localhost:4566 --region us-east-1 s3 mb s3://test-bucket

echo -e "\nVerifying bucket exists..."
aws --endpoint-url=http://localhost:4566 --region us-east-1 s3 ls

echo -e "\nConfiguring chaos fault for all S3 operations..."
curl --location --request POST 'http://localhost.localstack.cloud:4566/_localstack/chaos/faults' \
--header 'Content-Type: application/json' \
--data '[{"service": "s3", "probability": 1.0}]'

echo -e "\nVerifying fault configuration..."
curl --location --request GET 'http://localhost.localstack.cloud:4566/_localstack/chaos/faults'

echo -e "\nTrying multiple S3 operations that should all fail:"
echo "1. Listing buckets..."
aws --endpoint-url=http://localhost:4566 --region us-east-1 s3 ls

echo "2. Creating another bucket..."
aws --endpoint-url=http://localhost:4566 --region us-east-1 s3 mb s3://test-bucket-2

echo "3. Putting an object..."
echo "test" > test.txt
aws --endpoint-url=http://localhost:4566 --region us-east-1 s3 cp test.txt s3://test-bucket/

echo "4. Getting an object..."
aws --endpoint-url=http://localhost:4566 --region us-east-1 s3 cp s3://test-bucket/test.txt ./test2.txt

# Clean up
rm -f test.txt test2.txt
