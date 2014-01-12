class Program < ActiveRecord::Base
  belongs_to :channel
  has_many :events
  has_many :errors, class_name: "ProgramError", foreign_key: "program_id"
  has_attached_file :xml
end
