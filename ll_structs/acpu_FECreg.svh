/*
 * |-----------------------------------------------------------------------|
 * |                                                                       |
 * |   Copyright Avery Design Systems, Inc. 2021.                          |
 * |     All Rights Reserved.       Licensed Software.                     |
 * |                                                                       |
 * |                                                                       |
 * | THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF AVERY DESIGN SYSTEMS   |
 * | The copyright notice above does not evidence any actual or intended   |
 * | publication of such source code.                                      |
 * |                                                                       |
 * |-----------------------------------------------------------------------|
 */

`ifndef acpu_FECreg_svh
`define acpu_FECreg_svh
// ESNVME03_CORE_RS_Alibaba.pdf, Ver. 1.4.2, Nov. 2021

// 3.3 NVMe Layer Registers, p17-35
/* ??? CLH 1218, check with Chiafu whether this capabilities is
   already defined in our nvm_sim */

// 3.3.1 Controller Capabilities 0 (0x00 + 0x80*UFID), p17
typedef struct packed {
    bit [31:24] timeout;
    bit [23:19] rsvd23_19;
    bit [18:17] ams;
    bit cqr;
    bit [15:0] mqes; 
} anvme_L_R_NICap0_s;

// 3.3.2 Controller Capabilities 1 (0x04 + 0x80*UFID), p19
typedef struct packed {
    bit [31:26] rsvd31_26;
    bit cmbs;
    bit pmrs;
    bit [23:20] mpsmax;
    bit [19:16] mpsmin;
    bit [15:14] rsvd15_14;
    bit bps;
    bit [12:5] css;
    bit nssrs;
    bit [3:0] dstrd;
} anvme_L_R_NICap1_s;

// 3.3.3 Version (0x08 + 0x080*UFID), p21
typedef struct packed {
    bit [31:16] mjr;
    bit [15:8] mnr;
    bit [7:0] ter;
} anvme_L_R_NIVersion_s;

// 3.3.4 Interrupt Mask (0x0C + 0x80*UFID), p21
typedef struct packed {
    bit [31:0] ivm;
} anvme_L_R_NIIntm_s;

// 3.3.5 Controller Configuration (0x14 + 0x80*UFID), p22
typedef struct packed {
    bit [31:24] rsvd31_24;
    bit [23:20] iocqes;
    bit [19:16] iosqes;
    bit [15:14] shn;
    bit [13:11] ams;
    bit [10:7] mps;
    bit [6:4] css;
    bit [3:1] rsvd3_1;
    bit enable;
} anvme_L_R_NICc_s;

// 3.3.6 Controller Status (0x1C + 0x80*UFID), p25
typedef struct packed {
    bit [31:6] rsvd_31_6;
    bit ps_paused;
    bit nssroevent;
    bit [3:2] shst;
    bit cfs;
    bit rdy;
} anvme_L_R_NICsts_s;

// 3.3.7 Controller Memory Buffer Location (0x38 + 0x80*UFID), p26
typedef struct packed {
    bit [31:12] ofst;
    bit [11:9] rsvd11_9;
    bit cqda;
    bit cdmmms;
    bit cdpcils;
    bit cdpmls;
    bit cqpds;
    bit cqmms;
    bit [2:0] bir;
} anvme_L_R_NICmbloc_s;

// 3.3.8 Controller Memory Buffer Size (0x3C + 0x80*UFID), p28
typedef struct packed {
    bit [31:12] buff_size;
    bit [11:8] size_units;
    bit [7:5] rsvd7_5;
    bit wds;
    bit rds;
    bit lists;
    bit cqs;
    bit sqs;
} anvme_L_R_NICmbsz_s;

// 3.3.9 Boot Partition Information (0x40 + 0x80*UFID), p30
typedef struct packed {
    bit abpid;
    bit [30:26] rsvd30_26;
    bit [25:24] brs;
    bit [23:15] rsvd23_15;
    bit [14:0] bpsz;
} anvme_L_R_NIBpinfo_s;

// 3.3.10 Boot Partition Read Select (0x44 + 0x80*UFID), p31
typedef struct packed {
    bit bpid;
    bit rsvd30;
    bit [29:10] bprof;
    bit [9:0] bprsz;
} anvme_L_R_NIBprsel_s;

// 3.3.11 Boot Partition Memory Buffer Location (0x48h + 0x80*UFID), p31
typedef struct packed {
    bit [63:12] bmbba;
    bit rsvd30; // ??? IFM 1217: Ask about this register
} anvme_L_R_NIBpmbl_s;

// 3.3.12 Controller Memory Buffer Memory Space Control (0x50 + 0x80*UFID), p32
typedef struct packed {
    bit [63:12] cba;
    bit [11:2] rsvd11_2;
    bit cmse;
    bit cr_enabled;
} anvme_L_R_NICmbmsc_s;

// 3.3.13 Controller Memory Buffer Status (0x58 + 0x80*UFID), p33
typedef struct packed {
    bit [31:1] rsvd31_1;
    bit cbai;
} anvme_L_R_NICmbsts_s;

// 3.3.14 NVMe Layer Normal Status Register (0x70 + 0x80*UFID), p34
typedef struct packed {
    bit [31:7] n_status;
    bit bprevt;
    bit nssrevt;
    bit [4:3] shn;
    bit cont_e;
    bit shnchg;
    bit cechg;
} anvme_L_R_NINvmests_s;

// 3.3.15 MapQ Head Doorbell (0x0F00 + (0x4*(2y+1))), p35
// ??? IFM 1217: This one is not complete in the spec

// 3.4 NVMe Layer Extended Registers, p36 

// 3.5 NVMe Vendor Registers, p40-69
// 3.5.1 QPB Access Control Register (0xC100), p40
typedef struct packed {
    bit [31:24] fid;
    bit pid;
    bit [22:19] rsvd22_19;
    bit we;
    bit exe;
    bit qtype;
    bit [15:9] rsvd15_9;
    bit [8:0] qid;
} anvme_L_R_NIQpbq;

// 3.5.2 QPB USQ Descriptor Table (0xC104), p41
typedef struct packed {
    bit [31:12] sqpbl;
    bit [11:4] fid;
    bit pid;
    bit ss;
    bit pc;
    bit en;
} anvme_L_R_NIQpbsqdespt0;

// 3.5.2 QPB USQ Descriptor Table (0xC104), p42
typedef struct packed {
    bit [31:0] sqpbh;
} anvme_L_R_NIQpbsqdespt1;

// 3.5.2 QPB USQ Descriptor Table (0xC104), p42
typedef struct packed {
    bit [31:27] iod_sets;
    bit ctrl1;
    bit wisqdbr;
    bit isqdbwv;
    bit [23:21] ctrl0;
    bit sqmask;
    bit [19:18] pw;
    bit empty;
    bit rsvd16;
    bit adm;
    bit [14:11] mps;
    bit [10:9] rsvd10_9;
    bit [8:0] cqid;
} anvme_L_R_NIQpbsqdespt2;

// 3.5.2 QPB USQ Descriptor Table (0xC104), p43
typedef struct packed {
    bit [31:6] sqwkhead;
    bit [15:0] sqsize;
} anvme_L_R_NIQpbsqdespt3;

// 3.5.2 QPB USQ Descriptor Table (0xC104), p43
typedef struct packed {
    bit [31:6] sqtail;
    bit [15:0] sqhead;
} anvme_L_R_NIQpbsqdespt4;

// 3.5.2 QPB USQ Descriptor Table (0xC104), p43
typedef struct packed {
    bit [31:12] rsvd31_12;
    bit [11:0] sqpbl;
} anvme_L_R_NIQpbsqdespt5;

// 3.5.3 QPB UCQ Descriptor Table (0xC144), p44
typedef struct packed {
    bit [31:12] cqpbl;
    bit [11:4] fid;
    bit pid;
    bit ie;
    bit pc;
    bit en;
} anvme_L_R_NIQpbcqdespt0;

// 3.5.3 QPB UCQ Descriptor Table (0xC144), p44
typedef struct packed {
    bit [31:0] cqpbh;
} anvme_L_R_NIQpbcqdespt1;

// 3.5.3 QPB UCQ Descriptor Table (0xC144), p45
typedef struct packed {
    bit [31:26] ctrl1;
    bit wicqdbr;
    bit icqdbwv;
    bit [23:20] ctrl0;
    bit nonept;
    bit phase;
    bit full;
    bit rsvd16;
    bit adm;
    bit [14:9] rsvd14_9;
    bit [8:0] iv;
} anvme_L_R_NIQpbcqdespt2;

// 3.5.3 QPB UCQ Descriptor Table (0xC144), p45
typedef struct packed {
    bit [31:6] cqwktal;
    bit [15:0] cqsize;
} anvme_L_R_NIQpbcqdespt3;

// 3.5.3 QPB UCQ Descriptor Table (0xC144), p46
typedef struct packed {
    bit [31:6] cqtail;
    bit [15:0] cqhead;
} anvme_L_R_NIQpbcqdespt4;

// 3.5.3 QPB UCQ Descriptor Table (0xC144), p46
typedef struct packed {
    bit [31:12] rsvd31_12;
    bit [11:0] cqpbl;
} anvme_L_R_NIQpbcqdespt5;

// 3.5.4 Function-based SQ Mask Registers (0xC16C), p46
typedef struct packed {
    bit [127:0] fmask0_3;
} anvme_L_R_sqmask_0_3;

// 3.5.4 Function-based SQ Mask Registers (0xC16C), p47
typedef struct packed {
    bit [127:0] fmask4_7;
} anvme_L_R_sqmask_4_7;

// 3.5.5 MapOPQ Access Control (0xC170), p47
typedef struct packed {
    bit [31:24] fid;
    bit [23:19] rsvd23_19;
    bit mapq_we;
    bit mapq_exe;
    bit [16:4] rsvd16_4;
    bit [3:0] mapqid;
} anmve_L_R_mapqbpq;

// 3.5.6 MapOPB Descriptor Table (0xC190), p48
typedef struct packed {
    bit [31:20] mapqvector;
    bit [19:12] fid;
    bit [11:9] rsvd11_9;
    bit phase;
    bit mapq_empty;
    bit mapq_full;
    bit mapq_idbr;
    bit mapq_idbw;
    bit rsvd3;
    bit mapq_iven;
    bit rsvd1;
    bit mapq_en;
} anmve_L_R_nimapqpbdespt0;

// 3.5.6 MapOPB Descriptor Table (0xC190), p50
typedef struct packed {
    bit [31:0] hhdqbal;
} anmve_L_R_nimapqpbdespt1;

// 3.5.6 MapOPB Descriptor Table (0xC190), p50
typedef struct packed {
    bit [31:0] hhdqbah;
} anmve_L_R_nimapqpbdespt2;

// 3.5.6 MapOPB Descriptor Table (0xC190), p50
typedef struct packed {
    bit [31:0] hbyqbal;
} anmve_L_R_nimapqpbdespt3;

// 3.5.6 MapOPB Descriptor Table (0xC190), p50
typedef struct packed {
    bit [31:0] hbyqbah;
} anmve_L_R_nimapqpbdespt4;

// 3.5.6 MapOPB Descriptor Table (0xC190), p50
typedef struct packed {
    bit [31:16] chunksize;
    bit [15:0] entrysize;
} anmve_L_R_nimapqpbdespt5;

// 3.5.6 MapOPB Descriptor Table (0xC190), p51
typedef struct packed {
    bit [31:16] mapq_wktail;
    bit [15:0] mapq_depth;
} anmve_L_R_nimapqpbdespt6;

// 3.5.6 MapOPB Descriptor Table (0xC190), p51
typedef struct packed {
    bit [31:16] mapq_tail;
    bit [15:0] mapq_head;
} anmve_L_R_nimapqpbdespt7;

// 3.5.7 Function-based NFE FW Reset Register (0xC21C), p51
typedef struct packed {
    bit [127:0] rw;
} anmve_L_R_nirst_0_3;

// 3.5.7 Function-based NFE FW Reset Register (0xC21C), p52
typedef struct packed {
    bit [127:0] rw;
} anmve_L_R_nirst_4_7;

// 3.5.8 Completion Status (0xC300 - 0xC30C), p52
typedef struct packed {
    bit [31:28] rsvd31_28;
    bit [27:19] lsqid;
    bit [18:10] usqid;
    bit [9:1] ucqid;
    bit push;
} anmve_L_R_nicplsts0;

// 3.5.8 Completion Status (0xC300 - 0xC30C), p53
typedef struct packed {
    bit [31:16] cid;
    bit rsvd15;
    bit [14:0] status;
} anmve_L_R_nicplsts1;

// 3.5.8 Completion Status (0xC300 - 0xC30C), p53
typedef struct packed {
    bit [31:0] cmdspc;
} anmve_L_R_nicplsts2;

// 3.5.8 Completion Status (0xC300 - 0xC30C), p54
typedef struct packed {
    bit [31:0] rsvd31_0;
} anmve_L_R_nicplsts3;

// 3.5.9 Interrupt Coalescing Disable Registers (0xC34C), p54
typedef struct packed {
    bit [127:0] dis_0_3;
} anmve_L_R_nicplivdis_0_3;

// 3.5.9 Interrupt Coalescing Disable Registers (0xC34C), p54
typedef struct packed {
    bit [127:0] dis_4_7;
} anmve_L_R_nicplivdis_4_7;

// 3.5.9 Interrupt Coalescing Disable Registers (0xC34C), p54
typedef struct packed {
    bit [127:0] dis_8_b;
} anmve_L_R_nicplivdis_8_b;

// 3.5.9 Interrupt Coalescing Disable Registers (0xC34C), p55
typedef struct packed {
    bit [127:0] dis_c_f;
} anmve_L_R_nicplivdis_c_f;

// 3.5.10 Interrupt Coalescing Register (0xC350), p55
typedef struct packed {
    bit [31:16] tu;
    bit [15:8] aggrtime;
    bit [7:0] aggrthr;
} anmve_L_R_nicplintc;

// 3.5.11 NVMe Layer Control Register (0xC400), p56
typedef struct packed {
    bit [31:17] rsvd31_17;
    bit admin1st;
    bit [15:11] cmdchk_option5_0;
    bit rsventry_allow_highpri;
    bit rsventry_allow_medpri;
    bit rsventry_allow_lowpri;
    bit [7:0] mdts;
} anmve_L_R_nictrl;

// 3.5.12 Error Status A (0xC408), p58
typedef struct packed {
    bit [31:13] status;
    bit wicqdbr_err;
    bit icqdbwv_err;
    bit wisqdbr_err;
    bit isqdbwv_err;
    bit m1_axir_err;
    bit m0_axir_err;
    bit m1_axiw_err;
    bit m0_axiw_err;
    bit m1_rderr;
    bit m0_rderr;
    bit s1_wderr;
    bit s0_wderr;
    bit host_w_abn_addr;
} anmve_L_R_nicta;

// 3.5.13 Error Status B (0xC40C), p60
typedef struct packed {
    bit [31:0] status;
} anmve_L_R_nictb;

// 3.5.14 Abnormal Address (0xC474), p60
typedef struct packed {
    bit [31:0] rsvd_addr;
} anmve_L_R_nierrinfo;

// 3.5.15 NL Controller Enable Change Summary (0xC500), p61
typedef struct packed {
    bit [31:0] cechg_grp;
} anmve_L_R_nicechgsum;

// 3.5.16 NL Shutdown Change Summary (0xC504), p61
typedef struct packed {
    bit [31:0] shnchg_grp;
} anmve_L_R_nishnchgsum;

// 3.5.17 NLNSSR Event Summary (0xC508), p62
typedef struct packed {
    bit [31:0] nssrevt_grp;
} anmve_L_R_ninssrevtsum;

// 3.5.18 NLBPR Event Summary (0xC50C), p63
typedef struct packed {
    bit [31:0] bprevt_grp;
} anmve_L_R_nibprevtsum;

// 3.5.19 Information Register (0xC604), p64
typedef struct packed {
    bit [31:6] rsvd31_6;
    bit cmdh_buf_empty;
    bit [4:0] cnt;
} anmve_L_R_nicqcnt;

// 3.5.20 Interrupt Coalescing Disable Registers Extend (0xC740), p64
typedef struct packed {
    bit [127:0] dis_10_13;
} anmve_L_R_nicplivdis_10_13;

// 3.5.20 Interrupt Coalescing Disable Registers Extend (0xC740), p65
typedef struct packed {
    bit [127:0] dis_14_17;
} anmve_L_R_nicplivdis_14_17;

// 3.5.20 Interrupt Coalescing Disable Registers Extend (0xC740), p65
typedef struct packed {
    bit [127:0] dis_18_1B;
} anmve_L_R_nicplivdis_18_1B;

// 3.5.20 Interrupt Coalescing Disable Registers Extend (0xC740), p65
typedef struct packed {
    bit [127:0] dis_1C_1F;
} anmve_L_R_nicplivdis_1C_1F;

// 3.5.20 Interrupt Coalescing Disable Registers Extend (0xC740), p65
typedef struct packed {
    bit [127:0] dis_20_23;
} anmve_L_R_nicplivdis_20_23;

// 3.5.20 Interrupt Coalescing Disable Registers Extend (0xC740), p66
typedef struct packed {
    bit [127:0] dis_24_27;
} anmve_L_R_nicplivdis_24_27;

// 3.5.20 Interrupt Coalescing Disable Registers Extend (0xC740), p66
typedef struct packed {
    bit [127:0] dis_28_2B;
} anmve_L_R_nicplivdis_28_2B;

// 3.5.20 Interrupt Coalescing Disable Registers Extend (0xC740), p66
typedef struct packed {
    bit [127:0] dis_2C_2F;
} anmve_L_R_nicplivdis_2C_2F;

// 3.5.20 Interrupt Coalescing Disable Registers Extend (0xC740), p67
typedef struct packed {
    bit [127:0] dis_30_33;
} anmve_L_R_nicplivdis_30_33;

// 3.5.20 Interrupt Coalescing Disable Registers Extend (0xC740), p67
typedef struct packed {
    bit [127:0] dis_34_37;
} anmve_L_R_nicplivdis_34_37;

// 3.5.20 Interrupt Coalescing Disable Registers Extend (0xC740), p67
typedef struct packed {
    bit [127:0] dis_38_3B;
} anmve_L_R_nicplivdis_38_3B;

// 3.5.20 Interrupt Coalescing Disable Registers Extend (0xC740), p67
typedef struct packed {
    bit [127:0] dis_3C_3F;
} anmve_L_R_nicplivdis_3C_3F;

//3.5.21 Command Priority and Arbitration registers (0xC800 + 0x4*UFID), p68
typedef struct packed {
    bit [31:24] high;
    bit [23:16] med;
    bit [15:8] low;
    bit [7:4] cmdbufthrsh;
    bit wrr;
    bit [2:0] arbburst;
} anmve_L_R_nicmdpri;
    
// 3.6 Universal Queue Management Registers, p69-73
// 3.6.1 Universal Queue Management Table 0 Registers (0x7000 + 0x4*UFID), p71
typedef struct packed {
    bit [31:25] rsvd31_25;
    bit [24:16] uq_num;
    bit [15:9] rsvd15_9;
    bit [8:0] uqt0_ofs;
} anvme_UQM_R_UQM0_s;

// 3.6.2 Universal Queue Management Table 1 Registers (0x7400 + 0x4*UFID), p72
typedef struct packed {
    bit [31:25] rsvd31_25;
    bit [24:16] up_num;
    bit [15:9] rsvd15_9;
    bit [8:0] uqt1_ofs;
} anvme_UQM_R_UQM1_s;

// 3.6.3 Universal Queue Table 0 Registers (0x8000 + 0x4*(UQT_OFS/2)), p73
typedef struct packed {
    bit [31:27] rsvd31_27;
    bit [26:16] uqt_ofs_1;
    bit [15:11] rsvd15_11;
    bit [10:0] uqt_ofs;
} anvme_UQM_R_UQT0_s;

// 3.6.4 Universal Queue Table 1 Registers (0xA000 + 0x4*(UQT_OFS/2)), p73
typedef struct packed {
    bit [31:27] rsvd31_27;
    bit [26:16] uqt_ofs_1;
    bit [15:11] rsvd15_11;
    bit [10:0] uqt_ofs;
} anvme_UQM_R_UQT1_s;

// 3.7 NLOG Registers, p74 
// 3.7.1 NLOG Access Register (0xD000), p74
typedef struct packed {
    bit [31:10] rsvd31_10;
    bit wen;
    bit exec;
    bit [7:0] ufid;
} anvme_NLOG_R_NlogAccess;

// 3.7.2 NVMe Write Command Count Register (0xD010), p74
typedef struct packed {
    bit [127:0] wccnt;
} anvme_NLOG_R_WCCNT;

// 3.7.3 NVMe Read Command Count Register (0xD020), p75
typedef struct packed {
    bit [127:0] rccnt;
} anvme_NLOG_R_RCCNT;

// 3.7.4 NVMe Write Data Command Count Register (0xD030), p75
typedef struct packed {
    bit [127:0] wdcnt;
} anvme_NLOG_R_WDCNT;

// 3.7.5 NVMe Read Data Command Count Register (0xD040), p76
typedef struct packed {
    bit [127:0] rdcnt;
} anvme_NLOG_R_RDCNT;

// 3.7.6 NVMe Busy Time Register (0xD50), p76
typedef struct packed {
    bit [127:0] bsycnt;
} anvme_NLOG_R_BSYCNT;
    
// 3.7.7 NVMe Internal Busy Cycle Count Register (0xD60), p77
typedef struct packed {
    bit [63:0] bcyc_cnt;
} anvme_NLOG_R_BCYC_CNT;

// 3.7.8 NVMe R/W Command Less Then 1K Register (0xD70), p77
typedef struct packed {
    bit [31:26] rsvd31_26;
    bit [25:16] rdcnt_lt1k;
    bit [15:10] rsvd15_10;
    bit [9:0] wdcn_lt1k;
} anvme_NLOG_R_RWDCNT_LT1K;

// 3.7.9 NVMe Valid IO Command Count (0xD74), p78
typedef struct packed {
    bit [31:13] rsvd31_13;
    bit [12:0] iocmdcnt; // FIXME LLI: in spec bit [9:0] iocmdcnt??
} anvme_NLOG_R_IOCMDCNT;

// 3.8 Namespace Management Registers, p79-85
// 3.8.1 NameSpace management control (0xD080), p81
typedef struct packed {
    bit [31:9] rsvd31_9; // FIXME LLI: in spec bit [31:1] RSVD??
    bit tbl_flag;
    bit [7:6] rsvd7_6;
    bit tbl1_cmdcntr_reset;
    bit tbl0_cmdcntr_reset;
    bit [3:1] rsvd3_1;
    bit ns_mng_en;
} anvme_R_NfeNsMngCtrl;

// 3.8.2 TBL0 command counter (0xD088), p82
typedef struct packed {
    bit [31:13] rsvd31_13;
    bit [12:0] tbl0_cmdcntr;
} anvme_R_NsTbl0CmdCntr;

// 3.8.3 TBL1 command counter (0xD08C), p82
typedef struct packed {
    bit [31:13] rsvd31_13;
    bit [12:0] tbl1_cmdcntr;
} anvme_R_NsTbl1CmdCntr;

// 3.8.4 Indirect Access control (0xD090), p82
typedef struct packed {
    bit [31:21] rsvd31_21;
    bit tbl;
    bit [19:18] rsvd19_18;
    bit wr;
    bit exe;
    bit [15:0] nstag_idx;
} anvme_R_NsAccess;

// 3.8.5 Indirect Access Namespace-Function bitmap (0xD0A0), p83
typedef struct packed {
    bit [127:0] fmap;    
} anvme_R_Nsfmap;

// 3.8.6 Indirect Access Namespace Tag (0xD0C0), p84
typedef struct packed {
    bit vld;
    bit mptr;
    bit mdt;
    bit wprot;
    bit lbs4k;
    bit atomic;
    bit [121:119] mdsz;
    bit [118:112] rsvd118_112;
    bit [111:110] pi1_0;
    bit pi_en;
    bit [108:107] rsvd108_107;
    bit [106:64] lbs42_0;
    bit [63:43] rsvd63_43;
    bit [42:0] flba_oofs;
} anvme_R_Nstag;

// 3.9 Write Channel Registers, p85
// 3.9.1 WCH Command Registers (0x4000 - 0x400C, 0x4014), p85
typedef struct packed {
    bit [31:16] bctbc_nlbn;
    bit push;
    bit acplen;
    bit dest;
    bit tden;
    bit bp_aes;
    bit mt_trg;
    bit bcmd;
    bit [8:0] ctag;
} anvme_R_WCQ0_s;
// R_WCQ1, p87
typedef struct packed {
    bit [31:0] daddr;
} anvme_R_WCQ1_s;


// 3.10 NFE Control and Status Registers, p91-p117
// 3.10.1 NFE Control Register 0 (0x3_0000), p91
typedef struct packed {
    bit [31:27] rsvd31_27;
    bit aoccmd_dis;
    bit datadrop_en;
    bit db_activate;
    bit dma_cmdtbl_en;
    bit lba_overlap_scan_en;
    bit cid_conflict_scan_en;
    bit rsvd20;
    bit rchfiforst;
    bit rchchkddr;
    bit ctrl_wz_detec_en;
    bit [16:8] ctagnum;
    bit ior_always_acplen;
    bit iow_always_acplen;
    bit uqm_en;
    bit uqm_tbl_sel;
    bit crcen;
    bit paren;
    bit port1en;
    bit port0en;
} anvme_NFE_R_NfeCtrl0;

// 3.10.2 NFE Control Register 1 (0x3_0004), p93
typedef struct packed {
    bit errinj_wcrc;
    bit errinj_rcrc;
    bit errinj_rch_lcrc;
    bit errinj_wch_axierr;
    bit errinj_rch_axierr;
    bit rapu_en_hcpl_sq;
    bit rapu_en_hwch_sq;
    bit rapu_en_hcrq_sq;
    bit wapu_en_hdt_cq;
    bit wapu_en_hcmd_cq;
    bit rsvd21;
    bit cmdt_axierr_en;
    bit axierr_en;
    bit prperr_en;
    bit sram_auto_ls;
    bit meminit;
    bit meminit_msix;
    bit [14:9] rsvd14_9;
    bit rev1p3_en;
    bit [7:0] rsvd7_0;
} anvme_NFE_R_NfeCtrl1;

// 3.10.3 NFE Information Register 1 (0x3_0020), p95
typedef struct packed {
    bit [31:28] pffifoavathrsh;
    bit [27:12] rsvd27_12;
    bit port1of;
    bit port0of;
    bit [9:7] rchmaxwlen;
    bit [6:4] wchmaxrlen;
    bit [3:0] rsventrynum;
} anvme_NFE_R_NfeInfo;

// 3.10.4 NFE Normal Status Summary (0x3_0024), p97
typedef struct packed {
    bit [31:28] rsvd31_28;
    bit nl_nor_bprevt;
    bit nl_nor_nssrevt;
    bit nl_nor_shnchg;
    bit nl_not_cechg;
    bit rsvd23;
    bit [22:7] cmgrfcqval_iod_sets;
    bit cmgrftdqval;
    bit cmgrfscqval;
    bit cmgrfcqval;
    bit timeout_event;
    bit nfe_nor_event;
    bit meminitdone_msix;
    bit meminitdone;
} anvme_NFE_R_NfeNsum;

// 3.10.5 NFE Normal Status Register (0x3_0028), p98
typedef struct packed {
    bit [31:9] status;
    bit dbwakeevent;
    bit schd_wcpl_busy;
    bit schd_wcpl_free;
    bit schd_rcpl_busy;
    bit schd_rcpl_free;
    bit uqmendone;
    bit pd3offevent;
    bit meminitdone_msix;
    bit meminitdone;
} anvme_NFE_R_NfeNsts;

// 3.10.6 NFE Error Status Summary(0x3_0030), p99
typedef struct packed {
    bit [31:14] rsvd31_14;
    bit nl0ctb;
    bit nl0cta;
    bit [11:4] rsvd11_4;
    bit [3:0] errdw;
} anvme_NFE_R_NfeEsum;

// 3.10.7 NFE Error HW Status DW0 (0x3_0040), p99
typedef struct packed {
    bit err_test_dw0;
    bit [30:27] rsvd30_27;
    bit wchwcs_sram_par_err_plse;
    bit pmrinfobuf_sram_err_pulse;
    bit schd_sram_err;
    bit [23:20] rsvd23_20;
    bit rch1_sram_err_b;
    bit rch1_sram_err_a;
    bit wch1_sram_err_b;
    bit wch1_sram_err_a;
    bit sglinfobuf_sram_err_pulse;
    bit tsbuf_sram_err_pulse;
    bit pnsram_err_pulse;
    bit rch_sram_err_b;
    bit rch_sram_err_a;
    bit wch_sram_err_b;
    bit wch_sram_err_a;
    bit cmgr_z1rlbnbuf_sram_err;
    bit cmgr_z0rlbnbuf_sram_err;
    bit cmgr_errlogbuf_sram_err;
    bit cmgr_pnidxbuf_sram_err;
    bit cmgr_z0infobuf_sram_err;
    bit cmgr_cmgrbuf_sram_err;
    bit cmgr_rcq_sram_err;
    bit cmgr_tdq_sram_err;
    bit cmgr_fcq_sram_err;
} anvme_NFE_R_NfeErrDw0;

// 3.10.7 NFE Error HW Status DW1 (0x3_0040), p101
typedef struct packed {
    bit err_test_dw1;
    bit rch1_fsm_err;
    bit rsvd29;
    bit dx1_rch_ac_msg_parity_err;
    bit rlrdm1_dxc_parity_err;
    bit nfeapu_parity_err;
    bit dxc_rch_ac_msg_parity_err;
    bit rlrdm_dxc_parity_err;
    bit schd_axir_fsm_err;
    bit schd_axiw_fsm_err;
    bit [21:18] rsvd21_18;
    bit rsvd17;
    bit nl0_fsm_err;
    bit [15:10] rsvd15_10;
    bit refcq_ctrl_fsm_err;
    bit tdcq_ctrl_fsm_err;
    bit rcsq_ctrl_fsm_err;
    bit cplsq_ctrl_fsm_err;
    bit dbaxi_ctrl_fsm_err;
    bit nfeapu_fsm_err;
    bit rch_fsm_err;
    bit wch_fsm_err;
    bit cmgr_fsm_err;
} anvme_NFE_R_NfeErrDw1;

// 3.10.7 NFE Error HW Status DW2 (0x3_0048), p103
typedef struct packed {
    bit err_test_dw2;
    bit [30:0] rsvd30_0;
} anvme_NFE_R_NfeErrDw2;

// 3.10.7 NFE Error HW Status DW3 (0x3_004C), p103
typedef struct packed {
    bit err_test_dw3;
    bit [30:2] rsvd30_2;
    bit err_duplicate_ctag;
    bit err_invalid_ctag;
} anvme_NFE_R_NfeErrDw3;

// 3.10.8 NFE HW Error Status Mask (0x3_0050), p103
typedef struct packed {
    bit [31:0] mask;
} anvme_NFE_R_NfeStsMask0;

// 3.10.8 NFE HW Error Status Mask1 (0x3_0054), p104
typedef struct packed {
    bit [31:0] mask;
} anvme_NFE_R_NfeStsMask1;

// 3.10.8 NFE HW Error Status Mask2 (0x3_0058), p104
typedef struct packed {
    bit [31:0] mask;
} anvme_NFE_R_NfeStsMask2;

// 3.10.8 NFE HW Error Status Mask3 (0x3_005C), p104
typedef struct packed {
    bit [31:0] mask;
} anvme_NFE_R_NfeStsMask3;

// 3.10.9 NFE Normal Summary Status Mask (0x3_0060), p105
typedef struct packed {
    bit [31:0] mask;
} anvme_NFE_R_NfeNorSMask;

// 3.10.10 NFE Error Summary Status Mask (0x3_0064), p105
typedef struct packed {
    bit [31:0] mask;
} anvme_NFE_R_NfeErrSMask;

// 3.10.11 NFE Normal Status Mask (0x3_0068), p105
typedef struct packed {
    bit [31:0] mask;
} anvme_NFE_R_NfeNorMask;

// 3.10.12 NFE Status Info (0x3_0070), p106
typedef struct packed {
    bit [31:14] rsvd31_14;
    bit no_outstanding;
    bit nfe_idle;
    bit [11:0] ctag;
} anvme_NFE_R_NfeStsInfo;

// 3.10.13 NFE Interrupt Test (0x3_0080), p106
typedef struct packed {
    bit [31:4] rsvd31_4;
    bit errinj_dw3;
    bit errinj_dw2;
    bit errinj_dw1;
    bit errinj_dw0;
} anvme_NFE_R_NfeIntrTest;

// 3.10.14 NFE ID Offest (0x3_0100), p107
typedef struct packed {
    bit [31:25] rsvd31_25;
    bit [24:16] uqid_ofs;
    bit [15:8] rsvd15_8;
    bit [7:0] rsvd7_0;
} anvme_NFE_R_NfeIDOffset;

// 3.10.15 Command Aging Feature (0x3_0114), p108
typedef struct packed {
    bit [31:18] rsvd31_18;
    bit cctbl_enable;
    bit cmd_aging_en;
    bit [15:0] cmd_aging_threshold;
} anvme_NFE_R_Nfe114H;

// 3.10.16 CCTBL Base Address (0x3_011C), p108
typedef struct packed {
    bit [31:0] cctbl_base;
} anvme_NFE_R_Nfe11CH;

// 3.10.17 Timestamp Tick Period (0x3_0120), p109
typedef struct packed {
    bit [31:19] cmd_aging_pre_threshold;
    bit [18:0] tick_cycnum;
} anvme_NFE_R_Nfe120H;

// 3.10.18 Timestamp Value (0x3_0124), p109
typedef struct packed {
    bit [31:17] rsvd31_17;
    bit [16:0] cac_timestamp;
} anvme_NFE_R_Nfe124H;

// 3.10.19 Command Aging Group Status (0x3_0128 - 0x3_0144), p110
// Address 0x3_0128
typedef struct packed {
    bit [255:0] timeout_grp_sts_set;
} anvme_NFE_R_Nfe128H;

// Address 0x3_012C
typedef struct packed {
    bit [255:0] timeout_grp_sts_set;
} anvme_NFE_R_Nfe138H;

// Address 0x3_0130
typedef struct packed {
    bit [255:0] timeout_grp_sts_set;
} anvme_NFE_R_Nfe12cH;

// Address 0x3_0134
typedef struct packed {
    bit [255:0] timeout_grp_sts_set;
} anvme_NFE_R_Nfe13cH;

// Address 0x3_0138
typedef struct packed {
    bit [255:0] timeout_grp_sts_set;
} anvme_NFE_R_Nfe130H;

// Address 0x3_013C
typedef struct packed {
    bit [255:0] timeout_grp_sts_set;
} anvme_NFE_R_Nfe140H;

// Address 0x3_0140
typedef struct packed {
    bit [255:0] timeout_grp_sts_set;
} anvme_NFE_R_Nfe134H;

// Address 0x3_0144
typedef struct packed {
    bit [255:0] timeout_grp_sts_set;
} anvme_NFE_R_Nfe144H;

// 3.10.20 Minute Cycle Count Register (0x3_01A0 - 0x3_01A4), p111
typedef struct packed {
    bit [63:0] minccnt;
} anvme_NFE_R_MinCCNT;

// 3.10.21 CMGR Report Register (0x3_01A8), p112
typedef struct packed {
    bit [31:26] rsvd31_26;
    bit [25:13] rsvd25_13;
    bit nl_valid_ctag_cnt;
} anvme_NFE_R_NfeCmgr;

// 3.10.22 SCHD Timer Setting Register (0x3_01AB), p112
typedef struct packed {
    bit [31:16] wcpl_period;
    bit [15:0] rcpl_period;
} anvme_NFE_R_NfeSchdTimer;

// 3.10.23 SCHD WCPL Control Register (0x3_01B4), p113
typedef struct packed {
    bit [31:26] rsvd31_26;
    bit [25:16] wcpl_low;
    bit [15:10] rsvd15_10;
    bit [9:0] wcpl_high;
} anvme_NFE_R_NfeSchdWcpl;

// 3.10.24 SCHD RCPL Control Register (0x3_01B8), p113
typedef struct packed {
    bit [31:26] rsvd31_26;
    bit [25:16] rcpl_low;
    bit [15:10] rsvd15_10;
    bit [9:0] rcpl_high;
} anvme_NFE_R_NfeSchdRcpl;

// 3.10.25 SCHD Setting Register (0x3_01BC), p114
typedef struct packed {
    bit [31:26] rsvd31_26;
    bit [25:16] csw_max;
    bit [15:10] rsvd15_10;
    bit [9:0] csr_max;
} anvme_NFE_R_NfeSchdCs;

// 3.10.26 SCHD Control Register (0x3_01C0), p114
typedef struct packed {
    bit [31:1] rsvd31_1;
    bit schd_en;
} anvme_NFE_R_NfeSchdCtrl;


// 3.10.27 Dif Control Register (0x3_01C4), p115
typedef struct packed {
    bit pi_location;
    bit pi_err_en;
    bit [29:16] rsvd29_16;
    bit [15:12] rsvd15_12;
    bit dix_tag_gen_en;
    bit dix_guard_gen_en;
    bit dix_tag_chk_en;
    bit dix_guard_en;
    bit rsvd7_4;
    bit dif_tag_gen_en;
    bit dif_guard_gen_en;
    bit dif_tag_chk_en;
    bit dif_guard_en;
} anvme_NFE_R_NfeT10DIFCtrl;

// 3.10.28 IOD sets Control Register (0x3_01C8), p116
typedef struct packed {
    bit [31:16] rsvd13_16;
    bit [15:0] iod_setx_en;
} anvme_NFE_R_NfeIODSetsRSVCtrl;

// 3.10.29 IOD sets Info Register (0x3_01CC,0x3_01D0), p116
typedef struct packed {
    bit [63:48] rsvd63_48;
    bit [47:0] iod_setx_cnt;
} anvme_NFE_R_NfeIODInfo;

// 3.11 NFE APU Registers, p117-128
// 3.11.1 NFE APU Read Command (0x6000 - 0x6014), p117
typedef struct packed {
    // 0x6014
    bit [31:26] mptr_src_addr_ext;
    bit [25:20] src_addr_ext;
    bit [19:16] group_id;
    bit [15:0] bctbc_ext;
    // 0x6010
    bit [31:0] mptr_src_addr;
    // 0x600C
    bit [31:0] src_addr;
    // 0x6008
    bit [31:24] lba39_32;
    bit [23:16] sec_valid;
    bit lbmd_en;
    bit channel;
    bit [13:11] mdsz;
    bit pract;
    bit [9:3] nlbn; // ??? IFM 1220: What does the gray color mean in the spec?
    bit [2:0] ctag11_9;
    // 0x6004
    bit [31:0] lba31_0;
    // 0x6000
    bit [31:16] bctbc;
    bit push;
    bit [14:6] ctag;
    bit lb_size;
    bit bcmd;
    bit rcpl;
    bit by_e2e;
    bit force_unc;
    bit bp_aes;
} anvme_R_NapuRcmd_s;

// 3.11.2 NFE APU Command Queue Status Registers (0x6020), p123
typedef struct packed {
    bit [31:9] rsvd31_9;
    bit rqfull;
    bit [7:5] rsvd7_5;
    bit [4:0] rqcnt;
} anvme_R_NapuCmdqSts_s;

// 3.11.3 NFE APU Control Registers (0x6024), p124
typedef struct packed {
    bit errinj_w_lcrc;
    bit errinj_r_axierr;
    bit [29:7] rsvd29_7; //  Reset: 0
    bit rsvd6; // Reset: 1
    bit w_errtag_en;
    bit r_axierr_en;
    bit w_lcrc_en;
    bit [2:1] rsvd2_1;
    bit wait_dis;
} anvme_R_NapuCtrl_s;

// 3.11.4 NFE APU Delay Control Registers (0x6028 - 0x602C), p125
typedef struct packed {
    bit [31:16] dly_rd_timer;
    bit [15:0] dly_wr_timer;
} anvme_R_NapuDlyCtrl0_s;

// 3.11.5 NFE APU Delay Control Registers (0x6028 - 0x602C), p126
typedef struct packed {
    bit dly_rd_en;
    bit dly_wr_en;
    bit [29:16] rsvd29_16;
    bit [15:0] dly_unit;
} anvme_R_NapuDlyCtrl1_s;

// 3.11.6 NFE APU CH0 Write Status Registers (0x6030), p126
typedef struct packed {
    bit [31:28] rsvd31_28;
    bit [27:16] w_ctag;
    bit [15:0] w_lbno;
} anvme_R_NapuWsts_s;

// 3.11.7 NFE APU CH1 Write Status Registers (0x6038), p127
typedef struct packed {
    bit [31:28] rsvd31_28;
    bit [27:16] w_ctag;
    bit [15:0] w_lbno;
} anvme_R_Napu1Wsts_s;

// 3.11.8 LBA Global Range Index number Register (0x6104), p128
typedef struct packed {
    bit [31:5] rsvd31_5;
    bit [4:0] global_idx;
} anvme_R_NapuGlbldx_s;

// 3.11.9 LBA Ranger N Start Logic Block Address Registers (0x6110+0x10*N), p128
typedef struct packed {
    bit [31:0] range_slba_l;
} anvme_R_NapuSlba0_s;

// 3.12 LBA Range N Start Logic Block Address Registers, p128-132
typedef struct packed {
    bit [31:21] rsvd31_21;
    bit [20:16] range_index;
    bit [15:11] rsvd15_11;
    bit [10: 0] range_slba_h;
}anvme_LBA_R_NapuSlba1;

// 3.12.1 LBA Range N End Logic Black Address Register (0x6118 + 0x10*N), p129
typedef struct packed {
    bit [31:0] range_elba_i;
}anvme_LBA_R_NapuElba2_s;

// 3.12.2 LBA Range N End Logic Block Address Register (0x611C+0x10*N), p129
typedef struct packed {
    bit [31:11] rsvd31_11;
    bit [10: 0] range_elbn_h;
}anvme_LBA_R_NapuElba3_s;

// 3.12.3 LBA Read Lock Register (0x6400), p130
typedef struct packed {
    bit [63:33] rsvd_63_33;
    bit glb_rlock;
    bit [31: 0] rlock;
}anvme_LBA_R_NapuRlock_s;

// 3.12.4 LBA Write Lock Register (0x6408), p130
typedef struct packed {
    bit [63:33] rsvd63_33;
    bit glb_wlock;
    bit [31: 0] wlock;
}anvme_LBA_R_NapuWlock_s;

// 3.12.5 APU Reset and Debug (0x6410), p130
typedef struct packed {
    bit apu_pause_done;
    bit apu_rst_done;
    bit [29:2] rsvd29_2;
    bit apu_pause;
    bit apu_rst;
}anvme_APU_R_NapuRst_s;

// 3.12.6 LBA AES Bypass (0x6418), p131
typedef struct packed {
    bit [63:33] rsvd63_33;
    bit glb_bypass;
    bit [31:0] bypass;
} anvme_LBA_R_NapuAESBypass_s;

// 3.13 Command Manager Registers, p133-168
// 3.13.1 Command Manager Control Status (0x1_0000-0x1_FF80), p133
typedef struct packed {
    bit [63:48] z1_rsn;
    bit [47:32] z0_rsn;
    bit z1_tail_flag; 
    bit z1_ddr_vld;
    bit z1_cal_vld;
    bit z1_paddr_vld;
    bit z0_tail_flag;
    bit z0_ddr_vld;
    bit z0_cal_vld;
    bit z0_paddr_vld;
    bit [23:8] cur_pn;
    bit lpn;
    bit pnv;
    bit [5:4] cmd_sts;
    bit [3:1] cmd_type;
    bit entry_valid;    
} anvme_CMR_R_CTSTS_s;

// 3.13.2 SQ Command Header (0x1_0008-0x1_FF88), p136
typedef struct packed {
    bit lsnr;
    bit atm;
    bit acplen;
    bit mptr;
    bit [26:24] ucqid_10_8_;
    bit mdsz_0_;
    bit lbmd;
    bit adm;
    bit [20:19] pri;
    bit [18:16] usqid_10_8_;
    bit [15:8] ucqid;
    bit [7:0] usqid;
} anvme_CMR_R_SQCH_s;

// 3.13.3 SQ Command Content (0x1_000c-0x1_FF8C), p137
// There have the same name(RSVD) in this packed.
typedef struct packed {
    bit [511:480] cdw15;
    bit [479:448] cdw14;
    bit [447:416] cdw13;
    bit [415:384] cdw12;
    bit [383:352] cdw11;
    bit [351:320] cdw10;
    bit [319:256] prp2;
    bit [255:192] prp1;
    bit [191:128] mptr;
    bit [127:64] rsvd127_64;
    bit [63:32] nsid;
    bit [31:16] cid;
    bit psdt;
    bit [14:10] rsvd14_10;
    bit [9:8] fuse;
    bit [7:0] opc;
} anvme_CMR_R_SQCMD_s;

// 3.13.4 Allocated PN Index (0x1_0040-0x1_FFC0), p138
typedef struct packed {
    bit [31:16] rsvd31_16;
    bit [15:12] pns;   
    bit [11:0] alloc_pns_idx;
} anvme_CMR_R_PNSIDX_s;

// 3.13.5 Zone 0 information (0x1_0050-0x1_FFD0), p139
typedef struct packed {
    bit [127:114] rsvd127_114;
    bit nz1;
    bit nz0;
    bit rsvd111;
    bit [110:96] z0_offset;
    bit [95:32] z0_paddr;
    bit [31:16] z0_nlb;
    bit [15:0] z0_slbo;
} anvme_CMR_R_Z0INFO_s;

// 3.13.6 Timestamp (0x1_0060-0z1_FFE0), p140
typedef struct packed {
    bit [31:19] rsvd31_19;
    bit tsvld;
    bit to;
    bit [16:0] timestamp;
} anvme_CMR_R_TIMESTAMP_s;

// 3.13.7 IOD sets information (0x1_0068-0x1_FFE8), p140
typedef struct packed {
    bit [31:5] rsvd31_5;
    bit [4:0] iodsets;
} anvme_CMR_R_IODSETINFO_s;

// 3.13.8 Command Source information (0x1_006C-0x1_FFEC), p141
typedef struct packed {
    bit rsvd31;
    bit of;
    bit pid;
    bit [28:20] lsqid_8_0_;
    bit [19:16] mps_7_0_;
    bit [15:12] rsvd15_12;
    bit [11:10] mdsz_2_1_;
    bit [9:8] rsvd9_8;
    bit [7:0] fid_7_0_;
} anvme_CMR_R_SRCINFO_s;

// 3.13.9 Error Log (0x1_0070-0x1_FFF0), p142
typedef struct packed {
    bit [31:27] rsvd31_27;
    bit [26:24] ext_err_code_2_0_;
    bit [23:8] err_slbno;
    bit [7:4] err_code;
    bit rsvd3;
    bit pt;
    bit wz;
    bit err;
} anvme_CMR_R_ERRLOG_s;

// 3.13.10 FW_CMD_Q Control (0x2_0000-0x2_000C), p143
typedef struct packed {
    bit [127:37] rsvd127_37;
    bit lbmd;
    bit pract;
    bit [34:32] mdsz;
    bit [31:19] vldcnt;
    bit rsvd18;
    bit nxv;
    bit val;
    bit [15:14] pri;
    bit [13:11] ctag_11_9_;
    bit acplcmd_rsvd10;
    bit adm;
    bit [8:0] ctag_8_0_;        
} anvme_CMR_FW_CMD_QC_R_FCQ_s;

// 3.13.11 FW_TD_Q Control (0x2_0010-0x2_001C), p144
typedef struct packed {
    bit [127:32] rsvd127_32;
    bit [31:20] vldcnt;
    bit [19:18] rsvd19_18;
    bit nxv;
    bit val;
    bit [15:13] ctag_11_9_;
    bit wz;
    bit err;
    bit acplcmd;
    bit acplen;
    bit [8:0] ctag_8_0_;
} anvme_CMR_R_FTDQ_s;

// 3.13.12 RD_CMD_Q Control (0x2_0020-0x2_002C), p145
typedef struct packed {
    bit [127:32] rsvd127_32;
    bit [31:20] avalcnt;
    bit [19:18] rsvd19_18;
    bit nxa;
    bit aval;
    bit push;
    bit rsvd14;
    bit tden;
    bit [12:10] ctag_11_9_;
    bit acplen;
    bit [8:0] ctag_8_0_;   
} anvme_CMR_R_RCQ;

// 3.13.13 CPLQ Control (0x2_0030-0x2_0034), p146
typedef struct packed {
    bit [63:32] cmd_specific;
    bit rsvd31;
    bit [30:16] status_field;
    bit push;
    bit [14:12] avalcnt;
    bit [11:0] ctag_11_0_;
} anvme_CMR_R_CPLQ_s;

// 3.13.14 Extented CTAG Bits (0x2_0038), p147
typedef struct packed {
    bit [63:35] rsvd63_35;
    bit [34:32] ctag11_9;
    bit [31: 0] cmd_specific; 
}anvme_CMR_R_EXTCTAG_s;

// 3.13.15 MAPQ_Control (0x2_0040-0x20050), p148
typedef struct packed {
    bit [159: 96] bdy_srcaddr;
    bit [ 95: 32] hd_srcaddr;
    bit [ 31: 16] rsvd31_16;
    bit push;
    bit rsvd14;
    bit [ 13:  8] avalicnt;
    bit [  7:  0] mapqid;
}anvme_CMR_R_MAPQ_s;

// 3.13.16 FW_CMD_Q_IODSET1 Control (0x2_0100-0x2_0107), p148
typedef struct packed {
    bit [63:37] rsvd63_37;
    bit lbmd;
    bit pract;
    bit [34:32] mdsz;
    bit [31:19] vldcnt;
    bit rsvd18;
    bit nxv;
    bit val;
    bit [15:14] pri;
    bit [31:11] ctag11_9;
    bit acplcmd;
    bit adm;
    bit [ 8: 0] ctag8_0;
}anvme_CMR_IODSET1_R_FCQ_s;

// 3.13.17 FW_CMD_Q_IODSET2 Control (0x2_0108-0x2_010f), p150
typedef struct packed {
    bit [63:37] rsvd63_37;
    bit lbmd;
    bit pract;
    bit [34:32] mdsz;
    bit [31:19] vldcnt;
    bit rsvd18;
    bit nxv;
    bit val;
    bit [15:14] pri;
    bit [31:11] ctag11_9;
    bit acplcmd;
    bit adm;
    bit [ 8: 0] ctag8_0;
}anvme_CMR_IODSET2_R_FCQ_s;

// 3.13.18 FW_CMD_Q_IODSET3 Control (0x2_0110-0x2_0117), p151
typedef struct packed {
    bit [63:37] rsvd63_37;
    bit lbmd;
    bit pract;
    bit [34:32] mdsz;
    bit [31:19] vldcnt;
    bit rsvd18;
    bit nxv;
    bit val;
    bit [15:14] pri;
    bit [31:11] ctag11_9;
    bit acplcmd;
    bit adm;
    bit [ 8: 0] ctag8_0;
}anvme_CMR_IODSET3_R_FCQ_s;

// 3.13.19 FW_CMD_Q_IODSET4 Control (0x2_0118-0x2_011f), p152
typedef struct packed {
    bit [63:37] rsvd63_37;
    bit lbmd;
    bit pract;
    bit [34:32] mdsz;
    bit [31:19] vldcnt;
    bit rsvd18;
    bit nxv;
    bit val;
    bit [15:14] pri;
    bit [31:11] ctag11_9;
    bit acplcmd;
    bit adm;
    bit [ 8: 0] ctag8_0;
}anvme_CMR_IODSET4_R_FCQ_s;

// 3.13.20 FW_CMD_Q_IODSET5 Control (0x2_0120-0x2_0127), p154
typedef struct packed {
    bit [63:37] rsvd63_37;
    bit lbmd;
    bit pract;
    bit [34:32] mdsz;
    bit [31:19] vldcnt;
    bit rsvd18;
    bit nxv;
    bit val;
    bit [15:14] pri;
    bit [31:11] ctag11_9;
    bit acplcmd;
    bit adm;
    bit [ 8: 0] ctag8_0;
}anvme_CMR_IODSET5_R_FCQ_s;

// 3.13.21 FW_CMD_Q_IODSET6 Control (0x2_0128-0x2_012f), p155
typedef struct packed {
    bit [63:37] rsvd63_37;
    bit lbmd;
    bit pract;
    bit [34:32] mdsz;
    bit [31:19] vldcnt;
    bit rsvd18;
    bit nxv;
    bit val;
    bit [15:14] pri;
    bit [31:11] ctag11_9;
    bit acplcmd;
    bit adm;
    bit [ 8: 0] ctag8_0;
}anvme_CMR_IODSET6_R_FCQ_s;

// 3.13.22 FW_CMD_Q_IODSET9 Control (0x2_0130-0x2_0137), p156
typedef struct packed {
    bit [63:37] rsvd63_37;
    bit lbmd;
    bit pract;
    bit [34:32] mdsz;
    bit [31:19] vldcnt;
    bit rsvd18;
    bit nxv;
    bit val;
    bit [15:14] pri;
    bit [31:11] ctag11_9;
    bit acplcmd;
    bit adm;
    bit [ 8: 0] ctag8_0;
}anvme_CMR_IODSET7_R_FCQ_s;

// 3.13.23 FW_CMD_Q_IODSET8 Control (0x2_0138-0x2_013f), p157
typedef struct packed {
    bit [63:37] rsvd63_37;
    bit lbmd;
    bit pract;
    bit [34:32] mdsz;
    bit [31:19] vldcnt;
    bit rsvd18;
    bit nxv;
    bit val;
    bit [15:14] pri;
    bit [31:11] ctag11_9;
    bit acplcmd;
    bit adm;
    bit [ 8: 0] ctag8_0;
}anvme_CMR_IODSET8_R_FCQ_s;

// 3.13.24 FW_CMD_Q_IODSET9 Control (0x2_0140-0x2_0147), p158
typedef struct packed {
    bit [63:37] rsvd63_37;
    bit lbmd;
    bit pract;
    bit [34:32] mdsz;
    bit [31:19] vldcnt;
    bit rsvd18;
    bit nxv;
    bit val;
    bit [15:14] pri;
    bit [31:11] ctag11_9;
    bit acplcmd;
    bit adm;
    bit [ 8: 0] ctag8_0;
}anvme_CMR_IODSET9_R_FCQ_s;

// 3.13.25 FW_CMD_Q_IODSET10 Control (0x2_0148-0x2_014f), p160
typedef struct packed {
    bit [63:37] rsvd63_37;
    bit lbmd;
    bit pract;
    bit [34:32] mdsz;
    bit [31:19] vldcnt;
    bit rsvd18;
    bit nxv;
    bit val;
    bit [15:14] pri;
    bit [31:11] ctag11_9;
    bit acplcmd;
    bit adm;
    bit [ 8: 0] ctag8_0;
}anvme_CMR_IODSET10_R_FCQ_s;

// 3.13.26 FW_CMD_Q_IODSET11 Control (0x2_0150-0x2_0157), p161
typedef struct packed {
    bit [63:37] rsvd63_37;
    bit lbmd;
    bit pract;
    bit [34:32] mdsz;
    bit [31:19] vldcnt;
    bit rsvd18;
    bit nxv;
    bit val;
    bit [15:14] pri;
    bit [31:11] ctag11_9;
    bit acplcmd;
    bit adm;
    bit [ 8: 0] ctag8_0;
}anvme_CMR_IODSET11_R_FCQ_s;

// 3.13.27 FW_CMD_Q_IODSET12 Control (0x2_0158-0x2_015f), p162
typedef struct packed {
    bit [63:37] rsvd63_37;
    bit lbmd;
    bit pract;
    bit [34:32] mdsz;
    bit [31:19] vldcnt;
    bit rsvd18;
    bit nxv;
    bit val;
    bit [15:14] pri;
    bit [31:11] ctag11_9;
    bit acplcmd;
    bit adm;
    bit [ 8: 0] ctag8_0;
}anvme_CMR_IODSET12_R_FCQ_s;

// 3.13.28 FW_CMD_Q_IODSET13 Control (0x2_0160-0x2_0167), p163
typedef struct packed {
    bit [63:37] rsvd63_37;
    bit lbmd;
    bit pract;
    bit [34:32] mdsz;
    bit [31:19] vldcnt;
    bit rsvd18;
    bit nxv;
    bit val;
    bit [15:14] pri;
    bit [31:11] ctag11_9;
    bit acplcmd;
    bit adm;
    bit [ 8: 0] ctag8_0;
}anvme_CMR_IODSET13_R_FCQ_s;

// 3.13.29 FW_CMD_Q_IODSET14 Control (0x2_0168-0x2_016f), p164
typedef struct packed {
    bit [63:37] rsvd63_37;
    bit lbmd;
    bit pract;
    bit [34:32] mdsz;
    bit [31:19] vldcnt;
    bit rsvd18;
    bit nxv;
    bit val;
    bit [15:14] pri;
    bit [31:11] ctag11_9;
    bit acplcmd;
    bit adm;
    bit [ 8: 0] ctag8_0;
}anvme_CMR_IODSET14_R_FCQ_s;

// 3.13.30 FW_CMD_Q_IODSET15 Control (0x2_0170 - 0x2_0177), p166
typedef struct packed {
    bit [63:37] rsvd63_37;
    bit lbmd;
    bit pract;
    bit [34:32] mdsz;
    bit [31:19] vldcnt;
    bit rsvd18;
    bit nxv;
    bit val;
    bit [15:14] pri;
    bit [31:11] ctag11_9;
    bit acplcmd;
    bit adm;
    bit [ 8: 0] ctag8_0;
}anvme_CMR_IODSET15_R_FCQ_s;

// 3.13.31 FW_CMD_Q_IODSET16 Control (0x2_0178-0x2_017F), p167
typedef struct packed {
    bit [63:37] rsvd63_37;
    bit lbmd;
    bit pract;
    bit [34:32] mdsz;
    bit [31:19] vldcnt;
    bit rsvd18;
    bit nxv;
    bit val;
    bit [15:14] pri;
    bit [31:11] ctag11_9;
    bit acplcmd;
    bit adm;
    bit [ 8: 0] ctag8_0;
}anvme_CMR_IODSET16_R_FCQ_s;
`endif
