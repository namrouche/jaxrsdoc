require File.expand_path("../annotations.rb", __FILE__)

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
    include AnnotationScanner
    
    def self.parse(file)
      @filename = File.basename(file.path)
      parse_content(file.read)
    end
    
    def self.parse_content(text)
      verbs_annotations = {:gets => [], :posts => [], :puts => [], :deletes => []}
      descriptions = {}
      java_sections = text.split(/(?<=\s)({)/);
      resource_head_section = java_sections.shift
      type_annotations = AnnotationScanner.scan_annotations(resource_head_section)
      type_description = parse_resource_description(resource_head_section)
      java_sections.each { |section| 
        group = AnnotationScanner.scan_annotations(section)
        descriptions.update(ParamDescriptionScanner.scan_params_descriptions(section))
        unless group.empty?
          verbs_annotations[:gets] << group if(group.get_group?)
          verbs_annotations[:posts] << group if(group.post_group?)
          verbs_annotations[:puts] << group if(group.put_group?)
          verbs_annotations[:deletes] << group if(group.delete_group?)
        end
      }
      JaxrsDoc::Resource.new(@filename, type_annotations, verbs_annotations, type_description, descriptions)
    end 
    
    private
    
    def self.parse_resource_description(head_text_section)
      if (description_match = /^\/\*\*(.+)\*\/$/m.match(head_text_section))
        description_match[1].gsub("*", "")
      end      
    end
         
  end
end