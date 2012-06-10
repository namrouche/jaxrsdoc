require File.expand_path("../../lib/parse.rb", __FILE__)
require 'test/unit'

class ParserTest < Test::Unit::TestCase
  
  def test_parse_jaxrs_annotations_only_from_text
    text = <<-ANNOT
        @Path("/session/login") @Consumes("xml", "json")
        @Produces
        @GET 
        @QueryParam("userid")
        @RequestParam("userid")
        @POST
        @Autowired @Component
      ANNOT
   annotations = JaxrsDoc::AnnotationScanner.scan_annotations(text)
   
   assert_equal(6, annotations.size, "Should only collect valid jaxrs annotations")

   assert_equal("Path", annotations.path.name)
   assert_equal("/session/login", annotations.path.value)

   assert_equal("Consumes", annotations.consumes.name)
   assert_equal("xml", annotations.consumes.values[0])
   assert_equal("json", annotations.consumes.values[1])   

   assert_equal("Produces", annotations.produces.name)
   assert(annotations.produces.values.empty?)

   assert_equal("GET", annotations.get.name)
   assert(annotations.get.values.empty?)

   assert_equal("QueryParam", annotations.queryparam.name)
   assert_equal("userid", annotations.queryparam.values[0])

   assert_equal("POST", annotations.post.name)
   assert(annotations.post.values.empty?)
  end

  def test_should_parse_annotation_from_java_file_resources_content
    java_file_one = <<-JAVA
    @Component
    @Path("/user/find_user")
    @Scope("request")
    public class FindUserResource extends OnResource {

        @Autowired
        private UserService userService;

        @GET
        public Response findUser(@QueryParam("receiver") NormalizedContactPointParameter receiver)
                throws OnDoesNotExistsException {

            ParameterUtil.checkNotNull(receiver, "parameter 'receiver' is mandatory");

            String userId = userService.findLegacyUserId(receiver.getNormalizedValue());
            return Response.ok(buildDefaultOnResponse().addDataElement(buildComposite(userId))).build();
        }

        private SimpleUser buildComposite(String userId) {
            SimpleUser user = new SimpleUser();
            user.setId(userId);
            return user;
        }

    }
    JAVA
    
    java_file_two = <<-JAVA
    @Consumes("application/xml", "application/json")
    @Path("/user/set_carrier")
    @Scope("request")
    public class SetCarrierResource extends OnResource {

        @Autowired
        CarrierService carrierService;

        @Autowired
        UserService userService;

        @GET
        public Response setCarrier(@QueryParam("carrier_id") Long carrier_id,
                @QueryParam("voicemail_msisdn") String voicemail_msisdn) throws OnDoesNotExistsException {

            ParameterUtil.checkNotNull(carrier_id, "carrier_id is a mandatory parameter");
            ParameterUtil.checkIsNotBlank(voicemail_msisdn, "voicemail_msisdn is a mandatory parameter");
            userService.selectCarrier(carrier_id, voicemail_msisdn);

            return Response.ok(buildDefaultOnResponse()).build();
        }
        
        @POST
        @Produces("xml", "json")
        public Response newCarrier(@FormParam("carrier_id") Long carrier_id,
                @FormParam("carrier_name") String carrier_name) throws OnDoesNotExistsException {

        }
    }
    JAVA

    resource_one = JaxrsDoc::ResourceParser.parse_content(java_file_one)

    assert_equal(1, resource_one.gets.size, "Resource should have 1 GET annotations group")

    assert_equal("Path", resource_one.path.name)
    assert_equal("/user/find_user", resource_one.path.value)
    
    assert_equal("GET", resource_one.gets[0].get.name)
    assert(resource_one.gets[0].get.values.empty?)

    assert_equal("QueryParam", resource_one.gets[0].queryparam.name)
    assert_equal("receiver", resource_one.gets[0].queryparam.value)
    
    resource_two = JaxrsDoc::ResourceParser.parse_content(java_file_two)  
    
    assert_equal(1, resource_two.gets.size, "Resource should have 1 GET annotations group")
    assert_equal(1, resource_two.posts.size, "Resource should have 1 POST annotations group")

    assert_equal("Path", resource_two.path.name)
    assert_equal("/user/set_carrier", resource_two.path.value)
      
    assert_equal("Consumes", resource_two.consumes.name)
    assert_equal("application/xml", resource_two.consumes.value)
    assert_equal("application/json", resource_two.consumes.values[1])

    assert_equal("GET", resource_two.gets[0].get.name)
    assert_equal(nil, resource_two.gets[0].path)
    assert(resource_two.gets[0].get.values.empty?)

    assert_equal("QueryParam", resource_two.gets[0].queryparams(0).name)
    assert_equal("carrier_id", resource_two.gets[0].queryparams(0).value)

    assert_equal("QueryParam", resource_two.gets[0].queryparams(1).name)
    assert_equal("voicemail_msisdn", resource_two.gets[0].queryparams(1).value)

    assert_equal("POST", resource_two.posts[0].post.name)
    assert(resource_two.posts[0].post.values.empty?)

    assert_equal("Produces", resource_two.posts[0].produces.name)
    assert_equal("xml", resource_two.posts[0].produces.values[0])
    assert_equal("json", resource_two.posts[0].produces.values[1])

    assert_equal("FormParam", resource_two.posts[0].formparams(0).name)
    assert_equal("carrier_id", resource_two.posts[0].formparams(0).value)
    
    assert_equal("FormParam", resource_two.posts[0].formparams(1).name)
    assert_equal("carrier_name", resource_two.posts[0].formparams(1).value)
  end
end