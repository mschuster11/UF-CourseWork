################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

CG_TOOL_ROOT := C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS

GEN_OPTS__FLAG := 
GEN_CMDS__FLAG := 

ORDERED_OBJS += \
"./main.obj" \
"./AIC23_Lib/AIC23.obj" \
"./AIC23_Lib/InitAIC23.obj" \
"./Common/DSP2833x_ADC_cal.obj" \
"./Common/DSP2833x_Adc.obj" \
"./Common/DSP2833x_CpuTimers.obj" \
"./Common/DSP2833x_DMA.obj" \
"./Common/DSP2833x_DefaultIsr.obj" \
"./Common/DSP2833x_I2C.obj" \
"./Common/DSP2833x_Mcbsp.obj" \
"./Common/DSP2833x_MemCopy.obj" \
"./Common/DSP2833x_PieCtrl.obj" \
"./Common/DSP2833x_PieVect.obj" \
"./Common/DSP2833x_Spi.obj" \
"./Common/DSP2833x_SysCtrl.obj" \
"./Common/DSP2833x_Xintf.obj" \
"./Common/DSP2833x_usDelay.obj" \
"./Headers/DSP2833x_GlobalVariableDefs.obj" \
"./personalLib/src/ADC_Utils.obj" \
"./personalLib/src/Codec_Utils.obj" \
"./personalLib/src/I2C_LCD_Utils.obj" \
"./personalLib/src/Interrupt_ISRs.obj" \
"./personalLib/src/Interrupt_Utils.obj" \
"./personalLib/src/LEDs_switches_Utils.obj" \
"./personalLib/src/OneToOneI2CDriver.obj" \
"./personalLib/src/Timer1_Utils.obj" \
"./personalLib/src/extSram.obj" \
"../28335_RAM_lnk.cmd" \
"../Headers/DSP2833x_Headers_nonBIOS.cmd" \
$(GEN_CMDS__FLAG) \
-llibc.a \

-include ../makefile.init

RM := DEL /F
RMDIR := RMDIR /S/Q

# All of the sources participating in the build are defined here
-include sources.mk
-include subdir_vars.mk
-include AIC23_Lib/subdir_vars.mk
-include Common/subdir_vars.mk
-include Headers/subdir_vars.mk
-include personalLib/src/subdir_vars.mk
-include subdir_rules.mk
-include AIC23_Lib/subdir_rules.mk
-include Common/subdir_rules.mk
-include Headers/subdir_rules.mk
-include personalLib/src/subdir_rules.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C55_DEPS)),)
-include $(C55_DEPS)
endif
ifneq ($(strip $(C_UPPER_DEPS)),)
-include $(C_UPPER_DEPS)
endif
ifneq ($(strip $(S67_DEPS)),)
-include $(S67_DEPS)
endif
ifneq ($(strip $(S62_DEPS)),)
-include $(S62_DEPS)
endif
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(OPT_DEPS)),)
-include $(OPT_DEPS)
endif
ifneq ($(strip $(C??_DEPS)),)
-include $(C??_DEPS)
endif
ifneq ($(strip $(ASM_UPPER_DEPS)),)
-include $(ASM_UPPER_DEPS)
endif
ifneq ($(strip $(S??_DEPS)),)
-include $(S??_DEPS)
endif
ifneq ($(strip $(C64_DEPS)),)
-include $(C64_DEPS)
endif
ifneq ($(strip $(CXX_DEPS)),)
-include $(CXX_DEPS)
endif
ifneq ($(strip $(S64_DEPS)),)
-include $(S64_DEPS)
endif
ifneq ($(strip $(INO_DEPS)),)
-include $(INO_DEPS)
endif
ifneq ($(strip $(CLA_DEPS)),)
-include $(CLA_DEPS)
endif
ifneq ($(strip $(S55_DEPS)),)
-include $(S55_DEPS)
endif
ifneq ($(strip $(SV7A_DEPS)),)
-include $(SV7A_DEPS)
endif
ifneq ($(strip $(C62_DEPS)),)
-include $(C62_DEPS)
endif
ifneq ($(strip $(C67_DEPS)),)
-include $(C67_DEPS)
endif
ifneq ($(strip $(PDE_DEPS)),)
-include $(PDE_DEPS)
endif
ifneq ($(strip $(K_DEPS)),)
-include $(K_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(CC_DEPS)),)
-include $(CC_DEPS)
endif
ifneq ($(strip $(C++_DEPS)),)
-include $(C++_DEPS)
endif
ifneq ($(strip $(C43_DEPS)),)
-include $(C43_DEPS)
endif
ifneq ($(strip $(S43_DEPS)),)
-include $(S43_DEPS)
endif
ifneq ($(strip $(ASM_DEPS)),)
-include $(ASM_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(CPP_DEPS)),)
-include $(CPP_DEPS)
endif
ifneq ($(strip $(SA_DEPS)),)
-include $(SA_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
EXE_OUTPUTS += \
Lab6.out \

EXE_OUTPUTS__QUOTED += \
"Lab6.out" \

BIN_OUTPUTS += \
Lab6.hex \

BIN_OUTPUTS__QUOTED += \
"Lab6.hex" \


# All Target
all: $(OBJS) $(CMD_SRCS) $(GEN_CMDS)
	@$(MAKE) --no-print-directory -Onone "Lab6.out"

# Tool invocations
Lab6.out: $(OBJS) $(CMD_SRCS) $(GEN_CMDS)
	@echo 'Building target: "$@"'
	@echo 'Invoking: C2000 Linker'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/bin/cl2000" -v28 -ml -mt --float_support=fpu32 -g --c99 --diag_warning=225 --diag_wrap=off --display_error_number -z -m"Lab6.map" --stack_size=0x300 --warn_sections -i"C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/lib" -i"C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/include" --reread_libs --diag_wrap=off --display_error_number --xml_link_info="Lab6_linkInfo.xml" --rom_model -o "Lab6.out" $(ORDERED_OBJS)
	@echo 'Finished building target: "$@"'
	@echo ' '

Lab6.hex: $(EXE_OUTPUTS)
	@echo 'Building files: $(strip $(EXE_OUTPUTS__QUOTED))'
	@echo 'Invoking: C2000 Hex Utility'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/bin/hex2000"  -o "Lab6.hex" $(EXE_OUTPUTS__QUOTED)
	@echo 'Finished building: $(strip $(EXE_OUTPUTS__QUOTED))'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(BIN_OUTPUTS__QUOTED)$(EXE_OUTPUTS__QUOTED)
	-$(RM) "main.obj" "AIC23_Lib\AIC23.obj" "AIC23_Lib\InitAIC23.obj" "Common\DSP2833x_ADC_cal.obj" "Common\DSP2833x_Adc.obj" "Common\DSP2833x_CpuTimers.obj" "Common\DSP2833x_DMA.obj" "Common\DSP2833x_DefaultIsr.obj" "Common\DSP2833x_I2C.obj" "Common\DSP2833x_Mcbsp.obj" "Common\DSP2833x_MemCopy.obj" "Common\DSP2833x_PieCtrl.obj" "Common\DSP2833x_PieVect.obj" "Common\DSP2833x_Spi.obj" "Common\DSP2833x_SysCtrl.obj" "Common\DSP2833x_Xintf.obj" "Common\DSP2833x_usDelay.obj" "Headers\DSP2833x_GlobalVariableDefs.obj" "personalLib\src\ADC_Utils.obj" "personalLib\src\Codec_Utils.obj" "personalLib\src\I2C_LCD_Utils.obj" "personalLib\src\Interrupt_ISRs.obj" "personalLib\src\Interrupt_Utils.obj" "personalLib\src\LEDs_switches_Utils.obj" "personalLib\src\OneToOneI2CDriver.obj" "personalLib\src\Timer1_Utils.obj" "personalLib\src\extSram.obj" 
	-$(RM) "main.d" "AIC23_Lib\AIC23.d" "AIC23_Lib\InitAIC23.d" "Common\DSP2833x_Adc.d" "Common\DSP2833x_CpuTimers.d" "Common\DSP2833x_DMA.d" "Common\DSP2833x_DefaultIsr.d" "Common\DSP2833x_I2C.d" "Common\DSP2833x_Mcbsp.d" "Common\DSP2833x_MemCopy.d" "Common\DSP2833x_PieCtrl.d" "Common\DSP2833x_PieVect.d" "Common\DSP2833x_Spi.d" "Common\DSP2833x_SysCtrl.d" "Common\DSP2833x_Xintf.d" "Headers\DSP2833x_GlobalVariableDefs.d" "personalLib\src\ADC_Utils.d" "personalLib\src\Codec_Utils.d" "personalLib\src\I2C_LCD_Utils.d" "personalLib\src\Interrupt_ISRs.d" "personalLib\src\Interrupt_Utils.d" "personalLib\src\LEDs_switches_Utils.d" "personalLib\src\OneToOneI2CDriver.d" "personalLib\src\Timer1_Utils.d" "personalLib\src\extSram.d" 
	-$(RM) "Common\DSP2833x_ADC_cal.d" "Common\DSP2833x_usDelay.d" 
	-@echo 'Finished clean'
	-@echo ' '

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets

