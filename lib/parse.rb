require File.expand_path("../annotations.rb", __FILE__)
require 'javaparse'

include JavaParse

module JaxrsDoc
  
  module AnnotationScanner
    
    JAXRS_ANNOTATIONS = %w[ ApplicationPath Consumes CookieParam DefaultValue 
                            DELETE Encoded FormParam FormDataParam GET HEAD HeaderParam 
                            HttpMethod MatrixParam OPTIONS Path PathParam
                            POST Produces PUT QueryParam ]
        
    def self.scan_annotations(text)
      annotations = []
      text.scan(jaxrs_annotations_regexp) {|s| annotations << JaxrsDoc::Annotation.new(s.first)}
      JaxrsDoc::AnnotationsGroup.new(annotations)
    end
    
    private 
    
    def self.jaxrs_annotations_regexp
      regexp = JAXRS_ANNOTATIONS.map { |a|
        ["#{a}(?=[[:space:]])", "#{a}\\(?.*?\\)"]
      }
      Regexp.new("@(#{regexp.join('|')})")
    end
    
  end
  
  module ParamDescriptionScanner
    
    def self.scan_params_descriptions(text)
      params_descriptions = Hash.new("")
      text.each_line { |line|
        if(param_index = line.index("@param"))
          param_name, param_desc = line[(param_index + 6)..-1].split(" ", 2);
          params_descriptions.store(param_name, param_desc)
        end
      }
      params_descriptions
    end
    
  end 
  
  module ResourceParser
    
    def self.parse(file)
      @java_file = JavaUnit.new(file.path)
      @filename = File.basename(file.path)
      parse_content
    end
    
    def self.parse_content
      verbs_annotations = {:gets => [], :posts => [], :puts => [], :deletes => []}
      descriptions = {}
      type_annotations = AnnotationScanner.scan_annotations(@java_file.head.content)
      descriptions.update(ParamDescriptionScanner.scan_params_descriptions(@java_file.head.content))
      type_description = remove_params_description(@java_file.head.javadoc)
      @java_file.method_blocks.each { |section| 
        group = AnnotationScanner.scan_annotations(section.content)
        group.javadoc = section.javadoc
        descriptions.update(ParamDescriptionScanner.scan_params_descriptions(section.content))
        unless group.empty?
          verbs_annotations[:gets] << group if(group.get)
          verbs_annotations[:posts] << group if(group.post)
          verbs_annotations[:puts] << group if(group.put)
          verbs_annotations[:deletes] << group if(group.delete)
        end
      }
      JaxrsDoc::Resource.new(@filename, type_annotations, verbs_annotations, type_description, descriptions)
    end
    
    private 
    
    def self.remove_params_description(text)
      return nil unless text
      description = ""
      text.each_line { |line|
        description << line unless line.include?("@param")
      }
      description
    end
         
  end
end