require File.expand_path("../annotations.rb", __FILE__)

module JaxrsDoc
  
  module AnnotationScanner
    
    JAXRS_ANNOTATIONS = %w[ ApplicationPath Consumes CookieParam DefaultValue 
                            DELETE Encoded FormParam GET HEAD HeaderParam 
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
  
  module ResourceParser
    include AnnotationScanner
    
    def self.parse(file)
      @filename = File.basename(file.path)
      parse_content(file.read)
    end
    
    def self.parse_content(text)
      verbs_annotations = {:gets => [], :posts => [], :puts => [], :deletes => []}
      java_sections = text.split(/(?<=\s)({)/);
      type_annotations = AnnotationScanner.scan_annotations(java_sections.shift)
      java_sections.each { |section| 
        group = AnnotationScanner.scan_annotations(section) 
        unless group.empty?
          verbs_annotations[:gets] << group if(group.is_get_group?)
          verbs_annotations[:posts] << group if(group.is_post_group?)
          verbs_annotations[:puts] << group if(group.is_put_group?)
          verbs_annotations[:deletes] << group if(group.is_delete_group?)
        end
      }
      JaxrsDoc::Resource.new(@filename, type_annotations, verbs_annotations)
    end      
  end
end