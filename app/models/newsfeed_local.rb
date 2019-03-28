class NewsfeedLocal < ActiveRecord::Base
  validates_presence_of :announce
  validates_presence_of :date_created
  validates_presence_of :start_date
  validates_presence_of :end_date

  attr_accessor :template
end
