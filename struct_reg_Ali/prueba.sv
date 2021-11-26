typedef struct packed { 
	bit [97:96] Split_ID;
	bit [95] E2E_flag;
	bit [94:92] MDSZ_metadata_size;
	bit [91] LBMD_metadata_enable;
	bit [90] MPTR_flag;
	bit [89] virtual_flag;
	bit [88] force_unc;
	bit [87:80] NSTAG;
	bit [79:64] CTAG;
	bit [63:61] End_sector_valid_of_this_4KB_block;
	bit [60:58] Start_sector_valid_of_this_4KB_block;
	bit [50:46] Group_code;
	bit [45:44] dest_code;
	bit [43] LBA_size;
	bit [42:40] sector_number;
	bit [39:0] new_LBA;
} User_To_MEC ;

typedef struct packed { 
	bit [73:72] Split_ID;
	bit [71] E2E_flag;
	bit [70:68] MDSZ_metadata_size;
	bit [67] LBMD_metadata_enable;
	bit [66] MPTR_flag;
	bit [65] virtual_flag;
	bit [64] force_unc;
	bit [63:48] CTAG;
	bit [50:46] Group_code;
	bit [45:44] source_code;
	bit [39:0] new_LBA;
} User_From_MEC ;

typedef struct packed { 
	bit [95:88] NSTAG;
	bit [87:72] NEW_NLB;
	bit [71:32] NEW_SLBA;
	bit [31:24] OP_CODE;
	bit [23:20] SPLIT_ID;
	bit [19:16] CTYPE;
	bit [15:0] CTAG;
} CMD ;

typedef struct packed { 
	bit [95:32] PPA;
	bit [31:24] IDX;
	bit [23:20] SPLIT_ID;
	bit [19:16] Reserved;
	bit [15:0] CTAG;
} PPA_To_MEC ;

typedef struct packed { 
	bit [95:32] PPA;
	bit [31:24] IDX;
	bit [23:20] SPLIT_ID;
	bit [19:16] Reserved;
	bit [15:0] CTAG;
} PPA_From_MEC ;

typedef struct packed { 
	bit [95:88] NSTAG;
	bit [87] E2E_FLAG;
	bit [86] LBMD_EN;
	bit [85] LBSIZE;
	bit [84] MPTR;
	bit [83] Reserved;
	bit [82:80] MDSZ;
	bit [79:72] SECTROR_VALID;
	bit [71:32] NEW_SLBA;
	bit [31:24] Reserved;
	bit [23:20] SPLIT_ID;
	bit [19:18] Reserved;
	bit [17] VFLAG;
	bit [16] FORCE_UNC;
	bit [15:0] CTAG;
} RLBN  ;

