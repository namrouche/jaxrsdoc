require File.expand_path("../../lib/annotations.rb", __FILE__)
require 'test/unit'

class TestAnnotations < Test::Unit::TestCase
  
  def test_text_annotation_name_parsing
    assert_equal("Path", JaxrsDoc::Annotation.new("@Path").name)
    assert_equal("Path", JaxrsDoc::Annotation.new("@Path('my/path')").name)
    assert_equal("Path", JaxrsDoc::Annotation.new('@Path("my/path")').name)
    assert_equal("QueryParam", JaxrsDoc::Annotation.new('@QueryParam("userid")').name)
  end

  def test_text_annotation_value_parsing
    assert_equal("my/path", JaxrsDoc::Annotation.new('@Path("my/path")').value)
    assert_equal("my/path", JaxrsDoc::Annotation.new("@Path('my/path')").value)
    assert_equal("my/path", JaxrsDoc::Annotation.new("@Path('my/path')").value)
    assert_equal("images", JaxrsDoc::Annotation.new('@Consumes("images", "whatever")').values[0])
    assert_equal("whatever", JaxrsDoc::Annotation.new('@Consumes("images", "whatever")').values[1])
    assert_equal(nil, JaxrsDoc::Annotation.new("@Path").value)
    assert_equal(nil, JaxrsDoc::Annotation.new("@Path()").value)
    assert_equal(nil, JaxrsDoc::Annotation.new("@Path("")").value)
  end

end