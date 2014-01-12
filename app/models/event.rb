class Event < ActiveRecord::Base
  belongs_to :program
  has_many :errors, class_name: "ProgramError", foreign_key: 'after_event_id'
end
