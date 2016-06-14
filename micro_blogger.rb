require 'jumpstart_auth'
require 'bitly'

class MicroBlogger
	attr_reader :client

	def initialize
		puts "Initializing MicroBlogger"
		@client = JumpstartAuth.twitter
		Bitly.use_api_version_3
		@command_list = ["h: help", "q: quit", "t: tweet",
										 "dm: direct message", "smf: spam my followers",
										 "els: everyones last tweet", "s: shorten",
										 "turl: Tweet with URL"]
	end

	def shorten(url)
		bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
		bitly.shorten(url).short_url
	end

	def tweet(message)
		if message.length > 140
			puts "The tweet is too long. ABORT ABORT!"
		elsif message.strip.empty?
			puts "There is no tweet to be tweeted. ABORT ABORT!"
		else
			@client.update(message)
		end
	end

	def everyones_last_tweet
		friends = @client.friends
		friends = friends.sort_by{ |friend| @client.user(friend).screen_name.downcase }
		friends.each do |friend|
			puts "#{@client.user(friend).screen_name} said this on \
			#{@client.user(friend).status.created_at.strftime("%A, %b %d")}"
			puts @client.user(friend).status.text
			puts ""
		end
	end

	def spam_my_followers(message)
		followers = followers_list
		followers.each {|user| dm(user, message)}
	end

	def dm(target, message)
		screen_names = @client.followers.collect do |follower|
			@client.user(follower).screen_name
		end
		if target.nil? || message.nil? || target.empty? || message.empty?
			puts "looks like something went wrong..."
		elsif screen_names.include? target
			puts "Trying to send #{target} this direct message:"
			puts message
			message = "d @#{target} #{message}"
			tweet message
		else
			puts "#{target} isn't following you!"
		end
	end

	def run
		puts "Welcome to the JSL Twitter Client"
		command = ""
		while command != "q"
			printf "enter command (h for help): "
			input = gets.chomp
			parts = input.split
			command = parts[0].downcase
			parts.delete(command)
			message = parts.join(" ")
			case command
			when "h" then puts @command_list.join(", ")
			when "q" then puts "Goodbye!"
			when "t" then tweet(message)
			when "dm" then dm(parts[0], parts[1..-1].to_a.join(" "))
			when "smf" then spam_my_followers(message)
			when "els" then everyones_last_tweet
			when "s" then shorten message
			when "turl" then tweet(parts[0..-2].join(" ") + " " + shorten(parts[-1]))
			else
				puts "Sorry, I don't know how to #{command}"
			end
		end
	end

	private

		def followers_list
			screen_names = @client.followers.collect do |follower|
				@client.user(follower).screen_name
			end
		end

end

blogger = MicroBlogger.new
blogger.run