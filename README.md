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
### 1: Create SNS topic
You need create SNS topic and use the arn at step3.

### 2: Create SQS
You need create SQS and the subscribe the SNS topic at step2

※ [you can select endpoints other than SQS.](https://docs.aws.amazon.com/sns/latest/api/API_Subscribe.html).

### 3: SNS client setting

`settings.local.yml`

```
aws:
  access_key_id: YOUR_ACCESS_KEY_ID
  secret_access_key: YOUR_SECRET_ACCESS_KEY
  region: YOUR_SNS_RESOURCE_REGION
  sns_topic_arn: YOUR_SNS_TOPIC_ARN
```

### 4: application
```
$ docker-compose build
$ docker-compose run app bundle install
$ docker-compose run app rails db:setup
$ docker-compose up
```

## Reference
- [Pattern: Transactional outbox](https://microservices.io/patterns/data/transactional-outbox.html)
