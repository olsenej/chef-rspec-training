require 'spec_helper'

describe 'apache::default' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  #describe port(80) do
  #  it { should be_listening }
  #end

  # add another test to verify the result of the curl command
  describe command("curl localhost") do
    its(:stdout) { should match /Hello, world!/ }
  end

  describe command("curl localhost:8080") do
    its(:stdout) { should match /Welcome Admin!/ }
  end
end
