class NewsfeedImport < ActiveRecord::Base
  self.primary_key = "id"
  
  validates_presence_of :title
  # validates_presence_of :initial_title
  validates_presence_of :link
  validates_presence_of :date_created
end
