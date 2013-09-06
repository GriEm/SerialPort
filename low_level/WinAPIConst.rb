# Win32API constant (see MSDN)

NULL = 0

INVALID_HANDLE_VALUE = -1

# File security and access rights

GENERIC_READ  = 0x80000000
GENERIC_WRITE = 0x40000000

# An action to take on a file or device that exists
# or does not exist (see CreateFile and parameter 
# dwCreationDisposition in MSDN)

# For devices is usually set to OPEN_EXISTING.

OPEN_EXISTING = 0x00000003

# The file or device attributes and flags

FILE_FLAG_OVERLAPPED = 0x40000000

# Flags for PurgeComm function

PURGE_RXABORT = 0x0002
PURGE_RXCLEAR = 0x0008
PURGE_TXABORT = 0x0001
PURGE_TXCLEAR = 0x0004

# Baud rate

CBR_110       = 110
CBR_300       = 300
CBR_600       = 600
CBR_1200      = 1200
CBR_2400      = 2400
CBR_4800      = 4800
CBR_9600      = 9600
CBR_14400     = 14400
CBR_19200     = 19200
CBR_38400     = 38400
CBR_56000     = 56000
CBR_57600     = 57600
CBR_115200    = 115200
CBR_128000    = 128000
CBR_256000    = 256000

# Stop bits

ONESTOPBIT    = 0
ONE5STOPBITS  = 1
TWOSTOPBITS   = 2

# Parity

NOPARITY      = 0
ODDPARITY     = 1
EVENPARITY    = 2
MARKPARITY    = 3
SPACEPARITY   = 4

# The extended function of communications device
# (see EscapeCommFunction in MSDN)

CLRBREAK  = 9
CLRDTR    = 6
CLRRTS    = 4
SETBREAK  = 8
SETDTR    = 5
SETRTS    = 3
SETXOFF   = 1
SETXON    = 2