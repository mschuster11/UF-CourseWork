################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

# Each subdirectory must supply rules for building sources it contributes
Headers/DSP2833x_GlobalVariableDefs.obj: ../Headers/DSP2833x_GlobalVariableDefs.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C2000 Compiler'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/bin/cl2000" -v28 -ml -mt --float_support=fpu32 --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/AIC23_Lib" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab4/personalLib/headers" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_common/include" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_headers/include" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/include" --advice:performance=all -g --c99 --diag_warning=225 --diag_wrap=off --display_error_number --preproc_with_compile --preproc_dependency="Headers/DSP2833x_GlobalVariableDefs.d_raw" --obj_directory="Headers" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '


