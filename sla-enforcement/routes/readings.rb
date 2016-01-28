# @see OrchestratorSlaEnforcement
class OrchestratorSlaEnforcement < Sinatra::Application

  post '/sla-enforcement/readings' do
    # Return if content-type is invalid
    return 415, "Content-type must be 'application/json'.\n" unless request.content_type == 'application/json'

    # Parse JSON body
    request_body = request.body.read
    json = parse_json(request_body)

    # Validate body message
    return 401, "Invalid request: #{request_body}.\n" unless json.has_key?("nsi_id") && json.has_key?("parameter_id") && json.has_key?("value")

		reading = Reading.new(json)

    return 401, "Invalid reading: #{reading.to_json}" unless reading.valid?

    begin
      sla = Sla.find_by!(nsi_id: reading.nsi_id)
    rescue ActiveRecord::RecordNotFound => e
      return 404, "Could not find an SLA for NS Instance ID #{reading.nsi_id}"
    end

    return 404, "It seems that parameter ID #{reading.parameter_id} is not part of the SLA for NS Instance ID #{reading.nsi_id}" unless sla.has_parameter? reading.parameter_id

    sla_breach = sla.process_reading(reading)
    if sla_breach
      return 201, sla_breach.to_s
    else
      return 422, "It seems that we could not process parameter #{reading.to_json}.\n"
    end
  end
end