require File.expand_path("../../lib/annotations.rb", __FILE__)
require File.expand_path("../../lib/parse.rb", __FILE__)
require File.expand_path("../../lib/site.rb", __FILE__)
require 'test/unit'

class TestSite < Test::Unit::TestCase
  
  def test_simple_output
    file_one = File.open(File.expand_path("../../bin/AuthenticationResource.java", __FILE__))
    file_two = File.open(File.expand_path("../../bin/JobsResource.java", __FILE__))
    resource_one = JaxrsDoc::ResourceParser.parse(file_one)
    resource_two = JaxrsDoc::ResourceParser.parse(file_two)
    site = JaxrsDoc::Site.new([resource_one, resource_two])
    site.generate    
  end
  
end