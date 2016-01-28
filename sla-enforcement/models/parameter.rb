class Parameter < ActiveRecord::Base
  belongs_to :sla
  has_many :violations, dependent: :destroy

  validates_presence_of :name, :value, :formula
end