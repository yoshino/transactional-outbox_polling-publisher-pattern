# README
## Pattern: transactional outbox + polling-publisher
This pattern solves the difficulty of atomic operation betwen Relational Database and Event in Microservice Archtecture.

![outbox](https://user-images.githubusercontent.com/17586662/90325923-c0d12880-dfbc-11ea-865d-f6883416f07a.png)

You can use outbox table for the asynchronous event process.

- 1. insert data to orders and outbox tables in transaction process.
- 2. polling worker publishs a event by reading the record from outbox table.
- 3. the outbox record is deleted.


### transactional outbox example

When creating a order, you can use the transaction.

```ruby
  order = Order.new(order_params)

  if order.valid?
    ActiveRecord::Base.transaction do
      order.save
      order.order_events.create(event_type: 'post_order', order_status: order.status)
    end
  else....
```

### polling publisher example

Polling worker can publish a event from the outbox table.

After publishing, you can delete the outbox record.

```ruby
  # polling method vs publish method with cron(schedule job) make the trade-off about the cost and speed.
  def polling
    while true do
      publish
    end
  end

  def publish
    OrderEvent.all.each do |event|
      message_id = topic.publish(message: event.message.to_json)
      event.destroy! if message_id # because the order id is unique, client can handle the situation of the DB error.
    end
  end
```

## Setup
![pattern](https://user-images.githubusercontent.com/17586662/90975437-21d59f00-e56f-11ea-8b66-5aa68305f0de.png)

### 1: terraform
create aws resources(SNS and SQS).

```
$ cd terrafrom
$ terraform init
$ terraform plan
$ terraform apply
```


### 2: application
setup ENV.

```
$ touch config/settings.local.yml
```

```
aws:
  access_key_id: YOUR_ACCESS_KEY_ID
  secret_access_key: YOUR_SECRET_ACCESS_KEY
  region: YOUR_SNS_RESOURCE_REGION
  sns_topic_arn: YOUR_SNS_TOPIC_ARN
```

※ sns_topic_arn: arn:aws:sns:<YOUR_REGION>:<YOUR_ACCOUNT_ID>:OrderChanged


build and run application.

```
$ docker-compose build
$ docker-compose run app rails db:setup
$ docker-compose up
```

## Test
### 1: request POST /orders
- 1-1: create Order
- 1-2: create OrderEvent

### 2: polling worker publish the Event
- 2-1: polling worker publish the event to SNS form OrderEvent record
- 2-2: polling worker destroy the OrderEvent record

### 3: Another Service can use the event data by SQS
you can see the SQS message of the event in AWS console.



## Reference
- [Pattern: Transactional outbox](https://microservices.io/patterns/data/transactional-outbox.html)
