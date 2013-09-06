require './low_level/WinAPI'

# typedef struct _COMMTIMEOUTS {
  # DWORD ReadIntervalTimeout;
  # DWORD ReadTotalTimeoutMultiplier;
  # DWORD ReadTotalTimeoutConstant;
  # DWORD WriteTotalTimeoutMultiplier;
  # DWORD WriteTotalTimeoutConstant;
# } COMMTIMEOUTS, *LPCOMMTIMEOUTS;

class Timeouts

  # available Timeouts fields
  
  READ_TOTAL  = 2   # DWORD ReadTotalTimeoutConstant
  WRITE_TOTAL = 5   # DWORD WriteTotalTimeoutConstant

  def initialize(hCom)
    raise ArgumentError, "Invalid COM handle" if hCom.nil?
    @hCom = hCom
    get_system_timeouts
  end
  
  def [](field)
    get_system_timeouts
    case field
      when READ_TOTAL   then @timeouts[READ_TOTAL]
      when WRITE_TOTAL  then @timeouts[WRITE_TOTAL]
      else
        nil
    end
  end
  
  def []=(field,value)
    if value < 0
      raise ArgumentError, "Invalid timeout value (#{value})"
    end
    
    case field
      when READ_TOTAL   then @timeouts[READ_TOTAL]  = value
      when WRITE_TOTAL  then @timeouts[WRITE_TOTAL] = value
      else
        raise ArgumentError, "Unavailable Timeouts filed"
    end
    set_system_timeouts
  end
  
  private
  
  # get current _COMMTIMEOUTS value
  
  def get_system_timeouts
    @timeouts = '\0' * 20
    unless GetCommTimeouts.call(@hCom,@timeouts)
      raise RuntimeError, "System Error Code: #{GetLastError.call}"
    end
    @timeouts = @timeouts.unpack("LLLLL")
  end
  
  # set new _COMMTIMEOUTS value
  
  def set_system_timeouts
    unless SetCommTimeouts.call(@hCom,@timeouts.pack('LLLLL'))
      raise RuntimeError, "System Error Code: #{GetLastError.call}"
    end
  end
  
end