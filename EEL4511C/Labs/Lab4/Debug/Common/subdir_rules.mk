################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

# Each subdirectory must supply rules for building sources it contributes
Common/DSP2833x_ADC_cal.obj: ../Common/DSP2833x_ADC_cal.asm $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C2000 Compiler'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/bin/cl2000" -v28 -ml -mt --float_support=fpu32 --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/AIC23_Lib" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/personalLib/headers" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_common/include" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_headers/include" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/include" --advice:performance=all -g --c99 --diag_warning=225 --diag_wrap=off --display_error_number --preproc_with_compile --preproc_dependency="Common/DSP2833x_ADC_cal.d_raw" --obj_directory="Common" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

Common/DSP2833x_Adc.obj: ../Common/DSP2833x_Adc.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C2000 Compiler'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/bin/cl2000" -v28 -ml -mt --float_support=fpu32 --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/AIC23_Lib" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/personalLib/headers" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_common/include" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_headers/include" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/include" --advice:performance=all -g --c99 --diag_warning=225 --diag_wrap=off --display_error_number --preproc_with_compile --preproc_dependency="Common/DSP2833x_Adc.d_raw" --obj_directory="Common" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

Common/DSP2833x_CpuTimers.obj: ../Common/DSP2833x_CpuTimers.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C2000 Compiler'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/bin/cl2000" -v28 -ml -mt --float_support=fpu32 --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/AIC23_Lib" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/personalLib/headers" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_common/include" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_headers/include" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/include" --advice:performance=all -g --c99 --diag_warning=225 --diag_wrap=off --display_error_number --preproc_with_compile --preproc_dependency="Common/DSP2833x_CpuTimers.d_raw" --obj_directory="Common" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

Common/DSP2833x_DMA.obj: ../Common/DSP2833x_DMA.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C2000 Compiler'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/bin/cl2000" -v28 -ml -mt --float_support=fpu32 --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/AIC23_Lib" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/personalLib/headers" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_common/include" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_headers/include" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/include" --advice:performance=all -g --c99 --diag_warning=225 --diag_wrap=off --display_error_number --preproc_with_compile --preproc_dependency="Common/DSP2833x_DMA.d_raw" --obj_directory="Common" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

Common/DSP2833x_DefaultIsr.obj: ../Common/DSP2833x_DefaultIsr.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C2000 Compiler'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/bin/cl2000" -v28 -ml -mt --float_support=fpu32 --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/AIC23_Lib" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/personalLib/headers" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_common/include" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_headers/include" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/include" --advice:performance=all -g --c99 --diag_warning=225 --diag_wrap=off --display_error_number --preproc_with_compile --preproc_dependency="Common/DSP2833x_DefaultIsr.d_raw" --obj_directory="Common" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

Common/DSP2833x_I2C.obj: ../Common/DSP2833x_I2C.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C2000 Compiler'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/bin/cl2000" -v28 -ml -mt --float_support=fpu32 --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/AIC23_Lib" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/personalLib/headers" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_common/include" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_headers/include" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/include" --advice:performance=all -g --c99 --diag_warning=225 --diag_wrap=off --display_error_number --preproc_with_compile --preproc_dependency="Common/DSP2833x_I2C.d_raw" --obj_directory="Common" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

Common/DSP2833x_Mcbsp.obj: ../Common/DSP2833x_Mcbsp.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C2000 Compiler'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/bin/cl2000" -v28 -ml -mt --float_support=fpu32 --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/AIC23_Lib" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/personalLib/headers" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_common/include" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_headers/include" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/include" --advice:performance=all -g --c99 --diag_warning=225 --diag_wrap=off --display_error_number --preproc_with_compile --preproc_dependency="Common/DSP2833x_Mcbsp.d_raw" --obj_directory="Common" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

Common/DSP2833x_MemCopy.obj: ../Common/DSP2833x_MemCopy.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C2000 Compiler'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/bin/cl2000" -v28 -ml -mt --float_support=fpu32 --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/AIC23_Lib" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/personalLib/headers" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_common/include" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_headers/include" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/include" --advice:performance=all -g --c99 --diag_warning=225 --diag_wrap=off --display_error_number --preproc_with_compile --preproc_dependency="Common/DSP2833x_MemCopy.d_raw" --obj_directory="Common" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

Common/DSP2833x_PieCtrl.obj: ../Common/DSP2833x_PieCtrl.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C2000 Compiler'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/bin/cl2000" -v28 -ml -mt --float_support=fpu32 --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/AIC23_Lib" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/personalLib/headers" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_common/include" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_headers/include" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/include" --advice:performance=all -g --c99 --diag_warning=225 --diag_wrap=off --display_error_number --preproc_with_compile --preproc_dependency="Common/DSP2833x_PieCtrl.d_raw" --obj_directory="Common" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

Common/DSP2833x_PieVect.obj: ../Common/DSP2833x_PieVect.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C2000 Compiler'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/bin/cl2000" -v28 -ml -mt --float_support=fpu32 --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/AIC23_Lib" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/personalLib/headers" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_common/include" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_headers/include" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/include" --advice:performance=all -g --c99 --diag_warning=225 --diag_wrap=off --display_error_number --preproc_with_compile --preproc_dependency="Common/DSP2833x_PieVect.d_raw" --obj_directory="Common" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

Common/DSP2833x_Spi.obj: ../Common/DSP2833x_Spi.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C2000 Compiler'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/bin/cl2000" -v28 -ml -mt --float_support=fpu32 --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/AIC23_Lib" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/personalLib/headers" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_common/include" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_headers/include" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/include" --advice:performance=all -g --c99 --diag_warning=225 --diag_wrap=off --display_error_number --preproc_with_compile --preproc_dependency="Common/DSP2833x_Spi.d_raw" --obj_directory="Common" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

Common/DSP2833x_SysCtrl.obj: ../Common/DSP2833x_SysCtrl.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C2000 Compiler'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/bin/cl2000" -v28 -ml -mt --float_support=fpu32 --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/AIC23_Lib" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/personalLib/headers" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_common/include" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_headers/include" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/include" --advice:performance=all -g --c99 --diag_warning=225 --diag_wrap=off --display_error_number --preproc_with_compile --preproc_dependency="Common/DSP2833x_SysCtrl.d_raw" --obj_directory="Common" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

Common/DSP2833x_Xintf.obj: ../Common/DSP2833x_Xintf.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C2000 Compiler'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/bin/cl2000" -v28 -ml -mt --float_support=fpu32 --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/AIC23_Lib" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/personalLib/headers" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_common/include" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_headers/include" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/include" --advice:performance=all -g --c99 --diag_warning=225 --diag_wrap=off --display_error_number --preproc_with_compile --preproc_dependency="Common/DSP2833x_Xintf.d_raw" --obj_directory="Common" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

Common/DSP2833x_usDelay.obj: ../Common/DSP2833x_usDelay.asm $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C2000 Compiler'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/bin/cl2000" -v28 -ml -mt --float_support=fpu32 --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/AIC23_Lib" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/personalLib/headers" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_common/include" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_headers/include" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/include" --advice:performance=all -g --c99 --diag_warning=225 --diag_wrap=off --display_error_number --preproc_with_compile --preproc_dependency="Common/DSP2833x_usDelay.d_raw" --obj_directory="Common" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '


