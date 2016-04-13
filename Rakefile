# -*- encoding: utf-8 -*-

# Rakefile style taken from Ruby-Processing samples Rakefile

SAMPLES_DIR="./lib/sketches"

desc 'run demo'
task :default => [:demo]

desc 'demo'
task :demo do
  samples_list.shuffle.each{|sample| run_sample sample}
end

def samples_list
  files = []
  Dir.chdir(SAMPLES_DIR)
  Dir.glob("*.rb").each do |file|
    files << File.join(SAMPLES_DIR, file)
  end
  return files
end

def run_sample(sample_name)
  puts "Running #{sample_name}...quit to run next sample"
  open("|rp5 run #{sample_name}", "r") do |io|
    while l = io.gets
      puts(l.chop) 
    end      
  end
end

