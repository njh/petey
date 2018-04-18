Petey: Push To Talk
===================

Requirements: Ruby 2.0 and PulseAudio

Petey is a script for sending short audio messages over MQTT.

Press the space bar button to record a short audio message,
which is then sent to all the other people running petey.
They will then all hear the message as soon as the message has been received.
You can also send oinks.


Installing
----------

On Mac OS X:

    brew install rbenv ruby-build pulseaudio
    rbenv install 2.1.2
    bundle install

On Debian Linux:

    apt-get install pulseaudio pulseaudio-utils
    bundle install


Running
-------

    $ ruby petey.rb
    Welcome to Petey!
    space: Record Sound
        o: Send Oink
        q: Quit


Setting up PulseAudio on Mac OS X
---------------------------------

I found that Pulse audio was not using the 'Built In' inputs and outputs by default on my MacBook.

I resolved this by getting a list of the outputs using:

    pactl list sinks

Then select the corresponding Sink number using:

    pacmd set-default-sink 1

The same can be done for the source using:

    pactl list sources
    pacmd set-default-source 1



Oink
----

The Oink sound effect came from:
http://soundbible.com/1221-Pig-Oink.html

License: Creative Commons Attribution 3.0
Recorded by: Mike Koenig

It was created using:

    sox oink.wav -e a-law -c 1 -r 8000 -t raw oink.alaw

