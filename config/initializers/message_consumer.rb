require "rubygems"
require "bunny"

begin
	#MessagingErrorMailer.ranking_error_message("teste", "teste").deliver_now
	conn = Bunny.new
	conn.start

	ch = conn.create_channel
	q  = ch.queue("rankings", :auto_delete => true)
	x  = ch.default_exchange
	Rails.logger.debug "start consuming queue"
	q.subscribe do |delivery_info, metadata, payload|
	  begin
	  	UserRanking.create_or_append(JSON.parse(payload))
	  rescue => e
	  	MessagingErrorMailer.ranking_error_message(payload, e.message).deliver_now
	  end
	end
rescue => e
	Rails.logger.debug "error consuming queue: #{e.message}"
	MessagingErrorMailer.ranking_error_message("Error consuming queue", e.message).deliver_now
	retry
end if USE_MESSAGE_QUEUE
#sleep 1.0
#at exit {conn.close}