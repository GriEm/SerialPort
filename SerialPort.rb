require './low_level/WinAPI'
require './low_level/DCB'
require './low_level/Timeouts'

class SerialPort

  class PortNameError   < StandardError; end
  class ConnectError    < StandardError; end
  class DisconnectError < StandardError; end
  class FlushError      < StandardError; end
  class PurgeError      < StandardError; end
  class OutputError     < StandardError; end
  class InputError      < StandardError; end  
  class DTRSignalError  < StandardError; end
  class RTSSignalError  < StandardError; end
  
  # default settings
  
  DEFAULT_BRATE         = CBR_9600
  DEFAULT_BYTE_SIZE     = 8
  DEFAULT_STOP_BITS     = ONESTOPBIT
  DEFAULT_PARITY        = NOPARITY
  DEFAULT_WRITE_TIMEOUT = 1500
  DEFAULT_READ_TIMEOUT  = 1500
  DEFAULT_IN_BUFFER     = 512
  
  # all settings of serial port (hash)
  
  attr_reader :settings

  def initialize(port, options = {})
  
    raise PortNameError if port.nil?
    raise PortNameError unless port.gsub(" ","") =~ /^(COM){1}[0-9]+/i
  
    @hCom = CreateFile.call(  port,
                              GENERIC_READ | GENERIC_WRITE,
                              0,
                              NULL,
                              OPEN_EXISTING,
                              0,
                              NULL  )
                              
    if @hCom == INVALID_HANDLE_VALUE
      raise ConnectError, "System Error Code: #{GetLastError.call}"
    end
    
    @settings = { :PORT => port.gsub(" ","").upcase }
    
    @dcb      = DCB.new(@hCom)
    @timeout  = Timeouts.new(@hCom)
    
    # set serial port options
    
    self.baud_rate      = options[:BAUD_RATE]     || DEFAULT_BRATE
    self.byte_size      = options[:BYTE_SIZE]     || DEFAULT_BYTE_SIZE
    self.stop_bits      = options[:STOP_BITS]     || DEFAULT_STOP_BITS
    self.parity         = options[:PARITY]        || DEFAULT_PARITY
    self.write_timeout  = options[:WRITE_TIMEOUT] || DEFAULT_WRITE_TIMEOUT
    self.read_timeout   = options[:READ_TIMEOUT]  || DEFAULT_READ_TIMEOUT
    self.in_buff_size   = options[:IN_BUFFER]     || DEFAULT_IN_BUFFER

    # clear TX and RX buffers

    self.purge(PURGE_RXCLEAR | PURGE_TXCLEAR)
  end
  
  def close
    unless CloseHandle.call(@hCom)
      raise DisconnectError, "System Error Code: #{GetLastError.call}"
    end
  end
  
  # set options of serial port

  def baud_rate=(value)
    @settings[:BAUD_RATE] = @dcb[DCB::BAUD_RATE] = value
  end
  
  def byte_size=(value)
    @settings[:BYTE_SIZE] = @dcb[DCB::BYTE_SIZE] = value
  end
  
  def stop_bits=(value)
    @settings[:STOP_BITS] = @dcb[DCB::STOP_BITS] = value
  end
  
  def parity=(value)
    @settings[:PARITY] = @dcb[DCB::PARITY] = value
  end
  
  def write_timeout=(value)
    @timeout[Timeouts::WRITE_TOTAL] = value
    @settings[:WRITE_TIMEOUT] = value
  end
  
  def read_timeout=(value)
    @timeout[Timeouts::READ_TOTAL] = value
    @settings[:READ_TIMEOUT] = value
  end
  
  def in_buff_size=(value)
    @settings[:IN_BUFFER] = value
  end
  
  # break receiving/transmitting and clear TX and RX buffers 
  
  def purge(options)
    unless PurgeComm.call(@hCom, options)
      raise PurgeError, "System Error Code: #{GetLastError.call}"
    end
  end
  
  # receive/transmit data and clear TX and RX buffers
  
  def flush
    unless FlushFileBuffers.call(@hCom)
      raise FlushError, "System Error Code: #{GetLastError.call}"
    end
  end
  
  # send data (data.class == String)
  
  def output=(data)
    unless data.nil?
      cnt_written = '\0' * 4
      unless WriteFile.call(@hCom, data, data.size, cnt_written, NULL)
        raise OutputError, "System Error Code: #{GetLastError.call}"
      end
    end
  end
  
  # get data (return String)
  
  def input
    cnt_read = '\0' * 4
    @in_buff = '\0' * @settings[:IN_BUFFER]
    
    unless ReadFile.call(@hCom, @in_buff, @settings[:IN_BUFFER], cnt_read, NULL)
      raise InputError, "System Error Code: #{GetLastError.call}"
    end
    
    @in_buff[0...cnt_read.unpack('L')[0]]
  end
  
  # set DTR if value >= 1 and clear DTR in other case
  
  def DTR=(value)
    unless EscapeCommFunction.call(@hCom, value >= 1 ? SETDTR : CLRDTR)
      raise DTRSignalError, "System Error Code: #{GetLastError.call}"
    end
  end
  
  # set RTS if value >= 1 and clear RTS in other case
  
  def RTS=(value)
    unless EscapeCommFunction.call(@hCom, value >= 1 ? SETRTS : CLRRTS)
      raise RTSSignalError, "System Error Code: #{GetLastError.call}"
    end
  end

end