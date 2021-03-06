require 'serialport'

class OBDInterface

  def initialize port, baud = 38400, nbits = 7, stopb = 1
    @port = port
    @baud = baud
    @nbits = nbits
    @stopb = stopb
    @thread = nil
  end

  #opens the serial port connection
  def connect
    disconnect
    @sp = SerialPort.new(@port, @baud, @nbits, @stopb, SerialPort::NONE)
  end

  #close the serial port connection
  def disconnect
    @sp.close if @sp
  end

  # Sends a reset message to the OBD interface
  def reset
    at_message 'Z'
  end

  #Instructs the OBD interface to monitor all traffic
  def monitor_all
    at_message 'MA'
  end

  # Send a command to the OBD interface
  def at_message message
    write "AT #{message}"
  end

  #read a single message from the obd interface
  def read_message
    @sp.readline
  end

#  def process_messages callback
#    @thread = Thread.new(self) do |obd|
#        obd.connect
#        msg = obd.read_message
#        while msg do
#          callback.process_message msg
#          msg = obd.read_message
#        end
#        obd.disconnect
#    end
#  end

  private
  def write(message)
    @sp.write(message)
  end
end
