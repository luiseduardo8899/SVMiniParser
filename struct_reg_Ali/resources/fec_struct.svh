// 8 Data Structures p24-p29

To MEC
[39:0] new LBA in 4K
[42:40] sector number
[43] LBA size
[45:44] dest code
[50:46] group code
[56:51] reserved
[57] - error bit for this 4K block
[60:58] start sector valid of this 4KB block
[63:61] end sector valid of this 4KB block
[79:64] CTAG
[88] reserved
[89] virtual flag
[90] MPTR flag
[91] LBMD metadata enable
[94:92] MDSZ metadata size
[96:95] split_ID
[97] first LBN
[98] last LBN

[87:80] NSTAG

From MEC
[39:0] new LBA in 4K
[42:40] sector valid index of this 4K block
[45:44] source code
[50:46] group code
[79:64] CTAG
[88] force unc
[89] virtual flag
[90] MPTR flag
[91] LBMD metadata enable
[94:92] MDSZ metadata size
[96:95] split_ID
[98:97] reserved

// 8.2 MPTR Metadata Structure, p25

// 8.3 CMD Sturcture
[15:0]: CTAG
[16]: CTYPE( 0: read cmd, 1: write cmd)
[18:17]: RSV
[19]      : OVLP
 [23:20]: SPLIT_ID
[31:24]: OP_CODE
[71:32]: NEW_SLBA
[87:72]: NEW_NLB
[95:88]: NSTAG
[103:96] : SSV
[111:104] : ESV
[112] : First flag
[113] : Last Flag
[119:114] RSV 

// 8.4 PPA Structure, p25
To MEC
/* [15:0]: CTAG
[23:20]: SPLIT_ID
[31:24]: IDX
[95:32]: PPA */
typedef struct packed {	  
    bit [95:32] PPA;
    bit [31:24] IDX;
    bit [23:20] SPLIT_ID;
    bit [15:0] CTAG;
} to_MEC_PPA_s;

From MEC
[15:0]:   CTAG
[23:20]: SPLIT_ID
[31:24]: IDX
[95:32]: PPA
// 8.5 RLBN Structure, p26
[15:0]: CTAG
[16]:    FORCE_UNC
[17]:    VFLAG
[23:20]: SPLIT_ID
[71:32]: NEW_SLBA
[79:72]: SECTROR_VALID
[82:80]: MDSZ
[84]: MPTR
[85]: LBSIZE
[86]: LBMD_EN
[87]: E2E_FLAG
[95:88]: NSTAG

// 8.6 WLBN Structure, p26
[15:0]: CTAG
[31:16]: SPNLB 
// 8.7 CPU Model Queue Structure, p26
[15:0]: CTAG
[31:16]: SPNLB

// 8.8 CPU Model Queue Structure, p26

/* 3. FCQ report, p27
      From FEC to CPU.  MFR entry size is 8Bytes
      Data format: Same format as ACE_FCQ */

/* 4. TDQ report 
      From FEC to CPU.  MFR entry size is 8Bytes
      Data format: Same as ACE_TDQ */

/* 5. WCQ submission 
      From CPU to FEC.  MFR entry size is 8Bytes
      Data format: Same as ACE_WCQ */

/* 6. RCQ submission 
      From CPU to FEC.  MFR entry size is 8Bytes
      Data format: Same as ACE_RCQ */

/* 7. APURCQ submission, p28
      From CPU to FEC.  MFR entry size is 8Bytes
      Data format: Same as ACE_APURCQ */

/* 8. CPLQ submission, p29
      From CPU to FEC.  MFR entry size is 8Bytes
      Data format: Same as ACE_CPLQ */


  
