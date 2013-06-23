#!/usr/bin/env ruby
STDOUT.sync = true
# vim: ft=ruby ts=2 sts=2 sw=2 et ai
# -*- Mode: ruby; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-

require 'bundler/setup'
require 'dbus'
require 'restclient'

# Get system bus
system_bus = DBus::SystemBus.instance

# Get the NetworkManager service
nm_service = system_bus.service("org.freedesktop.NetworkManager")

# Get the object from the service
nm_object = nm_service.object("/org/freedesktop/NetworkManager")

# Set default interface for the object
nm_object.default_iface = "org.freedesktop.NetworkManager"
#nm_object.default_iface = "org.freedesktop.NetworkManager.AccessPoint"

# Introspect it
nm_object.introspect

nm_object.on_signal('PropertiesChanged') do |e|
  puts "PropertiesChanged #{e}"
end
nm_object.on_signal('StateChanged') do |e|
  if e == 70
    puts 'StateChanged #{e} RestClient.post "https://donpark.org/canary"'
    RestClient.post "https://donpark.org/canary", {:now => Time.now}
  end
end

# Disconnect
# {"State"=>40, "ActiveConnections"=>["/org/freedesktop/NetworkManager/ActiveConnection/7"]}
# {"State"=>20, "ActiveConnections"=>[]}
# {"ActiveConnections"=>[]}
# Reconnect
# {"State"=>40, "ActiveConnections"=>["/org/freedesktop/NetworkManager/ActiveConnection/8"]}
# {"ActiveConnections"=>["/org/freedesktop/NetworkManager/ActiveConnection/8"]}
# {"State"=>70}
#NM_STATE_DISCONNECTED = 20 There is no active network connection. 
#NM_STATE_CONNECTING = 40 A network device is connecting to a network and there is no other available network connection. 
#NM_STATE_CONNECTED_GLOBAL = 70 A network device is connected, with global network connectivity. 

puts "Listening..."
loop = DBus::Main.new
loop << system_bus
loop.run

