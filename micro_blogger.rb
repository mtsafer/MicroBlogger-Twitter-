require 'jumpstart_auth'

class MicroBlogger
	attr_reader :client

	def initialize
		puts "Initializing MicroBlogger"
		@client = JumpstartAuth.twitter
	end

	def tweet(message)
		if message.length > 140
			puts "The tweet is too long. ABORT ABORT!"
		else
			@client.update(message)
		end
	end

end

blogger = MicroBlogger.new
blogger.tweet("test"*40)
blogger.tweet("140test"*20)
blogger.tweet("<140")