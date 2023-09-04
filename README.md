# API-Deployement-AWS
Deploying container based Api's in serverless AWS services

# ARCHITECTURE:
![image](https://github.com/XI2879/API-Deployement-AWS/assets/91110151/d1d61d79-58ab-4c5e-9118-458c8dc3a6e9)

# 1. Amazon Cognito User Pools: 
This will be used for user authentication in our 
APIs. When the user makes a request, he/she will need to authenticate 
using Cognito and a JWT token will be granted on successful authentication. 
This token will be used for authorizing requests to our APIs.
# 2. API Gateway: 
API Gateway HTTP APIs will be used for exposing the 
containerized APIs to the user. In this API, private integrations will point to 
AWS Cloud Map, which then resolves to ECS. API gateway will perform the 
request authentication & authorization.
# 3. AWS CloudMap:
Cloud Map will be used for service discovery of the 
containerized service. ECS will perform periodic health checks on tasks and 
register the healthy tasks to the Cloud Map service.
# 4. Amazon ECS: 
ECS Fargate will be used for hosting the containerized service 
in a serverless manner.


