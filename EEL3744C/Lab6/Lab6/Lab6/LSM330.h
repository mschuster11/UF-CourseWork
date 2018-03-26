/*
 * LSM330.h
 *
 * Created: 12/31/2016 12:55:48 PM
 *  Author: Tim
 */ 


#ifndef LSM330_H_
#define LSM330_H_

typedef enum LSM330_ACCEL_REGISTERS
{
	WHO_AM_I_A		=	0x0F,
	
	CTRL_REG4_A		=	0x23,
	CTRL_REG5_A		=	0x20,
	CTRL_REG6_A		=	0x24,
	CTRL_REG7_A		=	0x25,
	STATUS_REG_A	=	0x27,
	
	OFF_X			=	0x10,
	OFF_Y			=	0x11,
	OFF_Z			=	0x12,
	
	CS_X			=	0x13,
	CS_Y			=	0x14,
	CS_Z			=	0x15,
	
	LC_L			=	0x16,
	LC_H			=	0x17,
	
	STAT			=	0x18,
	
	VFC_1			=	0x1B,
	VFC_2			=	0x1C,
	VFC_3			=	0x1D,
	VFC_4			=	0x1E,
	
	THRS3			=	0x1F,
	
	OUT_X_L_A		=	0x28,
	OUT_X_H_A		=	0x29,
	OUT_Y_L_A		=	0x2A,
	OUT_Y_H_A		=	0x2B,
	OUT_Z_L_A		=	0x2C,
	OUT_Z_H_A		=	0x2D,
	
	FIFO_CTRL_REG_A	=	0x2E,
	FIFO_SRC_REG_A	=	0x2F,
	
	CTRL_REG2_A		=	0x21,
	
	STx_1			=	0x40,	//0x40-0x4F
	
	TIM4_1			=	0x50,
	TIM3_1			=	0x51,
	TIM2_1			=	0x52,	//0x52-0x53
	TIM1_1			=	0x54,	//0x54-0x55
	
	THRS2_1			=	0x56,
	THRS1_1			=	0x57,
	
	MASKB_1			=	0x59,
	MASKA_1			=	0x5A,
	
	SETT1			=	0x5B,
	
	PR1				=	0x5C,
	
	TC1				=	0x5D,	//0x5D-0x5E
	
	OUTS1			=	0x5F,
	
	PEAK1			=	0x19,
	
	CTRL_REG3_A		=	0x22,
	
	STx_2			=	0x60,	//0x60-0x6F
	
	TIM4_2			=	0x70,
	TIM3_2			=	0x71,
	TIM2_2			=	0x72,	//0x72-0x73
	TIM1_2			=	0x74,	//0x74-0x75
	
	THRS2_2			=	0x76,
	THRS1_2			=	0x77,
	
	MASKB_2			=	0x79,
	MASKA_2			=	0x7A,
	
	SETT2			=	0x7B,
	
	PR2				=	0x7C,
	
	TC2				=	0x7D,	//0x7D-0x7E

	OUTS2			=	0x7F,
	
	PEAK2			=	0x1A,
	
	DES2			=	0x78,
	
}lsm330_regA_t;

typedef enum LSM330_CTRL_REG4_A
{
	
	CTRL_REG4_A_DR_EN	=	_BV(7),
	CTRL_REG4_A_IEA		=	_BV(6),
	CTRL_REG4_A_IEL		=	_BV(5),
	CTRL_REG4_A_INT2_EN	=	_BV(4),
	CTRL_REG4_A_INT1_EN	=	_BV(3),
	CTRL_REG4_A_VFILT	=	_BV(2),
	
	CTRL_REG4_A_STRT	=	_BV(0)
	
}CTRL_REG4_A_t;

typedef enum LSM330_CTRL_REG5_A
{
	
	CTRL_REG5_A_ODR3	=	_BV(7),
	CTRL_REG5_A_ODR2	=	_BV(6),
	CTRL_REG5_A_ODR1	=	_BV(5),
	CTRL_REG5_A_ODR0	=	_BV(4),
	CTRL_REG5_A_BDU		=	_BV(3),
	CTRL_REG5_A_ZEN		=	_BV(2),
	CTRL_REG5_A_YEN		=	_BV(1),
	CTRL_REG5_A_XEN		=	_BV(0),
	
	
}CTRL_REG5_A_t;

typedef enum LSM330_GYRO_REGISTERS
{
	WHO_AM_I_G		=	0x0F,
	
	CTRL_REG1_G		=	0x20,
	CTRL_REG2_G		=	0x21,
	CTRL_REG3_G		=	0x22,
	CTRL_REG4_G		=	0x23,
	CTRL_REG5_G		=	0x24,
	
	REFERENCE_G		=	0x25,
	
	OUT_TEMP_G		=	0x26,
	STATUS_REG_G	=	0x27,
	
	OUT_X_L_G		=	0x28,
	OUT_X_H_G		=	0x29,
	OUT_Y_L_G		=	0x2A,
	OUT_Y_H_G		=	0x2B,
	OUT_Z_L_G		=	0x2C,
	OUT_Z_H_G		=	0x2D,
	
	FIFO_CTRL_REG_G	=	0x2E,
	FIFO_SRC_REG_G	=	0x2F,
	
	INT1_CFG_G		=	0x30,
	INT1_SRC_G		=	0x31,
	
	INT1_THS_XH_G	=	0x32,
	INT1_THS_XL_G	=	0x33,
	INT1_THS_YH_G	=	0x34,
	INT1_THS_YL_G	=	0x35,
	INT1_THS_ZH_G	=	0x36,
	INT1_THS_ZL_G	=	0x37,
	
	INT1_DURATION_G	=	0x38
}lsm330_regG_t;

typedef enum LSM330_CTRL_REG1_G
{
	
	CTRL_REG1_G_DR1	=	_BV(7),
	CTRL_REG1_G_DR0	=	_BV(6),
	CTRL_REG1_G_BW1	=	_BV(5),
	CTRL_REG1_G_BW0	=	_BV(4),
	CTRL_REG1_G_PD	=	_BV(3),
	CTRL_REG1_G_ZEN	=	_BV(2),
	CTRL_REG1_G_XEN	=	_BV(1),
	CTRL_REG1_G_YEN	=	_BV(0)
	
}CTRL_REG1_G_t;

typedef enum LSM330_CTRL_REG2_G
{
	
	CTRL_REG2_G_EXTRen	=	_BV(7),
	CTRL_REG2_G_LVLen	=	_BV(6),
	CTRL_REG2_G_HPM1	=	_BV(5),
	CTRL_REG2_G_HPM0	=	_BV(4),
	CTRL_REG2_G_HPCF3	=	_BV(3),
	CTRL_REG2_G_HPCF2	=	_BV(2),
	CTRL_REG2_G_HPCF1	=	_BV(1),
	CTRL_REG2_G_HPCF0	=	_BV(0)
	
}CTRL_REG2_G_t;

typedef enum LSM330_CTRL_REG3_G
{
	
	CTRL_REG3_G_I1_Int1		=	_BV(7),
	CTRL_REG3_G_I1_Boot		=	_BV(6),
	CTRL_REG3_G_H_Lactive	=	_BV(5),
	CTRL_REG3_G_PP_OD		=	_BV(4),
	CTRL_REG3_G_I2_DRDY		=	_BV(3),
	CTRL_REG3_G_I2_WTM		=	_BV(2),
	CTRL_REG3_G_I2_ORun		=	_BV(1),
	CTRL_REG3_G_I2_Empty	=	_BV(0)
	
}CTRL_REG3_G_t;

typedef enum LSM330_CTRL_REG4_G
{
	
	CTRL_REG4_G_BDU		=	_BV(7),
	CTRL_REG4_G_BLE		=	_BV(6),
	CTRL_REG4_G_FS1		=	_BV(5),
	CTRL_REG4_G_FS0		=	_BV(4),
	//
	//
	//
	CTRL_REG4_G_SIM		=	_BV(0)
	
}CTRL_REG4_G_t;


typedef enum LSM330_CTRL_REG5_G
{
	
	CTRL_REG5_G_BOOT		=	_BV(7),
	CTRL_REG5_G_FIFO_EN		=	_BV(6),
	//
	CTRL_REG5_G_HPen		=	_BV(4),
	CTRL_REG5_G_INT1_SEL1	=	_BV(3),
	CTRL_REG5_G_INT1_SEL0	=	_BV(2),
	CTRL_REG5_G_Out_Sel1	=	_BV(1),
	CTRL_REG5_G_Out_Sel0	=	_BV(0)
	
}CTRL_REG5_G_t;

#define lsm330_spiRead_strobe		0x80
#define lsm330_spiWrite_strobe		0x00

#define lsm330_spiMultiByte_strobe	0x40
#define lsm330_spiSingleByte_strobe	0x00


#endif /* LSM330_H_ */
