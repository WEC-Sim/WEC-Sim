# ------------------- Required for MSVC nmake ---------------------------------
# This file should be included at the top of a MAKEFILE as follows:


CPU = AMD64
!include <ntwin32.mak>

MACHINE     = WECSim_Lib
TARGET      = sfun
CHART_SRCS   = c2_WECSim_Lib.c c8_WECSim_Lib.c
MACHINE_SRC  = WECSim_Lib_sfun.c
MACHINE_REG = 
MAKEFILE    = WECSim_Lib_sfun.mak
MATLAB_ROOT  = C:\Program Files\MATLAB\R2014b
BUILDARGS   =

#--------------------------- Tool Specifications ------------------------------
#
#
MSVC_ROOT1 = $(MSDEVDIR:SharedIDE=vc)
MSVC_ROOT2 = $(MSVC_ROOT1:SHAREDIDE=vc)
MSVC_ROOT  = $(MSVC_ROOT2:sharedide=vc)

# Compiler tool locations, CC, LD, LIBCMD:
CC     = cl.exe
LD     = link.exe
LIBCMD = lib.exe
#------------------------------ Include/Lib Path ------------------------------

USER_INCLUDES   = 
AUX_INCLUDES   = 
MLSLSF_INCLUDES = \
    /I "C:\Program Files\MATLAB\R2014b\extern\include" \
    /I "C:\Program Files\MATLAB\R2014b\simulink\include" \
    /I "C:\Program Files\MATLAB\R2014b\stateflow\c\mex\include" \
    /I "C:\Program Files\MATLAB\R2014b\rtw\c\src" \
    /I "C:\Users\rso\Documents\GitHub\WEC-Sim_NAK\tutorials\RM3\slprj\_sfprj\RM3\WECSim_Lib\sfun\src" 

COMPILER_INCLUDES = /I "$(MSVC_ROOT)\include"

THIRD_PARTY_INCLUDES   = 
INCLUDE_PATH = $(USER_INCLUDES) $(AUX_INCLUDES) $(MLSLSF_INCLUDES)\
 $(THIRD_PARTY_INCLUDES)
LIB_PATH     = "$(MSVC_ROOT)\lib"

CFLAGS = /c /Zp8 /GR /W3 /EHs /D_CRT_SECURE_NO_DEPRECATE /D_SCL_SECURE_NO_DEPRECATE /D_SECURE_SCL=0 /DMATLAB_MEX_FILE /nologo /MD 
LDFLAGS = /nologo /dll /MANIFEST /OPT:NOREF /export:mexFunction  
#----------------------------- Source Files -----------------------------------

REQ_SRCS  =  $(MACHINE_SRC) $(MACHINE_REG) $(CHART_SRCS)

USER_ABS_OBJS =

AUX_ABS_OBJS =

THIRD_PARTY_OBJS =

REQ_OBJS = $(REQ_SRCS:.cpp=.obj)
REQ_OBJS2 = $(REQ_OBJS:.c=.obj)
OBJS = $(REQ_OBJS2) $(USER_ABS_OBJS) $(AUX_ABS_OBJS) $(THIRD_PARTY_OBJS)
OBJLIST_FILE = WECSim_Lib_sfun.mol
SFCLIB = 
AUX_LNK_OBJS =     
USER_LIBS = 
LINK_MACHINE_LIBS = 
BLAS_LIBS = "C:\Program Files\MATLAB\R2014b\extern\lib\win64\microsoft\libmwblas.lib" 
THIRD_PARTY_LIBS = 

#--------------------------------- Rules --------------------------------------

$(MACHINE)_$(TARGET).lib : $(MAKEFILE) $(OBJS) $(SFCLIB) $(AUX_LNK_OBJS) $(USER_LIBS) $(THIRD_PARTY_LIBS)
	@echo ### Linking ...
	$(LD) -lib /OUT:$(MACHINE)_$(TARGET).lib @$(OBJLIST_FILE) $(USER_LIBS) $(THIRD_PARTY_LIBS)
	@echo ### Created Stateflow library $@
.c.obj :
	@echo ### Compiling "$<"
	$(CC) $(CFLAGS) $(INCLUDE_PATH) "$<"

.cpp.obj :
	@echo ### Compiling "$<"
	$(CC) $(CFLAGS) $(INCLUDE_PATH) "$<"


