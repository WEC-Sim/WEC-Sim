/* Include files */

#include "WECSim_Lib_sfun.h"
#include "WECSim_Lib_sfun_debug_macros.h"
#include "c2_WECSim_Lib.h"
#include "c8_WECSim_Lib.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */
uint32_T _WECSim_LibMachineNumber_;

/* Function Declarations */

/* Function Definitions */
void WECSim_Lib_initializer(void)
{
}

void WECSim_Lib_terminator(void)
{
}

/* SFunction Glue Code */
unsigned int sf_WECSim_Lib_method_dispatcher(SimStruct *simstructPtr, unsigned
  int chartFileNumber, const char* specsCksum, int_T method, void *data)
{
  if (chartFileNumber==2) {
    c2_WECSim_Lib_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  if (chartFileNumber==8) {
    c8_WECSim_Lib_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  return 0;
}

extern void sf_WECSim_Lib_uses_exported_functions(int nlhs, mxArray * plhs[],
  int nrhs, const mxArray * prhs[])
{
  plhs[0] = mxCreateLogicalScalar(0);
}

unsigned int sf_WECSim_Lib_process_check_sum_call( int nlhs, mxArray * plhs[],
  int nrhs, const mxArray * prhs[] )
{

#ifdef MATLAB_MEX_FILE

  char commandName[20];
  if (nrhs<1 || !mxIsChar(prhs[0]) )
    return 0;

  /* Possible call to get the checksum */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"sf_get_check_sum"))
    return 0;
  plhs[0] = mxCreateDoubleMatrix( 1,4,mxREAL);
  if (nrhs>2 && mxIsChar(prhs[1])) {
    mxGetString(prhs[1], commandName,sizeof(commandName)/sizeof(char));
    commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
    if (!strcmp(commandName,"library")) {
      char machineName[100];
      mxGetString(prhs[2], machineName,sizeof(machineName)/sizeof(char));
      machineName[(sizeof(machineName)/sizeof(char)-1)] = '\0';
      if (!strcmp(machineName,"WECSim_Lib")) {
        if (nrhs==3) {
          ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(765251695U);
          ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(639681749U);
          ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(2227361367U);
          ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(1116497241U);
        } else if (nrhs==4) {
          unsigned int chartFileNumber;
          chartFileNumber = (unsigned int)mxGetScalar(prhs[3]);
          switch (chartFileNumber) {
           case 2:
            {
              extern void sf_c2_WECSim_Lib_get_check_sum(mxArray *plhs[]);
              sf_c2_WECSim_Lib_get_check_sum(plhs);
              break;
            }

           case 8:
            {
              extern void sf_c8_WECSim_Lib_get_check_sum(mxArray *plhs[]);
              sf_c8_WECSim_Lib_get_check_sum(plhs);
              break;
            }

           default:
            ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(0.0);
            ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(0.0);
            ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(0.0);
            ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(0.0);
          }
        } else {
          return 0;
        }
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  } else {
    return 0;
  }

  return 1;

#else

  return 0;

#endif

}

unsigned int sf_WECSim_Lib_autoinheritance_info( int nlhs, mxArray * plhs[], int
  nrhs, const mxArray * prhs[] )
{

#ifdef MATLAB_MEX_FILE

  char commandName[32];
  char aiChksum[64];
  if (nrhs<3 || !mxIsChar(prhs[0]) )
    return 0;

  /* Possible call to get the autoinheritance_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_autoinheritance_info"))
    return 0;
  mxGetString(prhs[2], aiChksum,sizeof(aiChksum)/sizeof(char));
  aiChksum[(sizeof(aiChksum)/sizeof(char)-1)] = '\0';

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 2:
      {
        if (strcmp(aiChksum, "7eGEzE46D3H4BA95pxR1PH") == 0) {
          extern mxArray *sf_c2_WECSim_Lib_get_autoinheritance_info(void);
          plhs[0] = sf_c2_WECSim_Lib_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     case 8:
      {
        if (strcmp(aiChksum, "uqCoPZeELl9XTr7kofsxhF") == 0) {
          extern mxArray *sf_c8_WECSim_Lib_get_autoinheritance_info(void);
          plhs[0] = sf_c8_WECSim_Lib_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;

#else

  return 0;

#endif

}

unsigned int sf_WECSim_Lib_get_eml_resolved_functions_info( int nlhs, mxArray *
  plhs[], int nrhs, const mxArray * prhs[] )
{

#ifdef MATLAB_MEX_FILE

  char commandName[64];
  if (nrhs<2 || !mxIsChar(prhs[0]))
    return 0;

  /* Possible call to get the get_eml_resolved_functions_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_eml_resolved_functions_info"))
    return 0;

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 2:
      {
        extern const mxArray *sf_c2_WECSim_Lib_get_eml_resolved_functions_info
          (void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c2_WECSim_Lib_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     case 8:
      {
        extern const mxArray *sf_c8_WECSim_Lib_get_eml_resolved_functions_info
          (void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c8_WECSim_Lib_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;

#else

  return 0;

#endif

}

unsigned int sf_WECSim_Lib_third_party_uses_info( int nlhs, mxArray * plhs[],
  int nrhs, const mxArray * prhs[] )
{
  char commandName[64];
  char tpChksum[64];
  if (nrhs<3 || !mxIsChar(prhs[0]))
    return 0;

  /* Possible call to get the third_party_uses_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  mxGetString(prhs[2], tpChksum,sizeof(tpChksum)/sizeof(char));
  tpChksum[(sizeof(tpChksum)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_third_party_uses_info"))
    return 0;

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 2:
      {
        if (strcmp(tpChksum, "69EBA0W0ZdDKlUAGGxTGHE") == 0) {
          extern mxArray *sf_c2_WECSim_Lib_third_party_uses_info(void);
          plhs[0] = sf_c2_WECSim_Lib_third_party_uses_info();
          break;
        }
      }

     case 8:
      {
        if (strcmp(tpChksum, "pNBG4Nr8RdFvZADz7XsCEF") == 0) {
          extern mxArray *sf_c8_WECSim_Lib_third_party_uses_info(void);
          plhs[0] = sf_c8_WECSim_Lib_third_party_uses_info();
          break;
        }
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;
}

unsigned int sf_WECSim_Lib_jit_fallback_info( int nlhs, mxArray * plhs[], int
  nrhs, const mxArray * prhs[] )
{
  char commandName[64];
  char tpChksum[64];
  if (nrhs<3 || !mxIsChar(prhs[0]))
    return 0;

  /* Possible call to get the jit_fallback_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  mxGetString(prhs[2], tpChksum,sizeof(tpChksum)/sizeof(char));
  tpChksum[(sizeof(tpChksum)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_jit_fallback_info"))
    return 0;

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 2:
      {
        if (strcmp(tpChksum, "69EBA0W0ZdDKlUAGGxTGHE") == 0) {
          extern mxArray *sf_c2_WECSim_Lib_jit_fallback_info(void);
          plhs[0] = sf_c2_WECSim_Lib_jit_fallback_info();
          break;
        }
      }

     case 8:
      {
        if (strcmp(tpChksum, "pNBG4Nr8RdFvZADz7XsCEF") == 0) {
          extern mxArray *sf_c8_WECSim_Lib_jit_fallback_info(void);
          plhs[0] = sf_c8_WECSim_Lib_jit_fallback_info();
          break;
        }
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;
}

unsigned int sf_WECSim_Lib_updateBuildInfo_args_info( int nlhs, mxArray * plhs[],
  int nrhs, const mxArray * prhs[] )
{
  char commandName[64];
  char tpChksum[64];
  if (nrhs<3 || !mxIsChar(prhs[0]))
    return 0;

  /* Possible call to get the updateBuildInfo_args_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  mxGetString(prhs[2], tpChksum,sizeof(tpChksum)/sizeof(char));
  tpChksum[(sizeof(tpChksum)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_updateBuildInfo_args_info"))
    return 0;

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 2:
      {
        if (strcmp(tpChksum, "69EBA0W0ZdDKlUAGGxTGHE") == 0) {
          extern mxArray *sf_c2_WECSim_Lib_updateBuildInfo_args_info(void);
          plhs[0] = sf_c2_WECSim_Lib_updateBuildInfo_args_info();
          break;
        }
      }

     case 8:
      {
        if (strcmp(tpChksum, "pNBG4Nr8RdFvZADz7XsCEF") == 0) {
          extern mxArray *sf_c8_WECSim_Lib_updateBuildInfo_args_info(void);
          plhs[0] = sf_c8_WECSim_Lib_updateBuildInfo_args_info();
          break;
        }
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;
}

void sf_WECSim_Lib_get_post_codegen_info( int nlhs, mxArray * plhs[], int nrhs,
  const mxArray * prhs[] )
{
  unsigned int chartFileNumber = (unsigned int) mxGetScalar(prhs[0]);
  char tpChksum[64];
  mxGetString(prhs[1], tpChksum,sizeof(tpChksum)/sizeof(char));
  tpChksum[(sizeof(tpChksum)/sizeof(char)-1)] = '\0';
  switch (chartFileNumber) {
   case 2:
    {
      if (strcmp(tpChksum, "69EBA0W0ZdDKlUAGGxTGHE") == 0) {
        extern mxArray *sf_c2_WECSim_Lib_get_post_codegen_info(void);
        plhs[0] = sf_c2_WECSim_Lib_get_post_codegen_info();
        return;
      }
    }
    break;

   case 8:
    {
      if (strcmp(tpChksum, "pNBG4Nr8RdFvZADz7XsCEF") == 0) {
        extern mxArray *sf_c8_WECSim_Lib_get_post_codegen_info(void);
        plhs[0] = sf_c8_WECSim_Lib_get_post_codegen_info();
        return;
      }
    }
    break;

   default:
    break;
  }

  plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
}

void WECSim_Lib_debug_initialize(struct SfDebugInstanceStruct* debugInstance)
{
  _WECSim_LibMachineNumber_ = sf_debug_initialize_machine(debugInstance,
    "WECSim_Lib","sfun",1,2,0,0,0);
  sf_debug_set_machine_event_thresholds(debugInstance,_WECSim_LibMachineNumber_,
    0,0);
  sf_debug_set_machine_data_thresholds(debugInstance,_WECSim_LibMachineNumber_,0);
}

void WECSim_Lib_register_exported_symbols(SimStruct* S)
{
}

static mxArray* sRtwOptimizationInfoStruct= NULL;
mxArray* load_WECSim_Lib_optimization_info(void)
{
  if (sRtwOptimizationInfoStruct==NULL) {
    sRtwOptimizationInfoStruct = sf_load_rtw_optimization_info("WECSim_Lib",
      "RM3");
    mexMakeArrayPersistent(sRtwOptimizationInfoStruct);
  }

  return(sRtwOptimizationInfoStruct);
}

void unload_WECSim_Lib_optimization_info(void)
{
  if (sRtwOptimizationInfoStruct!=NULL) {
    mxDestroyArray(sRtwOptimizationInfoStruct);
    sRtwOptimizationInfoStruct = NULL;
  }
}
