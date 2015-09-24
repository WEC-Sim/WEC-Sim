@echo off
set COMPILER=cl 
        set COMPFLAGS=/c /GR /W3 /EHs /nologo /MD -I"C:\Program Files\MATLAB\R2014b\extern\include" -I"C:\Program Files\MATLAB\R2014b\simulink\include"  /D_CRT_SECURE_NO_DEPRECATE /D_SCL_SECURE_NO_DEPRECATE /D_SECURE_SCL=0  /DMATLAB_MEX_FILE /D_CRT_SECURE_NO_DEPRECATE /D_SCL_SECURE_NO_DEPRECATE /D_SECURE_SCL=0  /DMATLAB_MEX_FILE  /DMATLAB_MEX_FILE 
        set OPTIMFLAGS=/O2 /Oy- /DNDEBUG 
        set DEBUGFLAGS=/Z7 
        set LINKER=link 
        set LINKFLAGS=/nologo /manifest /export:%ENTRYPOINT% /DLL  /LIBPATH:"C:\Program Files\MATLAB\R2014b\extern\lib\win64\microsoft" libmx.lib libmex.lib libmat.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /EXPORT:mexFunction 
        set LINKDEBUGFLAGS=/debug /PDB:"%OUTDIR%%MEX_NAME%.mexw64.pdb" 
        set NAME_OUTPUT=/out:"%OUTDIR%%MEX_NAME%%MEX_EXT%"
set PATH=C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE;C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\Tools;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\Bin\amd64;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\Bin\VCPackages;C:\Program Files\Microsoft SDKs\Windows\v7.1\\Bin\x64;C:\Program Files\Microsoft SDKs\Windows\v7.1\\Bin;;%MATLAB_BIN%;%PATH%
set INCLUDE=C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\INCLUDE;C:\Program Files\Microsoft SDKs\Windows\v7.1\\INCLUDE;C:\Program Files\Microsoft SDKs\Windows\v7.1\\INCLUDE\gl;C:\Program Files\MATLAB\R2014b\extern\include;;%INCLUDE%
set LIB=C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\Lib\amd64;C:\Program Files\Microsoft SDKs\Windows\v7.1\\Lib\X64;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\ATLMFC\LIB\AMD64;C:\Program Files\MATLAB\R2014b\lib\win64;C:\Program Files\MATLAB\R2014b\extern\lib\win64;%LIB%
set LIBPATH=C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\Lib\amd64;C:\Program Files\Microsoft SDKs\Windows\v7.1\\LIB\X64;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\ATLMFC\LIB\AMD64;C:\Program Files\MATLAB\R2014b\extern\lib\win64;%LIBPATH%

nmake -f RM3_sfun.mak
