#MESSAGING_SERVICE = MessagingService.new(ENV.fetch("AMQP_URL"))
USE_MESSAGE_QUEUE=false
MESSAGING_SERVICE = MessagingService.new if USE_MESSAGE_QUEUE
#MESSAGING_SERVICE.start