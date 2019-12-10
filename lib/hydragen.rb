STDOUT.sync = true

=begin

hydragen/
  todo/* <= area holding all pending tasks
  live/* <= jobs that are being processed
  fail/* <= jobs that bomb out
  done/* <= jobs that complete

=end

# get files
base = "hydragen"
list = Dir[File.join(base, 'todo', '*')].sort - ['.', '..']

# spawn jobs (optional)
jobs = ARGV.first.to_i
wait = 0
jobs.times {|n| wait = n + 1; fork or break; wait = nil } if jobs > 0
exit unless wait
sleep wait
print "Starting job #{$job = wait}...\n" if jobs > 0

$job  = wait
$task = 0

# process list
rows = 0
list.each do |todo|
  break if File.exists?("stop.now")

  # build filenames
  file = File.basename(todo)
  live = File.join(base, "live", file)
  done = File.join(base, "done", file)
  fail = File.join(base, "fail", file)

  # put file in 'live' spool and touch it
  FileUtils.move(todo, live) rescue next
  FileUtils.touch(live)

  # perform work
  begin
    perform(file)
    print "done: #{file}\n"
  rescue
    print "fail: #{file}\n"
    print "Error: #{$!}\n"
    puts  "Stack:\n\n", $@ if ENV['HYDRAGEN_TRACE']
    FileUtils.move(live, fail)
    next
  end

  # put file in 'done' spool
  FileUtils.move(live, done)

  # exit if (rows += 1) >= 10
end
