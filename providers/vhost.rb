use_inline_resources

action :create do
  new_resource.name
  new_resource.config_file
  new_resource.port
  new_resource.document_root
  new_resource.content
  new_resource.config_filepath


#Template with power user path and port
template new_resource.config_file do
  source "config.erb"
  variables(port: new_resource.port, document_root: new_resource.document_root)
end

#Create dir for html
directory new_resource.document_root do
  recursive true
end

#Create index html
file "#{new_resource.document_root}/index.html" do
  content new_resource.content
end
  
end
