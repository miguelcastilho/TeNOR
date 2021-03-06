#
# TeNOR - NS Monitoring Repository
#
# Copyright 2014-2016 i2CAT Foundation, Portugal Telecom Inovação
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# @see OrchestratorNsMonitoring
class OrchestratorNsMonitoring < Sinatra::Application

	# @method get_ns-monitoring
	# @overload get '/ns-monitoring/:instance_id/monitoring-data/'
	#	Returns all monitored data
	get '/ns-monitoring/:instance_id/monitoring-data/' do
	    t = []

	    if params[:metric] && !params[:start]
	      @db.execute("SELECT metricName, date, unit, value FROM nsmonitoring WHERE instanceid='#{params[:instance_id].to_s}' AND metricname='#{params[:metric].to_s}' LIMIT 100").fetch { |row| t.push(row.to_hash) }
	    elsif params[:metric] && params[:start] &&  !params[:end]
	        @db.execute("SELECT metricName, date, unit, value FROM nsmonitoring WHERE instanceid='#{params[:instance_id].to_s}' AND metricname='#{params[:metric].to_s}' AND date >= #{params[:start]} ").fetch { |row| t.push(row.to_hash) }
	    elsif params[:metric] && params[:start] &&  params[:end]
	      @db.execute("SELECT metricName, date, unit, value FROM nsmonitoring WHERE instanceid='#{params[:instance_id].to_s}' AND metricname='#{params[:metric].to_s}' AND date >= #{params[:start]} AND date <= #{params[:end]}").fetch { |row| t.push(row.to_hash) }
	    else
	      @db.execute("SELECT metricName, date, unit, value FROM nsmonitoring WHERE instanceid='#{params[:instance_id].to_s}'").fetch { |row| t.push( row.to_hash ) }
	    end

		return t.to_json
	end

	# @method get_ns-monitoring
	# @overload get '/ns-monitoring/:instance_id/?:metric/last100/'
	# Returns last 100 values
	get '/ns-monitoring/:instance_id/monitoring-data/last100/' do
		t = []
		@db.execute("SELECT metricName, date, unit, value FROM nsmonitoring WHERE instanceid='#{params[:instance_id].to_s}' AND metricname='#{params[:metric].to_s}' ORDER BY metricname DESC LIMIT 100").fetch { |row| t.push(row.to_hash) }
		return t.to_json
	end

	# @method post_ns-monitoring
	# @overload post '/ns-monitoring/:instance_id'
	# Inserts monitoring data
	post '/ns-monitoring/:instance_id' do
		#@json = JSON.parse(request.body.read)
		mData = JSON.parse(request.body.read)
		#@json.each do |item|
			@db.execute("INSERT INTO nsmonitoring (instanceid, date, metricname, unit, value) VALUES ('#{params[:instance_id].to_s}', #{mData['timestamp']}, '#{mData['type']}', '#{mData['unit']}', '#{mData['value']}' )")
		#end
	end
end