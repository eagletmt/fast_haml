require 'bundler/gem_tasks'

task :default => [:compile, :spec]

require 'rake/extensiontask'
Rake::ExtensionTask.new('attribute_builder') do |ext|
  ext.lib_dir = 'lib/faml'
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

namespace :benchmark do
  task :rendering => ['benchmark:rendering:haml', 'benchmark:rendering:attributes', 'benchmark:rendering:slim']
  namespace :rendering do
    desc "Run benchmark with Haml's standard template"
    task :haml do
      haml_gem = Gem::Specification.find_by_name('haml')
      standard_haml_path = File.join(haml_gem.gem_dir, 'test', 'templates', 'standard.haml')
      sh 'ruby', 'benchmark/rendering.rb', standard_haml_path
    end

    desc "Run benchmark for attribute builder"
    task :attributes do
      sh 'ruby', 'benchmark/rendering.rb', 'benchmark/attribute_builder.haml', 'benchmark/attribute_builder.slim'
    end

    desc "Run slim's benchmark"
    task :slim do
      sh 'ruby', 'benchmark/slim.rb'
    end
  end
end
