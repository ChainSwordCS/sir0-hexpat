// SIR0 / SIRO (Pokemon Mystery Dungeon: Gates to Infinity, specifically)
#pragma endian little

import std.mem;

struct DataOffset {
    //h
};

u32 magic @ 0x00; // SIR0
u32 BASE_OFF = 0;
u32 OFFSET1 = 4;
u32 SEC2_OFF @ 0x04;
u32 OFFSETS_OFF @ 0x08;

std::mem::Section HEADER @ 0x0;
std::mem::Section SECTION1 @ 0x10;
std::mem::Section SECTION2 @ SEC2_OFF;
std::mem::Section SECTION3 @ OFFSETS_OFF;

u32 sec1_cur = 0x12; // not sure
u32 sec2_cur = SEC2_OFF+8;
u32 sec3_cur = OFFSETS_OFF+2;

// move cursor
//$ = OFFSETS_OFF;
//DataOffset dataOffs[while(!std::mem::eof())];

//file_data[]




u32 s = std::mem::read_unsigned(sec3_cur, 8);
s = s & 0x7F;
/*
if (s & 0x80) {
    s = s & 0x7F;
    u32 s2 = std::mem::read_unsigned(sec3_cur+1, 8);
    s = (s << 7) + (s2 & 0x7F);
    if (s2 & 0x80) {
        s2 = std::mem::read_unsigned(sec3_cur+2, 8);
        s = (s << 7) + (s2 & 0x7F);
        if (s2 & 0x80) {
            s2 = std::mem::read_unsigned(sec3_cur+3, 8);
            s = (s << 7) + (s2 & 0x7F);
        }
    }
}
*/

char16 file_name_3[0x15] @ sec1_cur;
sec1_cur = sec1_cur + 0x15;
u128 file_data_3[s] @ sec2_cur;
sec2_cur = sec2_cur + s;




u8 a @ OFFSETS_OFF;
u8 b @ OFFSETS_OFF+1;
u8 c @ OFFSETS_OFF+2;
u8 d @ OFFSETS_OFF+3;
u8 e @ OFFSETS_OFF+4;
u8 z @ OFFSETS_OFF+10;

struct pcap_record_t {
    u32 ts_sec;         /* timestamp seconds */
    u32 ts_usec;        /* timestamp microseconds */
    u32 incl_len;       /* number of octets of packet saved in file */
    u32 orig_len;       /* actual length of packet */
    u8  data[incl_len];
};


//pcap_record_t packet[while(!std::mem::eof())];


char16 char16_array_at_0x0C[0x2C] @ 0x0C;
u8 u8_array_at_0x64[0x0C] @ 0x64;
u8 u8_array_at_0x70[0x0C] @ 0x70;
u8 u8_array_at_0x7C[0x0C] @ 0x7C;
u8 u8_array_at_0x88[0x0C] @ 0x88;