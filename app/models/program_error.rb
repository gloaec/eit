class ProgramError < ActiveRecord::Base
  belongs_to :program
  belongs_to :before_event, class_name: 'Event'
  belongs_to :after_event, class_name: 'Event'

  OTHER = -1
  NO_GAP = 1
  WARNING_GAP = 2
  ERROR_GAP = 3
end
