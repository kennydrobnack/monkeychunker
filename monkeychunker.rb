require 'twitter'
require 'optparse' 
require 'yaml'

default_config = 'config.yaml'
config_file = default_config

maxtime = 2  #Default to read tweets for 10 seconds
maxtweets = 5 #Default to not limit number of tweets

stop_words = ['a', 'the', 'and', 'or']

# This hash will hold all of the options # parsed from the command-line by 
# OptionParser. 
options = {}  
optparse = OptionParser.new do |opts|   
	# Set a banner, displayed at the top   
	# of the help screen.   
	opts.banner = "Usage: optparse1.rb [options] file1 file2 ..."
  # This displays the help screen, all programs are   
  # assumed to have this option.   
  opts.on( '-h', '--help', 'Display this screen' ) do     
  	puts opts     
  	exit   
  end
end  # Parse the command-line. Remember there are two forms # of the parse method. The 'parse' method simply parses # ARGV, while the 'parse!' method parses ARGV and removes # any options found there, as well as any parameters for # the options. What's left is the list of files to resize. optparse.parse!


puts "Loading config from #{config_file}"
yaml_config = YAML.load_file(config_file)

client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = yaml_config['consumer_key']
  config.consumer_secret     = yaml_config['consumer_secret']
  config.access_token        = yaml_config['access_token']
  config.access_token_secret = yaml_config['access_token_secret']
end

tweets = 0
time = 0

word_counts = Hash.new

start_time = Time.now
puts "Starting at #{start_time}"
end_time = start_time + maxtime
puts "Ending time #{end_time}"


client.sample do |object|
	current_time = Time.now
	break if current_time >= end_time
	if object.is_a?(Twitter::Tweet) and object.lang == 'en'
  		words = object.text.split(' ')
  		words.each do |word|
  			next if stop_words.include?(word)
  			unless word_counts.has_key?(word)
  				word_counts[word] = 0
  			end
  			word_counts[word] += 1
  		end
  	end
end

puts "Top 10 words by count: #{word_counts.sort_by{|word, count| count}.reverse.take(10)}"





