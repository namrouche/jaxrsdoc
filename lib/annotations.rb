module JaxrsDoc
  
  class Resource
    
    attr_reader :name, :path, :verbs, :gets, :posts, :consumes
    
    def initialize(file_name, type_annotations, verbs_annotations = {})
      @name = file_name
      @path = type_annotations.annotations.find {|a| a.name.eql?"Path"}
      @consumes = type_annotations.annotations.find {|a| a.name.eql?"Consumes"}
      @gets = verbs_annotations[:gets]
      @posts = verbs_annotations[:posts]
      @verbs = verbs_annotations
    end
    
    # Support ERB templating of member data.
    def get_binding
      binding
    end
    
  end
  
  class AnnotationsGroup
    
    attr_reader :annotations
    
    def initialize(annotations = [])
      @annotations = Array.new(annotations)
    end
    
    def method_missing(method_name, *args)
      if((not args.empty?) and method_name.to_s.end_with?"s")
        annotation_name = method_name.to_s[0..-2]
        annots = @annotations.select{|a| annotation_name.eql?(a.name.downcase) }
        return annots[args.first]
      else  
        @annotations.each {|a|
          if (method_name.to_s.eql?(a.name.downcase)) then return a end
        }
      end
      return nil
      #raise "No jaxrs annotation with name '#{annotation_called}' in annotation group"
    end
    
    def to_s
      @annotations.to_s
    end
    
    def empty?
      @annotations.empty?
    end
    
    def size
      @annotations.size
    end
    
    def is_get_group?
      @annotations.each {|a| return "GET".eql?a.name }
    end

    def is_post_group?
      @annotations.each {|a| return "POST".eql?a.name }
    end

    def is_put_group?
      @annotations.each {|a| return "PUT".eql?a.name }
    end

    def is_delete_group?
      @annotations.each {|a| return "DELETE".eql?a.name }
    end
    
  end
  
  
  class Annotation
    include Comparable
    
    attr_reader :name, :values, :value
    
    def initialize(annotation_text)
      @text = annotation_text.strip
      @name = @text.delete("@").split("(")[0]
      parse_values
    end
    
    def to_s
      @text
    end
    
    private
    
    def parse_values
      @values = []
      match_value = /\((.*)\)/.match(@text)
      if(match_value.nil?) then return end
      values_text = match_value[1].split(",")
      values_text.each { |v|
        @values << v.delete("\"").delete("'").strip
      }
      @value = values_text.first.delete("\"").delete("'").strip 
    end
    
  end

end