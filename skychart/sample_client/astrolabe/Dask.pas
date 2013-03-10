unit DASK;

interface

Const

(*-------- ADLink PCI Card Type -----------*)
    PCI_6208V      = 1;
    PCI_6208A      = 2;
    PCI_6308V      = 3;
    PCI_6308A      = 4;
    PCI_7200       = 5;
    PCI_7230       = 6;
    PCI_7233       = 7;
    PCI_7234       = 8;
    PCI_7248       = 9;
    PCI_7249       = 10;
    PCI_7250       = 11;
    PCI_7252       = 12;
    PCI_7296       = 13;
    PCI_7300A_RevA = 14;
    PCI_7300A_RevB = 15;
    PCI_7432       = 16;
    PCI_7433       = 17;
    PCI_7434       = 18;
    PCI_8554       = 19;
    PCI_9111DG     = 20;
    PCI_9111HR     = 21;
    PCI_9112       = 22;
    PCI_9113       = 23;
    PCI_9114DG     = 24;
    PCI_9114HG     = 25;
    PCI_9118DG     = 26;
    PCI_9118HG     = 27;
    PCI_9118HR     = 28;
    PCI_9810       = 29;
    PCI_9812       = 30;
    PCI_7396       = 31;
    PCI_9116       = 32;
    PCI_7256       = 33;
    PCI_7258       = 34;
    PCI_7260       = 35;
    PCI_7452       = 36;
    PCI_7442       = 37;
    PCI_7443       = 38;
    PCI_7444       = 39;
    PCI_9221       = 40;
    PCI_9524       = 41;
    PCI_6202       = 42;
    PCI_9222       = 43;
    PCI_9223       = 44;
    PCI_7433C      = 45;
    PCI_7434C      = 46;
    PCI_922A       = 47;
    PCI_7350       = 48;

    MAX_CARD       = 32;

(*-------- Error Number -----------*)
    NoError                    =  0;
    ErrorUnknownCardType       = -1;
    ErrorInvalidCardNumber     = -2;
    ErrorTooManyCardRegistered = -3;
    ErrorCardNotRegistered     = -4;
    ErrorFuncNotSupport        = -5;
    ErrorInvalidIoChannel      = -6;
    ErrorInvalidAdRange        = -7;
    ErrorContIoNotAllowed      = -8;
    ErrorDiffRangeNotSupport   = -9;
    ErrorLastChannelNotZero    = -10;
    ErrorChannelNotDescending  = -11;
    ErrorChannelNotAscending   = -12;
    ErrorOpenDriverFailed      = -13;
    ErrorOpenEventFailed       = -14;
    ErrorTransferCountTooLarge = -15;
    ErrorNotDoubleBufferMode   = -16;
    ErrorInvalidSampleRate     = -17;
    ErrorInvalidCounterMode    = -18;
    ErrorInvalidCounter        = -19;
    ErrorInvalidCounterState   = -20;
    ErrorInvalidBinBcdParam    = -21;
    ErrorBadCardType           = -22;
    ErrorInvalidDaRefVoltage   = -23;
    ErrorAdTimeOut             = -24;
    ErrorNoAsyncAI             = -25;
    ErrorNoAsyncAO             = -26;
    ErrorNoAsyncDI             = -27;
    ErrorNoAsyncDO             = -28;
    ErrorNotInputPort          = -29;
    ErrorNotOutputPort         = -30;
    ErrorInvalidDioPort        = -31;
    ErrorInvalidDioLine        = -32;
    ErrorContIoActive          = -33;
    ErrorDblBufModeNotAllowed  = -34;
    ErrorConfigFailed          = -35;
    ErrorInvalidPortDirection  = -36;
    ErrorBeginThreadError      = -37;
    ErrorInvalidPortWidth      = -38;
    ErrorInvalidCtrSource      = -39;
    ErrorOpenFile              = -40;
    ErrorAllocateMemory        = -41;
    ErrorDaVoltageOutOfRange   = -42;
    ErrorDaExtRefNotAllowed    = -43;
    ErrorDIODataWidthError     = -44;
    ErrorTaskCodeError         = -45;
    ErrortriggercountError     = -46;
    ErrorInvalidTriggerMode    = -47;
    ErrorInvalidTriggerType    = -48;
    ErrorInvalidCounterValue   = -50;
    ErrorInvalidEventHandle    = -60;
    ErrorNoMessageAvailable    = -61;
    ErrorEventMessgaeNotAdded  = -62;
    ErrorCalibrationTimeOut    = -63;
    ErrorUndefinedParameter    = -64;
    ErrorInvalidBufferID       = -65;
    ErrorInvalidSampledClock   = -66;
    ErrorInvalisOperationMode  = -67;

    ErrorConfigIoctl           = -201;
    ErrorAsyncSetIoctl         = -202;
    ErrorDBSetIoctl            = -203;
    ErrorDBHalfReadyIoctl      = -204;
    ErrorContOPIoctl           = -205;
    ErrorContStatusIoctl       = -206;
    ErrorPIOIoctl              = -207;
    ErrorDIntSetIoctl          = -208;
    ErrorWaitEvtIoctl          = -209;
    ErrorOpenEvtIoctl          = -210;
    ErrorCOSIntSetIoctl        = -211;
    ErrorMemMapIoctl           = -212;
    ErrorMemUMapSetIoctl       = -213;
    ErrorCTRIoctl              = -214;
    ErrorGetResIoctl           = -215;
    ErrorCalIoctl              = -216;
    ErrorPMIntSetIoctl         = -217;

(*-------- AD Range -----------*)
    AD_B_10_V     =  1;
    AD_B_5_V      =  2;
    AD_B_2_5_V    =  3;
    AD_B_1_25_V   =  4;
    AD_B_0_625_V  =  5;
    AD_B_0_3125_V =  6;
    AD_B_0_5_V    =  7;
    AD_B_0_05_V   =  8;
    AD_B_0_005_V  =  9;
    AD_B_1_V      = 10;
    AD_B_0_1_V    = 11;
    AD_B_0_01_V   = 12;
    AD_B_0_001_V  = 13;
    AD_U_20_V     = 14;
    AD_U_10_V     = 15;
    AD_U_5_V      = 16;
    AD_U_2_5_V    = 17;
    AD_U_1_25_V   = 18;
    AD_U_1_V      = 19;
    AD_U_0_1_V    = 20;
    AD_U_0_01_V   = 21;
    AD_U_0_001_V  = 22;
    AD_B_2_V      = 23;
    AD_B_0_25_V   = 24;
    AD_B_0_2_V    = 25;
    AD_U_4_V      = 26;
    AD_U_2_V      = 27;
    AD_U_0_5_V    = 28;
    AD_U_0_4_V    = 29;


(*-------- AO Terminate Mode -----------*)
    DA_TerminateImmediate = 0;


(*-------- Trigger Mode -----------*)
    TRIG_SOFTWARE         = 0;
    TRIG_INT_PACER        = 1;
    TRIG_EXT_STROBE       = 2;
    TRIG_HANDSHAKE        = 3;
    TRIG_CLK_10MHZ        = 4; (* PCI-7300A        *)
    TRIG_CLK_20MHZ        = 5; (* PCI-7300A        *)
    TRIG_DO_CLK_TIMER_ACK = 6; (* PCI-7300A Rev. B *)
    TRIG_DO_CLK_10M_ACK   = 7; (* PCI-7300A Rev. B *)
    TRIG_DO_CLK_20M_ACK   = 8; (* PCI-7300A Rev. B *)

(*-- Virtual Sampling Rate for using external clock as the clock source --*)
    CLKSRC_EXT_SampRate = 10000;

(*-------- Constants for PCI-6208A -----------*)
(*-- Output Mode --*)
    P6208_CURRENT_0_20MA = 0;
    P6208_CURRENT_5_25MA = 1;
    P6208_CURRENT_4_20MA = 3;
(*-------- Constants for PCI-6308A/PCI-6308V -----------*)
(*-- Output Mode --*)
    P6308_CURRENT_0_20MA = 0;
    P6308_CURRENT_5_25MA = 1;
    P6308_CURRENT_4_20MA = 3;
(*-- AO Setting --*)
    P6308V_AO_CH0_3    = 0;
    P6308V_AO_CH4_7    = 1;
    P6308V_AO_UNIPOLAR = 0;
    P6308V_AO_BIPOLAR  = 1;
(*-------- Constants for PCI-7200 ------------*)
(*-- InputMode --*)
    DI_WAITING      = $02;
    DI_NOWAITING    = $00;
    DI_TRIG_RISING  = $04;
    DI_TRIG_FALLING = $00;
    IREQ_RISING     = $08;
    IREQ_FALLING    = $00;
(*------- Output Mode ---------------------- *)
    OREQ_ENABLE  = $10;
    OREQ_DISABLE = $00;
    OTRIG_HIGH   = $20;
    OTRIG_LOW    = $00;

(*--------- Constants for PCI-7248/7296/7442 ----------*)
(*--- DIO Port Direction ---*)
    INPUT_PORT  = 1;
    OUTPUT_PORT = 2;
(*--- DIO Line Direction ---*)
    INPUT_LINE  = 1;
    OUTPUT_LINE = 2;

(*--- Channel&Port ---*)
    Channel_P1A  = 0;
    Channel_P1B  = 1;
    Channel_P1C  = 2;
    Channel_P1CL = 3;
    Channel_P1CH = 4;
    Channel_P1AE = 10;
    Channel_P1BE = 11;
    Channel_P1CE = 12;
    Channel_P2A  = 5;
    Channel_P2B  = 6;
    Channel_P2C  = 7;
    Channel_P2CL = 8;
    Channel_P2CH = 9;
    Channel_P2AE = 15;
    Channel_P2BE = 16;
    Channel_P2CE = 17;
    Channel_P3A  = 10;
    Channel_P3B  = 11;
    Channel_P3C  = 12;
    Channel_P3CL = 13;
    Channel_P3CH = 14;
    Channel_P4A  = 15;
    Channel_P4B  = 16;
    Channel_P4C  = 17;
    Channel_P4CL = 18;
    Channel_P4CH = 19;
    Channel_P5A  = 20;
    Channel_P5B  = 21;
    Channel_P5C  = 22;
    Channel_P5CL = 23;
    Channel_P5CH = 24;
    Channel_P6A  = 25;
    Channel_P6B  = 26;
    Channel_P6C  = 27;
    Channel_P6CL = 28;
    Channel_P6CH = 29;
    Channel_P1   = 30;
    Channel_P2   = 31;
    Channel_P3   = 32;
    Channel_P4   = 33;
    Channel_P1E  = 34;
    Channel_P2E  = 35;
    Channel_P3E  = 36;
    Channel_P4E  = 37;

    P7442_CH0    = 0;
    P7442_CH1    = 1;
    P7442_TTL0   = 2;
    P7442_TTL1   = 3;
    P7443_CH0    = 0;
    P7443_CH1    = 1;
    P7443_CH2    = 2;
    P7443_CH3    = 3;
    P7443_TTL0   = 4;
    P7443_TTL1   = 5;
    P7444_CH0    = 0;
    P7444_CH1    = 1;
    P7444_CH2    = 2;
    P7444_CH3    = 3;
    P7444_TTL0   = 4;
    P7444_TTL1   = 5;

(*-------- Constants for PCI-7300A -------------------*)
(*--- Wait Status ---*)
    P7300_WAIT_NO   = 0;
    P7300_WAIT_TRG  = 1;
    P7300_WAIT_FIFO = 2;
    P7300_WAIT_BOTH = 3;

(*--- Terminator control ---*)
    P7300_TERM_OFF = 0;
    P7300_TERM_ON  = 1;

(*--- DI control signals polarity for PCI-7300A Rev. B ---*)
    P7300_DIREQ_POS  = $00;
    P7300_DIREQ_NEG  = $01;
    P7300_DIACK_POS  = $00;
    P7300_DIACK_NEG  = $02;
    P7300_DITRIG_POS = $00;
    P7300_DITRIG_NEG = $04;

(*--- DO control signals polarity for PCI-7300A Rev. B ---*)
    P7300_DOREQ_POS  = $00;
    P7300_DOREQ_NEG  = $08;
    P7300_DOACK_POS  = $00;
    P7300_DOACK_NEG  = $10;
    P7300_DOTRIG_POS = $00;
    P7300_DOTRIG_NEG = $20;

(*--- DO Disable mode in DO_AsyncClear ---*)
    P7300_DODisableDOEnabled    = 0;
    P7300_DONotDisableDOEnabled = 1;

(*-------- Constants for PCI-7432/7433/7434/7433C/7434C ---------------*)
    PORT_DI_LOW    = 0;
    PORT_DI_HIGH   = 1;
    PORT_DO_LOW    = 0;
    PORT_DO_HIGH   = 1;
    P7432R_DO_LED  = 1;
    P7433R_DO_LED  = 0;
    P7434R_DO_LED  = 2;
    P7432R_DI_SLOT = 1;
    P7433R_DI_SLOT = 2;
    P7434R_DI_SLOT = 0;

(*-- Dual-Interrupt Source control for PCI-7248/29/96 & 7432/33 & 7230/7233 & 8554 & 7396 & 7256/58/60 & 7433C --*)
    INT1_NC	       = -2;   (* INT1 Unchanged                                                           *)
    INT1_DISABLE       = -1;   (* INT1 Disabled                                                            *)
    INT1_COS           =  0;   (* INT1 COS : only available for PCI-7396, PCI-7256/58/60                   *)
    INT1_FP1C0         =  1;   (* INT1 by Falling edge of P1C0 : only available for PCI7248/96/7396        *)
    INT1_RP1C0_FP1C3   =  2;   (* INT1 by P1C0 Rising or P1C3 Falling : only available for PCI7248/96/7396 *)
    INT1_EVENT_COUNTER =  3;   (* INT1 by Event Counter down to zero : only available for PCI7248/96/7396  *)
    INT1_EXT_SIGNAL    =  1;   (* INT1 by external signal: only available for PCI7432/33                   *)
    INT1_COUT12        =  1;   (* INT1 COUT12 : only available for PCI8554                                 *)
    INT1_CH0           =  1;   (* INT1 CH0 : only available for PCI7256/58/60                              *)
    INT1_COS0          =  1;   (* INT1 COS0 : only available for PCI-7452/7442/7443                        *)
    INT1_COS1          =  2;   (* INT1 COS1 : only available for PCI-7452/7442/7443                        *)
    INT1_COS2          =  4;   (* INT1 COS2 : only available for PCI-7452/7443                             *)
    INT1_COS3          =  8;   (* INT1 COS3 : only available for PCI-7452/7443                             *)
    INT2_NC	       = -2;   (* INT2 Unchanged                                                           *)
    INT2_DISABLE       = -1;   (* INT2 Disabled                                                            *)
    INT2_COS           =  0;   (* INT2 COS : only available for PCI-7396                                   *)
    INT2_FP2C0         =  1;   (* INT2 by Falling edge of P2C0 : only available for PCI7248/96/7396        *)
    INT2_RP2C0_FP2C3   =  2;   (* INT2 by P2C0 Rising or P2C3 Falling : only available for PCI7248/96/7396 *)
    INT2_TIMER_COUNTER =  3;   (* INT2 by Timer Counter down to zero : only available for PCI7248/96/7396  *)
    INT2_EXT_SIGNAL    =  1;   (* INT2 by external signal: only available for PCI7432/33                   *)
    INT2_CH1           =  2;   (* INT2 CH1 : only available for PCI7256/58/60                              *)
    INT2_WDT           =  4;   (* INT2 by WDT                                                              *)

    WDT_OVRFLOW_SAFETYOUT = $8000; (* enable safteyout while WDT overflow *)
(*-------- Constants for PCI-8554 -----------*)
(*-- Clock Source of Cunter N --*)
    ECKN    = 0;
    COUTN_1 = 1;
    CK1     = 2;
    COUT10  = 3;

(*-- Clock Source of CK1 --*)
    CK1_C8M    = 0;
    CK1_COUT11 = 1;

(*-- Debounce Clock --*)
    DBCLK_COUT11 = 0;
    DBCLK_2MHZ   = 1;

(*-------- Constants for PCI-9111 ------------*)
(*-- Dual Interrupt Mode --*)
    P9111_INT1_EOC     = 0;    (* Ending of AD conversion *)
    P9111_INT1_FIFO_HF = 1;    (* FIFO Half Full          *)
    P9111_INT2_PACER   = 0;    (* Every Timer tick        *)
    P9111_INT2_EXT_TRG = 1;    (* ExtTrig High->Low       *)

(*-- Channel Count --*)
    P9111_CHANNEL_DO  = 0;
    P9111_CHANNEL_EDO = 1;
    P9111_CHANNEL_DI  = 0;
    P9111_CHANNEL_EDI = 1;

(*-- EDO function  --*)
    P9111_EDO_INPUT   = 1;   (* EDO port set as Input port                *)
    P9111_EDO_OUT_EDO = 2;   (* EDO port set as Output port               *)
    P9111_EDO_OUT_CHN = 3;   (* EDO port set as channel number ouput port *)

(*-- Trigger Mode  --*)
    P9111_TRGMOD_SOFT = 0;   (* Software Trigger Mode  *)
    P9111_TRGMOD_PRE  = 1;   (* Pre-Trigger Mode       *)
    P9111_TRGMOD_POST = 2;   (* Post Trigger Mode      *)

(*-- AO Setting --*)
    P9111_AO_UNIPOLAR = 0;
    P9111_AO_BIPOLAR  = 1;

(*-------- Constants for PCI-9116 ------------*)
    P9116_AI_LocalGND      = $00;
    P9116_AI_UserCMMD      = $01;
    P9116_AI_SingEnded     = $00;
    P9116_AI_Differential  = $02;
    P9116_AI_BiPolar       = $00;
    P9116_AI_UniPolar      = $04;

    P9116_TRGMOD_SOFT      = $00;  (* Software Trigger Mode *)
    P9116_TRGMOD_POST      = $10;  (* Post Trigger Mode     *)
    P9116_TRGMOD_DELAY     = $20;  (* Delay Trigger Mode    *)
    P9116_TRGMOD_PRE       = $30;  (* Pre-Trigger Mode      *)
    P9116_TRGMOD_MIDL      = $40;  (* Middle Trigger Mode   *)
    P9116_AI_TrgPositive   = $00;
    P9116_AI_TrgNegative   = $80;
    P9116_AI_IntTimeBase   = $00;
    P9116_AI_ExtTimeBase   = $100;
    P9116_AI_DlyInSamples  = $200;
    P9116_AI_DlyInTimebase = $000;
    P9116_AI_ReTrigEn      = $400;
    P9116_AI_MCounterEn    = $800;
    P9116_AI_SoftPolling   = $0000;
    P9116_AI_INT           = $1000;
    P9116_AI_DMA           = $2000;

(*-------- Constants for PCI-9118 ------------*)
    P9118_AI_BiPolar      = $00;
    P9118_AI_UniPolar     = $01;

    P9118_AI_SingEnded    = $00;
    P9118_AI_Differential = $02;

    P9118_AI_ExtG         = $04;

    P9118_AI_ExtTrig      = $08;

    P9118_AI_DtrgNegative = $00;
    P9118_AI_DtrgPositive = $10;

    P9118_AI_EtrgNegative = $00;
    P9118_AI_EtrgPositive = $20;

    P9118_AI_BurstModeEn  = $40;
    P9118_AI_SampleHold   = $80;
    P9118_AI_PostTrgEn    = $100;
    P9118_AI_AboutTrgEn   = $200;

(*-------- Constants for PCI-9812 ------------*)
(*-- Channel Count --*)
    P9812_CHANNEL_CNT1   = 1;    (* Channel 0 is enabled        *)
    P9812_CHANNEL_CNT2   = 2;    (* Channel 0 and 1 is enabled  *)
    P9812_CHANNEL_CNT4   = 4;    (* All channels are enabled    *)

(*-- Trigger Mode --*)
    P9812_TRGMOD_SOFT    = $00;  (* Software Trigger Mode       *)
    P9812_TRGMOD_POST    = $01;  (* Post Trigger Mode           *)
    P9812_TRGMOD_PRE     = $02;  (* Pre-Trigger Mode            *)
    P9812_TRGMOD_DELAY   = $03;  (* Delay Trigger Mode          *)
    P9812_TRGMOD_MIDL    = $04;  (* Middle Trigger Mode         *)

    P9812_AIEvent_Manual = $80;  (* AI event manual reset     *)

(*-- Trigger Source --*)
    P9812_TRGSRC_CH0     = $00;   (* trigger source --CH0     *)
    P9812_TRGSRC_CH1     = $08;   (* trigger source --CH1     *)
    P9812_TRGSRC_CH2     = $10;   (* trigger source --CH2     *)
    P9812_TRGSRC_CH3     = $18;   (* trigger source --CH3     *)
    P9812_TRGSRC_EXT_DIG = $20;   (* External Digital Trigger *)

(*-- Trigger Polarity --*)
    P9812_TRGSLP_POS     = $00;   (* Positive slope trigger *)
    P9812_TRGSLP_NEG     = $40;   (* Negative slope trigger *)

(*-- Frequency Selection --*)
    P9812_AD2_GT_PCI     = $80;   (* Freq. of A/D clock > PCI clock freq. *)
    P9812_AD2_LT_PCI     = $00;   (* Freq. of A/D clock < PCI clock freq. *)

(*-- Clock Source --*)
    P9812_CLKSRC_INT     = $000;   (* Internal clock             *)
    P9812_CLKSRC_EXT_SIN = $100;   (* External SIN wave clock    *)
    P9812_CLKSRC_EXT_DIG = $200;   (* External Square wave clock *)


(*-------- Constants for PCI-9221 -------*)
(*-- Input Type --*)
    P9221_AI_SingEnded        = $00;
    P9221_AI_NonRef_SingEnded = $01;
    P9221_AI_Differential     = $02;

(*-- Trigger Mode --*)
    P9221_TRGMOD_SOFT = $00;
    P9221_TRGMOD_ExtD = $08;

(*-- Trigger Source --*)
    P9221_TRGSRC_GPI0 = $00;
    P9221_TRGSRC_GPI1 = $01;
    P9221_TRGSRC_GPI2 = $02;
    P9221_TRGSRC_GPI3 = $03;
    P9221_TRGSRC_GPI4 = $04;
    P9221_TRGSRC_GPI5 = $05;
    P9221_TRGSRC_GPI6 = $06;
    P9221_TRGSRC_GPI7 = $07;

(*-- Trigger Polarity --*)
    P9221_AI_TrgPositive = $00;
    P9221_AI_TrgNegative = $10;

(*-- TimeBase Mode --*)
    P9221_AI_IntTimeBase = $00;
    P9221_AI_ExtTimeBase = $80;

(*-- TimeBase Source --*)
    P9221_TimeBaseSRC_GPI0 = $00;
    P9221_TimeBaseSRC_GPI1 = $10;
    P9221_TimeBaseSRC_GPI2 = $20;
    P9221_TimeBaseSRC_GPI3 = $30;
    P9221_TimeBaseSRC_GPI4 = $40;
    P9221_TimeBaseSRC_GPI5 = $50;
    P9221_TimeBaseSRC_GPI6 = $60;
    P9221_TimeBaseSRC_GPI7 = $70;

(*-- DAQ Event type for the event message --*)
    AIEnd   = 0;
    AOEnd   = 0;
    DIEnd   = 0;
    DOEnd   = 0;
    DBEvent = 1;
    TrigEvent = 2;

(*-- EMG shdn ctrl code --*)
    EMGSHDN_OFF      = 0;
    EMGSHDN_ON       = 1;
    EMGSHDN_RECOVERY = 2;

(*-- Hot Reset Hold ctrl code --*)
    HRH_OFF = 0;
    HRH_ON  = 1;

(*-- COS Counter OP --*)
    COS_COUNTER_RESET = 0;
    COS_COUNTER_SETUP = 1;
    COS_COUNTER_START = 2;
    COS_COUNTER_STOP  = 3;
    COS_COUNTER_READ  = 4;

(*-------- Timer/Counter -----------------------------*)
(*-- Counter Mode (8254) --*)
    TOGGLE_OUTPUT          = 0;   (* Toggle output from low to high on terminal count *)
    PROG_ONE_SHOT          = 1;   (* Programmable one-shot      *)
    RATE_GENERATOR         = 2;   (* Rate generator             *)
    SQ_WAVE_RATE_GENERATOR = 3;   (* Square wave rate generator *)
    SOFT_TRIG              = 4;   (* Software-triggered strobe  *)
    HARD_TRIG              = 5;   (* Hardware-triggered strobe  *)

(* General Purpose Timer/Counter *)
(* -- Counter Mode -- *)
    General_Counter         = $00;  (* general counter  *)
    Pulse_Generation        = $01;  (* pulse generation *)
(* -- GPTC clock source --*)
    GPTC_CLKSRC_EXT         = $08;
    GPTC_CLKSRC_INT         = $00;
    GPTC_GATESRC_EXT        = $10;
    GPTC_GATESRC_INT        = $00;
    GPTC_UPDOWN_SELECT_EXT  = $20;
    GPTC_UPDOWN_SELECT_SOFT = $00;
    GPTC_UP_CTR             = $40;
    GPTC_DOWN_CTR           = $00;
    GPTC_ENABLE             = $80;
    GPTC_DISABLE            = $00;

(*-- General Purpose Timer/Counter for 9221 --*)
(*-- Counter Mode --*)
    SimpleGatedEventCNT       = $01;
    SinglePeriodMSR           = $02;
    SinglePulseWidthMSR       = $03;
    SingleGatedPulseGen       = $04;
    SingleTrigPulseGen        = $05;
    RetrigSinglePulseGen      = $06;
    SingleTrigContPulseGen    = $07;
    ContGatedPulseGen         = $08;
    EdgeSeparationMSR         = $09;
    SingleTrigContPulseGenPWM = $0a;
    ContGatedPulseGenPWM      = $0b;
    CW_CCW_Encoder            = $0c;
    x1_AB_Phase_Encoder       = $0d;
    x2_AB_Phase_Encoder       = $0e;
    x4_AB_Phase_Encoder       = $0f;
    Phase_Z                   = $10;

 (*-- GPTC clock source --*)
    GPTC_CLK_SRC_Ext  = $01;
    GPTC_CLK_SRC_Int  = $00;
    GPTC_GATE_SRC_Ext = $02;
    GPTC_GATE_SRC_Int = $00;
    GPTC_UPDOWN_Ext   = $04;
    GPTC_UPDOWN_Int   = $00;

 (*-- GPTC clock polarity --*)
    GPTC_CLKSRC_LACTIVE   = $01;
    GPTC_CLKSRC_HACTIVE   = $00;
    GPTC_GATE_LACTIVE     = $02;
    GPTC_GATE_HACTIVE     = $00;
    GPTC_UPDOWN_LACTIVE   = $04;
    GPTC_UPDOWN_HACTIVE   = $00;
    GPTC_OUTPUT_LACTIVE   = $08;
    GPTC_OUTPUT_HACTIVE   = $00;

    IntGate               = $00;
    IntUpDnCTR            = $01;
    IntENABLE             = $02;

    GPTC_EZ0_ClearPhase0  = $00;
    GPTC_EZ0_ClearPhase1  = $01;
    GPTC_EZ0_ClearPhase2  = $02;
    GPTC_EZ0_ClearPhase3  = $03;

    GPTC_EZ0_ClearMode0   = $00;
    GPTC_EZ0_ClearMode1   = $01;
    GPTC_EZ0_ClearMode2   = $02;
    GPTC_EZ0_ClearMode3   = $03;

(*-- Watchdog Timer --*)
(*-- Counter action --*)
    WDT_DISARM  = 0;
    WDT_ARM     = 1;
    WDT_RESTART = 2;

(*-- Pattern ID --*)
    INIT_PTN    = 0;
    EMGSHDN_PTN = 1;

(*-- Pattern ID for 7442/7444 --*)
    INIT_PTN_CH0    = 0;
    INIT_PTN_CH1    = 1;
    INIT_PTN_CH2    = 2; (* Only for 7444 *)
    INIT_PTN_CH3    = 3; (* Only for 7444 *)
    SAFTOUT_PTN_CH0 = 4;
    SAFTOUT_PTN_CH1 = 5;
    SAFTOUT_PTN_CH2 = 6; (* Only for 7444 *)
    SAFTOUT_PTN_CH3 = 7; (* Only for 7444 *)

(*-------- 16-bit binary or 4-decade BCD counter------------------*)
    BIN = 0;
    BCD = 1;

(*-- EEPROM --*)
    EEPROM_DEFAULT_BANK = 0;
    EEPROM_USER_BANK1   = 1;

(*------------------------------------*)
(* Constants for PCI-9524             *)
(*------------------------------------*)
(*AI Interrupt*)
    P9524_INT_LC_EOC          = $02;
    P9524_INT_GP_EOC          = $03;
(*DSP Constants*)
    P9524_SPIKE_REJ_DISABLE   = $00;
    P9524_SPIKE_REJ_ENABLE    = $01;
(*Transfer Mode*)
    P9524_AI_XFER_POLL        = $00;
    P9524_AI_XFER_DMA         = $01;
(*Poll All Channels*)
    P9524_AI_POLL_ALLCHANNELS = 8;
    P9524_AI_POLLSCANS_CH0_CH3 = 8;
    P9524_AI_POLLSCANS_CH0_CH2 = 9;
    P9524_AI_POLLSCANS_CH0_CH1 = 10;
(*ADC Sampling Rate*)
    P9524_ADC_30K_SPS         = 0;
    P9524_ADC_15K_SPS         = 1;
    P9524_ADC_7K5_SPS         = 2;
    P9524_ADC_3K75_SPS        = 3;
    P9524_ADC_2K_SPS          = 4;
    P9524_ADC_1K_SPS          = 5;
    P9524_ADC_500_SPS         = 6;
    P9524_ADC_100_SPS         = 7;
    P9524_ADC_60_SPS          = 8;
    P9524_ADC_50_SPS          = 9;
    P9524_ADC_30_SPS          = 10;
    P9524_ADC_25_SPS          = 11;
    P9524_ADC_15_SPS          = 12;
    P9524_ADC_10_SPS          = 13;
    P9524_ADC_5_SPS           = 14;
    P9524_ADC_2R5_SPS         = 15;
(*ConfigCtrl Constants*)
    P9524_VEX_Range_2R5V      = $00;
    P9524_VEX_Range_10V       = $01;
    P9524_VEX_Sence_Local     = $00;
    P9524_VEX_Sence_Remote    = $02;
    P9524_AI_AZMode           = $04;
    P9524_AI_BufAutoReset     = $08;
    P9524_AI_EnEOCInt         = $10;
(*Trigger Constants*)
    P9524_TRGMOD_POST         = $00;
    P9524_TRGSRC_SOFT         = $00;
    P9524_TRGSRC_ExtD         = $01;
    P9524_TRGSRC_SSI          = $02;
    P9524_TRGSRC_QD0          = $03;
    P9524_TRGSRC_PG0          = $04;
    P9524_AI_TrgPositive      = $00;
    P9524_AI_TrgNegative      = $08;
(*Group*)
    P9524_AI_LC_Group         = 0;
    P9524_AI_GP_Group         = 1;
(*Channel*)
    P9524_AI_LC_CH0           = 0;
    P9524_AI_LC_CH1           = 1;
    P9524_AI_LC_CH2           = 2;
    P9524_AI_LC_CH3           = 3;
    P9524_AI_GP_CH0           = 4;
    P9524_AI_GP_CH1           = 5;
    P9524_AI_GP_CH2           = 6;
    P9524_AI_GP_CH3           = 7;
(*Pulse Generation and Quadrature Decoder*)
    P9524_CTR_PG0             = 0;
    P9524_CTR_PG1             = 1;
    P9524_CTR_PG2             = 2;
    P9524_CTR_QD0             = 3;
    P9524_CTR_QD1             = 4;
    P9524_CTR_QD2             = 5;
    P9524_CTR_INTCOUNTER      = 6;
(*Counter Mode*)
    P9524_PulseGen_OUTDIR_N   = 0;
    P9524_PulseGen_OUTDIR_R   = 1;
    P9524_PulseGen_CW         = 0;
    P9524_PulseGen_CCW        = 2;
    P9524_x4_AB_Phase_Decoder = 3;
    P9524_Timer               = 4;
(*Counter Op*)
    P9524_CTR_Enable          = 0;
(*Event Mode*)
    P9524_Event_Timer         = 0;
(*AO*)
    P9524_AO_CH0_1            = 0;

(*------------------------------------*)
(* Constants for PCI-6202             *)
(*------------------------------------*)
    P6202_ISO0                = 0;
    P6202_TTL0                = 1;
    P6202_GPTC0               = $00;
    P6202_GPTC1               = $01;
    P6202_ENCODER0            = $02;
    P6202_ENCODER1            = $03;
    P6202_ENCODER2            = $04;
(*DA control constant*)
    P6202_DA_WRSRC_Int        = $00;
    P6202_DA_WRSRC_AFI0       = $01;
    P6202_DA_WRSRC_SSI        = $02;
    P6202_DA_WRSRC_AFI1       = $03;
(*DA trigger constant*)
    P6202_DA_TRGSRC_SOFT      = $00;
    P6202_DA_TRGSRC_AFI0      = $01;
    P6202_DA_TRGSRC_SSI       = $02;
    P6202_DA_TRGSRC_AFI1      = $03;
    P6202_DA_TRGMOD_POST      = $00;
    P6202_DA_TRGMOD_DELAY     = $04;
    P6202_DA_ReTrigEn         = $20;
    P6202_DA_DLY2En           = $100;
(*SSI signal code*)
    P6202_SSI_DA_CONV         = $04;
    P6202_SSI_DA_TRIG         = $40;
(*Encoder constant*)
    P6202_EVT_TYPE_EPT0       = $00;
    P6202_EVT_TYPE_EPT1       = $01;
    P6202_EVT_TYPE_EPT2       = $02;
    P6202_EVT_TYPE_EZC0       = $03;
    P6202_EVT_TYPE_EZC1       = $04;
    P6202_EVT_TYPE_EZC2       = $05;
    P6202_EVT_MOD_EPT         = $00;
    P6202_EPT_PULWIDTH_200us  = $00;
    P6202_EPT_PULWIDTH_2ms    = $01;
    P6202_EPT_PULWIDTH_20ms   = $02;
    P6202_EPT_PULWIDTH_200ms  = $03;
    P6202_EPT_TRGOUT_CALLBACK = $04;
    P6202_EPT_TRGOUT_AFI      = $08;

    P6202_ENCODER0_LDATA      = $05;
    P6202_ENCODER1_LDATA      = $06;
    P6202_ENCODER2_LDATA      = $07;

(*------------------------------------*)
(* Constants for PCI-922x             *)
(*------------------------------------*)
(*------------------*)
(* AI Constants     *)
(*------------------*)
(*Input Type*)
    P922x_AI_SingEnded        = $00;
    P922x_AI_NonRef_SingEnded = $01;
    P922x_AI_Differential     = $02;
(*Conversion Source*)
    P922x_AI_CONVSRC_INT      = $00;
    P922x_AI_CONVSRC_GPI0     = $10;
    P922x_AI_CONVSRC_GPI1     = $20;
    P922x_AI_CONVSRC_GPI2     = $30;
    P922x_AI_CONVSRC_GPI3     = $40;
    P922x_AI_CONVSRC_GPI4     = $50;
    P922x_AI_CONVSRC_GPI5     = $60;
    P922x_AI_CONVSRC_GPI6     = $70;
    P922x_AI_CONVSRC_GPI7     = $80;
    P922x_AI_CONVSRC_SSI1     = $90;
    P922x_AI_CONVSRC_SSI      = $90;
(*Trigger Mode*)
    P922x_AI_TRGMOD_POST      = $00;
    P922x_AI_TRGMOD_GATED     = $01;
(*Trigger Source*)
    P922x_AI_TRGSRC_SOFT      = $00;
    P922x_AI_TRGSRC_GPI0      = $10;
    P922x_AI_TRGSRC_GPI1      = $20;
    P922x_AI_TRGSRC_GPI2      = $30;
    P922x_AI_TRGSRC_GPI3      = $40;
    P922x_AI_TRGSRC_GPI4      = $50;
    P922x_AI_TRGSRC_GPI5      = $60;
    P922x_AI_TRGSRC_GPI6      = $70;
    P922x_AI_TRGSRC_GPI7      = $80;
    P922x_AI_TRGSRC_SSI5      = $90;
    P922x_AI_TRGSRC_SSI       = $90;
(*Trigger Polarity*)
    P922x_AI_TrgPositive      = $000;
    P922x_AI_TrgNegative      = $100;
(*ReTrigger*)
    P922x_AI_EnReTigger       = $200;

(*------------------*)
(* AO Constants     *)
(*------------------*)
(*Conversion Source*)
    P922x_AO_CONVSRC_INT      = $00;
    P922x_AO_CONVSRC_GPI0     = $01;
    P922x_AO_CONVSRC_GPI1     = $02;
    P922x_AO_CONVSRC_GPI2     = $03;
    P922x_AO_CONVSRC_GPI3     = $04;
    P922x_AO_CONVSRC_GPI4     = $05;
    P922x_AO_CONVSRC_GPI5     = $06;
    P922x_AO_CONVSRC_GPI6     = $07;
    P922x_AO_CONVSRC_GPI7     = $08;
    P922x_AO_CONVSRC_SSI2     = $09;
    P922x_AO_CONVSRC_SSI      = $09;
(*Trigger Mode*)
    P922x_AO_TRGMOD_POST      = $00;
    P922x_AO_TRGMOD_DELAY     = $01;
(*Trigger Source*)
    P922x_AO_TRGSRC_SOFT      = $00;
    P922x_AO_TRGSRC_GPI0      = $10;
    P922x_AO_TRGSRC_GPI1      = $20;
    P922x_AO_TRGSRC_GPI2      = $30;
    P922x_AO_TRGSRC_GPI3      = $40;
    P922x_AO_TRGSRC_GPI4      = $50;
    P922x_AO_TRGSRC_GPI5      = $60;
    P922x_AO_TRGSRC_GPI6      = $70;
    P922x_AO_TRGSRC_GPI7      = $80;
    P922x_AO_TRGSRC_SSI6      = $90;
    P922x_AO_TRGSRC_SSI       = $90;
(*Trigger Polarity*)
    P922x_AO_TrgPositive      = $000;
    P922x_AO_TrgNegative      = $100;
(*Retrigger*)
    P922x_AO_EnReTigger       = $200;
(*Delay 2*)
    P922x_AO_EnDelay2         = $400;

(*------------------*)
(* DI Constants     *)
(*------------------*)
(*Conversion Source*)
    P922x_DI_CONVSRC_INT      = $00;
    P922x_DI_CONVSRC_GPI0     = $01;
    P922x_DI_CONVSRC_GPI1     = $02;
    P922x_DI_CONVSRC_GPI2     = $03;
    P922x_DI_CONVSRC_GPI3     = $04;
    P922x_DI_CONVSRC_GPI4     = $05;
    P922x_DI_CONVSRC_GPI5     = $06;
    P922x_DI_CONVSRC_GPI6     = $07;
    P922x_DI_CONVSRC_GPI7     = $08;
    P922x_DI_CONVSRC_ADCONV   = $09;
    P922x_DI_CONVSRC_DACONV   = $0A;
(*Trigger Mode*)
    P922x_DI_TRGMOD_POST      = $00;
(*Trigger Source*)
    P922x_DI_TRGSRC_SOFT      = $00;
    P922x_DI_TRGSRC_GPI0      = $10;
    P922x_DI_TRGSRC_GPI1      = $20;
    P922x_DI_TRGSRC_GPI2      = $30;
    P922x_DI_TRGSRC_GPI3      = $40;
    P922x_DI_TRGSRC_GPI4      = $50;
    P922x_DI_TRGSRC_GPI5      = $60;
    P922x_DI_TRGSRC_GPI6      = $70;
    P922x_DI_TRGSRC_GPI7      = $80;
(*Trigger Polarity*)
    P922x_DI_TrgPositive      = $000;
    P922x_DI_TrgNegative      = $100;
(*ReTrigger*)
    P922x_DI_EnReTigger       = $200;

(*------------------*)
(* DO Constants     *)
(*------------------*)
(*Conversion Source*)
    P922x_DO_CONVSRC_INT      = $00;
    P922x_DO_CONVSRC_GPI0     = $01;
    P922x_DO_CONVSRC_GPI1     = $02;
    P922x_DO_CONVSRC_GPI2     = $03;
    P922x_DO_CONVSRC_GPI3     = $04;
    P922x_DO_CONVSRC_GPI4     = $05;
    P922x_DO_CONVSRC_GPI5     = $06;
    P922x_DO_CONVSRC_GPI6     = $07;
    P922x_DO_CONVSRC_GPI7     = $08;
    P922x_DO_CONVSRC_ADCONV   = $09;
    P922x_DO_CONVSRC_DACONV   = $0A;
(*Trigger Mode*)
    P922x_DO_TRGMOD_POST      = $00;
    P922x_DO_TRGMOD_DELAY     = $01;
(*Trigger Source*)
    P922x_DO_TRGSRC_SOFT      = $00;
    P922x_DO_TRGSRC_GPI0      = $10;
    P922x_DO_TRGSRC_GPI1      = $20;
    P922x_DO_TRGSRC_GPI2      = $30;
    P922x_DO_TRGSRC_GPI3      = $40;
    P922x_DO_TRGSRC_GPI4      = $50;
    P922x_DO_TRGSRC_GPI5      = $60;
    P922x_DO_TRGSRC_GPI6      = $70;
    P922x_DO_TRGSRC_GPI7      = $80;
(*Trigger Polarity*)
    P922x_DO_TrgPositive      = $000;
    P922x_DO_TrgNegative      = $100;
(*Retrigger*)
    P922x_DO_EnReTigger       = $200;

(*--------------------------*)
(* Encoder/GPTC Constants   *)
(*--------------------------*)
    P922x_GPTC0               = $00;
    P922x_GPTC1               = $01;
    P922x_GPTC2               = $02;
    P922x_GPTC3               = $03;
    P922x_ENCODER0            = $04;
    P922x_ENCODER1            = $05;
(*Encoder Setting Event Mode*)
    P922x_EVT_MOD_EPT         = $00;
(*Encoder Setting Event Control*)
    P922x_EPT_PULWIDTH_200us  = $00;
    P922x_EPT_PULWIDTH_2ms    = $01;
    P922x_EPT_PULWIDTH_20ms   = $02;
    P922x_EPT_PULWIDTH_200ms  = $03;
    P922x_EPT_TRGOUT_GPO      = $04;
    P922x_EPT_TRGOUT_CALLBACK = $08;
(*Event Type*)
    P922x_EVT_TYPE_EPT0       = $00;
    P922x_EVT_TYPE_EPT1       = $01;

(*SSI signal code*)
    P922x_SSI_AI_CONV         = $02;
    P922x_SSI_AI_TRIG         = $20;
    P922x_SSI_AO_CONV         = $04;
    P922x_SSI_AO_TRIG         = $40;


(*------------------------------------*)
(* Constants for PCIe-7350            *)
(*------------------------------------*)
    P7350_PortDIO        = 0;
    P7350_PortAFI        = 1;
(*DIO Port*)
    P7350_DIO_A          = 0;
    P7350_DIO_B          = 1;
    P7350_DIO_C          = 2;
    P7350_DIO_D          = 3;
(*AFI Port*)
    P7350_AFI_0          = 0;
    P7350_AFI_1          = 1;
    P7350_AFI_2          = 2;
    P7350_AFI_3          = 3;
    P7350_AFI_4          = 4;
    P7350_AFI_5          = 5;
    P7350_AFI_6          = 6;
    P7350_AFI_7          = 7;
(*AFI Mode*)
    P7350_AFI_DIStartTrig = 0;
    P7350_AFI_DOStartTrig = 1;
    P7350_AFI_DIPauseTrig = 2;
    P7350_AFI_DOPauseTrig = 3;
    P7350_AFI_DISWTrigOut = 4;
    P7350_AFI_DOSWTrigOut = 5;
    P7350_AFI_COSTrigOut  = 6;
    P7350_AFI_PMTrigOut   = 7;
    P7350_AFI_HSDIREQ     = 8;
    P7350_AFI_HSDIACK     = 9;
    P7350_AFI_HSDITRIG    = 10;
    P7350_AFI_HSDOREQ     = 11;
    P7350_AFI_HSDOACK     = 12;
    P7350_AFI_HSDOTRIG    = 13;
    P7350_AFI_SPI         = 14;
    P7350_AFI_I2C         = 15;
    P7350_POLL_DI         = 16;
    P7350_POLL_DO         = 17;
(*Operation Mode*)
    P7350_FreeRun         = 0;
    P7350_HandShake       = 1;
    P7350_BurstHandShake  = 2;
(*Trigger Status*)
    P7350_WAIT_NO         = 0;
    P7350_WAIT_EXTTRG     = 1;
    P7350_WAIT_SOFTTRG    = 2;
(*Sampled Clock*)
    P7350_IntSampledCLK   = $00;
    P7350_ExtSampledCLK   = $01;
(*Sampled Clock Edge*)
    P7350_SampledCLK_R    = $00;
    P7350_SampledCLK_F    = $02;
(*Enable Export Sample Clock*)
    P7350_EnExpSampledCLK = $04;
(*Trigger Configuration*)
    P7350_EnPauseTrig     = $01;
    P7350_EnSoftTrigOut   = $02;
(*HandShake & Trigger Polarity*)
    P7350_DIREQ_POS       = $00;
    P7350_DIREQ_NEG       = $01;
    P7350_DIACK_POS       = $00;
    P7350_DIACK_NEG       = $02;
    P7350_DITRIG_POS      = $00;
    P7350_DITRIG_NEG      = $04;
    P7350_DIStartTrig_POS = $00;
    P7350_DIStartTrig_NEG = $08;
    P7350_DIPauseTrig_POS = $00;
    P7350_DIPauseTrig_NEG = $10;
    P7350_DOREQ_POS       = $00;
    P7350_DOREQ_NEG       = $01;
    P7350_DOACK_POS       = $00;
    P7350_DOACK_NEG       = $02;
    P7350_DOTRIG_POS      = $00;
    P7350_DOTRIG_NEG      = $04;
    P7350_DOStartTrig_POS = $00;
    P7350_DOStartTrig_NEG = $08;
    P7350_DOPauseTrig_POS = $00;
    P7350_DOPauseTrig_NEG = $10;
(*External Sampled Clock Source*)
    P7350_ECLK_IN         = 8;
(*Export Sampled Clock*)
    P7350_ECLK_OUT        = 8;
(*Enable Dynamic Delay Adjust*)
    P7350_DisDDA          = $0;
    P7350_EnDDA           = $1;
(*Dynamic Delay Adjust Mode*)
    P7350_DDA_Lag         = $0;
    P7350_DDA_Lead        = $2;
(*Dynamic Delay Adjust Step*)
    P7350_DDA_130PS       = 0;
    P7350_DDA_260PS       = 1;
    P7350_DDA_390PS       = 2;
    P7350_DDA_520PS       = 3;
    P7350_DDA_650PS       = 4;
    P7350_DDA_780PS       = 5;
    P7350_DDA_910PS       = 6;
    P7350_DDA_1R04NS      = 7;
(*Enable Dynamic Phase Adjust*)
    P7350_DisDPA          = $0;
    P7350_EnDPA           = $1;
(*Dynamic Delay Adjust Degree*)
    P7350_DPA_0DG         = 0;
    P7350_DPA_22R5DG      = 1;
    P7350_DPA_45DG        = 2;
    P7350_DPA_67R5DG      = 3;
    P7350_DPA_90DG        = 4;
    P7350_DPA_112R5DG     = 5;
    P7350_DPA_135DG       = 6;
    P7350_DPA_157R5DG     = 7;
    P7350_DPA_180DG       = 8;
    P7350_DPA_202R5DG     = 9;
    P7350_DPA_225DG       = 10;
    P7350_DPA_247R5DG     = 11;
    P7350_DPA_270DG       = 12;
    P7350_DPA_292R5DG     = 13;
    P7350_DPA_315DG       = 14;
    P7350_DPA_337R5DG     = 15;

(*DIO & AFI Voltage Level*)
    VoltLevel_3R3         = 0;
    VoltLevel_2R5         = 1;
    VoltLevel_1R8         = 2;

(*------------------------------------*)
(* Constants for I Squared C (I2C)    *)
(*------------------------------------*)
(*I2C Port*)
    I2C_Port_A = 0;
(*I2C Control Operation*)
    I2C_ENABLE = 0;
    I2C_STOP   = 1;

(*-------------------------------------------*)
(* Constants for Serial Peripheral Interface *)
(*-------------------------------------------*)
(*SPI Port*)
    SPI_Port_A = 0;
(*SPI Clock Mode*)
    SPI_CLK_L  = $00;
    SPI_CLK_H  = $01;
(*SPI TX Polarity*)
    SPI_TX_POS = $00;
    SPI_TX_NEG = $02;
(*SPI RX Polarity*)
    SPI_RX_POS = $00;
    SPI_RX_NEG = $04;
(*SPI Transferred Order*)
    SPI_MSB    = $00;
    SPI_LSB    = $08;
(*SPI Control Operation*)
    SPI_ENABLE = 0;

(*------------------------------------*)
(* Constants for Access EEPROM        *)
(*------------------------------------*)
(*Pattern Match Channel Mode*)
    PATMATCH_CHNDisable = 0;
    PATMATCH_CHNEnable  = 1;
(*Pattern Match Channel Type*)
    PATMATCH_Level_L    = 0;
    PATMATCH_Level_H    = 1;
    PATMATCH_Edge_R     = 2;
    PATMATCH_Edge_F     = 3;
(*Pattern Match Operation*)
    PATMATCH_STOP       = 0;
    PATMATCH_START      = 1;
    PATMATCH_RESTART    = 2;

(*------------------------------------*)
(* Constants for Pattern Match        *)
(*------------------------------------*)
(*for PCI-7230/PCMe-7230*)
    P7230_EEP_BLK_0 = 0;
    P7230_EEP_BLK_1 = 1;
    
type
  TCallbackFunc = function : Integer;

(****************************************************************************)
(*          PCIS-DASK Functions Declarations                                *)
(****************************************************************************)
function Register_Card (CardType:Word; card_num:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function Release_Card (CardNumber:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function GetActualRate (CardNumber:word; SampleRate:Double; var ActualRate:Double):Smallint;stdcall; external 'Pci-Dask.dll';
function GetActualRate_9524 (CardNumber:word; Group:word; SampleRate:Double; var ActualRate:Double):Smallint;stdcall; external 'Pci-Dask.dll';
function GetCardType (CardNumber:word; var cardType:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function GetBaseAddr (CardNumber:word; var BaseAddr:Cardinal; var BaseAddr2:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function GetLCRAddr (CardNumber:word; LcrAddr:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function GetCardIndexFromID (CardNumber:word; var cardType:Word; var cardIndex:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function EMGShutDownControl (CardNumber:word; ctrl:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function EMGShutDownStatus (CardNumber:word; var status:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function HotResetHoldControl (CardNumber:word; enable:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function HotResetHoldStatus (CardNumber:word; var sts:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function GetInitPattern (CardNumber:word; patID:Byte; var pattern:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function SetInitPattern (CardNumber:word; patID:Byte; pattern:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function IdentifyLED_Control (CardNumber:word; ctrl:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function PCI_EEPROM_LoadData (CardNumber:word; block:word; var data:word):Smallint;stdcall; external 'Pci-Dask.dll';
function PCI_EEPROM_SaveData (CardNumber:word; block:word; data:word):Smallint;stdcall; external 'Pci-Dask.dll';
(*---------------------------------------------------------------------------*)
function AI_9111_Config (CardNumber:Word; TrigSource:Word; TrgMode:Word; TraceCnt:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_9112_Config (CardNumber:Word; TrigSource:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_9113_Config (CardNumber:Word; TrigSource:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_9114_Config (CardNumber:Word; TrigSource:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_9114_PreTrigConfig (CardNumber:Word; PreTrgEn:Word; TraceCnt:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_9116_Config (CardNumber:Word; ConfigCtrl:Word; TrigCtrl:Word; PostCnt:Word; MCnt:Word; ReTrgCnt:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_9118_Config (CardNumber:Word; ModeCtrl:Word; FunCtrl:Word; BurstCnt:Word; PostCnt:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_9221_Config (CardNumber:Word; ConfigCtrl:Word; TrigCtrl:Word; AutoResetBuf:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_9812_Config (CardNumber:Word; TrgMode:Word; TrgSrc:Word; TrgPol:Word; ClkSel:Word; TrgLevel:Word; PostCnt:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_9812_SetDiv (CardNumber:Word; pacerVal:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_9116_CounterInterval (CardNumber:Word; ScanIntrv:Cardinal; SampIntrv:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_9221_CounterInterval (CardNumber:Word; ScanIntrv:Cardinal; SampIntrv:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_9524_Config (CardNumber:Word; Group:Word; XMode:Word; ConfigCtrl:Word; TrigCtrl:Word; TrigValue:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_9524_PollConfig (CardNumber:Word; Group:Word; PollChannel:Word; PollRange:Word; PollSpeed:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_9524_SetDSP (CardNumber:Word; Channel:Word; Mode:Word; DFStage:Word; SPKRejThreshold:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_9524_GetEOCEvent (CardNumber:Word; Group:Word; var hEvent:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_9222_Config (CardNumber:Word; ConfigCtrl:Word; TrigCtrl:Word; ReTriggerCnt:Cardinal; AutoResetBuf:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_9222_CounterInterval (CardNumber:Word; ScanIntrv:Cardinal; SampIntrv:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_9223_Config (CardNumber:Word; ConfigCtrl:Word; TrigCtrl:Word; ReTriggerCnt:Cardinal; AutoResetBuf:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_9223_CounterInterval (CardNumber:Word; ScanIntrv:Cardinal; SampIntrv:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_922A_Config (CardNumber:Word; ConfigCtrl:Word; TrigCtrl:Word; ReTriggerCnt:Cardinal; AutoResetBuf:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_922A_CounterInterval (CardNumber:Word; ScanIntrv:Cardinal; SampIntrv:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_InitialMemoryAllocated (CardNumber:Word; var MemSize:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_ReadChannel (CardNumber:Word; Channel:Word; AdRange:Word; var Value:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_ReadChannel32 (CardNumber:Word; Channel:Word; AdRange:Word; var Value:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_VReadChannel (CardNumber:Word; Channel:Word; AdRange:Word; var voltage:Double):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_ScanReadChannels (CardNumber:Word; Channel:Word; AdRange:Word; var Buffer:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_ScanReadChannels32 (CardNumber:Word; Channel:Word; AdRange:Word; var Buffer:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_ReadMultiChannels (CardNumber:Word; NumChans:Word; var Chans:Word; var AdRanges:Word; var Buffer:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_VoltScale (CardNumber:Word; AdRange:Word; reading:Smallint; var voltage:Double):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_VoltScale32 (CardNumber:Word; AdRange:Word; reading:Longint; var voltage:Double):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_ContReadChannel (CardNumber:Word; Channel:Word; AdRange:Word; var Buffer:Word; ReadCount:Cardinal; SampleRate:Double; SyncMode:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_ContReadMultiChannels (CardNumber:Word; NumChans:Word; var Chans:Word; var AdRanges:Word; var Buffer:Word; ReadCount:Cardinal; SampleRate:Double; SyncMode:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_ContScanChannels (CardNumber:Word; Channel:Word; AdRange:Word; var Buffer:Word; ReadCount:Cardinal; SampleRate:Double; SyncMode:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_ContReadChannelToFile (CardNumber:Word; Channel:Word; AdRange:Word; var FileName:Char; ReadCount:Cardinal; SampleRate:Double; SyncMode:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_ContReadMultiChannelsToFile (CardNumber:Word; NumChans:Word; var Chans:Word; var AdRanges:Word; var FileName:Char; ReadCount:Cardinal; SampleRate:Double; SyncMode:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_ContScanChannelsToFile (CardNumber:Word; Channel:Word; AdRange:Word; var FileName:Char; ReadCount:Cardinal; SampleRate:Double; SyncMode:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_ContVScale (CardNumber:Word; AdRange:Word; var readingArray:Word; var voltageArray:Double; count:Longint):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_ContStatus (CardNumber:Word; var Status:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_AsyncCheck (CardNumber:Word; var Stopped:Byte; var AccessCnt:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_AsyncClear (CardNumber:Word; var AccessCnt:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_AsyncDblBufferHalfReady (CardNumber:Word; var HalfReady:Byte; var StopFlag:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_AsyncDblBufferMode (CardNumber:Word; Enable:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_AsyncDblBufferTransfer (CardNumber:Word; var Buffer:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_AsyncDblBufferOverrun (CardNumber:Word; op:Word; var overrunFlag:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_AsyncDblBufferHandled (CardNumber:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_AsyncDblBufferToFile (CardNumber:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_EventCallBack (CardNumber:Word; mode:Smallint; EventType:Smallint; callbackAddr:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_SetTimeOut (CardNumber:Word; TimeOut:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_ContBufferSetup (CardNumber:Word; var Buffer:Word; ReadCount:Cardinal; var BufferId:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_ContBufferReset (CardNumber:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_AsyncReTrigNextReady (CardNumber:Word; var Ready:Byte; var StopFlag:Byte; var RdyTrigCnt:Word):Smallint;stdcall; external 'Pci-Dask.dll';
(*---------------------------------------------------------------------------*)
function AO_6202_Config (CardNumber:Word; ConfigCtrl:Word; TrigCtrl:Word; ReTrgCnt:Cardinal; DLY1Cnt:Cardinal; DLY2Cnt:Cardinal; AutoResetBuf:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function AO_6208A_Config (CardNumber:Word; V2AMode:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AO_6308A_Config (CardNumber:Word; V2AMode:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AO_6308V_Config (CardNumber:Word; Channel:Word; OutputPolarity:Word; refVoltage:Double):Smallint;stdcall; external 'Pci-Dask.dll';
function AO_9111_Config (CardNumber:Word; OutputPolarity:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AO_9112_Config (CardNumber:Word; Channel:Word; refVoltage:Double):Smallint;stdcall; external 'Pci-Dask.dll';
function AO_AsyncCheck (CardNumber:Word; var Stopped:Byte; var AccessCnt:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function AO_9222_Config (CardNumber:Word; ConfigCtrl:Word; TrigCtrl:Word; ReTrgCnt:Cardinal; DLY1Cnt:Cardinal; DLY2Cnt:Cardinal; AutoResetBuf:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function AO_9223_Config (CardNumber:Word; ConfigCtrl:Word; TrigCtrl:Word; ReTrgCnt:Cardinal; DLY1Cnt:Cardinal; DLY2Cnt:Cardinal; AutoResetBuf:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function AO_InitialMemoryAllocated (CardNumber:Word; var MemSize:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function AO_AsyncClear (CardNumber:Word; var AccessCnt:Cardinal; stop_mode:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AO_AsyncDblBufferHalfReady (CardNumber:Word; var HalfReady:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function AO_AsyncDblBufferMode (CardNumber:Word; Enable:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function AO_ContBufferCompose (CardNumber:Word; TotalChnCount:Word; ChnNum:Word; UpdateCount:Cardinal; var ConBuffer:Cardinal; var Buffer:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function AO_ContBufferReset (CardNumber:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AO_ContBufferSetup (CardNumber:Word; var Buffer:Cardinal; WriteCount:Cardinal; var BufferId:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AO_ContStatus (CardNumber:Word; var Status:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AO_ContWriteChannel (CardNumber:Word; Channel:Word; BufId:Word; WriteCount:Cardinal; Iterations:Cardinal; CHUI:Cardinal; definite:Word; SyncMode:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AO_ContWriteMultiChannels (CardNumber:Word; NumChans:Word; var Chans:Word; BufId:Word; WriteCount:Cardinal; Iterations:Cardinal; CHUI:Cardinal; definite:Word; SyncMode:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AO_EventCallBack (CardNumber:Word; mode:Smallint; EventType:Smallint; callbackAddr:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function AO_SetTimeOut (CardNumber:Word; TimeOut:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function AO_WriteChannel (CardNumber:Word; Channel:Word; Value:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AO_VWriteChannel (CardNumber:Word; Channel:Word; Voltage:Double):Smallint;stdcall; external 'Pci-Dask.dll';
function AO_VoltScale (CardNumber:Word; Channel:Word; Voltage:Double; var binValue:Smallint):Smallint;stdcall; external 'Pci-Dask.dll';
function AO_SimuWriteChannel (CardNumber:Word; Group:Word; var valueArray:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function AO_SimuVWriteChannel (CardNumber:Word; Group:Word; var voltageArray:Double):Smallint;stdcall; external 'Pci-Dask.dll';
(*---------------------------------------------------------------------------*)
function DI_7200_Config (CardNumber:Word; TrigSource:Word; ExtTrigEn:Word; TrigPol:Word; I_REQ_Pol:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_7233_ForceLogic (CardNumber:Word; ConfigCtrl:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_7300A_Config (CardNumber:Word; PortWidth:Word; TrigSource:Word; WaitStatus:Word; Terminator:Word; I_REQ_Pol:Word; clear_fifo:Byte; disable_di:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_7300B_Config (CardNumber:Word; PortWidth:Word; TrigSource:Word; WaitStatus:Word; Terminator:Word; I_Cntrl_Pol:Word; clear_fifo:Byte; disable_di:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_9222_Config (CardNumber:Word; ConfigCtrl:Word; TrigCtrl:Word; ReTriggerCnt:Cardinal; AutoResetBuf:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_9223_Config (CardNumber:Word; ConfigCtrl:Word; TrigCtrl:Word; ReTriggerCnt:Cardinal; AutoResetBuf:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_InitialMemoryAllocated (CardNumber:Word; var DmaSize:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_ReadLine (CardNumber:Word; Port:Word; Line:Word; var State:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_ReadPort (CardNumber:Word; Port:Word; var Value:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_ContReadPort (CardNumber:Word; Port:Word; var Buffer:Cardinal; ReadCount:Cardinal; SampleRate:Double; SyncMode:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_ContReadPortToFile (CardNumber:Word; Port:Word; var FileName:Byte; ReadCount:Cardinal; SampleRate:Double; SyncMode:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_ContStatus (CardNumber:Word; var Status:Word):smallint;stdcall; external 'Pci-Dask.dll';
function DI_AsyncCheck (CardNumber:Word; var Stopped:Byte; var AccessCnt:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_AsyncClear (CardNumber:Word; var AccessCnt:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_AsyncDblBufferHalfReady (CardNumber:Word; var HalfReady:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_AsyncDblBufferMode (CardNumber:Word; Enable:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_AsyncDblBufferTransfer (CardNumber:Word; var Buffer:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_ContMultiBufferSetup (CardNumber:Word; var Buffer:Cardinal; ReadCount:Cardinal; var BufferId:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_ContMultiBufferStart (CardNumber:Word; Port:Word; SampleRate:Double):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_AsyncMultiBufferNextReady (CardNumber:Word; var NextReady:Byte; var BufferId:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_AsyncDblBufferOverrun (CardNumber:Word; op:Word; var overrunFlag:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_EventCallBack (CardNumber:Word; mode:Smallint; EventType:Smallint; callbackAddr:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_AsyncDblBufferHandled (CardNumber:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_AsyncDblBufferToFile (CardNumber:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_SetTimeOut (CardNumber:Word; TimeOut:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_ContBufferSetup (CardNumber:Word; var Buffer:Cardinal; ReadCount:Cardinal; var BufferId:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_ContBufferReset (CardNumber:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_AsyncReTrigNextReady (CardNumber:Word; var Ready:Byte; var StopFlag:Byte; var RdyTrigCnt:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_7350_Config (CardNumber:Word; DIPortWidth:Word; DIMode:Word; DIWaitStatus:Word; DIClkConfig:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_7350_ExportSampCLKConfig (CardNumber:Word; CLK_Src:Word; CLK_DPAMode:Word; CLK_DPAVlaue:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_7350_ExtSampCLKConfig (CardNumber:Word; CLK_Src:Word; CLK_DDAMode:Word; CLK_DPAMode:Word; CLK_DDAVlaue:Word; CLK_DPAVlaue:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_7350_SoftTriggerGen (CardNumber:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_7350_TrigHSConfig (CardNumber:Word; TrigConfig:Word; DI_IPOL:Word; DI_REQSrc:Word; DI_ACKSrc:Word; DI_TRIGSrc:Word; StartTrigSrc:Word; PauseTrigSrc:Word; SoftTrigOutSrc:Word; SoftTrigOutLength:Cardinal; TrigCount:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_7350_BurstHandShakeDelay (CardNumber:Word; Delay:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
(*---------------------------------------------------------------------------*)
function DO_7200_Config (CardNumber:Word; TrigSource:Word; OutReqEn:Word; OutTrigSig:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_7300A_Config (CardNumber:Word; PortWidth:Word; TrigSource:Word; WaitStatus:Word; Terminator:Word; O_REQ_Pol:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_7300B_Config (CardNumber:Word; PortWidth:Word; TrigSource:Word; WaitStatus:Word; Terminator:Word; O_Cntrl_Pol:Word; FifoThreshold:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_7300B_SetDODisableMode (CardNumber:Word; Mode:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_9222_Config (CardNumber:Word; ConfigCtrl:Word; TrigCtrl:Word; ReTrgCnt:Cardinal; DLY1Cnt:Cardinal; DLY2Cnt:Cardinal; AutoResetBuf:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_9223_Config (CardNumber:Word; ConfigCtrl:Word; TrigCtrl:Word; ReTrgCnt:Cardinal; DLY1Cnt:Cardinal; DLY2Cnt:Cardinal; AutoResetBuf:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_InitialMemoryAllocated (CardNumber:Word; var MemSize:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_WriteLine (CardNumber:Word; Port:Word; Line:Word; Value:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_WritePort (CardNumber:Word; Port:Word; Value:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_SimuWritePort (CardNumber:Word; NumChans:Word; var dwBuffer:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_ReadLine (CardNumber:Word; Port:Word; Line:Word; var Value:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_ReadPort (CardNumber:Word; Port:Word; var Value:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_ContWritePort (CardNumber:Word; Port:Word; var Buffer:Cardinal; WriteCount:Cardinal; Iterations:Word; SampleRate:Double; SyncMode:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_PGStart (CardNumber:Word; var Buffer:Cardinal; WriteCount:Cardinal; SampleRate:Double):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_PGStop (CardNumber:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_ContStatus (CardNumber:Word; var Status:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_AsyncCheck (CardNumber:Word; var Stopped:Byte; var AccessCnt:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_AsyncClear (CardNumber:Word; var AccessCnt:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function EDO_9111_Config (CardNumber:Word; EDO_Fun:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_WriteExtTrigLine (CardNumber:Word; Value:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_ContMultiBufferSetup (CardNumber:Word; var Buffer:Cardinal; WriteCount:Cardinal; var BufferId:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_ContMultiBufferStart (CardNumber:Word; Port:Word; SampleRate:Double):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_AsyncMultiBufferNextReady (CardNumber:Word; var NextReady:Byte; var BufferId:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_EventCallBack (CardNumber:Word; mode:Smallint; EventType:Smallint; callbackAddr:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_SetTimeOut (CardNumber:Word; TimeOut:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_ContBufferSetup (CardNumber:Word; var Buffer:Cardinal; WriteCount:Cardinal; var BufferId:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_ContBufferReset (CardNumber:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_7350_Config (CardNumber:Word; DOPortWidth:Word; DOMode:Word; DOWaitStatus:Word; DOClkConfig:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_7350_TrigHSConfig (CardNumber:Word; TrigConfig:Word; DO_IPOL:Word; DO_REQSrc:Word; DO_ACKSrc:Word; DO_TRIGSrc:Word; StartTrigSrc:Word; PauseTrigSrc:Word; SoftTrigOutSrc:Word; SoftTrigOutLength:Cardinal; TrigCount:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_7350_ExtSampCLKConfig (CardNumber:Word; CLK_Src:Word; CLK_DDAMode:Word; CLK_DPAMode:Word; CLK_DDAVlaue:Word; CLK_DPAVlaue:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_7350_ExportSampCLKConfig (CardNumber:Word; CLK_Src:Word; CLK_DPAMode:Word; CLK_DPAVlaue:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_7350_SoftTriggerGen (CardNumber:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_ContWritePortEx (CardNumber:Word; Port:Word; var Buffer:Cardinal; WriteCount:Cardinal; Iterations:Word; SampleRate:Double; SyncMode:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_7350_BurstHandShakeDelay (CardNumber:Word; Delay:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
(*---------------------------------------------------------------------------*)
function DIO_PortConfig (CardNumber:Word; Port:Word; Direction:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DIO_LinesConfig (CardNumber:Word; Port:Word; Linesdirmap:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DIO_LineConfig (CardNumber:Word; Port:Word; Line:Word; Direction:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DIO_SetDualInterrupt (CardNumber:Word; Int1Mode:Smallint; Int2Mode:Smallint; var hEvent:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function DIO_SetCOSInterrupt (CardNumber:Word; Port:Word; ctlA:Word; ctlB:Word; ctlC:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DIO_GetCOSLatchData (CardNumber:Word; var CosLData:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DIO_SetCOSInterrupt32(CardNumber:Word; Port:Byte; ctl:Cardinal; var hEvent:Cardinal; ManualReset:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function DIO_GetCOSLatchData32 (CardNumber:Word; Port:Byte; var CosLData:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function DIO_GetCOSLatchDataInt32 (CardNumber:Word; Port:Byte; var CosLData:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function DIO_INT1_EventMessage (CardNumber:Word; Int1Mode:Smallint; windowHandle:Cardinal; message:Cardinal; callbackAddr:TCallbackFunc):Smallint;stdcall; external 'Pci-Dask.dll';
function DIO_INT2_EventMessage (CardNumber:Word; Int2Mode:Smallint; windowHandle:Cardinal; message:Cardinal; callbackAddr:TCallbackFunc):Smallint;stdcall; external 'Pci-Dask.dll';
function DIO_INT_EventMessage (CardNumber:Word; mode:Smallint; evt:Cardinal; windowHandle:Cardinal; message:Cardinal; callbackAddr:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function DIO_7300SetInterrupt (CardNumber:Word; AuxDIEn:Smallint; T2En:Smallint; var hEvent:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function DIO_AUXDI_EventMessage (CardNumber:Word; AuxDIEn:Smallint; windowHandle:Cardinal; message:Cardinal; callbackAddr:TCallbackFunc):Smallint;stdcall; external 'Pci-Dask.dll';
function DIO_T2_EventMessage (CardNumber:Word; T2En:Smallint; windowHandle:Cardinal; message:Cardinal; callbackAddr:TCallbackFunc):Smallint;stdcall; external 'Pci-Dask.dll';
function DIO_COSInterruptCounter (CardNumber:Word; Counter_Num:Word; Counter_Mode:Word; DI_Port:Word; DI_Line:Word; var Counter_Value:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function DIO_VoltLevelConfig (CardNumber:Word; PortType:Word; VoltLevel:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DIO_7350_AFIConfig (CardNumber:Word; AFI_Port:Word; AFI_Enable:Word; AFI_Mode:Word; AFI_TrigOutLen:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function DIO_PMConfig (CardNumber:Word; Channel:Word; PM_ChnEn:Word; PM_ChnType:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function DIO_PMControl (CardNumber:Word; Port:Word; PM_Enable:Word; var hEvent:Cardinal; ManualReset:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function DIO_SetPMInterrupt32 (CardNumber:Word; Port:Word; Ctrl:Cardinal; Pattern1:Cardinal; Pattern2:Cardinal; var hEvent:Cardinal; ManualReset:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function DIO_GetPMLatchData32 (CardNumber:Word; Port:Word; var PMLData:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
(*---------------------------------------------------------------------------*)
function CTR_Setup (CardNumber:Word; Ctr:Word; Mode:Word; Count:Cardinal; BinBcd:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function CTR_Setup_All (CardNumber:Word; CtrCnt:Word; var Ctr:Word; var Mode:Word; var Count:Cardinal; var BinBcd:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function CTR_Clear (CardNumber:Word; Ctr:Word; State:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function CTR_Read (CardNumber:Word; Ctr:Word; var Value:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function CTR_Read_All (CardNumber:Word; CtrCnt:Word; var Ctr:Word; var Value:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function CTR_Status (CardNumber:Word; Ctr:Word; var Value:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function CTR_Update (CardNumber:Word; Ctr:Word; Count:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function CTR_8554_ClkSrc_Config (CardNumber:Word; Ctr:Word; ClockSource:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function CTR_8554_CK1_Config (CardNumber:Word; ClockSource:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function CTR_8554_Debounce_Config (CardNumber:Word; DebounceClock:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function GCTR_Setup (CardNumber:Word; GCtr:Word; GCtrCtrl:Word; Count:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function GCTR_Clear (CardNumber:Word; GCtr:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function GCTR_Read (CardNumber:Word; GCtr:Word; var Value:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function GPTC_Clear (CardNumber:Word; GCtr:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function GPTC_Control (CardNumber:Word; GCtr:Word; ParamID:Word; Value:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function GPTC_Read (CardNumber:Word; GCtr:Word; var Value:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function GPTC_Setup (CardNumber:Word; GCtr:Word; Mode:Word; SrcCtrl:Word; PolCtrl:Word; LReg1_Val:Cardinal; LReg2_Val:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function GPTC_Status (CardNumber:Word; GCtr:Word; var Value:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function GPTC_EventCallBack (CardNumber:Word; Enabled:Smallint; EventType:Smallint; callbackAddr:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function GPTC_EventSetup (CardNumber:Word; GCtr:Word; Mode:Word; Ctrl:Word; LVal_1:Cardinal; LVal_2:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function GPTC_9524_PG_Config (CardNumber:Word; GCtr:Word; PulseGenNum:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function GPTC_9524_GetTimerEvent (CardNumber:Word; GCtr:Word; var hEvent:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function WDT_Setup (CardNumber:Word; Ctr:Word; ovflowSec:Single; var actualSec:Single; var hEvent:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function WDT_Control (CardNumber:Word; Ctr:Word; action:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function WDT_Status (CardNumber:Word; Ctr:Word; var Value:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function WDT_Reload (CardNumber:Word; ovflowSec:Single; var actualSec:Single):Smallint;stdcall; external 'Pci-Dask.dll';
(*---------------------------------------------------------------------------*)
function AI_GetView (CardNumber:word; View:Pointer):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_GetView (CardNumber:word; View:Pointer):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_GetView (CardNumber:word; View:Pointer):Smallint;stdcall; external 'Pci-Dask.dll';
function AI_GetEvent (CardNumber:Word; var hEvent:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function AO_GetEvent (CardNumber:Word; var hEvent:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function DI_GetEvent (CardNumber:Word; var hEvent:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function DO_GetEvent (CardNumber:Word; var hEvent:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
(*------------------------------------------------------------------------------*)
function PCI_DB_Auto_Calibration_ALL (CardNumber:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function PCI_Load_CAL_Data (CardNumber:Word; bank:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function PCI_EEPROM_CAL_Constant_Update (CardNumber:Word; bank:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function PCI9524_Acquire_AD_CalConst (CardNumber:Word; Group:Word; ADC_Range:Word; ADC_Speed:Word; var CalDate:Cardinal; var CalTemp:Single; var ADC_offset:Cardinal; var ADC_gain:Cardinal; var Residual_offset:Double; var Residual_scaling:Double):Smallint;stdcall; external 'Pci-Dask.dll';
function PCI9524_Acquire_DA_CalConst (CardNumber:Word; Channel:Word; var CalDate:Cardinal; var CalTemp:Single; var DAC_offset:Byte; var DAC_linearity:Byte; var Gain_factor:Single):Smallint;stdcall; external 'Pci-Dask.dll';
function PCI9524_Read_EEProm (CardNumber:Word; ReadAddr:Word; var ReadData:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function PCI9524_Read_RemoteSPI (CardNumber:Word; Addr:Word; var RdData:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function PCI9524_Write_EEProm (CardNumber:Word; WriteAddr:Word; var WriteData:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
function PCI9524_Write_RemoteSPI (CardNumber:Word; Addr:Word; WrtData:Byte):Smallint;stdcall; external 'Pci-Dask.dll';
(*------------------------------------------------------------------------------*)
function SSI_SourceConn (CardNumber:Word; sigCode:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function SSI_SourceDisConn (CardNumber:Word; sigCode:Word):Smallint;stdcall; external 'Pci-Dask.dll';
function SSI_SourceClear (CardNumber:Word):Smallint;stdcall; external 'Pci-Dask.dll';
(*-----------------------------------------------------------------------------*)
function PWM_Output (CardNumber:Word; Channel:Word; high_interval:Cardinal; low_interval:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function PWM_Stop (CardNumber:Word; Channel:Word):Smallint;stdcall; external 'Pci-Dask.dll';
(*-----------------------------------------------------------------------------*)
function I2C_Setup (CardNumber:Word; I2C_Port:Word; I2C_Config:Word; I2C_SetupValue1:Cardinal; I2C_SetupValue2:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function I2C_Control (CardNumber:Word; I2C_Port:Word; I2C_CtrlParam:Word; I2C_CtrlValue:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function I2C_Status (CardNumber:Word; I2C_Port:Word; var I2C_Status:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function I2C_Read (CardNumber:Word; I2C_Port:Word; I2C_SlaveAddr:Word; I2C_CmdAddrBytes:Word; I2C_DataBytes:Word; I2C_CmdAddr:Cardinal; var I2C_Data:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function I2C_Write (CardNumber:Word; I2C_Port:Word; I2C_SlaveAddr:Word; I2C_CmdAddrBytes:Word; I2C_DataBytes:Word; I2C_CmdAddr:Cardinal; I2C_Data:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
(*-----------------------------------------------------------------------------*)
function SPI_Setup (CardNumber:Word; SPI_Port:Word; SPI_Config:Word; SPI_SetupValue1:Cardinal; SPI_SetupValue2:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function SPI_Control (CardNumber:Word; SPI_Port:Word; SPI_CtrlParam:Word; SPI_CtrlValue:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function SPI_Status (CardNumber:Word; SPI_Port:Word; var SPI_Status:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function SPI_Read (CardNumber:Word; SPI_Port:Word; SPI_SlaveAddr:Word; SPI_CmdAddrBits:Word; SPI_DataBits:Word; SPI_FrontDummyBits:Word; SPI_CmdAddr:Cardinal; var SPI_Data:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
function SPI_Write (CardNumber:Word; SPI_Port:Word; SPI_SlaveAddr:Word; SPI_CmdAddrBits:Word; SPI_DataBits:Word; SPI_FrontDummyBits:Word; SPI_TailDummyBits:Word; SPI_CmdAddr:Cardinal; SPI_Data:Cardinal):Smallint;stdcall; external 'Pci-Dask.dll';
(*-----------------------------------------------------------------------------*)


implementation

{function Register_Card:Smallint; external 'Pci-Dask.dll';
function Release_Card:SmallInt ; external 'Pci-Dask.dll';
function GetActualRate:SmallInt ; external 'Pci-Dask.dll';
function GetActualRate_9524:SmallInt ; external 'Pci-Dask.dll';
function GetCardType:SmallInt ; external 'Pci-Dask.dll';
function GetBaseAddr:SmallInt ; external 'Pci-Dask.dll';
function GetLCRAddr:SmallInt ; external 'Pci-Dask.dll';
function GetCardIndexFromID:SmallInt ; external 'Pci-Dask.dll';
function EMGShutDownControl:SmallInt ; external 'Pci-Dask.dll';
function EMGShutDownStatus:SmallInt ; external 'Pci-Dask.dll';
function HotResetHoldControl:SmallInt ; external 'Pci-Dask.dll';
function HotResetHoldStatus:SmallInt ; external 'Pci-Dask.dll';
function SetInitPattern:SmallInt ; external 'Pci-Dask.dll';
function GetInitPattern:SmallInt ; external 'Pci-Dask.dll';
function IdentifyLED_Control:SmallInt ; external 'Pci-Dask.dll';
(*---------------------------------------------------------------------------*)
function AI_9111_Config:SmallInt ; external 'Pci-Dask.dll';
function AI_9112_Config:SmallInt ; external 'Pci-Dask.dll';
function AI_9113_Config:SmallInt ; external 'Pci-Dask.dll';
function AI_9114_Config:SmallInt ; external 'Pci-Dask.dll';
function AI_9114_PreTrigConfig:SmallInt ; external 'Pci-Dask.dll';
function AI_9116_Config:SmallInt ; external 'Pci-Dask.dll';
function AI_9118_Config:SmallInt ; external 'Pci-Dask.dll';
function AI_9221_Config:SmallInt ; external 'Pci-Dask.dll';
function AI_9812_Config:SmallInt ; external 'Pci-Dask.dll';
function AI_9812_SetDiv:SmallInt ; external 'Pci-Dask.dll';
function AI_9116_CounterInterval:SmallInt ; external 'Pci-Dask.dll';
function AI_9221_CounterInterval:SmallInt ; external 'Pci-Dask.dll';
function AI_9524_Config:SmallInt ; external 'Pci-Dask.dll';
function AI_9524_PollConfig:SmallInt ; external 'Pci-Dask.dll';
function AI_9524_SetDSP:SmallInt ; external 'Pci-Dask.dll';
function AI_9524_GetEOCEvent:SmallInt ; external 'Pci-Dask.dll';
function AI_9222_Config:SmallInt ; external 'Pci-Dask.dll';
function AI_9222_CounterInterval:SmallInt ; external 'Pci-Dask.dll';
function AI_9223_Config:SmallInt ; external 'Pci-Dask.dll';
function AI_9223_CounterInterval:SmallInt ; external 'Pci-Dask.dll';
function AI_922A_Config:SmallInt ; external 'Pci-Dask.dll';
function AI_922A_CounterInterval:SmallInt ; external 'Pci-Dask.dll';
function AI_AsyncReTrigNextReady:SmallInt ; external 'Pci-Dask.dll';
function AI_InitialMemoryAllocated:SmallInt ; external 'Pci-Dask.dll';
function AI_ReadChannel:SmallInt ; external 'Pci-Dask.dll';
function AI_ReadChannel32:SmallInt ; external 'Pci-Dask.dll';
function AI_VReadChannel:SmallInt ; external 'Pci-Dask.dll';
function AI_ScanReadChannels:SmallInt ; external 'Pci-Dask.dll';
function AI_ScanReadChannels32:SmallInt ; external 'Pci-Dask.dll';
function AI_ReadMultiChannels:SmallInt ; external 'Pci-Dask.dll';
function AI_VoltScale:SmallInt ; external 'Pci-Dask.dll';
function AI_VoltScale32:SmallInt ; external 'Pci-Dask.dll';
function AI_ContReadChannel:SmallInt ; external 'Pci-Dask.dll';
function AI_ContReadMultiChannels:SmallInt ; external 'Pci-Dask.dll';
function AI_ContScanChannels:SmallInt ; external 'Pci-Dask.dll';
function AI_ContReadChannelToFile:SmallInt ; external 'Pci-Dask.dll';
function AI_ContReadMultiChannelsToFile:SmallInt ; external 'Pci-Dask.dll';
function AI_ContScanChannelsToFile:SmallInt ; external 'Pci-Dask.dll';
function AI_ContVScale:SmallInt ; external 'Pci-Dask.dll';
function AI_ContStatus:SmallInt ; external 'Pci-Dask.dll';
function AI_AsyncCheck:SmallInt ; external 'Pci-Dask.dll';
function AI_AsyncClear:SmallInt ; external 'Pci-Dask.dll';
function AI_AsyncDblBufferHalfReady:SmallInt ; external 'Pci-Dask.dll';
function AI_AsyncDblBufferMode:SmallInt ; external 'Pci-Dask.dll';
function AI_AsyncDblBufferTransfer:SmallInt ; external 'Pci-Dask.dll';
function AI_AsyncDblBufferOverrun:SmallInt ; external 'Pci-Dask.dll';
function AI_AsyncDblBufferHandled:SmallInt ; external 'Pci-Dask.dll';
function AI_AsyncDblBufferToFile:SmallInt ; external 'Pci-Dask.dll';
function AI_EventCallBack:SmallInt ; external 'Pci-Dask.dll';
function AI_SetTimeOut:SmallInt ; external 'Pci-Dask.dll';
function AI_ContBufferSetup:SmallInt ; external 'Pci-Dask.dll';
function AI_ContBufferReset:SmallInt ; external 'Pci-Dask.dll';
(*---------------------------------------------------------------------------*)
function AO_6202_Config:SmallInt ; external 'Pci-Dask.dll';
function AO_6208A_Config:SmallInt ; external 'Pci-Dask.dll';
function AO_6308A_Config:SmallInt ; external 'Pci-Dask.dll';
function AO_6308V_Config:SmallInt ; external 'Pci-Dask.dll';
function AO_9111_Config:SmallInt ; external 'Pci-Dask.dll';
function AO_9112_Config:SmallInt ; external 'Pci-Dask.dll';
function AO_9222_Config:SmallInt ; external 'Pci-Dask.dll';
function AO_9223_Config:SmallInt ; external 'Pci-Dask.dll';
function AO_InitialMemoryAllocated:SmallInt ; external 'Pci-Dask.dll';
function AO_AsyncCheck:SmallInt ; external 'Pci-Dask.dll';
function AO_AsyncClear:SmallInt ; external 'Pci-Dask.dll';
function AO_AsyncDblBufferHalfReady:SmallInt ; external 'Pci-Dask.dll';
function AO_AsyncDblBufferMode:SmallInt ; external 'Pci-Dask.dll';
function AO_ContBufferCompose:SmallInt ; external 'Pci-Dask.dll';
function AO_ContBufferReset:SmallInt ; external 'Pci-Dask.dll';
function AO_ContBufferSetup:SmallInt ; external 'Pci-Dask.dll';
function AO_ContStatus:SmallInt ; external 'Pci-Dask.dll';
function AO_ContWriteChannel:SmallInt ; external 'Pci-Dask.dll';
function AO_ContWriteMultiChannels:SmallInt ; external 'Pci-Dask.dll';
function AO_EventCallBack:SmallInt ; external 'Pci-Dask.dll';
function AO_SetTimeOut:SmallInt ; external 'Pci-Dask.dll';
function AO_WriteChannel:SmallInt ; external 'Pci-Dask.dll';
function AO_VWriteChannel:SmallInt ; external 'Pci-Dask.dll';
function AO_VoltScale:SmallInt ; external 'Pci-Dask.dll';
function AO_SimuWriteChannel:SmallInt ; external 'Pci-Dask.dll';
function AO_SimuVWriteChannel:SmallInt ; external 'Pci-Dask.dll';
(*---------------------------------------------------------------------------*)
function DI_7200_Config:SmallInt ; external 'Pci-Dask.dll';
function DI_7233_ForceLogic:SmallInt ; external 'Pci-Dask.dll';
function DI_7300A_Config:SmallInt ; external 'Pci-Dask.dll';
function DI_7300B_Config:SmallInt ; external 'Pci-Dask.dll';
function DI_InitialMemoryAllocated:SmallInt ; external 'Pci-Dask.dll';
function DI_ReadLine:SmallInt ; external 'Pci-Dask.dll';
function DI_ReadPort:SmallInt ; external 'Pci-Dask.dll';
function DI_ContReadPort:SmallInt ; external 'Pci-Dask.dll';
function DI_ContReadPortToFile:SmallInt ; external 'Pci-Dask.dll';
function DI_ContStatus:SmallInt ; external 'Pci-Dask.dll';
function DI_AsyncCheck:SmallInt ; external 'Pci-Dask.dll';
function DI_AsyncClear:SmallInt ; external 'Pci-Dask.dll';
function DI_AsyncDblBufferHalfReady:SmallInt ; external 'Pci-Dask.dll';
function DI_AsyncDblBufferMode:SmallInt ; external 'Pci-Dask.dll';
function DI_AsyncDblBufferTransfer:SmallInt ; external 'Pci-Dask.dll';
function DI_ContMultiBufferSetup:SmallInt ; external 'Pci-Dask.dll';
function DI_ContMultiBufferStart:SmallInt ; external 'Pci-Dask.dll';
function DI_AsyncMultiBufferNextReady:SmallInt ; external 'Pci-Dask.dll';
function DI_AsyncDblBufferOverrun:SmallInt ; external 'Pci-Dask.dll';
function DI_EventCallBack:SmallInt ; external 'Pci-Dask.dll';
function DI_9222_Config:SmallInt ; external 'Pci-Dask.dll';
function DI_9223_Config:SmallInt ; external 'Pci-Dask.dll';
function DI_AsyncDblBufferHandled:SmallInt ; external 'Pci-Dask.dll';
function DI_AsyncDblBufferToFile:SmallInt ; external 'Pci-Dask.dll';
function DI_SetTimeOut:SmallInt ; external 'Pci-Dask.dll';
function DI_ContBufferSetup:SmallInt ; external 'Pci-Dask.dll';
function DI_ContBufferReset:SmallInt ; external 'Pci-Dask.dll';
function DI_AsyncReTrigNextReady:SmallInt ; external 'Pci-Dask.dll';
function DI_7350_Config:SmallInt ; external 'Pci-Dask.dll';
function DI_7350_TrigHSConfig:SmallInt ; external 'Pci-Dask.dll';
function DI_7350_ExtSampCLKConfig:SmallInt ; external 'Pci-Dask.dll';
function DI_7350_ExportSampCLKConfig:SmallInt ; external 'Pci-Dask.dll';
function DI_7350_SoftTriggerGen:SmallInt ; external 'Pci-Dask.dll';
function DI_7350_BurstHandShakeDelay:SmallInt ; external 'Pci-Dask.dll';
(*---------------------------------------------------------------------------*)
function DO_7200_Config:SmallInt ; external 'Pci-Dask.dll';
function DO_7300A_Config:SmallInt ; external 'Pci-Dask.dll';
function DO_7300B_Config:SmallInt ; external 'Pci-Dask.dll';
function DO_7300B_SetDODisableMode:SmallInt ; external 'Pci-Dask.dll';
function DO_InitialMemoryAllocated:SmallInt ; external 'Pci-Dask.dll';
function DO_WriteLine:SmallInt ; external 'Pci-Dask.dll';
function DO_WritePort:SmallInt ; external 'Pci-Dask.dll';
function DO_SimuWritePort:SmallInt ; external 'Pci-Dask.dll';
function DO_ReadLine:SmallInt ; external 'Pci-Dask.dll';
function DO_ReadPort:SmallInt ; external 'Pci-Dask.dll';
function DO_ContWritePort:SmallInt ; external 'Pci-Dask.dll';
function DO_PGStart:SmallInt ; external 'Pci-Dask.dll';
function DO_PGStop:SmallInt ; external 'Pci-Dask.dll';
function DO_ContStatus:SmallInt ; external 'Pci-Dask.dll';
function DO_AsyncCheck:SmallInt ; external 'Pci-Dask.dll';
function DO_AsyncClear:SmallInt ; external 'Pci-Dask.dll';
function EDO_9111_Config:SmallInt ; external 'Pci-Dask.dll';
function DO_WriteExtTrigLine:SmallInt ; external 'Pci-Dask.dll';
function DO_ContMultiBufferSetup:SmallInt ; external 'Pci-Dask.dll';
function DO_ContMultiBufferStart:SmallInt ; external 'Pci-Dask.dll';
function DO_AsyncMultiBufferNextReady:SmallInt ; external 'Pci-Dask.dll';
function DO_EventCallBack:SmallInt ; external 'Pci-Dask.dll';
function DO_9222_Config:SmallInt ; external 'Pci-Dask.dll';
function DO_9223_Config:SmallInt ; external 'Pci-Dask.dll';
function DO_SetTimeOut:SmallInt ; external 'Pci-Dask.dll';
function DO_ContBufferSetup:SmallInt ; external 'Pci-Dask.dll';
function DO_ContBufferReset:SmallInt ; external 'Pci-Dask.dll';
function DO_7350_Config:SmallInt ; external 'Pci-Dask.dll';
function DO_7350_TrigHSConfig:SmallInt ; external 'Pci-Dask.dll';
function DO_7350_ExtSampCLKConfig:SmallInt ; external 'Pci-Dask.dll';
function DO_7350_ExportSampCLKConfig:SmallInt ; external 'Pci-Dask.dll';
function DO_7350_SoftTriggerGen:SmallInt ; external 'Pci-Dask.dll';
function DO_ContWritePortEx:SmallInt ; external 'Pci-Dask.dll';
function DO_7350_BurstHandShakeDelay:SmallInt ; external 'Pci-Dask.dll';
(*---------------------------------------------------------------------------*)
function DIO_PortConfig:SmallInt ; external 'Pci-Dask.dll';
function DIO_LinesConfig:SmallInt ; external 'Pci-Dask.dll';
function DIO_LineConfig:SmallInt ; external 'Pci-Dask.dll';
function DIO_SetDualInterrupt:SmallInt ; external 'Pci-Dask.dll';
function DIO_SetCOSInterrupt:SmallInt ; external 'Pci-Dask.dll';
function DIO_GetCOSLatchData:SmallInt ; external 'Pci-Dask.dll';
function DIO_SetCOSInterrupt32:SmallInt ; external 'Pci-Dask.dll';
function DIO_GetCOSLatchData32:SmallInt ; external 'Pci-Dask.dll';
function DIO_GetCOSLatchDataInt32:SmallInt ; external 'Pci-Dask.dll';
function DIO_INT1_EventMessage:SmallInt ; external 'Pci-Dask.dll';
function DIO_INT2_EventMessage:SmallInt ; external 'Pci-Dask.dll';
function DIO_INT_EventMessage:SmallInt ; external 'Pci-Dask.dll';
function DIO_7300SetInterrupt:SmallInt ; external 'Pci-Dask.dll';
function DIO_AUXDI_EventMessage:SmallInt ; external 'Pci-Dask.dll';
function DIO_T2_EventMessage:SmallInt ; external 'Pci-Dask.dll';
function DIO_COSInterruptCounter:SmallInt ; external 'Pci-Dask.dll';
function DIO_VoltLevelConfig:SmallInt ; external 'Pci-Dask.dll';
function DIO_7350_AFIConfig:SmallInt ; external 'Pci-Dask.dll';
function DIO_PMConfig:SmallInt ; external 'Pci-Dask.dll';
function DIO_PMControl:SmallInt ; external 'Pci-Dask.dll';
function DIO_SetPMInterrupt32:SmallInt ; external 'Pci-Dask.dll';
function DIO_GetPMLatchData32:SmallInt ; external 'Pci-Dask.dll';
(*---------------------------------------------------------------------------*)
function CTR_Setup:SmallInt ; external 'Pci-Dask.dll';
function CTR_Setup_All:SmallInt ; external 'Pci-Dask.dll';
function CTR_Clear:SmallInt ; external 'Pci-Dask.dll';
function CTR_Read:SmallInt ; external 'Pci-Dask.dll';
function CTR_Read_All:SmallInt ; external 'Pci-Dask.dll';
function CTR_Status:SmallInt ; external 'Pci-Dask.dll';
function CTR_Update:SmallInt ; external 'Pci-Dask.dll';
function CTR_8554_ClkSrc_Config:SmallInt ; external 'Pci-Dask.dll';
function CTR_8554_CK1_Config:SmallInt ; external 'Pci-Dask.dll';
function CTR_8554_Debounce_Config:SmallInt ; external 'Pci-Dask.dll';
function GCTR_Setup:SmallInt ; external 'Pci-Dask.dll';
function GCTR_Clear:SmallInt ; external 'Pci-Dask.dll';
function GCTR_Read:SmallInt ; external 'Pci-Dask.dll';
function GPTC_Clear:SmallInt ; external 'Pci-Dask.dll';
function GPTC_Control:SmallInt ; external 'Pci-Dask.dll';
function GPTC_Read:SmallInt ; external 'Pci-Dask.dll';
function GPTC_Setup:SmallInt ; external 'Pci-Dask.dll';
function GPTC_Status:SmallInt ; external 'Pci-Dask.dll';
function GPTC_EventCallBack:SmallInt ; external 'Pci-Dask.dll';
function GPTC_EventSetup:SmallInt ; external 'Pci-Dask.dll';
function GPTC_9524_PG_Config:SmallInt ; external 'Pci-Dask.dll';
function GPTC_9524_GetTimerEvent:SmallInt ; external 'Pci-Dask.dll';
function WDT_Setup:SmallInt ; external 'Pci-Dask.dll';
function WDT_Control:SmallInt ; external 'Pci-Dask.dll';
function WDT_Status:SmallInt ; external 'Pci-Dask.dll';
function WDT_Reload:SmallInt ; external 'Pci-Dask.dll';
(*---------------------------------------------------------------------------*)
function AI_GetEvent:SmallInt ; external 'Pci-Dask.dll';
function AO_GetEvent:SmallInt ; external 'Pci-Dask.dll';
function DI_GetEvent:SmallInt ; external 'Pci-Dask.dll';
function DO_GetEvent:SmallInt ; external 'Pci-Dask.dll';
(*---------------------------------------------------------------------------*)
function AI_GetView:SmallInt ; external 'Pci-Dask.dll';
function DI_GetView:SmallInt ; external 'Pci-Dask.dll';
function DO_GetView:SmallInt ; external 'Pci-Dask.dll';
(*---------------------------------------------------------------------------*)
function PCI_DB_Auto_Calibration_ALL:SmallInt ; external 'Pci-Dask.dll';
function PCI_Load_CAL_Data:SmallInt ; external 'Pci-Dask.dll';
function PCI_EEPROM_CAL_Constant_Update:SmallInt ; external 'Pci-Dask.dll';
function PCI9524_Acquire_AD_CalConst:SmallInt ; external 'Pci-Dask.dll';
function PCI9524_Acquire_DA_CalConst:SmallInt ; external 'Pci-Dask.dll';
function PCI9524_Read_EEProm:SmallInt ; external 'Pci-Dask.dll';
function PCI9524_Read_RemoteSPI:SmallInt ; external 'Pci-Dask.dll';
function PCI9524_Write_EEProm:SmallInt ; external 'Pci-Dask.dll';
function PCI9524_Write_RemoteSPI:SmallInt ; external 'Pci-Dask.dll';
(*---------------------------------------------------------------------------*)
function SSI_SourceConn:SmallInt ; external 'Pci-Dask.dll';
function SSI_SourceDisConn:SmallInt ; external 'Pci-Dask.dll';
function SSI_SourceClear:SmallInt ; external 'Pci-Dask.dll';
(*----------------------------------------------------------------------------*)
function PWM_Output:SmallInt ; external 'Pci-Dask.dll';
function PWM_Stop:SmallInt ; external 'Pci-Dask.dll';
(*----------------------------------------------------------------------------*)
function I2C_Setup:SmallInt ; external 'Pci-Dask.dll';
function I2C_Control:SmallInt ; external 'Pci-Dask.dll';
function I2C_Status:SmallInt ; external 'Pci-Dask.dll';
function I2C_Read:SmallInt ; external 'Pci-Dask.dll';
function I2C_Write:SmallInt ; external 'Pci-Dask.dll';
(*----------------------------------------------------------------------------*)
function SPI_Setup:SmallInt ; external 'Pci-Dask.dll';
function SPI_Control:SmallInt ; external 'Pci-Dask.dll';
function SPI_Status:SmallInt ; external 'Pci-Dask.dll';
function SPI_Read:SmallInt ; external 'Pci-Dask.dll';
function SPI_Write:SmallInt ; external 'Pci-Dask.dll';
(*----------------------------------------------------------------------------*)
}
end.
