#!/usr/bin/env ruby

require 'mqtt'
require 'io/console'

username = ENV['USER'] || 'anonymous'
client = MQTT::Client.connect('test.mosquitto.org')


# Fix for using STDIN.getch at same time
def puts(str='')
  STDOUT.print("#{str}\n\r")
end

def while_pressing_space
  loop do
    keypress = begin
      Timeout::timeout(1) { STDIN.getch }
    rescue Timeout::Error
      nil
    end
    break if keypress != ' '
  end
end

def record_audio
  IO.popen('parec --raw --format=alaw --channels=1 --rate=8000', 'rb') do |parec|
    while_pressing_space
    Process.kill('TERM', parec.pid)
    parec.read
  end
end

# Create a seperate thread, that deals with playing the audio
receive = Thread.new do
  client.get('petey/+/audio') do |topic,message|
    puts "Got audio from #{topic}."
    IO.popen('paplay --raw --format=alaw --channels=1 --rate=8000', 'wb') do |paplay|
      paplay.write(message)
    end
  end
end




STDOUT.sync = true
puts "Welcome to Petey!"
puts "space: Record Sound"
puts "    o: Send Oink"
puts "    q: Quit"
puts

loop do
  keypress = STDIN.getch

  case keypress
    when nil, 'q', "\u0003"
      break
    when ' '
      client.publish("petey/#{username}/audio", record_audio)
      puts "Sent!"
    when 'o'
      client.publish("petey/#{username}/audio", File.read('oink.alaw'))
  end
end

client.disconnect
