require 'nokogiri'

task :validate, :paths do |t, args|
  p 'rake validate', args.paths

  args.paths.each do |path|
    f = File.open(path)
    doc = Nokogiri::XML(f)
    p doc.errors
    events = doc.css("EVENT")
    endtime = nil
    events.each do |event|
      name = event.css("NAME").first.content
      starttime = Time.parse(event['time'])
      prev_endtime = endtime
      timegap = TimeDifference.between(prev_endtime, starttime).in_general unless endtime.nil?
      duration = Time.parse(event['duration'])
      endtime = starttime + duration.hour.hours + duration.min.minutes + duration.sec.seconds

      p "------------------------------------"
      p "  gap      : #{timegap[:hours].to_i}:#{timegap[:minutes].to_i}:#{timegap[:seconds].to_i}" unless timegap.nil?
      p "===================================="
      p "#{name}:" 
      p "===================================="
      p "  start    : #{starttime.strftime("%d/%m/%Y %H:%M:%S")}"
      p "  duration : #{duration.hour}:#{duration.min}:#{duration.sec}"
      p "  end      : #{endtime.strftime("%d/%m/%Y %H:%M:%S")}"
    end
    f.close
  end
end
