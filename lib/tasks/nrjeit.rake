require 'nokogiri'

namespace :db do
  desc "Database Re-Install"
  task :install do  
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
  end
end 

desc "Validate new XML files"

task :validate, [:paths] => :environment do |t, args|

  puts "Executing 'rake validate[#{args.paths.join ', '}]'"

  args.paths.each do |path|
 
    next unless File.exists? path
    next unless File.extname(path) == ".xml"
    
    p "Processing #{path}..."

    # Wait for file to be transferred
    filesize = -1
    retries = 0
    while filesize != File.size(path)
      filesize = File.size(path)
      sleep 1
      retries += 1
      break if retries > 10
    end

    p "> Ready !"

    f, program, channel = nil
    channel_id = File.basename(File.dirname(path)).to_i
    if channel_id != 0
      channel = Channel.find(channel_id)
      p "  Channel: #{channel.name}"
    else
      p "  Channel: Not found !"
    end
 
    start_at = path.match(/_(\d+)_(\d+)_(\d+)_(\d+)_(\d+)\.xml$/) do |d|
      Time.parse("#{d[1]}/#{d[2]}/#{d[3]} #{d[4]}:#{d[5]} UTC")
    end

    chmoded = 0

    begin
      f = File.open(path)
      program = Program.find_or_create_by_xml_file_name(File.basename(path))
      program.start_at = start_at
      program.end_at = start_at
      program.program_errors.destroy_all
      program.events.destroy_all
      program.xml = f
      program.channel = channel
      program.save!
    rescue => e
      File.chmod(0755, path) rescue nil
      chmoded += 1
      retry if chmoded < 2
      puts "[Error rescued with Program] from 'rake validate' : #{e.message}"
      program.dangers.create(
        :classname => 'danger',
        :code => ProgramError::FILE,
        :msg => "#{e}",
        :line => nil
      )
    else
      begin
        program.validate
      rescue => e
        puts "[Error rescued] from 'rake validate' : #{e.message}"
      end
    end

  end
end
