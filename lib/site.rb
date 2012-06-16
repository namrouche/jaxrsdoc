require File.expand_path("../templates.rb", __FILE__)
require 'erb'
require 'fileutils'

module JaxrsDoc
  
  class Site
    
    attr_reader :resources, :project_version, :project_name
    
    def initialize(resources, output_location, options = {})
      @resources = resources
      @project_version = options[:project_version]
      @project_name = options[:project_name]
      make_output_dir(output_location)
      copy_resources_to_output_dir
    end
    
    def generate
      @resources.each { |resource|
        File.open(resource_file_path(resource.name), "w") { |f|
            content = ERB.new(JaxrsDoc::Templates.get_resource_page).result(binding)
            f.syswrite(content)
        }
      }
      
      File.open(index_file_path, "w") { |f|
          content = ERB.new(JaxrsDoc::Templates.get_index_page).result(binding)
          f.syswrite(content)
      }
    end
    
    private
    
    def resource_file_path(resource_name)
      File.join(@output_dir.path, "#{resource_name}.html")
    end
    
    def index_file_path
      File.join(@output_dir.path, "index.html")
    end
    
    def make_output_dir(output_location)
      output_path = "#{output_location}/site-jaxrsdoc/"
      Dir.mkdir(output_path) if Dir[output_path].empty?
      @output_dir = Dir.new(output_path)
    end

    def copy_resources_to_output_dir
      bootstrap_file_path = File.expand_path("../../site/bootstrap.css", __FILE__)
      jaxrsdoc_css_file_path = File.expand_path("../../site/jaxrsdoc.css", __FILE__)
      FileUtils.cp(bootstrap_file_path, File.join(@output_dir.path, "bootstrap.css"))
      FileUtils.cp(jaxrsdoc_css_file_path, File.join(@output_dir.path, "jaxrsdoc.css"))
    end
  end    
end