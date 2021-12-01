\\0x5E00_0000
typedef struct packed { 
	bit [31:0] obq0_0_baddr;		\\Default: 32'h00,  descrip: obq0_0_baddr (baddr) - => obq0_0 fifo 起始基地址32位, permits: R/W
}obq0_0_baddr;

\\0x5E00_0004
typedef struct packed { 
	bit [31:16] Reserved_0;		\\Default: 0x0,  descrip: Reserved, permits: nan
	bit [15:0] obq0_0_depth;		\\Default: 16'h40,  descrip: obq0_0_depth (depth) - => obq0_0 fifo的深度, permits: R/W
}obq0_0_depth;

\\0x5E00_0008
typedef struct packed { 
	bit [31:16] Reserved_0;		\\Default: 0x0,  descrip: Reserved, permits: nan
	bit [15:0] obq0_0_tailer;		\\Default: 16'h0,  descrip: obq0_0_tailer (tailer) - => obq0_0的写指针, permits: R/W
}obq0_0_tailer;

\\0x5E00_000C
typedef struct packed { 
	bit [31:0] obq0_0_hed_addr;		\\Default: 32'h00,  descrip: obq0_0_hed_addr (addr) - => obq0_0  fifo  header指针地址32位, permits: R/W
}obq0_0_hed_addr;

\\0x5E00_0010
typedef struct packed { 
	bit [31:16] Reserved_0;		\\Default: 0x0,  descrip: Reserved, permits: nan
	bit [15:0] obq0_0_header;		\\Default: 16'h0,  descrip: obq0_0_header (header) - => obq0_0的读指针, permits: RO
}obq0_0_header;

\\0x5E00_0014
typedef struct packed { 
	bit [31:4] Reserved_0;		\\Default: 0x0,  descrip: Reserved, permits: nan
	bit [3] obq0_0_alempty;		\\Default: 1'b0,  descrip: obq0_0_alempty (alempty) - => , permits: RO
	bit [2] obq0_0_alfull;		\\Default: 1'b0,  descrip: obq0_0_alfull (alfull) - => , permits: RO
	bit [1] obq0_0_empty;		\\Default: 1'b0,  descrip: obq0_0_empty (empty) - => , permits: RO
	bit [0] obq0_0_full;		\\Default: 1'b0,  descrip: obq0_0_full (full) - => , permits: RO
}obq0_0_status;

\\0x5E00_0018
typedef struct packed { 
	bit [31:16] Reserved_0;		\\Default: 0x0,  descrip: Reserved, permits: nan
	bit [15:0] obq0_0_cnt;		\\Default: 16'h0,  descrip: obq0_0_cnt (num) - => obq0_0fifo内部还剩多少个entry没取, permits: R/W
}obq0_0_cnt;

\\0x5E00_001C
typedef struct packed { 
	bit [31:16] Reserved_0;		\\Default: 0x0,  descrip: Reserved, permits: nan
	bit [15:8] obq0_0_alem_th;		\\Default: 8'h6,  descrip: obq0_0_alem_th (alem_th) - => obq0_0 fifo 将空阈值, permits: R/W
	bit [7:0] obq0_0_alful_th;		\\Default: 8'h6,  descrip: obq0_0_alful_th (alful_th) - => obq0_0 fifo 将满阈值, permits: R/W
}obq0_0_th;

\\0x5E00_0020
typedef struct packed { 
	bit [31:0] obq0_1_baddr;		\\Default: 32'h00,  descrip: obq0_1_baddr (baddr) - => obq0_1 fifo 起始基地址32位, permits: R/W
}obq0_1_baddr;

\\0x5E00_0024
typedef struct packed { 
	bit [31:16] Reserved_0;		\\Default: 0x0,  descrip: Reserved, permits: nan
	bit [15:0] obq0_1_depth;		\\Default: 16'h40,  descrip: obq0_1_depth (depth) - => obq0_1 fifo的深度, permits: R/W
}obq0_1_depth;

\\0x5E00_0028
typedef struct packed { 
	bit [31:16] Reserved_0;		\\Default: 0x0,  descrip: Reserved, permits: nan
	bit [15:0] obq0_1_tailer;		\\Default: 16'h0,  descrip: obq0_1_tailer (tailer) - => obq0_1的写指针, permits: R/W
}obq0_1_tailer;

\\0x5E00_002C
typedef struct packed { 
	bit [31:0] obq0_1_hed_addr;		\\Default: 32'h00,  descrip: obq0_1_hed_addr (addr) - => obq0_1  fifo  header指针地址32位, permits: R/W
}obq0_1_hed_addr;

\\0x5E00_0030
typedef struct packed { 
	bit [31:16] Reserved_0;		\\Default: 0x0,  descrip: Reserved, permits: nan
	bit [15:0] obq0_1_header;		\\Default: 16'h0,  descrip: obq0_1_header (header) - => obq0_1的读指针, permits: RO
}obq0_1_header;

