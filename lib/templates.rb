module JaxrsDoc
  
  module Templates
    
    def self.get_index_page
      %q{
        <html>
          <head>
            <link rel="stylesheet" type="text/css" href="bootstrap.css" />
            <link rel="stylesheet" type="text/css" href="jaxrsdoc.css" />
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
          <link rel="stylesheet" type="text/css" href="jaxrsdoc.css" />
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
            <div class="page-header">	
        	     <h1><% if resource.path %><%= resource.path.value %><% end %><pre class="pull-right"><%= resource.name %></pre></h1>
            </div>
    
            <% resource.gets.each do |annot_group| %>
              <div class="row">	
            		<div class="get span12">
                    <button class="btn btn-success pull-left disabled" href="#"><%= annot_group.get.name %></button>
                    <h3 class="pagination-centered"><% if annot_group.path %> <%= annot_group.path.value %> <% end %></h3>
                  </div>	
               </div>

        	     <% unless annot_group.queryparams.empty? %>
               <div class="row">	
             		<div class="span12">
                  <table class="table table-bordered table-striped">
            		   <colgroup>
            		    <col class="span1">
            		   </colgroup>
            	     <thead>
            		   <tr><th>Parameter</th><th>Description</th></tr>
            	     </thead>
            	     <tbody>
            	       <% annot_group.queryparams.each do |param| %>
                       <tr>
                        <td><%= param.value %></td>
                        <td> description </td>
                       </tr>
                     <% end %>
                   </tbody>
                  </table>
                  </div>	
               </div>
               <% end %>
            <% end %>
      
            <% resource.posts.each do |annot_group| %>
              <div class="row">	
            		<div class="post span12">
                    <button class="btn btn-info pull-left disabled" href="#"><%= annot_group.post.name %></button>
                    <h3 class="pagination-centered"><% if annot_group.path %> <%= annot_group.path.value %> <% end %></h3>
                  </div>	
               </div>

         	     <% unless annot_group.params.empty? %>
               <div class="row">	
             		<div class="span12">
                  <table class="table table-bordered table-striped">
            		   <colgroup>
            		    <col class="span1">
            		   </colgroup>
            	     <thead>
            		   <tr><th>Parameter</th><th>Description</th></tr>
            	     </thead>
                   <tbody>
             	       <% annot_group.params.each do |param| %>
                        <tr>
                         <td><%= param.value %></td>
                         <td> description </td>
                        </tr>
                    <% end %>
                    </tbody>
                  </table>
                  </div>	
               </div>
               <% end %>
            <% end %>
      
          <footer>Powered by JaxrsDoc @simcap</footer>  
          </div>
        <body>
      </html>
    }
  end
 end
end