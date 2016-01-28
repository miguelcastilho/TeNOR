class Sla < ActiveRecord::Base
  has_many :parameters, dependent: :destroy

  validates_presence_of :nsi_id

  def has_parameter?(param_id)
    self.parameters.select {|parameter| parameter[:parameter_id] == param_id}
  end

  def process_reading(reading)
    parameter = Parameter.where("sla_id = ? AND external_parameter_id = ?", self.id, reading.parameter_id).first
    unless parameter.nil?
      if (reading.value > parameter.maximum || reading.value < parameter.minimum)
        @breach = process_breach reading
      else
        @breach = process_no_breach reading
      end
    end
    @breach
    # TODO: the above is instant processing, must process along a time-interval
  end

  private

  #begin
  #	response = RestClient.post settings.ns_instance_repository + '/ns-instances', instance.to_json, :content_type => :json
  #rescue => e
  #	logger.error e
  #	if (defined?(e.response)).nil?
  #		halt 503, "NS-Instance Repository unavailable"
  #	end
  #	halt e.response.code, e.response.body
  #end
  def process_breach(reading)
    store_breach reading
    notify_ns_manager @breach
  end

  def store_breach(reading)
    puts "In Sla#store_breach: #{reading.inspect}"
    @breach = Breach.create(nsi_id: self.nsi_id, external_parameter_id: reading.parameter_id, value: reading.value)
  end

  def process_no_breach(reading)
    #store_breach reading
    self
  end

  def notify_ns_manager(breach)
    self
  end
end