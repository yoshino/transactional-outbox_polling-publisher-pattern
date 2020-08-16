class PollingPublisher
  SNS_TOPIC_ARN = Settings.aws.sns_topic_arn

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

  private

  def topic
    @topic ||= begin
      sns = Aws::SNS::Resource.new(client: sns_client)
      sns.topic(SNS_TOPIC_ARN)
    end
  end

  def sns_client
    Aws::SNS::Client.new(
      access_key_id: Settings.aws.access_key_id,
      secret_access_key: Settings.aws.secret_access_key,
      region: Settings.aws.region
    )
  end
end
