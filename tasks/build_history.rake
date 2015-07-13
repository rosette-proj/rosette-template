# encoding: UTF-8

require 'progress-reporters'
require 'rosette/server/tools'

include ProgressReporters
include Rosette::Core
include Rosette::Server::Tools

task :build_history, :repo_name do |t, args|
  repo_names = if args[:repo_name]
    [args[:repo_name]]
  else
    RosetteConfig.config.repo_configs.map(&:name)
  end

  progress_reporter = MeteredProgressReporter.new
    .set_calc_type(:moving_avg)
    .set_window_size(10)
    .on_complete { STDOUT.write("\n") }
    .on_progress do |count, total, percentage, rate|
      STDOUT.write("\rProcessing commit #{count} of #{total} (#{percentage}%), #{rate} commits/sec ")
    end

  error_reporter = PrintingErrorReporter.new(STDOUT)

  repo_names.each do |repo_name|
    history_builder = HistoryBuilder.new(
      config: RosetteConfig.config,
      repo_config: RosetteConfig.config.get_repo(repo_name),
      progress_reporter: progress_reporter,
      error_reporter: error_reporter
    )

    progress_reporter.reset
    history_builder.execute
  end
end
