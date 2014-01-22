class Program < ActiveRecord::Base
  belongs_to :channel
  has_many :events
  has_many :program_errors, foreign_key: "program_id",  class_name: "ProgramError"
  has_many :errors,   -> { where classname: 'danger' }, class_name: 'ProgramError'
  has_many :warnings, -> { where classname: 'warnings' }, class_name: 'ProgramError'
  has_attached_file :xml

  #accepts_nested_attributes_for :errors
  #accepts_nested_attributes_for :warnings

  #def errors
  #  self.program_errors.where(classname: 'danger')
  #end

  #def warnings
  #  self.program_errors.where(classname: 'warning')
  #end
end
