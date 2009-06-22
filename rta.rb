#!/usr/bin/env ruby

class TimeKeeper
  def initialize cl
    @checklist = cl
    @record = []
  end
  
  def start
    @start = Time.now
  end

  def top
    @checklist[0]
  end

  def check
    elapsed = Time.now - @start
    @record.push [@checklist.shift, elapsed]
    elapsed
  end

  attr_reader :record
end

class Controller
  def initialize
    @keeper = TimeKeeper.new parse ARGF.read
  end
  
  def ready
    puts 'Ready?'
    $stdin.gets
    puts 'Start!'
    start
  end

  private
  def start
    @keeper.start

    while top = @keeper.top
      print top
      $stdin.gets
      fmt = ftime_format @keeper.check
      puts "\t#{fmt}"
    end
    
    output
  end

  def parse src
    src.split "\n"
  end

  def ftime_format ftime
    int = ftime.truncate
    sec = int % 60
    min = ((int - sec) / 60) % 60
    hr = (int - min * 60 - sec) / 3600
    format "%02d:%02d:%02d", hr, min, sec
  end

  def printrecord rec
    checkpoint = rec[0]
    time = ftime_format rec[1]
    "#{checkpoint}\t#{time}"
  end
    
  def outfilename
    ARGF.filename + '.out'
  end

  def output
    open outfilename, 'w' do |f|
      @keeper.record.each do |r|
        f.puts printrecord r
      end
    end
  end
end

Controller.new.ready
