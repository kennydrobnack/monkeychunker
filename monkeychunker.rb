#!/usr/bin/env ruby
require 'twitter'
require 'optparse' 
require 'yaml'


#Handle command line options - time to run for & config file 
options = {:config_file => 'config.yaml', :time => 2}  
optparse = OptionParser.new do |opts|    
	opts.banner = "Usage: monkeychunker.rb [--time SECONDS] [--config FILE_NAME]"
	opts.on( '-t', '--time [TIME]', "Time to collect Tweets (in seconds" ) do|t|
		options[:time] = t || default_max_time
	end
	opts.on( '-c', '--config_file [CONFIG_FILE]', "Config file" ) do|config_file|
		options[:config_file] = config_file || default_config
	end
	opts.on( '-h', '--help', 'Display this screen' ) do     
		puts opts     
		exit   
	end
	opts.parse!
end  

#Load in Twitter connection info from config.yaml file. Secret keys should not be hard-coded into code.
# Words to ignore are also in config file so that can be tweaked without changing actual code.
puts "Loading config from #{options[:config_file]} and running for #{options[:time]} seconds"
yaml_config = YAML.load_file(options[:config_file])

client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = yaml_config['consumer_key']
  config.consumer_secret     = yaml_config['consumer_secret']
  config.access_token        = yaml_config['access_token']
  config.access_token_secret = yaml_config['access_token_secret']
end
stop_words = yaml_config['ignore_words'].downcase.split(',')

#List when we're starting & ending collection of Tweets
start_time = Time.now
end_time = start_time + Integer(options[:time])
puts "Collecting Tweets from Twitter streaming API starting at #{start_time} ending at #{end_time}"
tweets = 0


#Sample Tweets from Twitter stream until time is up.
word_counts = Hash.new
client.sample do |object|
	current_time = Time.now
	break if current_time >= end_time 
	if current_time.sec % 60 == 0
		puts "."
	elsif current_time.sec % 10 == 0
		print "."
	end
	#I'm ignoring non-English tweets so the results aren't all in Korean or Japanese or anything else I don't know how to read at all. 
	# Unicode could still have some weird stuff show up like 💦
	if object.is_a?(Twitter::Tweet) and object.lang == 'en'
		tweets += 1
  		words = object.text.split(' ')
  		words.each do |word| 
  			#Downcasing everything so tHinGs like tHis don't MaTTer
  			word.downcase!
  			unless word_counts.has_key?(word)
  			next if stop_words.include?(word) 
  				word_counts[word] = 0
  			end
  			word_counts[word] += 1
  		end
  	end
end

puts "Top 10 words by count in #{tweets} Tweets: #{word_counts.sort_by{|word, count| count}.reverse.take(10)}"





