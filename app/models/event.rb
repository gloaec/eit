class Event < ActiveRecord::Base
  belongs_to :program
  has_many :program_errors, class_name: "ProgramError", foreign_key: 'before_event_id'
  has_many :duration_errors,   -> { where code: ProgramError::DURATION_ERROR }, class_name: 'ProgramError'
  has_many :duration_warnings, -> { where code: ProgramError::DURATION_WARNING }, class_name: 'ProgramError'
end
