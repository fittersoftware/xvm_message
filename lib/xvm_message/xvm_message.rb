require 'digest/sha1'
module Xvm

  # Encapsulates a virloc xvm message
  class XvmMessage
    attr_accessor :message, :device, :number

    def initialize(args)
      if args.is_a? String
        raise "#{args} is not a valid xvm message" unless XvmMessage.is_valid?(args)
        message_without_gtlt = args[1..-2] # removes the > < characters
        message_parts        = message_without_gtlt.split(';')
        @message             = message_parts[0]
        @device              = message_parts[1][3..-1]
        @number              = message_parts[2][1..-1].to_i(16)
      elsif args.is_a? Hash
        @message = args[:message]
        @device  = args[:device]
        @number  = args[:number]
      end
    end

    # build the ack to use as a response for this message
    def ack
      XvmMessage.new(:message => 'ACK', :device => self.device, :number => self.number)
    end

    def self.is_valid?(msg)
      msg.chomp!
      return false unless msg[0] == '>' and msg[-1] == '<' # message between > <
      return false unless msg[-3..-2] == checksum(msg[0..-5]) # message checksum matches
      true
    end

    def to_s
      m = ">#{@message};ID=#{@device};##{("%04x" % @number).upcase};"
      m + "*#{XvmMessage.checksum(m)}<"
    end

    # Calculates the checksum of a string
    # from VirHelp V1.84.3:
    #   En formato hexadecimal que se calcula haciendo una XOR OR-exclusiva con todos los códigos ASCII de los caracteres
    #   que componen el mensaje comenzando con > y terminando en el último ; incluido pero no incluyendo, el * indicador
    #   de Check SUM
    def self.checksum(msg)
      sum = 0
      msg.each_byte do |b|
        sum ^= b
      end
      ("%02x" % sum).upcase
    end

  end

  # RUS00 report virloc message with performance data
  class PerformanceMessage < XvmMessage
    #returns a hash with the values contained in the message
    def parse
      m = @message.split(',')

      {:datetime => m[1],
       :wbs      => m[2].to_i, # wheel based speed
       :esr      => m[3].to_i, # engine speed rpm
       :tvd      => m[4].to_i, # total vehicle distance
       :tvdhp    => m[5].to_i, # total vehicle distance high precision
       :fcl      => m[6].to_i, # fuel consumption liquid (Engine Total Fuel Used)
       :fel      => m[7].to_i, # fuel economy liquid (Km/L)
       :ect      => m[8].to_i, # engine coolant temperature
       :efr      => m[9].to_i, # engine fuel rate (Litre/Hour)
      }
    end

    # saves himself using the given datasource
    def save(datasource)
      data = self.parse
      data[:device] = self.device
      datasource.save_performance(data)
    end


  end

  # RGP virloc messages
  class GeopositionMessage < XvmMessage
    #returns a hash with the values contained in the message
    def parse
      m = @message

      {:datetime => m[3..14],
       :lat      => m[15..22], # latitude
       :lon      => m[23..31], # lingitude
       :speed    => m[32..34], # speed
       :head     => m[35..37], # heading (North, South, East, West, etc.)
       :status   => m[38], # status of the gps signal
       :age      => m[39..40].to_i(16)} # age of the last valid gps tick, in seconds
    end

    def save(datasource)
      data = self.parse
      data[:device] = self.device
      datasource.save_geoposition(data)
    end
  end
end