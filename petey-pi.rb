#!/usr/bin/env ruby

require 'mqtt'
require 'pi_piper'

username = ENV['USER'] || 'anonymous'
client = MQTT::Client.connect('test.mosquitto.org')

STDOUT.sync = true
puts "Welcome to Petey Pi!"
puts "Type Ctrl-C to exit"
puts

PiPiper.watch :pin => 11, :trigger => :rising , :pull => :down do
  audio = IO.popen('parec --raw --format=alaw --channels=1 --rate=8000', 'rb') do |parec|
    pin = PiPiper::Pin.new(:pin => 11, :direction => :in, :pull => :down)
    pin.wait_for_change
    Process.kill('TERM', parec.pid)
    parec.read
  end
  
  client.publish("petey/#{username}/audio", audio)
end

PiPiper.wait

client.disconnect
