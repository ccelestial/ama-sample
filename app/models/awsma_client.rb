class AwsmaClient
  def self.get_client
    @client ||= self.new.get_client
  end

  def initialize
    awsma = Rails.application.awsma
    puts ">>>>> This is the Client"
    puts @client

    @client = AwsmaRails::Reporter.new(
        awsma[:url],
        awsma[:app_id],
        awsma[:identity_pool_id])
  end

  def get_client
    @client
  end
end