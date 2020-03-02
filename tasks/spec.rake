begin
  require 'rspec/core/rake_task'

  desc 'Run all specs'
  task :spec => ['spec:unit', 'spec:acceptance']

  desc 'Default task which runs all specs with code coverage enabled'
  task :default => ['spec:unit']

  task :ci => ['spec:unit']
rescue LoadError; end

namespace :spec do
  task :set_coverage do
    ENV['COVERAGE'] = 'true'
  end

  desc 'Run acceptance specs using vagrant-spec'
  task :acceptance do
    components = %w(
      basic
      network/forwarded_port
      synced_folder
      synced_folder/nfs
      synced_folder/rsync
      provisioner/shell
      provisioner/puppet
      provisioner/chef-solo
      package
    ).map{|s| "provider/lxc/#{s}" }
    sh "export ACCEPTANCE=true && bundle exec vagrant-spec test --components=#{components.join(' ')}"
  end

  desc "Run unit specs with rspec"
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = "./unit/**/*_spec.rb"
  end
end
