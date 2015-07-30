# Copyright 1994-2013 The MathWorks, Inc.
#
# File    : raccel_unix.tmf   
#
# Abstract:
#	Template makefile for building a UNIX-based "rapid acceleration"
#       executable from the generated C code.
#
# 	This makefile attempts to conform to the guidelines specified in the
# 	IEEE Std 1003.2-1992 (POSIX) standard. It is designed to be used
#       with GNU Make which is located in matlabroot/rtw/bin.
#
# 	Note that this template is automatically customized by the build
#       procedure to create "<model>.mk"
#
#       The following defines can be used to modify the behavior of the
#	build:
#	  OPT_OPTS       - Optimization options. Default is -O.
#	  CPP_OPTS       - C++ compiler options.
#	  OPTS           - User specific compile options.
#	  USER_SRCS      - Additional user sources, such as files needed by
#			   S-functions.
#	  USER_INCLUDES  - Additional include paths
#			   (i.e. USER_INCLUDES="-Iwhere-ever -Iwhere-ever2")
#
#       To enable debugging:
#         set DEBUG_BUILD = 1 below, which will trigger OPTS=-g and
#          LDFLAGS += -g (may vary with compiler version, see compiler doc)
#
#       This template makefile is designed to be used with a system target
#       file that contains 'rtwgensettings.BuildDirSuffix' see raccel.tlc

#------------------------ Macros read by make_rtw ------------------------------
#
# The following macros are read by the build procedure:
#
#  MAKECMD         - This is the command used to invoke the make utility
#  HOST            - What platform this template makefile is targeted for
#                    (i.e. PC or UNIX)
#  BUILD           - Invoke make from the build procedure (yes/no)?
#  SYS_TARGET_FILE - Name of system target file.

MAKECMD         = /Applications/MATLAB_R2015a.app/bin/maci64/gmake
HOST            = UNIX
BUILD           = yes
SYS_TARGET_FILE = raccel.tlc
BUILD_SUCCESS	= *** Created
COMPILER_TOOL_CHAIN = unix

#---------------------- Tokens expanded by make_rtw ----------------------------
#
# The following tokens, when wrapped with "|>" and "<|" are expanded by the
# build procedure.
#
#  MODEL_NAME          - Name of the Simulink block diagram
#  MODEL_MODULES       - Any additional generated source modules
#  MAKEFILE_NAME       - Name of makefile created from template makefile <model>.mk
#  MATLAB_ROOT         - Path to where MATLAB is installed.
#  S_FUNCTIONS         - List of S-functions.
#  S_FUNCTIONS_LIB     - List of S-functions libraries to link.
#  COMPUTER            - Computer type. See the MATLAB computer command.
#  BUILDARGS           - Options passed in at the command line.
#  EXT_MODE            - yes (1) or no (0): Build for external mode
#  TMW_EXTMODE_TESTING - yes (1) or no (0): Build ext_test.c for external mode
#                        testing.
#  EXTMODE_TRANSPORT   - Name of transport mechanism (e.g. tcpip, serial) for extmode
#  EXTMODE_STATIC      - yes (1) or no (0): Use static instead of dynamic mem alloc.
#  EXTMODE_STATIC_SIZE - Size of static memory allocation buffer.
#  TGT_FCN_LIB         - Target Funtion library to use


MODEL                  = model
MODULES                = model_504c237a_1.c model_504c237a_1_assembly.c model_504c237a_1_checkDynamics.c model_504c237a_1_create.c model_504c237a_1_deriv.c model_504c237a_1_outputDyn.c model_504c237a_1_outputKin.c model_504c237a_gateway.c model_capi.c model_data.c model_tgtconn.c rtGetInf.c rtGetNaN.c rt_backsubrr_dbl.c rt_forwardsubrr_dbl.c rt_logging.c rt_logging_mmi.c rt_lu_real.c rt_matrixlib_dbl.c rt_nonfinite.c rtw_modelmap_utils.c 
MAKEFILE               = model.mk
MATLAB_ROOT            = /Applications/MATLAB_R2015a.app
ALT_MATLAB_ROOT        = /Applications/MATLAB_R2015a.app
MATLAB_ROOTQ           = \"/Applications/MATLAB_R2015a.app\"
MASTER_ANCHOR_DIR      = 
START_DIR              = /Users/mlawson/Applications/WEC-Sim_lawsonro3/tutorials/COER_OMAE2015_Competition
S_FUNCTIONS            = rtiostream_utils.c
S_FUNCTIONS_LIB        = $(MATLAB_ROOT)/bin/maci64/libmwcoder_target_services.dylib $(MATLAB_ROOT)/bin/maci64/libmwcoder_ToAsyncQueueTgtAppSvc.dylib
COMPUTER               = MACI64
BUILDARGS              =  RSIM_SOLVER_SELECTION=2 PCMATLABROOT="/Applications/MATLAB_R2015a.app" EXT_MODE=1 ISPROTECTINGMODEL=NOTPROTECTING OPTS="-DTGTCONN -DON_TARGET_WAIT_FOR_START=0"
RSIM_PARAMETER_LOADING = 1
ENABLE_SLEXEC_SSBRIDGE = 0

EXT_MODE            = 1
TMW_EXTMODE_TESTING = 0
EXTMODE_TRANSPORT   = 0
EXTMODE_STATIC      = 0
EXTMODE_STATIC_SIZE = 1000000

SOLVER              = ode4.c
SOLVER_TYPE         = FixedStep
NUMST               = 2
TID01EQ             = 1
NCSTATES            = 6
MULTITASKING        = 0
TGT_FCN_LIB         = None

MODELREFS           = 
SHARED_SRC          = 
SHARED_SRC_DIR      = 
SHARED_BIN_DIR      = 
SHARED_LIB          = 
OPTIMIZATION_FLAGS  = -O0 -DNDEBUG
ADDITIONAL_LDFLAGS  = 

RACCEL_PARALLEL_EXECUTION = 0
RACCEL_PARALLEL_EXECUTION_NUM_THREADS = 2
RACCEL_NUM_PARALLEL_NODES = 1
RACCEL_PARALLEL_SIMULATOR_TYPE = 0

# To enable debugging:
# set DEBUG_BUILD = 1
DEBUG_BUILD             = 0


#--------------------------- Model and reference models -----------------------
MODELLIB                  = modellib.a
MODELREF_LINK_LIBS        = 
MODELREF_INC_PATH         = 
RELATIVE_PATH_TO_ANCHOR   = ../../..
# NONE: standalone, SIM: modelref sim, RTW: modelref coder target
MODELREF_TARGET_TYPE       = NONE

GLOBAL_TIMING_ENGINE       = 0

#-- In the case when directory name contains space ---
ifneq ($(MATLAB_ROOT),$(ALT_MATLAB_ROOT))
MATLAB_ROOT := $(ALT_MATLAB_ROOT)
endif

#--------------------------- Solver ---------------------------------------------
RSIM_WITH_SL_SOLVER = 1

#--------------------------- Tool Specifications -------------------------------

include $(MATLAB_ROOT)/rtw/c/tools/unixtools.mk

#----------------------------- External mode -----------------------------------
# Uncomment -DVERBOSE to have information printed to stdout
# To add a new transport layer, see the comments in
#   <matlabroot>/toolbox/simulink/simulink/extmode_transports.m
EXT_CC_OPTS = -DEXT_MODE -D$(COMPUTER) #-DVERBOSE
EXT_LIB     =
EXT_SRC     =
ifeq ($(EXTMODE_TRANSPORT),0) #tcpip
  EXT_SRC = ext_svr.c updown.c ext_work.c rtiostream_interface.c rtiostream_tcpip.c
endif
ifeq ($(EXTMODE_TRANSPORT),1) #serial_win32
  err:
	@echo
	@echo "### ERROR: External mode serial transport only available on win32"
	@echo
endif
ifeq ($(TMW_EXTMODE_TESTING),1)
  EXT_SRC     += ext_test.c
  EXT_CC_OPTS += -DTMW_EXTMODE_TESTING
endif
ifeq ($(EXTMODE_STATIC),1)
  EXT_SRC     += mem_mgr.c
  EXT_CC_OPTS += -DEXTMODE_STATIC -DEXTMODE_STATIC_SIZE=$(EXTMODE_STATIC_SIZE)
endif

#------------------------------Parameter Tuning---------------------------------
PARAM_CC_OPTS = -DRSIM_PARAMETER_LOADING

#------------------------------ Include Path -----------------------------------

MATLAB_INCLUDES = \
	-I$(MATLAB_ROOT)/simulink/include \
	-I$(MATLAB_ROOT)/extern/include \
	-I$(MATLAB_ROOT)/rtw/c/src \
	-I$(MATLAB_ROOT)/rtw/c/src/rapid \
	-I$(MATLAB_ROOT)/rtw/c/raccel \
	-I$(MATLAB_ROOT)/rtw/c/src/ext_mode/common

# Additional includes

ADD_INCLUDES = \
	-I$(START_DIR)/slprj/raccel/model \
	-I$(START_DIR) \
	-I$(MATLAB_ROOT)/toolbox/coder/rtiostream/src/utils \
	-I$(MATLAB_ROOT)/toolbox/physmod/sm/ssci/c \
	-I$(MATLAB_ROOT)/toolbox/physmod/sm/core/c \
	-I$(MATLAB_ROOT)/toolbox/physmod/pm_math/c \
	-I$(MATLAB_ROOT)/toolbox/physmod/simscape/engine/sli/c \
	-I$(MATLAB_ROOT)/toolbox/physmod/simscape/engine/core/c \
	-I$(MATLAB_ROOT)/toolbox/physmod/simscape/compiler/core/c \
	-I$(MATLAB_ROOT)/toolbox/physmod/network_engine/c \
	-I$(MATLAB_ROOT)/toolbox/physmod/common/foundation/core/c \



SHARED_INCLUDES =
ifneq ($(SHARED_SRC_DIR),)
SHARED_INCLUDES = -I$(SHARED_SRC_DIR)
endif

INCLUDES = -I. -I$(RELATIVE_PATH_TO_ANCHOR)  $(MATLAB_INCLUDES) $(ADD_INCLUDES) $(USER_INCLUDES) \
	$(INSTRUMENT_INCLUDES) 	$(MODELREF_INC_PATH) $(SHARED_INCLUDES)

#-------------------------------- C Flags --------------------------------------

# Optimization Options
ifndef OPT_OPTS
OPT_OPTS = $(DEFAULT_OPT_OPTS)
endif

# General User Options
ifeq ($(DEBUG_BUILD),0)
DBG_FLAG =
else
#   Set OPTS=-g and any additional flags for debugging
DBG_FLAG = -g
LDFLAGS += -g
endif

# Compiler options, etc:
ifneq ($(OPTIMIZATION_FLAGS),)
CC_OPTS = $(OPTS) $(EXT_CC_OPTS) $(PARAM_CC_OPTS) $(OPTIMIZATION_FLAGS)
else
CC_OPTS = $(OPT_OPTS) $(OPTS) $(EXT_CC_OPTS) $(PARAM_CC_OPTS)
endif

CPP_REQ_DEFINES = -DMODEL=$(MODEL) -DHAVESTDIO -DUNIX

CPP_REQ_DEFINES += -DNRT \
                   -DRSIM_WITH_SL_SOLVER

ifneq ($(ENABLE_SLEXEC_SSBRIDGE), 0)
   CPP_REQ_DEFINES += -DENABLE_SLEXEC_SSBRIDGE=$(ENABLE_SLEXEC_SSBRIDGE)
endif

ifeq ($(RACCEL_PARALLEL_EXECUTION), 1)
   CPP_REQ_DEFINES += -DRACCEL_ENABLE_PARALLEL_EXECUTION \
		      -DRACCEL_PARALLEL_EXECUTION_NUM_THREADS=$(RACCEL_PARALLEL_EXECUTION_NUM_THREADS) \
		      -DRACCEL_NUM_PARALLEL_NODES=$(RACCEL_NUM_PARALLEL_NODES) \
		      -DRACCEL_PARALLEL_SIMULATOR_TYPE=$(RACCEL_PARALLEL_SIMULATOR_TYPE)
endif

ifeq ($(MULTITASKING),1)
    CPP_REQ_DEFINES += -DRSIM_WITH_SOLVER_MULTITASKING \
                       -DTID01EQ=$(TID01EQ) \
	               -DNUMST=$(NUMST)
endif

CFLAGS = $(ANSI_OPTS) $(DBG_FLAG) $(CC_OPTS) $(CPP_REQ_DEFINES) $(INCLUDES)
CPPFLAGS = $(CPP_ANSI_OPTS) $(DBG_FLAG) $(CPP_OPTS) $(CC_OPTS) $(CPP_REQ_DEFINES) $(INCLUDES)

#----------------------------- Source Files ------------------------------------
USER_SRCS =
SRC_DEP =
ifeq ($(MODELREF_TARGET_TYPE), NONE)
    PRODUCT            = $(MODEL)
    BIN_SETTING        = $(LD) $(LDFLAGS) -o $(PRODUCT)
    BUILD_PRODUCT_TYPE = "executable"
    REQ_SRCS = $(MODEL).c $(MODULES) $(EXT_SRC) \
       raccel_sup.c raccel_mat.c simulink_solver_api.c raccel_utils.c
    ifneq ($(ENABLE_SLEXEC_SSBRIDGE), 0)
        REQ_SRCS += raccel_main_new.c
    else
        REQ_SRCS += raccel_main.c
    endif

else
   # Model reference coder target
   PRODUCT            = $(MODELLIB)
   BUILD_PRODUCT_TYPE = "library"
   REQ_SRCS = $(MODULES)
endif

USER_OBJS       = $(addsuffix .o, $(basename $(USER_SRCS)))
LOCAL_USER_OBJS = $(notdir $(USER_OBJS))

SRCS = $(REQ_SRCS) $(S_FUNCTIONS)

OBJS      = $(addsuffix .o, $(basename $(SRCS))) $(USER_OBJS)
LINK_OBJS = $(addsuffix .o, $(basename $(SRCS))) $(LOCAL_USER_OBJS)

SHARED_SRC := $(wildcard $(SHARED_SRC))
SHARED_OBJS = $(addsuffix .o, $(basename $(SHARED_SRC)))

#--------------------------- Link flags & libraries ----------------------------

SYSLIBS = $(EXT_LIB) -lm

ifneq ($(findstring .cpp,$(suffix $(SRCS), $(USER_SRCS))),)
  LD = $(CPP)
endif

LIBS =

ifeq ($(OPT_OPTS),$(DEFAULT_OPT_OPTS))
LIBS += $(MATLAB_ROOT)/toolbox/physmod/sm/ssci/lib/maci64/sm_ssci_std.a
else
LIBS += sm_ssci.a
endif

ifeq ($(OPT_OPTS),$(DEFAULT_OPT_OPTS))
LIBS += $(MATLAB_ROOT)/toolbox/physmod/sm/core/lib/maci64/sm_std.a
else
LIBS += sm.a
endif

ifeq ($(OPT_OPTS),$(DEFAULT_OPT_OPTS))
LIBS += $(MATLAB_ROOT)/toolbox/physmod/pm_math/lib/maci64/pm_math_std.a
else
LIBS += pm_math.a
endif

ifeq ($(OPT_OPTS),$(DEFAULT_OPT_OPTS))
LIBS += $(MATLAB_ROOT)/toolbox/physmod/simscape/engine/sli/lib/maci64/ssc_sli_std.a
else
LIBS += ssc_sli.a
endif

ifeq ($(OPT_OPTS),$(DEFAULT_OPT_OPTS))
LIBS += $(MATLAB_ROOT)/toolbox/physmod/simscape/engine/core/lib/maci64/ssc_core_std.a
else
LIBS += ssc_core.a
endif

ifeq ($(OPT_OPTS),$(DEFAULT_OPT_OPTS))
LIBS += $(MATLAB_ROOT)/toolbox/physmod/network_engine/lib/maci64/ne_std.a
else
LIBS += ne.a
endif

ifeq ($(OPT_OPTS),$(DEFAULT_OPT_OPTS))
LIBS += $(MATLAB_ROOT)/toolbox/physmod/common/foundation/core/lib/maci64/pm_std.a
else
LIBS += pm.a
endif
 
LIBS += $(S_FUNCTIONS_LIB) $(INSTRUMENT_LIBS)

BINDIR = $(MATLAB_ROOT)/bin/$(ARCH)
MATLIBS=

ifneq (,$(findstring GLNX,$(COMPUTER)))
  MATLIBS = -Wl,-rpath,$(BINDIR),-L$(BINDIR)
  ifneq ($(ENABLE_SLEXEC_SSBRIDGE), 0)
    MATLIBS += -Wl,-lmwslexec_simbridge
  else
    MATLIBS += -Wl,-lmwsl_solver_rtw
  endif
  ifeq ($(RACCEL_PARALLEL_EXECUTION), 1)
    MATLIBS += -Wl,-lmwslexec_parallel
  endif

  MATLIBS += -Wl,-lmwsl_fileio
  MATLIBS += -Wl,-lmwsigstream
  MATLIBS += -Wl,-lmat,-lmx,-lut,-lmwmathutil
  MATLIBS += -L$(MATLAB_ROOT)/bin/$(ARCH) -lmwipp -lpthread
endif

ifneq (,$(findstring MAC,$(COMPUTER)))
 LD = $(CPP)
 LDFLAGS += -Wl,$(ADDITIONAL_LDFLAGS)
 MATLIBS = -L$(BINDIR) -L$(MATLAB_ROOT)/sys/os/$(ARCH)
  ifneq ($(ENABLE_SLEXEC_SSBRIDGE), 0)
    MATLIBS += -lmwslexec_simbridge
  else 
  MATLIBS += -lmwsl_solver_rtw 
  endif
  ifeq ($(RACCEL_PARALLEL_EXECUTION), 1)
    MATLIBS += -lmwslexec_parallel
  endif
  MATLIBS += -lmwsl_fileio
  MATLIBS += -lmwsigstream
  MATLIBS += -lmat -lmx -lut -lmwmathutil
  MATLIBS += -L$(MATLAB_ROOT)/bin/$(ARCH) -lmwipp -lpthread
endif

ifeq ($(MATLIBS),)
   err:
	@echo
	@echo "### ERROR: Platform $(COMPUTER) is not supported"
	@echo
endif

# Put this after the above error check so that this only appears in the Makefile
# once so TMF expansion works correctly.  If this were above the error check,
# the error check would be meaningless.
MATLIBS += -lmwsl_log_load_blocks
MATLIBS += -lfixedpoint
MATLIBS += -lmwsl_AsyncioQueue


#--------------------------------- Rules ---------------------------------------

ifeq ($(MODELREF_TARGET_TYPE),NONE)
$(PRODUCT) : $(OBJS)  $(SHARED_LIB) $(LIBS)  $(MODELREF_LINK_LIBS)
	$(BIN_SETTING) $(LINK_OBJS) $(MODELREF_LINK_LIBS) $(SHARED_LIB) \
		$(LIBS) $(MATLIBS) $(ADDITIONAL_LDFLAGS) $(SYSLIBS)
else
$(PRODUCT) : $(OBJS) $(SHARED_LIB)
	@rm -f $@
	$(AR) ruvs $@ $(LINK_OBJS)
endif
	@echo "$(BUILD_SUCCESS) $(BUILD_PRODUCT_TYPE): $@"

#-------------------------- Standard rules for building modules --------------

ifneq ($(SHARED_SRC_DIR),)
$(SHARED_BIN_DIR)/%.o : $(SHARED_SRC_DIR)/%.c
	cd $(SHARED_BIN_DIR); $(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) $(notdir $?)

$(SHARED_BIN_DIR)/%.o : $(SHARED_SRC_DIR)/%.cpp
	cd $(SHARED_BIN_DIR); $(CPP) -c $(CPPFLAGS) $(GCC_WALL_FLAG_MAX) $(notdir $?)
endif

%.o : %.c
	$(CC) -c -o $(@F) $(CFLAGS) $(GCC_WALL_FLAG) "$<"

%.o : %.cpp
	$(CPP) -c $(CPPFLAGS)$(GCC_WALL_FLAG)  "$<"

%.o : $(RELATIVE_PATH_TO_ANCHOR)/%.c
	$(CC) -c -o $(@F) $(CFLAGS) $(GCC_WALL_FLAG) "$<"

%.o : $(RELATIVE_PATH_TO_ANCHOR)/%.cpp
	$(CPP) -c $(CPPFLAGS) $(GCC_WALL_FLAG) "$<"

%.o : $(MATLAB_ROOT)/rtw/c/raccel/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/rtw/c/src/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/rtw/c/src/rapid/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/rtw/c/src/ext_mode/common/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/rtw/c/src/rtiostream/rtiostreamtcpip/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/rtw/c/src/ext_mode/custom/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

simulink_solver_api.o : $(MATLAB_ROOT)/simulink/include/simulink_solver_api.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/rtw/c/src/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/simulink/src/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/rtw/c/src/ext_mode/common/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/toolbox/coder/rtiostream/src/utils/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/toolbox/physmod/sm/ssci/c/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/toolbox/physmod/sm/core/c/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/toolbox/physmod/pm_math/c/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/toolbox/physmod/simscape/engine/sli/c/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/toolbox/physmod/simscape/engine/core/c/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/toolbox/physmod/simscape/compiler/core/c/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/toolbox/physmod/network_engine/c/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/toolbox/physmod/common/foundation/core/c/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"




%.o : $(MATLAB_ROOT)/rtw/c/src/%.cpp
	$(CPP) -c $(CPPFLAGS) "$<"
%.o : $(MATLAB_ROOT)/simulink/src/%.cpp
	$(CPP) -c $(CPPFLAGS) "$<"
%.o : $(MATLAB_ROOT)/rtw/c/src/ext_mode/common/%.cpp
	$(CPP) -c $(CPPFLAGS) "$<"
%.o : $(MATLAB_ROOT)/toolbox/coder/rtiostream/src/utils/%.cpp
	$(CPP) -c $(CPPFLAGS) "$<"
%.o : $(MATLAB_ROOT)/toolbox/physmod/sm/ssci/c/%.cpp
	$(CPP) -c $(CPPFLAGS) "$<"
%.o : $(MATLAB_ROOT)/toolbox/physmod/sm/core/c/%.cpp
	$(CPP) -c $(CPPFLAGS) "$<"
%.o : $(MATLAB_ROOT)/toolbox/physmod/pm_math/c/%.cpp
	$(CPP) -c $(CPPFLAGS) "$<"
%.o : $(MATLAB_ROOT)/toolbox/physmod/simscape/engine/sli/c/%.cpp
	$(CPP) -c $(CPPFLAGS) "$<"
%.o : $(MATLAB_ROOT)/toolbox/physmod/simscape/engine/core/c/%.cpp
	$(CPP) -c $(CPPFLAGS) "$<"
%.o : $(MATLAB_ROOT)/toolbox/physmod/simscape/compiler/core/c/%.cpp
	$(CPP) -c $(CPPFLAGS) "$<"
%.o : $(MATLAB_ROOT)/toolbox/physmod/network_engine/c/%.cpp
	$(CPP) -c $(CPPFLAGS) "$<"
%.o : $(MATLAB_ROOT)/toolbox/physmod/common/foundation/core/c/%.cpp
	$(CPP) -c $(CPPFLAGS) "$<"


%.o : $(MATLAB_ROOT)/simulink/src/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/simulink/src/%.cpp
	@$(GCC_TEST_CMD) "$<" $(GCC_TEST_OUT)
	$(CPP) -c $(CPPFLAGS) "$<"

# Libraries:



MODULES_sm_ssci = \
    sm_ssci_3dd14f0a.o \
    sm_ssci_646478c5.o \
    sm_ssci_916e6db1.o \
    sm_ssci_b2b6b422.o \
    sm_ssci_c16a187b.o \


sm_ssci.a : $(MAKEFILE) rtw_proj.tmw \
				$(MODULES_sm_ssci)
	$(AR) rs $@ $(MODULES_sm_ssci)

MODULES_sm = \
    sm_440126a7.o \
    sm_62d41fb5.o \
    sm_6fbd150d.o \
    sm_73d210b9.o \
    sm_b402b573.o \
    sm_bc63e36c.o \
    sm_c0ba649d.o \
    sm_d3d946fd.o \
    sm_e8bab6d7.o \
    sm_efdfa66e.o \
    sm_f7683dd1.o \


sm.a : $(MAKEFILE) rtw_proj.tmw \
				$(MODULES_sm)
	$(AR) rs $@ $(MODULES_sm)

MODULES_pm_math = \
    pm_math_1966ea7d.o \
    pm_math_1ad202b7.o \
    pm_math_1c69d5b2.o \
    pm_math_2cdd2951.o \
    pm_math_3463da5d.o \
    pm_math_360e4b46.o \
    pm_math_48bd51fb.o \
    pm_math_646fa971.o \
    pm_math_a001e9ec.o \
    pm_math_b7b980b1.o \
    pm_math_bad43c87.o \
    pm_math_d1be0f30.o \
    pm_math_da630bd2.o \
    pm_math_f760e8f6.o \


pm_math.a : $(MAKEFILE) rtw_proj.tmw \
				$(MODULES_pm_math)
	$(AR) rs $@ $(MODULES_pm_math)

MODULES_ssc_sli = \
    ssc_sli_0763c151.o \
    ssc_sli_0bd269e6.o \
    ssc_sli_360cfd63.o \
    ssc_sli_43618287.o \
    ssc_sli_466b08dd.o \
    ssc_sli_4e028390.o \
    ssc_sli_51dbd3b5.o \
    ssc_sli_550a4805.o \
    ssc_sli_5a0cb974.o \
    ssc_sli_62d81790.o \
    ssc_sli_77063d8b.o \
    ssc_sli_7a618260.o \
    ssc_sli_7f630b0f.o \
    ssc_sli_89d0f30a.o \
    ssc_sli_8a64c4e2.o \
    ssc_sli_9c030181.o \
    ssc_sli_c7dda239.o \
    ssc_sli_dcd66f69.o \
    ssc_sli_eb0a5702.o \
    ssc_sli_fa0ce53e.o \
    ssc_sli_fbdf29da.o \


ssc_sli.a : $(MAKEFILE) rtw_proj.tmw \
				$(MODULES_ssc_sli)
	$(AR) rs $@ $(MODULES_ssc_sli)

MODULES_ssc_core = \
    ssc_core_01d712d7.o \
    ssc_core_01db7fea.o \
    ssc_core_01dcc633.o \
    ssc_core_026ff268.o \
    ssc_core_04da2c69.o \
    ssc_core_05058dd9.o \
    ssc_core_06ba677c.o \
    ssc_core_06ba68a6.o \
    ssc_core_0764a3ad.o \
    ssc_core_0768a42c.o \
    ssc_core_076b7741.o \
    ssc_core_0864e4ae.o \
    ssc_core_09b5fa6e.o \
    ssc_core_0bd666aa.o \
    ssc_core_0f019bd9.o \
    ssc_core_0f0420a6.o \
    ssc_core_1108d1b5.o \
    ssc_core_166caddf.o \
    ssc_core_1b0315f1.o \
    ssc_core_1b0cafd5.o \
    ssc_core_1c64d74c.o \
    ssc_core_1c656373.o \
    ssc_core_1c6b0332.o \
    ssc_core_1fd25120.o \
    ssc_core_24b4cdee.o \
    ssc_core_2568b075.o \
    ssc_core_280c0222.o \
    ssc_core_29d2a20c.o \
    ssc_core_2a669a14.o \
    ssc_core_2cd54448.o \
    ssc_core_2d095f25.o \
    ssc_core_30bf43ef.o \
    ssc_core_3169e4b7.o \
    ssc_core_330dceec.o \
    ssc_core_37d4ea84.o \
    ssc_core_38d9af99.o \
    ssc_core_38df7cb7.o \
    ssc_core_390bbe0e.o \
    ssc_core_3dd7f5fc.o \
    ssc_core_40d704a7.o \
    ssc_core_40db6c85.o \
    ssc_core_41017299.o \
    ssc_core_440f9cd3.o \
    ssc_core_4666b45b.o \
    ssc_core_466b06df.o \
    ssc_core_48b08af1.o \
    ssc_core_48b1386a.o \
    ssc_core_4965213d.o \
    ssc_core_4ad7a19e.o \
    ssc_core_4ad9135b.o \
    ssc_core_4db6bd68.o \
    ssc_core_4db86fcc.o \
    ssc_core_4e04eecd.o \
    ssc_core_500718de.o \
    ssc_core_51d5b9a3.o \
    ssc_core_53b3fda6.o \
    ssc_core_54d55ae9.o \
    ssc_core_54d63c45.o \
    ssc_core_550a9a70.o \
    ssc_core_550d4b87.o \
    ssc_core_56b1a2bf.o \
    ssc_core_59b034b8.o \
    ssc_core_5a07074f.o \
    ssc_core_5a0fdaac.o \
    ssc_core_5d6ba758.o \
    ssc_core_616494c7.o \
    ssc_core_6167281d.o \
    ssc_core_67d1f118.o \
    ssc_core_68da074b.o \
    ssc_core_6b6b89d2.o \
    ssc_core_6c0642ff.o \
    ssc_core_6dd833f3.o \
    ssc_core_6e6bba26.o \
    ssc_core_706e4ae5.o \
    ssc_core_71b6e960.o \
    ssc_core_73d9c2b7.o \
    ssc_core_76d825be.o \
    ssc_core_780fa54b.o \
    ssc_core_79dd08ab.o \
    ssc_core_7a613edb.o \
    ssc_core_7bb79f23.o \
    ssc_core_7d0b92a7.o \
    ssc_core_7ebac74c.o \
    ssc_core_820e26d8.o \
    ssc_core_820f4eaa.o \
    ssc_core_856738f2.o \
    ssc_core_8569edc5.o \
    ssc_core_870cc9ba.o \
    ssc_core_880d3897.o \
    ssc_core_8a6471dc.o \
    ssc_core_8bb063d9.o \
    ssc_core_8d0064b8.o \
    ssc_core_8f61989f.o \
    ssc_core_93052d9d.o \
    ssc_core_96061071.o \
    ssc_core_97d767fe.o \
    ssc_core_97dcde38.o \
    ssc_core_9b6a1dd2.o \
    ssc_core_9c01d168.o \
    ssc_core_9dd110ad.o \
    ssc_core_9fb0e229.o \
    ssc_core_9fb0e6d6.o \
    ssc_core_9fb25b4f.o \
    ssc_core_9fb2efdc.o \
    ssc_core_a00457ac.o \
    ssc_core_a1d393be.o \
    ssc_core_a1d6f570.o \
    ssc_core_a4d3adaf.o \
    ssc_core_a4d4c45e.o \
    ssc_core_a4da1d0a.o \
    ssc_core_a6b78ccc.o \
    ssc_core_a6bce7bb.o \
    ssc_core_a7672daf.o \
    ssc_core_a867d880.o \
    ssc_core_a9bb7f35.o \
    ssc_core_a9bf1ff2.o \
    ssc_core_aa0efe9f.o \
    ssc_core_abd5e7b4.o \
    ssc_core_acb64294.o \
    ssc_core_acb6462e.o \
    ssc_core_b0d62444.o \
    ssc_core_b1038cbb.o \
    ssc_core_b10e34f4.o \
    ssc_core_b2b3b239.o \
    ssc_core_b402b40d.o \
    ssc_core_b407dc7e.o \
    ssc_core_b40edf20.o \
    ssc_core_b8b01afe.o \
    ssc_core_b8be7371.o \
    ssc_core_b96ebc21.o \
    ssc_core_bb0b2992.o \
    ssc_core_be01a0db.o \
    ssc_core_c168ace6.o \
    ssc_core_c3003040.o \
    ssc_core_c5b63cb2.o \
    ssc_core_c605b061.o \
    ssc_core_c607b660.o \
    ssc_core_c8d83e88.o \
    ssc_core_c8df395b.o \
    ssc_core_c90f4384.o \
    ssc_core_cab615c8.o \
    ssc_core_cab87eff.o \
    ssc_core_cabdc251.o \
    ssc_core_cb63b745.o \
    ssc_core_cc067f58.o \
    ssc_core_ce6a84bb.o \
    ssc_core_d1beb31a.o \
    ssc_core_d3d34d7c.o \
    ssc_core_d3df2fff.o \
    ssc_core_d4ba8ed2.o \
    ssc_core_d708bbfb.o \
    ssc_core_d9d13dac.o \
    ssc_core_dcda6edd.o \
    ssc_core_deb7fd8d.o \
    ssc_core_e0d0866d.o \
    ssc_core_e2b61d72.o \
    ssc_core_e400c1c2.o \
    ssc_core_e4061965.o \
    ssc_core_e407adf8.o \
    ssc_core_eb093eda.o \
    ssc_core_ee000fbe.o \
    ssc_core_ee01086d.o \
    ssc_core_ee0f0141.o \
    ssc_core_f2610835.o \
    ssc_core_f3b47568.o \
    ssc_core_f867a7f6.o \
    ssc_core_f9b6dbed.o \
    ssc_core_fa09e9e6.o \
    ssc_core_fbd34e62.o \
    ssc_core_fd6bfe36.o \
    ssc_core_fede7425.o \
    ssc_core_ff06d9a4.o \


ssc_core.a : $(MAKEFILE) rtw_proj.tmw \
				$(MODULES_ssc_core)
	$(AR) rs $@ $(MODULES_ssc_core)

MODULES_ne = \
    ne_03b6336b.o \
    ne_06b3d331.o \
    ne_16631e46.o \
    ne_1dbdc793.o \
    ne_21b3fe2a.o \
    ne_23d90911.o \
    ne_38dea646.o \
    ne_390cbc71.o \
    ne_3ab8881f.o \
    ne_3b664010.o \
    ne_3c033af4.o \
    ne_3fb96ad2.o \
    ne_42b0ffc8.o \
    ne_45d43f88.o \
    ne_47b9c424.o \
    ne_48b6562f.o \
    ne_4c607df4.o \
    ne_550a94df.o \
    ne_57686ca9.o \
    ne_59b4e14a.o \
    ne_5bd7a7a4.o \
    ne_5f045abc.o \
    ne_6469a614.o \
    ne_6b61eb1c.o \
    ne_71b28889.o \
    ne_83d4e865.o \
    ne_95b22d2e.o \
    ne_9fbe8f50.o \
    ne_a1d5f1af.o \
    ne_af03741f.o \
    ne_b0dd440f.o \
    ne_b40304b0.o \
    ne_b7b159c5.o \
    ne_c3033fa8.o \
    ne_d9dde03a.o \
    ne_df6be635.o \
    ne_e2be7d51.o \
    ne_e8bbbd86.o \
    ne_e960a484.o \
    ne_eb048896.o \
    ne_ee0cb880.o \
    ne_f26d0c55.o \
    ne_fd61f8e5.o \


ne.a : $(MAKEFILE) rtw_proj.tmw \
				$(MODULES_ne)
	$(AR) rs $@ $(MODULES_ne)

MODULES_pm = \
    pm_26dc3230.o \


pm.a : $(MAKEFILE) rtw_proj.tmw \
				$(MODULES_pm)
	$(AR) rs $@ $(MODULES_pm)



#----------------------------- Dependencies ------------------------------------

$(OBJS) : $(MAKEFILE) rtw_proj.tmw


$(SHARED_LIB) : $(SHARED_OBJS)
	$(AR) ruvs $@ $(SHARED_OBJS)

#--------- Miscellaneous rules to purge and clean ------------------------------

purge : clean
	\rm -f $(MODEL).c $(MODEL).h $(MODEL)_types.h $(MODEL)_data.c \
		 $(MODEL)_private.h $(MODEL).rtw $(MODULES) rtw_proj.tmw $(MAKEFILE)

clean :
	\rm -f $(LINK_OBJS) $(PROGRAM)

# EOF: raccel_unix.tmf
