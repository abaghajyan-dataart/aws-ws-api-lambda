This terraform configuration will create

DynamoDB
DynamoDB Items
Lambda
APIGateway

How to use

Set aws region and account id variables

then run
```
terraform init
terraform plan
terraform apply
```
After deployment finishing you can make connect to websocket.
wss url will be shown after terraform apply as output
wscat example

    wscat -c wss://url
    
Send as body
    
    { "action":"getword" }