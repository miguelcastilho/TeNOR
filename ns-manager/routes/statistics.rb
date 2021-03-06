#
# TeNOR - NS Manager
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
# @see TnovaManager
class TnovaManager < Sinatra::Application

  get '/statistics' do
    return StatisticModel.all.to_json
  end

  post "/statistics/:metric" do
    updateStatistics(params['metric'])
  end

  get "/performance-stats" do
    return PerformanceStatisticModel.all.to_json
  end

  post "/performance-stats" do

    body, errors = parse_json(request.body.read)

    #save instance metrics
    savePerformance(body)

  end

end