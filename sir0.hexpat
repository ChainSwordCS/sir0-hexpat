// little-endian

u32 magic @ 0x00; // SIR0
u32 BASE_OFF = 0;
u32 OFFSET = 4;
u32 DUMMY_OFF @ 0x04;
u32 OFFSETS_OFF @ 0x08;

u8 a @ OFFSETS_OFF;
u8 b @ OFFSETS_OFF+1;
u8 c @ OFFSETS_OFF+2;
u8 d @ OFFSETS_OFF+3;
u8 e @ OFFSETS_OFF+4;
u8 z @ OFFSETS_OFF+10;

char16 char16_array_at_0x0C[0x2C] @ 0x0C;
u8 u8_array_at_0x64[0x0C] @ 0x64;
u8 u8_array_at_0x70[0x0C] @ 0x70;
u8 u8_array_at_0x7C[0x0C] @ 0x7C;
u8 u8_array_at_0x88[0x0C] @ 0x88;