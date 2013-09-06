require './low_level/WinAPI'

# typedef struct _DCB {
  # DWORD DCBlength;              // sizeof(DCB)
  # DWORD BaudRate;               // current baud rate
  # DWORD fBinary : 1;            // binary mode, no EOF check
  # DWORD fParity : 1;            // enable parity checking
  # DWORD fOutxCtsFlow : 1;       // CTS output flow control
  # DWORD fOutxDsrFlow : 1;       // DSR output flow control
  # DWORD fDtrControl : 2;        // DTR flow control type
  # DWORD fDsrSensitivity : 1;    // DSR sensitivity
  # DWORD fTXContinueOnXoff : 1;  // XOFF continues Tx
  # DWORD fOutX : 1;              // XON/XOFF out flow control
  # DWORD fInX : 1;               // XON/XOFF in flow control
  # DWORD fErrorChar : 1;         // enable error replacement
  # DWORD fNull : 1;              // enable null stripping
  # DWORD fRtsControl : 2;        // RTS flow control
  # DWORD fAbortOnError : 1;      // abort reads/writes on error
  # DWORD fDummy2 : 17;           // reserved
  # WORD  wReserved;              // not currently used
  # WORD  XonLim;                 // transmit XON threshold
  # WORD  XoffLim;                // transmit XOFF threshold
  # BYTE  ByteSize;               // number of bits/byte, 5-8
  # BYTE  Parity;                 // 0-4=no,odd,even,mark,space
  # BYTE  StopBits;               // 0,1,2 = 1, 1.5, 2
  # char  XonChar;                // Tx and Rx XON character
  # char  XoffChar;               // Tx and Rx XOFF character
  # char  ErrorChar;              // error replacement character
  # char  EofChar;                // end of input character
  # char  EvtChar;                // received event character
  # WORD  wReserved1;             // reserved; do not use
# } DCB;

class DCB

  # available DCB fields

  BAUD_RATE = 1   # DWORD BaudRate  // current baud rate
  BYTE_SIZE = 6   # BYTE  ByteSize  // number of bits/byte, 5-8
  PARITY    = 7   # BYTE  Parity    // 0-4=no,odd,even,mark,space
  STOP_BITS = 8   # BYTE  StopBits  // 0,1,2 = 1, 1.5, 2

  def initialize(hCom)
    raise ArgumentError, "Invalid COM handle" if hCom.nil?
    @hCom = hCom
    get_system_dcb
  end
  
  # get _DCB fields
  
  def [](field)
    get_system_dcb
    case field
      when BAUD_RATE  then @dcb[BAUD_RATE]
      when BYTE_SIZE  then @dcb[BYTE_SIZE]
      when PARITY     then @dcb[PARITY]
      when STOP_BITS  then @dcb[STOP_BITS]
      else
        nil
    end
  end
  
  # set _DCB field
  
  def []=(field,value)
    case field
      when BAUD_RATE
      
        set_param(  BAUD_RATE,
                    value,
                    [ 
                      CBR_110,    CBR_300,    CBR_600,
                      CBR_1200,   CBR_2400,   CBR_4800,
                      CBR_9600,   CBR_14400,  CBR_19200,
                      CBR_38400,  CBR_56000,  CBR_57600,
                      CBR_115200, CBR_128000, CBR_256000
                    ]
                  )
                    
      when BYTE_SIZE
      
        check_ds_size(value, @dcb[STOP_BITS])
        set_param( BYTE_SIZE, value, [5, 6, 7, 8] )
      
      when PARITY
        
        set_param(  PARITY,
                    value,
                    [
                      NOPARITY,   ODDPARITY,
                      EVENPARITY, MARKPARITY,
                      SPACEPARITY
                    ]
                  )
      
      when STOP_BITS
      
        check_ds_size(@dcb[BYTE_SIZE], value)
        set_param( STOP_BITS, value, [ONESTOPBIT, ONE5STOPBITS, TWOSTOPBITS] )
      
      else
        raise ArgumentError, "Unavailable DCB filed"
    end
    set_system_dcb
  end
  
  private
  
  # get current _DCB value
  
  def get_system_dcb
    @dcb  = "\0" * 80
    unless GetCommState.call(@hCom,@dcb)
      raise RuntimeError, "System Error Code: #{GetLastError.call}"
    end
    @dcb = @dcb.unpack('LLLSSSCCCcccccS')
  end
  
  # set new _DCB value
  
  def set_system_dcb
    unless SetCommState.call(@hCom,@dcb.pack('LLLSSSCCCcccccS'))
      raise RuntimeError, "System Error Code: #{GetLastError.call}"
    end
  end
  
  def set_param(param, value, avail_values)
    if avail_values.include?(value)
      @dcb[param] = value
    else
      raise ArgumentError, "Invalid value"
    end
  end
  
  def check_ds_size(data_b, stop_b)
    if data_b == 5 && stop_b == TWOSTOPBITS
      raise ArgumentError, "Invalid combination " +
                            "(5 data bits with 2 stop bits)"
    end 
    
    if [6..8].include?(data_b) && stop_b == ONE5STOPBITS
      raise ArgumentError, "Invalid combination " +
                          "(#{data_b} data bits with 1.5 stop bits)"
    end
  end
  
end