################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

# Each subdirectory must supply rules for building sources it contributes
AIC23_Lib/AIC23.obj: ../AIC23_Lib/AIC23.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C2000 Compiler'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/bin/cl2000" -v28 -ml -mt --float_support=fpu32 --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_common/include" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab5/AIC23_Lib" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab5/personalLib/headers" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab5" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_headers/include" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/include" -g --c99 --diag_warning=225 --diag_wrap=off --display_error_number --preproc_with_compile --preproc_dependency="AIC23_Lib/AIC23.d_raw" --obj_directory="AIC23_Lib" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

AIC23_Lib/InitAIC23.obj: ../AIC23_Lib/InitAIC23.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C2000 Compiler'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/bin/cl2000" -v28 -ml -mt --float_support=fpu32 --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_common/include" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab5/AIC23_Lib" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab5/personalLib/headers" --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/Labs/Lab5" --include_path="C:/ti/controlSUITE/device_support/f2833x/v142/DSP2833x_headers/include" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/include" -g --c99 --diag_warning=225 --diag_wrap=off --display_error_number --preproc_with_compile --preproc_dependency="AIC23_Lib/InitAIC23.d_raw" --obj_directory="AIC23_Lib" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '


