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

  args.paths.each do |path|
 
    channel_id = File.basename(File.dirname(path)).to_i
    channel = Channel.find(channel_id)
    f, doc, program = nil

    p "#{channel.name} => #{path}"

    begin
      f = File.open(path)
      doc = Nokogiri::XML(f)
    rescue Exception => e
      p "Exception #{e}"                 
    end

    program = channel.programs.create(
      xml: f
    )

    if doc.errors.any?
      doc.errors.each do |error|
        program.errors.create(
          :classname => 'danger',
          :code => ProgramError::OTHER,
          :msg => "#{error}",
          :line => error.line
        )
      end
    else
      end_time = nil
      position = 0
      before_event = nil
      events = doc.css("EVENT")
      events.each do |event|
 
        position+=1
        name_node = event.css("NAME").first
        name = unless name_node.nil? then name_node.content else nil end
        description_node = event.css("DESCRIPTION").first
        description = unless description_node.nil? then description_node.content else nil end
        minimum_age_node = event.css("PARENTAL_RATING").first
        minimum_age = unless minimum_age_node.nil? then minimum_age_node['minimum_age'] else nil end
        start_time = Time.parse(event['time'])
        prev_end_time = end_time
        timegap = TimeDifference.between(prev_end_time, start_time).in_general unless end_time.nil?
        gap = timegap[:hours].to_i.hours + timegap[:minutes].to_i.minutes + timegap[:seconds].to_i.seconds unless timegap.nil?
        duration = Time.parse(event['duration'])
        end_time = start_time + duration.hour.hours + duration.min.minutes + duration.sec.seconds

        event_node = event 

        event = program.events.create(
          name: name,
          description: description,
          minimum_age: minimum_age,
          start_time: start_time,
          end_time: end_time,
          position: position
        )
 
        if gap.nil?
        elsif gap == 0
          event.errors.create(
            :program_id => program.id,
            :before_event_id => before_event.id,
            :classname => 'danger',
            :code => ProgramError::NO_GAP,
            :msg => 'No time gap',
            :line => event_node.line
          )
        elsif gap.to_i > 300
          event.errors.create(
            :program_id => program.id,
            :before_event_id => before_event.id,
            :classname => 'danger',
            :code => ProgramError::ERROR_GAP,
            :msg => 'Time gap error',
            :line => event_node.line
          )
        elsif gap > 120
          event.errors.create(
            :program_id => program.id,
            :before_event_id => before_event.id,
            :classname => 'warning',
            :code => ProgramError::WARNING_GAP,
            :msg => 'Long time gap',
            :line => event_node.line
          )
        end 

        before_event = event

        p "------------------------------------"
        p "  timegap  : #{timegap[:hours].to_i}:#{timegap[:minutes].to_i}:#{timegap[:seconds].to_i}" unless timegap.nil?
        p "  seconds  : #{gap}"
        p "===================================="
        p "#{name}:" 
        p "===================================="
        p "  start    : #{start_time.strftime("%d/%m/%Y %H:%M:%S")}"
        p "  duration : #{duration.hour}:#{duration.min}:#{duration.sec}"
        p "  end      : #{end_time.strftime("%d/%m/%Y %H:%M:%S")}"
      end

    end
    f.close
  end
end
