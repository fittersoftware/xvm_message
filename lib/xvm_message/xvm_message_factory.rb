module Xvm
  class XvmMessageFactory

    def self.create_message(string_with_message)
      return Xvm::GeopositionMessage.new(string_with_message) if is_geoposition? string_with_message
      return Xvm::PerformanceMessage.new(string_with_message) if is_rus00? string_with_message
      Xvm::XvmMessage.new(string_with_message)
    end


    def self.is_geoposition?(message)
      message[1..3] == 'RGP'
    end

    def self.is_ping?(message)
      message[1..3] == 'RVR'
    end

    def self.is_rus00?(message)
      message[1..5] == 'RUS00'
    end


  end
end