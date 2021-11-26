\\1.2.2  p1
\\ (0x5000_0004)
typedef struct packed { 
	bit [31:0] obq0_0_baddr_I;		\\32'h00,  descrip: obq0_0_baddr_I (baddr) - obq0_0_fifo, permits: R/W
} obq0_0_baddr_h;

\\1.2.3  p1
\\ (0x5000_0008)
typedef struct packed { 
	bit [31:8] Reserved_0;		\\0x0,  descrip: Reserved, permits: nan
	bit [7:0] obq0_0_baddr_h;		\\32'h00,  descrip: obq0_0_baddr_h (baddr) - obq0_0_fifo, permits: R/W
} obq1_0_baddr_I;

\\1.2.4  p1
\\ (0x5000_000C)
typedef struct packed { 
	bit [31:0] obq1_0_baddr_I;		\\32'h00,  descrip: obq1_0_baddr_I (baddr) – obq1_0_fifo, permits: R/W
} obq1_0_baddr_h;

\\1.2.5  p2
\\ (0x5000_0010)
typedef struct packed { 
	bit [31:8] Reserved_0;		\\0x0,  descrip: Reserved, permits: nan
	bit [7:0] obq0_0_baddr_h;		\\8'h00,  descrip: obq0_0_baddr_h (baddr) – obq1_0_fifo, permits: R/W
} obq2_0_baddr_I;

\\1.2.6 p2
\\ (0x5000_0014)
typedef struct packed { 
	bit [31:0] obq2_0_baddr_I;		\\32'h00,  descrip: obq2_0_baddr_I (baddr) - obq2_0_fifo, permits: R/W
} obq1_0_baddr_h;

\\1.2.7 p2
\\ (0x5000_0018)
typedef struct packed { 
	bit [31:8] Reserved_0;		\\0x0,  descrip: Reserved, permits: nan
	bit [7:0] obq2_0_baddr_h;		\\8'h00,  descrip: obq2_0_baddr_h (baddr) – obq2_0_fifo, permits: R/W
} obq3_0_baddr_I;

\\1.2.8
\\ (0x5000_001C)
typedef struct packed { 
	bit [31:0] obq3_0_baddr_I;		\\32'h00,  descrip: obq3_0_baddr_I (baddr) - obq3_0_fifo, permits: R/W
} obq3_0_baddr_h;

\\1.2.9 p2
\\ (0x5000_0020)
typedef struct packed { 
	bit [31:8] Reserved_0;		\\0x0,  descrip: Reserved, permits: nan
	bit [7:0] obq3_0_baddr_h;		\\8'h00,  descrip: obq3_0_baddr_h (baddr) – obq3_0_fifo, permits: R/W
} obq4_0_baddr_I;

\\1.2.8 p3
\\ (0x5000_0024)
typedef struct packed { 
	bit [31:0] nan;		\\nan,  descrip: nan, permits: 1.2.9 obq4_0_baddr_I (0x5000_0020)
}obq4_0_baddr_h;

\\1.2.536 p3
\\ (0x5000_0DAC)
typedef struct packed { 
	bit [31:8] Reserved_0;		\\0x0,  descrip: Reserved, permits: nan
	bit [7:0] obq4_0_baddr_h;		\\8'h00,  descrip: obq4_0_baddr_h (baddr) – obq4_0_fifo, permits: R/W
} obq9_1_status;

\\1.2.536 p3
\\ (0x5000_0DAC)
typedef struct packed { 
	bit [31:24] Reserved_1;		\\0x0,  descrip: Reserved, permits: nan
	bit [23:16] obq9_1_alem_th;		\\8’h6,  descrip: obq9_1_alem_th (alem_th) – obq9_1_fifo, permits: R/W
	bit [15:8] obq9_1_alful_th;		\\8’h6,  descrip: obq9_1_alful_th (alful_th) – obq9_1_fifo, permits: R/W
	bit [7:4] Reserved_0;		\\0x0,  descrip: Reserved, permits: nan
	bit [3] obq9_1_alempty;		\\1'b0,  descrip: obq9_1_alempty (alempty), permits: RO
	bit [2] obq9_1_alfull;		\\1'b0,  descrip: obq9_1_alfull (alfull), permits: RO
	bit [1] obq9_1_empty;		\\1'b0,  descrip: obq9_1_empty (empty), permits: RO
	bit [0] obq9_1_full;		\\1'b0,  descrip: obq9_1_full (full), permits: RO
} obq9_1_status;

