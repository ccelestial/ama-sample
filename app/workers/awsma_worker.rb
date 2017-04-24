class AwsmaWorker
  include Sidekiq::Worker

  def perform(client_id, session_id, event_name)
    app_title = "Team App"
    app_package_name = "com.ta.team_app"

    attributes = {}
    metrics = {}

    client = AwsmaClient.get_client

    result = client.report_event(client_id,
                        session_id,
                        app_title,
                        app_package_name,
                        event_name,
                        attributes,
                        metrics)

    puts result

    result
  end
end
