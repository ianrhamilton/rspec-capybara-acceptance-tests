require 'rake'
require 'rspec/core/rake_task'

desc 'Run all tests'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ["--format progress", "--color"]
  browser = ENV['DRIVER'] || 'poltergeist'
  ENV['DRIVER'] = browser
  puts "Executing specs using #{browser}..................."
  t.pattern = ['bundle exec rspec spec/*.rb']
end

desc 'Run all tests in parallel'
RSpec::Core::RakeTask.new(:parallel_spec) do |t|
  t.rspec_opts = ["--format progress", "--color"]
  browser = ENV['DRIVER'] || 'poltergeist'
  ENV['DRIVER'] = browser
  puts "Executing specs using #{browser}..................."
  system("bundle exec parallel_rspec spec/*.rb -n 5")
end

desc 'Run all tests with parallel test execution with failure retries'
task :ci, [:spec_file_pattern] do |t, args|
  browser = ENV['DRIVER'] || 'poltergeist'
  ENV['DRIVER'] = browser
  puts "Executing specs using #{browser}..................."
  run args[:spec_file_pattern.to_s]
  puts "Before re-run #{$?.to_s}"
  if $?.success? == false
    rerun args[:spec_file_pattern.to_s]
    puts "After re-run #{$?.to_s}"
    if $?.success? == false
      generate_report
      raise 'Rerun still had failing tests'
    else
      generate_report
      puts 'Rerun resulted in all passing'
    end
  else
    generate_report
    puts 'All tests passed in the first run'
  end
end

task :default => :spec

def launch(params = {})
  if params[:test_options].include? '-e'
    count = params[:test_options].split(/failed/).count - 1
  end
  system("bundle exec parallel_rspec spec/*.rb -n #{params[:processes] || 5} \
    --test-options '#{params[:test_options]}' --serialize-stdout \
         #{params[:spec_file_pattern]}")
end

def run(spec_file_pattern)
  cleanup
  launch(processes: "5".to_i,
         test_options: "--require ./spec/support/failures_formatter.rb \
    --format FailureCatcher", spec_file_pattern: spec_file_pattern)
end

def rerun(spec_file_pattern)
  launch(processes: "5".to_i, test_options: gather_failures, spec_file_pattern: spec_file_pattern)
end

def gather_failures
  opts = ''
  files = Dir.glob('*.failures')
  files.each { |file| opts << File.read(file).gsub(/\n/, ' ') }
  all_failures = './all.failures'
  File.write(all_failures, opts.rstrip)
  return File.read all_failures
end

def generate_report
  puts 'Generating report . . . '
  report = "log/screenshots --report-path log/reports"
  system("allure generate #{report}")
end

def cleanup
  puts 'Deleting all failure files . . . '
  system('rm -rf log') unless Dir.glob('log').empty?
  system('rm -rf allure-report') unless Dir.glob('allure-report').empty?
end
