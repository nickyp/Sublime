#!/usr/bin/env ruby
require 'fileutils'

def go_go_power_rangers
  destination = File.expand_path("~/Library/Application\ Support/Sublime\ Text\ 2/") # expands ~

  directories = detect_directories
  directories.each {|dir|
    symlink_directory(destination, dir)
  }
end

def detect_directories
  dirs = Dir.glob("*").delete_if {|entry| File.stat(entry).file? } 
  puts "Directories found: #{dirs.join(", ")}"

  dirs
end

def symlink_directory(destination, directory)
  source = File.join(File.expand_path("."), directory)
  destination = File.join(destination, directory)
  
  if entry_exists_and_is_symlink?(destination)
    FileUtils.ln_sf(source, destination)
    puts "Updated symlink #{destination} to: #{source}"
  elsif entry_does_not_exist?(destination)
    File.symlink(source, destination)
    puts "Created symlink #{destination} to: #{source}"
  else entry_exists_and_is_not_symlink?(destination)
    puts "Won't symlink: #{destination} exists and isn't a symlink. Move it out of the way first."
  end
end

def entry_exists_and_is_not_symlink?(entry)
  File.exists?(entry) && !File.symlink?(entry)
end

def entry_exists_and_is_symlink?(entry)
  File.exists?(entry) && File.symlink?(entry)
end

def entry_does_not_exist?(entry)
  File.exists?(entry) == false
end

go_go_power_rangers
