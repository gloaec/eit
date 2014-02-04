require 'net/ftp'

class Program < ActiveRecord::Base
  belongs_to :channel
  has_many :events
  has_many :program_errors, foreign_key: "program_id",  class_name: "ProgramError"
  has_many :dangers,   -> { where classname: 'danger' }, class_name: 'ProgramError'
  has_many :warnings, -> { where classname: 'warning' }, class_name: 'ProgramError'
  has_attached_file :xml
  accepts_nested_attributes_for :events, allow_destroy: true

  def xml_file
    @xml_file ||=
      if self.dangers.any?
        File.join self.channel.error_path, self.xml_file_name
      else
        File.join self.channel.queue_path, self.xml_file_name
      end
  end

  def transfer
    ftp, results = nil, {}
    self.channel.channel_ftps.each do |cf|
      f = cf.ftp
      remote_path = cf.success_path #"/NRJ" #f.root_path

      p "   Transferring to #{f.user}@#{f.host}:#{remote_path}..."

      begin 
        ftp = Net::FTP.new
        ftp.passive = f.passive || false
        ftp.connect(f.host, f.port) 
        ftp.login f.user, f.password
        
        files = ftp.chdir(remote_path)
        files = ftp.list
        #p files
        ftp.put(@xml_file)
        ftp.quit
        #results[f.id] = true
      #rescue
      #  results[f.id] = false
      ensure
        ftp.close unless ftp.nil?
      end
    end
    results
  end

  def validate

    f, doc = nil
    self.xml_file

    begin
      f = File.open(@xml_file)
      doc = Nokogiri::XML(f)
    rescue Exception => e
      p "Exception #{e}"                 
      self.dangers.build(
        :classname => 'danger',
        :code => ProgramError::OTHER,
        :msg => "#{e}",
        :line => nil
      )
    end
 
    begin
      if doc.errors.any?
        doc.errors.each do |error|
          self.dangers.build(
            :classname => 'danger',
            :code => ProgramError::OTHER,
            :msg => "#{error}",
            :line => error.line
          )
        end
      else
        end_at = nil
        position = 0
        before_event = nil
        events = doc.css("EVENT")
        service = doc.css("SERVICE").first

        self.start_at = Time.parse(service['start_time']) unless service.nil?

        events.each do |event|
 
          position+=1
          name_node = event.css("NAME").first
          name = unless name_node.nil? then name_node.content else nil end
          description_node = event.css("DESCRIPTION").first
          description = unless description_node.nil? then description_node.content else nil end
          minimum_age_node = event.css("PARENTAL_RATING").first
          minimum_age = unless minimum_age_node.nil? then minimum_age_node['minimum_age'] else nil end
          start_at = Time.parse(event['time'])
          prev_end_at = end_at
          timegap = TimeDifference.between(prev_end_at, start_at).in_general unless end_at.nil?
          gap = timegap[:hours].to_i.hours + timegap[:minutes].to_i.minutes + timegap[:seconds].to_i.seconds unless timegap.nil?
          duration = Time.parse(event['duration'])
          durationgap = duration.hour.hours + duration.min.minutes + duration.sec.seconds
          end_at = start_at + durationgap
          self.end_at = end_at if event == events.last

          event_node = event 

          event = self.events.build(
            name: name,
            description: description,
            minimum_age: minimum_age,
            start_at: start_at,
            end_at: end_at,
            position: position
          )

          if durationgap.nil?
          elsif durationgap <= 0 or
                (durationgap < self.channel.min_duration_error and self.channel.min_duration_error > 0) or
                (durationgap > self.channel.max_duration_error and self.channel.max_duration_error > 0)
            self.dangers.build(
              before_event: event,
              after_event:  event,
              code:         ProgramError::DURATION_ERROR,
              msg:          "Incorrect event duration",
              line:         event_node.line
            )
          elsif (durationgap < self.channel.min_duration_warning and self.channel.min_duration_warning > 0) or
                (durationgap > self.channel.max_duration_warning and self.channel.max_duration_warning > 0)
            self.warnings.build(
              before_event: event,
              after_event:  event,
              code:         ProgramError::DURATION_WARNING,
              msg:          "Incorrect event duration",
              line:         event_node.line
            )
          end

          if gap.nil?
          elsif gap <= 0 or
                (gap < self.channel.min_gap_error and self.channel.min_gap_error > 0) or
                (gap > self.channel.max_gap_error and self.channel.max_gap_error > 0)
            self.dangers.build(
              before_event: event,
              after_event:  event,
              code:         ProgramError::GAP_ERROR,
              msg:          "Incorrect time gap",
              line:         event_node.line
            )
          elsif (durationgap < self.channel.min_gap_warning and self.channel.min_gap_warning > 0) or
                (durationgap > self.channel.max_gap_warning and self.channel.max_gap_warning > 0)
            self.warnings.build(
              before_event: event,
              after_event:  event,
              code:         ProgramError::GAP_WARNING,
              msg:          "Incorrect time gap",
              line:         event_node.line
            )
          end

          #elsif gap == 0
          #  self.dangers.build(
          #    before_event: before_event,
          #    after_event:  event,
          #    code:         ProgramError::GAP_ERROR,
          #    msg:          'No time gap',
          #    line:         event_node.line
          #  )
          #elsif gap.to_i > 3600
          #  self.dangers.build(
          #    before_event: before_event,
          #    after_event:  event,
          #    :code => ProgramError::ERROR_GAP,
          #    :msg => 'Time gap error',
          #    :line => event_node.line
          #  )
          #elsif gap > 600
          #  self.warnings.build(
          #    before_event: before_event,
          #    after_event:  event,
          #    :code => ProgramError::WARNING_GAP,
          #    :msg => 'Long time gap',
          #    :line => event_node.line
          #  )
          #end 

          before_event = event

          #p "------------------------------------"
          #p "  timegap  : #{timegap[:hours].to_i}:#{timegap[:minutes].to_i}:#{timegap[:seconds].to_i}" unless timegap.nil?
          #p "  seconds  : #{gap}"
          #p "===================================="
          #p "#{name}:" 
          #p "===================================="
          #p "  start    : #{start_at.strftime("%d/%m/%Y %H:%M:%S")}"
          #p "  duration : #{duration.hour}:#{duration.min}:#{duration.sec}"
          #p "  end      : #{end_at.strftime("%d/%m/%Y %H:%M:%S")}"
        end

      end
    rescue Exception => e
      p "Exception #{e}"                 
      self.dangers.build(
        :classname => 'danger',
        :code => ProgramError::OTHER,
        :msg => "#{e}",
        :line => nil#e.line
      )
    ensure
      #p "LOADED : #{self.errors.loaded?}"
      self.save
    end 

    p "   [#{self.dangers.any? ? 'ERROR' : 'SUCCESS'}] #{self.dangers.count} errors / #{self.dangers.count} warnings detected"

    if self.dangers.any?
      p "   Moving to #{self.channel.error_path}..."
      FileUtils.mv @xml_file, self.channel.error_path
    else 
      self.transfer
      FileUtils.rm @xml_file
    end

    f.close
    
  end

end
