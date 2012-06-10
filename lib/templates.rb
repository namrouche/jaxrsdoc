module JaxrsDoc
  
  module Templates
    
    def self.get_index_page
      %q{
        <html>
          <head>
            <link rel="stylesheet" type="text/css" href="bootstrap.css" />
          </head>
          <body>
            <div class="navbar">
              <div class="navbar-inner">
                <div class="container">
                  <a class="brand" href="#"><%= @project_name %> - version <%= @project_version %></a>
                  <p class="navbar-text pull-right">Updated <%= Time.now.strftime("%d %B - %H:%M:%S") %></p>
                  <p class="navbar-text pull-right"><a href="index.html">Index</a></p>
                </div>
              </div>
            </div>
            <div class="container">
              <ul>
              <% @resources.each do |resource| %>
                <li><a href="<%= resource.name %>.html"> <% if resource.path %><%= resource.path.value %><% end %></a></li>
              <% end%>
              </ul>
          
            <footer>Powered by JaxrsDoc @simcap</footer>  
            </div>
          <body>
        </html>
       }
    end
    
    def self.get_resource_page
      %q{
      <html>
        <head>
          <link rel="stylesheet" type="text/css" href="bootstrap.css" />
        </head>
        <body>
          <div class="navbar">
            <div class="navbar-inner">
              <div class="container">
                <a class="brand" href="#">Nope</a>
                <p class="navbar-text pull-right">Updated <%= Time.now.strftime("%d %B - %H:%M:%S") %></p>
                <p class="navbar-text pull-right"><a href="index.html">Index</a></p>
              </div>
            </div>
          </div>
    
          <div class="container">
            <div class="row">	
          		<div class="span12">
          	     <h2 class="pull-left"><% if @path %><%= @path.value %><% end %></h2>
                   <pre class="pull-right"><%= @name %></pre>
          	    </div>	
            </div>
    
            <% @gets.each do |annot_group| %>
              <div class="row">	
            		<div class="span12">
                    <button class="btn btn-success pull-left disabled" href="#"><%= annot_group.get.name %></button>
                    <h3 class="pull-left"><% if annot_group.path %> <%= annot_group.path.value %> <% end %></h3>
                  </div>	
               </div>

               <div class="row">	
             		<div class="span12">
                  <table class="table table-bordered table-striped">
            		   <colgroup>
            		    <col class="span1">
            		   </colgroup>
            	     <thead>
            		   <tr><th>Parameter</th><th>Description</th></tr>
            	     </thead>
                   <tr>
                    <td><% if annot_group.queryparams(0) %> <%= annot_group.queryparams(0).value %><% end %></td>
                    <td> description </td>
                   </tr>
                  </table>
                  </div>	
               </div>
            <% end %>
      
            <% @posts.each do |annot_group| %>
              <div class="row">	
            		<div class="span12">
                    <button class="btn btn-info pull-left disabled" href="#"><%= annot_group.post.name %></button>
                    <h3 class="pull-left"><% if annot_group.path %> <%= annot_group.path.value %> <% end %></h3>
                  </div>	
               </div>

               <div class="row">	
             		<div class="span12">
                  <table class="table table-bordered table-striped">
            		   <colgroup>
            		    <col class="span1">
            		   </colgroup>
            	     <thead>
            		   <tr><th>Parameter</th><th>Description</th></tr>
            	     </thead>
                   <tr>
                    <td><% if annot_group.formparams(0) %> <%= annot_group.formparams(0).value %><% end %></td>
                    <td> description </td>
                   </tr>
                  </table>
                  </div>	
               </div>
            <% end %>
      
          <footer>Powered by JaxrsDoc @simcap</footer>  
          </div>
        <body>
      </html>
    }
  end
 end
end