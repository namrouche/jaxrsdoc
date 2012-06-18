#!/usr/bin/env ruby
require File.expand_path("../../lib/parse.rb", __FILE__)
require File.expand_path("../../lib/site.rb", __FILE__)
require 'optparse'
require "rexml/document"

options = {}
optparse = OptionParser.new do |opts|
  opts.banner = "USAGE\n jaxrsdoc [-p] [-]"
  opts.separator "\nOPTIONS\n"
  
  options[:pattern] = "*Resource.java"
  opts.on( '-p', '--pattern PATTERN', 'Pattern of your Jaxrs file java resource. Default is: "*Resource.java".' ) do |pattern|
    options[:pattern] = pattern
  end
  
  opts.on( '-o', '--output OUTPUT', 'Location of your generated site folder. Default is current directory.' ) do |output|
    options[:output_path] = output
  end

  opts.on( '-m', '--maven', 'Indicates a maven project. Project name & version will be derived from the first pom.xml found' ) do |maven|
    options[:maven] = true
  end

  opts.on( '-a', '--artifact ARTIFACT', 'Name of the artifact/project/module to be included on the website banner.' ) do |artifact_name|
    options[:artifact_name] = artifact_name
  end

  opts.on( '-v', '--version VERSION', 'Version of your artifact/project/module to be included on the website banner.' ) do |artifact_version|
    options[:artifact_version] = artifact_version
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

puts "Looking files recursively from #{options[:sources]}"
matched_files = Dir.glob("#{options[:sources]}/**/#{options[:pattern]}").select{ |entry| File.file?(entry) }
puts "Found #{matched_files.size} files resources matching '#{options[:pattern]}'"

processed_resources = matched_files.map {|file| 
  resource = JaxrsDoc::ResourceParser.parse(File.new(file)) 
  if resource.valid? then resource else nil end
}.select {|resource| not resource.nil? }
puts "Processed #{processed_resources.size} file resources"

project_version = options[:artifact_version]
project_name = options[:artifact_name]

if(options[:maven]) then
  pom_xml = Dir.glob("#{options[:sources]}/**/pom.xml").first
  pom = REXML::Document.new File.new(pom_xml)
  project_name = pom.elements["//artifactId"].first 
  project_version = pom.elements["//version"].first
end

puts "Generating site at #{Dir.pwd}"
JaxrsDoc::Site.new(processed_resources, Dir.pwd, {:project_version => project_version, :project_name => project_name}).generate


