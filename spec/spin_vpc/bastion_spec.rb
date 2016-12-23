require 'spec_helper_remote'
require 'spec_helper_aws'

describe ec2_running('SSH Bastion Host') do

  before(:all) do
    target_host = described_class.public_ip
    options = get_ssh_options(
      target_host,
      target_host_key: '/home/vagrant/.ssh/spin-bastion-key'
    )
    set :ssh_options, options
    set :host, target_host
  end

  context 'within the environment' do
    it { should exist }
  end

  context 'on the server' do
    describe command('curl -sf --connect-timeout 10 http://kief.com') do
      its(:exit_status) { should eq 0 }
    end

    describe interface('eth0') do
      its(:ipv4_address) { should match /10\.0\.[123]\./ }
    end
  end

end
