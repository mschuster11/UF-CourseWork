################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

# Each subdirectory must supply rules for building sources it contributes
hw2.obj: ../hw2.asm $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: "$<"'
	@echo 'Invoking: C2000 Compiler'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/bin/cl2000" -v28 -ml -mt --float_support=fpu32 --include_path="C:/Users/ghost/OneDrive/School-Master/EEL4511C/HW2" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/include" -g --diag_warning=225 --diag_wrap=off --display_error_number --asm_listing --preproc_with_compile --preproc_dependency="hw2.d_raw" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: "$<"'
	@echo ' '


