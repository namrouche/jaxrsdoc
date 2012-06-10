#!/usr/bin/env ruby
require File.expand_path("../../lib/parse.rb", __FILE__)
require File.expand_path("../../lib/site.rb", __FILE__)
require 'optparse'

options = {}
optparse = OptionParser.new do |opts|
  opts.banner = "USAGE\n jaxrsdoc [-p] [-]"
  opts.separator "\nOPTIONS\n"
  
  options[:pattern] = "*Resource.java"
  opts.on( '-p', '--pattern PATTERN', 'Pattern of your Jaxrs file java resource. Default is: "*Resource.java".' ) do |pattern|
    options[:pattern] = pattern || "*Resource.java"
  end
  
  opts.on( '-o', '--output OUTPUT', 'Location of your generated site folder. Default is current directory.' ) do |output|
    options[:output_path] = output
  end

  options[:project_name] = "JaxrsDoc"
  opts.on( '-p', '--project PROJECT', 'Name of the project to be included on the website.' ) do |project_name|
    options[:project_name] = project_name
  end

  opts.on( '-v', '--version VERSION', 'Version of your project to be included on the website.' ) do |project_version|
    options[:project_version] = project_version
  end
  
  opts.on( '-s', '--sources SOURCES', 'Directory that locates your java resources. Default is current directory.' ) do |sources|
    options[:sources] = sources
  end
  
  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end

begin
  optparse.parse!
rescue OptionParser::InvalidOption, OptionParser::InvalidArgument, OptionParser::MissingArgument
  puts "#{$!.message}"
  puts "try 'jaxrsdoc -h' for more information"
  exit
end

puts "Retrieving #{options[:pattern]} files recursively from #{options[:sources]}"
matched_files = Dir.glob("#{options[:sources]}/**/#{options[:pattern]}").select{ |entry| File.file?(entry) }
puts "Found #{matched_files.size} files resources"

processed_resources = matched_files.map {|file| JaxrsDoc::ResourceParser.parse(File.new(file))}
puts "Processed #{processed_resources.size} file resources"

puts "Generating site at "
JaxrsDoc::Site.new(processed_resources, Dir.pwd, {:project_version => options[:project_version], :project_name => options[:project_name]}).generate


