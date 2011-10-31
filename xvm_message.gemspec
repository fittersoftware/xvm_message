spec = Gem::Specification.new do |s|
  s.name = 'xvm_message'
  s.version = '1.0'
  s.summary = "xvm_message libraries"
  s.description = %{Contains libraries for handling xvm_messages.}
  s.files = Dir['lib/xvm_message/xvm_message.rb'] +
            Dir['lib/xvm_message/xvm_message_factory.rb'] +
            Dir['test/xvm_message_factory_test.rb'] +
            Dir['test/xvm_message_test.rb']
  s.has_rdoc = false
  s.author = "Alberto Yoshimiya"
  s.email = "alberto@brightwaysw.com"
  s.homepage = "http://brightwaysw.com"
end