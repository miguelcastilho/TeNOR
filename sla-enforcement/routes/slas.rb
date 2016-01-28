# @see OrchestratorSlaEnforcement
class OrchestratorSlaEnforcement < Sinatra::Application

  before do
    if request.path_info == '/gk_credentials'
      return
    end

    if settings.environment == 'development'
      return
    end

    authorized?
  end

  # @method get_root
  # @overload get '/'
  #   Get all available interfaces
  #   @return [JSON] The list of all interfaces
  # Get all interfaces
  get '/' do
    logger.debug 'Interfaces list: ' + interfaces_list.to_json
    halt 200, interfaces_list.to_json
  end

  # @method post_sla-enforcement_slas
  # @overload post '/sla-enforcement/slas'
  #   Post a SLA in JSON format
  #   @param [JSON] SLA in JSON format
  #   @return [JSON] The created SLA
  # Post a SLA
  post '/sla-enforcement/slas' do
    # Return if content-type is invalid
    return 415, "Content-type must be 'application/json'.\n" unless request.content_type == 'application/json'

    # Check if request body is invalid
    parsed_body = parse_json(request.body.read)
    logger.debug 'Parsed body: ' + parsed_body.to_json

    # Create SLA object
    sla = Sla.new(nsi_id: json['nsi_id'])
    return 422, "Could not create SLA from #{request_body}.\n" unless sla

    #parameters = []
    json["parameters"].each do |parameter|
      #violations = []
      #parameter['violations'].each do |violation|
        #violations.push(Violation.new(breaches_count: violation['breaches_count'].to_i, interval: violation['interval'].to_i))
      #end
      sla.parameters << Parameter.new(parameter_id: parameter['parameter_id'], minimum: parameter['minimum'].to_i, maximum: parameter['maximum'].to_i)
      #parameters.push(Parameter.new(name: parameter['name'], minimum: parameter['minimum'].to_f, maximum: parameter['maximum'].to_f, threshold: parameter['threshold'], violations: violations))

      #TODO: calculate values
    end
    #@sla.parameters = parameters

    #TODO: deal with transactions
    #http://stackoverflow.com/questions/7965949/best-practice-for-bulk-update-in-controller
#    def update_bulk
#      @posts = Post.where(:id => params[:ids])
    #wrap in a transaction to avoid partial updates (and move to the model in any case)
#      if @posts.all? { |post| post.update_attributes(params[:post]) }
#        redirect_to(posts_url)
#      else
#        redirect_to(:back)
#      end
#    end

#    @sla.parameters.each do |parameter|
#      unless parameter.save
#        body = "Parameter #{parameter.to_json} of the SLA #{@sla.to_json} could not be saved.\n"
#        headers 'Content-Length' => body.length.to_s
#        halt 401, headers, body
#      end
#    end

    # Save object to database
    if sla.save
      headers['Location'] = "/sla-enforcement/slas/#{sla.id}"
      return 201, "The SLA #{sla.to_json} has been successfuly created.\n"
    else
      return 401, "The SLA #{sla.to_json} could not be saved.\n"
    end

  end

  # @method put_sla-enforcement_slas_id
  # @overload post '/sla-enforcement/slas/:id'
  #   Update a SLA in JSON format
  #   @param [JSON] SLA in JSON format
  #   @return [JSON] The updated SLA
  # Update a SLA
  put '/sla-enforcement/slas/:id' do
    return 501, 'Not implemented yet'

    # Return if content-type is invalid
    return 415 unless request.content_type == 'application/json'

    # Parse request body
    new_sla = parse_json(request.body.read)

    begin
      sla = Sla.find_by!(nsi_id: params[:id])
    rescue ActiveRecord::RecordNotFound => e
      return 404, "The SLA with NSI ID #{params[:id]} was not found.\n"
    end

    #TODO: Update SLA with the new values
    # sla.update(parameters: ...) or sla.parameters = ....; sla.save

    return 200, sla.to_json

    #don't forget to subscribe from the NS Monitoring module
    #TODO
  end

  # @method delete_sla-enforcement_slas_id
  # @overload delete '/sla-enforcement/slas/:id'
  #   Delete a SLA by its ID
  #   @param [Integer] id SLA ID
  #   @return [JSON] The deleted SLA
  # Delete a SLA
  delete '/sla-enforcement/slas/:id' do
    begin
      sla = Sla.find_by!(nsi_id: params[:id])
    rescue ActiveRecord::RecordNotFound => e
      return 404, "The SLA with NSI ID #{params[:id]} was not found.\n"
    end

    sla.destroy

    return 200

    #TODO
    #ubsubscribe from the NS Monitoring module
  end

  # @method get_sla-enforcement_slas
  # @overload get '/sla-enforcement/slas'
  #   Returns a list of SLAs
  #   @return [Array] An array of all the SLAs
  # List all SLAs
  get '/sla-enforcement/slas' do
    params[:offset] ||= 1
    params[:limit] ||= 2

    # Only accept positive numbers
    params[:offset] = 1 if params[:offset].to_i < 1
    params[:limit] = 2 if params[:limit].to_i < 1

    # Get paginated list
    slas = Sla.paginate(:page => params[:offset], :per_page => params[:limit])

    # Build HTTP Link Header
    headers['Link'] = build_http_link(params[:offset].to_i, params[:limit])

    return 200, slas.to_json
  end

  # @method get_sla-enforcement_slas_id
  # @overload get '/sla-enforcement/slas/:id'
  #   Show a SLA
  #   @param [Integer] id SLA ID
  #   @return [JSON] The SLA
  # Show a SLA
  get '/sla-enforcement/slas/:id' do
    begin
      sla = Sla.find_by!(nsi_id: params[:id])
    rescue ActiveRecord::RecordNotFound => e
      return 404
    end

    return 200, sla.to_json
  end
  
end