#
# Cookbook Name:: apache
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

RSpec.shared_examples "an apache server running an apache service" do
     it 'converges successfully' do
       chef_run
     end
     
     it 'installed the apache package' do
       expect(chef_run).to install_package('apache2')
     end

     it 'starts the apache service' do
       expect(chef_run).to start_service('apache2')
     end

     it 'enables the apache service' do
       expect(chef_run).to enable_service('apache2')
     end
end

describe 'apache::default' do
  context 'When all attributes are default, on ubuntu 12.04' do
     let(:chef_run) do
       runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '12.04', step_into: ['apache_vhost'])
       runner.converge(described_recipe)
     end
     let(:configuration_file) {"/etc/apache2/conf.d/admin.conf"}
     
     it_should_behave_like "an apache server running an apache service"

     it 'creates a file with correct attributes' do
       expect(chef_run).to create_file("/var/www/index.html").with(owner: "root", group: "root", mode: "0644")
     end

     it 'creates a template config at the create location' do
       expect(chef_run).to create_template("/etc/apache2/conf.d/admin.conf")
     end
     
     it 'creates the template config with the content I expect' do
       expect(chef_run).to render_file("/etc/apache2/conf.d/admin.conf").with_content("Listen 8080")
       expect(chef_run).to render_file("/etc/apache2/conf.d/admin.conf").with_content("DocumentRoot /var/www/admin/html")
     end
     
     it 'template notifies the apache service when it changes' do
       resource = chef_run.template("/etc/apache2/conf.d/admin.conf")
       expect(resource).to notify("service[apache2]").to(:restart)
     end
     
     it 'create directory to host admin html files' do
       expect(chef_run).to create_directory("/var/www/admin/html")
     end

     it 'create index.html file for the admins see' do
       expect(chef_run).to create_file("/var/www/admin/html/index.html").with_content("Welcome Admin!")
     end
  end

  context 'When all attributes are default, on ubuntu 14.04' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04', step_into: ['apache_vhost'])
      runner.converge(described_recipe)
    end
    let(:configuration_file) {"/etc/apache2/conf-enabled/admin.conf"}
    
    it_should_behave_like "an apache server running an apache service"
    
    it 'the index.html has the appropriate content' do
      expect(chef_run).to render_file('/var/www/html/index.html').with_content('Hello, world!')
    end
    
    it 'the index.html has the correct attributes' do
      expect(chef_run).to create_file('/var/www/html/index.html').with(:owner => "root", :group => "root", :mode => "0644")
    end

    it 'creates a template config at the create location' do
#       expect(chef_run).to create_template("/etc/apache2/conf-enabled/admin.conf")
       expect(chef_run).to create_template("/etc/apache2/conf-enabled/admin.conf")
    end

    it 'creates the template config with the content I expect' do
       expect(chef_run).to render_file("/etc/apache2/conf-enabled/admin.conf").with_content("Listen 8080")
       expect(chef_run).to render_file("/etc/apache2/conf-enabled/admin.conf").with_content("DocumentRoot /var/www/admin/html")
    end

    it 'template notifies the apache service when it changes' do
       resource = chef_run.template("/etc/apache2/conf-enabled/admin.conf")
       expect(resource).to notify("service[apache2]").to(:restart)
    end


 end
end
