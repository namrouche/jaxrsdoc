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
                  <a class="brand" href="#"><%= @project_name %> <%= @project_version %></a>
                  <ul class="nav">
                    <li class="active"><a href="index.html">API index</a></li>
                  </ul>
                  <p class="navbar-text pull-right">Last update <%= Time.now.strftime("%d %B - %H:%M:%S") %></p>
                </div>
              </div>
            </div>
            <div class="container">
              <% @resources.each_slice(20) do |big_packets_of_resources| %>
                <div class="row">
                <% big_packets_of_resources.each_slice(10) do |small_packets_of_resources|%>
                  <div class="span6">
                    <pre><ul><% small_packets_of_resources.each do |resource|%><li><a href="<%= resource.name %>.html"> <% if resource.path %><%= resource.path.value %><% end %></a></li><% end%></ul></pre>
                  </div>
                <% end %>
                </div>
              <% end%>
            <footer class="modal-footer"><span>Powered by <a href="http://simcap.github.com/jaxrsdoc">Jaxrsdoc</a></span></footer>  
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
                <a class="brand" href="#"><%= @project_name %> <%= @project_version %></a>
                <ul class="nav">
                  <li class="active"><a href="index.html">API index</a></li>
                </ul>
                <p class="navbar-text pull-right">Updated <%= Time.now.strftime("%d %B - %H:%M:%S") %></p>
              </div>
            </div>
          </div>
    
          <div class="container">
          
            <div class="page-header">	
        	     <h1><% if resource.path %><%= resource.path.value %><% end %><pre class="pull-right"><%= resource.name %></pre></h1>
            </div>
            
            <% if resource.description %>
            <div>
              <pre><%= resource.description %></pre>
            </div>
            <% end %>
    
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
                        <td><%= resource.params_descriptions[param.value] %></td>
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
                         <td><%= resource.params_descriptions[param.value] %></td>
                        </tr>
                    <% end %>
                    </tbody>
                  </table>
                  </div>	
               </div>
               <% end %>
            <% end %>
            
            <% resource.puts.each do |annot_group| %>
              <div class="row">	
            		<div class="put span12">
                    <button class="btn btn-warning pull-left disabled" href="#"><%= annot_group.put.name %></button>
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
                         <td><%= resource.params_descriptions[param.value] %></td>
                        </tr>
                    <% end %>
                    </tbody>
                  </table>
                  </div>	
               </div>
               <% end %>
            <% end %>
            
            <% resource.deletes.each do |annot_group| %>
              <div class="row">	
            		<div class="post span12">
                    <button class="btn btn-danger pull-left disabled" href="#"><%= annot_group.delete.name %></button>
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
                         <td><%= resource.params_descriptions[param.value] %></td>
                        </tr>
                    <% end %>
                    </tbody>
                  </table>
                  </div>	
               </div>
               <% end %>
            <% end %>
            
            
          </div>
        <body>
      </html>
    }
  end
 end
end