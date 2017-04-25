class AwsmaWorker
  include Sidekiq::Worker

  def perform(client_id, events)
    puts ">>>>>> Now Sending: #{client_id} => #{events.first["session_id"]}, Event Count: #{events.count}"
    app_title = "Team App"
    app_package_name = "com.ta.team_app"

    client = AwsmaClient.get_client

    result = client.report_events(client_id, app_title, app_package_name, events)

    puts result

    result
  end
end
