# spec/features/slas_spec.rb
require_relative '../spec_helper'

describe 'Root Path' do
  describe 'GET /sla-enforcement' do
    before { get '/sla-enforcement/slas' }

    it 'is successful' do
      expect(last_response.status).to eq 200
    end
  end
end

#Sla.create(:description => 'A wonderful idea!')
#get '/'
#expected = "[{\"id\":1,\"description\":\"A wonderful idea!\"}]"
#assert_equal expected, last_response.body
