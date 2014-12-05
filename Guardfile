# A sample Guardfile
# More info at https://github.com/guard/guard#readme
#
#
directories %w(channels)
guard 'rake', :task => :validate do
  watch(%r{^channels\/(.+)\.xml$})
end
