class NewsfeedSettings < ActiveRecord::Base
  self.primary_key = "id"

  attr_accessor :start_date
  attr_accessor :end_date
  attr_accessor :tag
end
