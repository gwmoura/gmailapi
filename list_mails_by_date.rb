require_relative 'gmail_service'

service = GmailService.service
user_id = 'me'
result = service.list_user_messages(user_id, q: "label:fieb after:2016/10/1 before:2016/10/31")
puts "Messages:"
puts "No mails found" if result.messages.empty?
result.messages.each do |message|
  mail = service.get_user_message(user_id, message.id)
  report = {}
  mail.payload.headers.each do |header|
    if header.name == "Subject"
      report[:subject] = header.value
    elsif header.name == "Date"
      report[:date] = header.value
    elsif header.name == "From"
      report[:from] = header.value
    end
  end
  unless report[:from].include?('gwmoura@gmail.com')
    formated = DateTime.parse(report[:date]).strftime("%d/%m/%Y")
    puts "#{report[:from]} - #{report[:subject]} - #{formated}"
  end
end
