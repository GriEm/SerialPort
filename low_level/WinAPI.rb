require 'Win32API'
require './low_level/WinAPIConst'

# HANDLE WINAPI CreateFile(
  # _In_      LPCTSTR lpFileName,
  # _In_      DWORD dwDesiredAccess,
  # _In_      DWORD dwShareMode,
  # _In_opt_  LPSECURITY_ATTRIBUTES lpSecurityAttributes,
  # _In_      DWORD dwCreationDisposition,
  # _In_      DWORD dwFlagsAndAttributes,
  # _In_opt_  HANDLE hTemplateFile
# );

CreateFile  = Win32API.new('kernel32','CreateFile','PLLPLLL','L')

# BOOL WINAPI CloseHandle(
  # _In_  HANDLE hObject
# );

CloseHandle = Win32API.new('kernel32','CloseHandle','L','L')

# BOOL WINAPI SetCommState(
  # _In_  HANDLE hFile,
  # _In_  LPDCB lpDCB
# );

SetCommState = Win32API.new('kernel32','SetCommState','LP','L')

# BOOL WINAPI GetCommState(
  # _In_     HANDLE hFile,
  # _Inout_  LPDCB lpDCB
# );

GetCommState = Win32API.new('kernel32','GetCommState','LP','L')

# BOOL WINAPI SetCommTimeouts(
  # _In_  HANDLE hFile,
  # _In_  LPCOMMTIMEOUTS lpCommTimeouts
# );

SetCommTimeouts = Win32API.new('kernel32','SetCommTimeouts','LP','L')

# BOOL WINAPI GetCommTimeouts(
  # _In_   HANDLE hFile,
  # _Out_  LPCOMMTIMEOUTS lpCommTimeouts
# );

GetCommTimeouts = Win32API.new('kernel32','GetCommTimeouts','LP','L')

# BOOL WINAPI PurgeComm(
  # _In_  HANDLE hFile,
  # _In_  DWORD dwFlags
# );

PurgeComm = Win32API.new('kernel32','PurgeComm','LL','L')

# BOOL WINAPI FlushFileBuffers(
  # _In_  HANDLE hFile
# );

FlushFileBuffers = Win32API.new('kernel32','FlushFileBuffers','L','L')

# BOOL WINAPI WriteFile(
  # _In_         HANDLE hFile,
  # _In_         LPCVOID lpBuffer,
  # _In_         DWORD nNumberOfBytesToWrite,
  # _Out_opt_    LPDWORD lpNumberOfBytesWritten,
  # _Inout_opt_  LPOVERLAPPED lpOverlapped
# );

WriteFile = Win32API.new('kernel32','WriteFile','LPLPP','L')

# BOOL WINAPI ReadFile(
  # _In_         HANDLE hFile,
  # _Out_        LPVOID lpBuffer,
  # _In_         DWORD nNumberOfBytesToRead,
  # _Out_opt_    LPDWORD lpNumberOfBytesRead,
  # _Inout_opt_  LPOVERLAPPED lpOverlapped
# );

ReadFile = Win32API.new('kernel32','ReadFile','LPLPP','L')

# DWORD WINAPI GetLastError(void);

GetLastError = Win32API.new('kernel32','GetLastError','V','L')

# BOOL WINAPI EscapeCommFunction(
  # _In_  HANDLE hFile,
  # _In_  DWORD dwFunc
# );

EscapeCommFunction = Win32API.new('kernel32','EscapeCommFunction','LL','L')