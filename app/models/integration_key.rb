class IntegrationKey < ActiveRecord::Base
  belongs_to :user
  attr_accessible :key, :source
end
