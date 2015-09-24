#ifndef __c2_WECSim_Lib_h__
#define __c2_WECSim_Lib_h__

/* Include files */
#include "sf_runtime/sfc_sf.h"
#include "sf_runtime/sfc_mex.h"
#include "rtwtypes.h"
#include "multiword_types.h"

/* Type Definitions */
#ifndef typedef_SFc2_WECSim_LibInstanceStruct
#define typedef_SFc2_WECSim_LibInstanceStruct

typedef struct {
  SimStruct *S;
  ChartInfoStruct chartInfo;
  uint32_T chartNumber;
  uint32_T instanceNumber;
  int32_T c2_sfEvent;
  boolean_T c2_isStable;
  boolean_T c2_doneDoubleBufferReInit;
  uint8_T c2_is_active_c2_WECSim_Lib;
  real_T c2_velocity[3606];
  boolean_T c2_velocity_not_empty;
  real_T c2_kkk;
  boolean_T c2_kkk_not_empty;
  real_T c2_inData[21636];
  real_T c2_IRKB[21636];
  real_T *c2_check;
  real_T (*c2_v)[6];
  real_T (*c2_F_FM)[6];
  real_T (*c2_b_IRKB)[21636];
  real_T (*c2_CTTime)[601];
} SFc2_WECSim_LibInstanceStruct;

#endif                                 /*typedef_SFc2_WECSim_LibInstanceStruct*/

/* Named Constants */

/* Variable Declarations */
extern struct SfDebugInstanceStruct *sfGlobalDebugInstanceStruct;

/* Variable Definitions */

/* Function Declarations */
extern const mxArray *sf_c2_WECSim_Lib_get_eml_resolved_functions_info(void);

/* Function Definitions */
extern void sf_c2_WECSim_Lib_get_check_sum(mxArray *plhs[]);
extern void c2_WECSim_Lib_method_dispatcher(SimStruct *S, int_T method, void
  *data);

#endif
