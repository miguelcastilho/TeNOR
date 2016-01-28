class Violation < ActiveRecord::Base
  belongs_to :parameter

  validates_presence_of :breaches_count, :interval
end