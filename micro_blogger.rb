require 'jumpstart_auth'

class MicroBlogger
	attr_reader :client

	def initialize
		puts "Initializing MicroBlogger"
		@client = JumpstartAuth.twitter
		@command_list = ["h: help", "q: quit", "t: tweet"]
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
			else
				puts "Sorry, I don't know how to #{command}"
			end
		end
	end
end

blogger = MicroBlogger.new
blogger.run