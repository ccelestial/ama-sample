class AwsmaClient
  protected

  @@events = {}

  public

  def self.get_client
    @client ||= self.new.get_client
  end

  def initialize
    awsma = Rails.application.awsma

    @client = AwsmaRails::Reporter.new(
        awsma[:url],
        awsma[:app_id],
        awsma[:identity_pool_id])
  end

  def get_client
    @client
  end

  def self.add_event(client_id, session_id, event_name, attributes, metrics)
    @@events["#{client_id}:#{session_id}"] ||= []

    new_event = {
        'client_id' => client_id,
        'session_id' => session_id,
        'event_name' => event_name,
        'attributes' => attributes,
        'metrics' => metrics
    }

    @@events["#{client_id}:#{session_id}"] << new_event

    if @@events["#{client_id}:#{session_id}"].count >= 10
      self.send_to_analytics(client_id, @@events["#{client_id}:#{session_id}"])
      @@events.except!("#{client_id}:#{session_id}")
    end

    new_event
  end

  def self.events
    @@events
  end

  private

  def self.send_to_analytics(client_id, events)
    AwsmaWorker.perform_async(client_id, events)
  end
end