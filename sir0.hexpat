/** SIR0 / SIRO (Pokemon Mystery Dungeon: Gates to Infinity, specifically)
 * 
 * see also:
 * https://projectpokemon.org/home/docs/mystery-dungeon-nds/sir0siro-format-r46/
 */

#pragma endian little

import std.mem;

struct sir0_header_t {
    u32 magic; // SIR0
    u32 content_header_addr;
    u32 pointer_offset_list_addr;
    u32 pad;
};

struct content_header_t {
    u32 entries; // idk :P
    u32 unk; // unknown purpose
};

/**
 * - s is the raw encoded byte(s). it may be a u8, u16, u24, or u32.
 *      it's here just for reference.
 * - offset is the decoded value. for nearly all intents and purposes,
 *      you probably want to use offset and not s.
 * 
 * note: this function takes care of advancing the cursor
 * according to how many bytes s occupies.
 */
struct pointer_offset_t {
    if (std::mem::read_unsigned($, 1) < 0x80) {
        u8 s;
        u32 offset = s;
    } else {
        if (std::mem::read_unsigned($+1, 1) < 0x80) {
            u16 s;
            u32 offset = ((s&0x7F00)>>1) | (s&0x7F);
        } else {
            if (std::mem::read_unsigned($+2, 1) < 0x80) {
                u24 s;
                u32 offset = ((s&0x7F0000)>>2) | ((s&0x7F00)>>1) | (s&0x7F);
            } else {
                u32 s;
                u32 offset = ((s&0x7F000000)>>3) | ((s&0x7F0000)>>2) | ((s&0x7F00)>>1) | (s&0x7F);
            }
        }
    }
};

sir0_header_t header @ 0x00;
//u32 BASE_OFF = 0;
//u32 OFFSET1 = 4;
//u32 SEC2_OFF @ 0x04;
//u32 OFFSETS_OFF @ 0x08;

// h
//std::mem::Section HEADER @ 0x0;
// h
//std::mem::Section SECTION1 @ 0x10;
// content header, or data at 0x10 if N/A
//std::mem::Section SECTION2 @ header.content_header_addr;
// Pointer Offsets List
//std::mem::Section SECTION3 @ header.pointer_offset_list_addr;

u32 sec1_cur = 0x10; // not sure
u32 sec2_cur = header.content_header_addr;
u32 sec3_cur = header.pointer_offset_list_addr;

content_header_t content_hdr @ header.content_header_addr;

$ = header.pointer_offset_list_addr;
//pointer_offset_t ptroffs[while(!std::mem::eof())] @ $;
pointer_offset_t ptr_offs[while(std::mem::read_unsigned($, 1) != 0x00)] @ $;

u32 pointers[sizeof(ptr_offs)];
u32 i = 0;
u32 currentpos = 0;
while (i < sizeof(ptr_offs)) {
    currentpos = currentpos + ptr_offs[i].offset;
    u32 ptr @ currentpos;
    pointers[i] = ptr;
    i = i + 1;
}

//u32 ptr0 @ 0x04;
//u32 ptr1 @ 0x08;
u32 ptr2 @ 0x60; // = 0x10
u32 ptr3 @ 0x6C; // = 0x12
u32 ptr4 @ 0x78; // = 0x24
u32 ptr5 @ 0x84; // = 0x26
u32 ptr6 @ 0x90; // = 0x38
u32 ptr7 @ 0x9C; // = 0x3A
u32 ptr8 @ 0xA8; // = 0x4C
u32 ptr9 @ 0xB4; // = 0x4E
//u32 ptr10 @ 0xC4; // = 0x60

char16 char16_array_at_0x10[0x01] @ 0x10;
char16 char16_array_at_0x12[0x09] @ 0x12;
char16 char16_array_at_0x24[0x01] @ 0x24;
char16 char16_array_at_0x26[0x09] @ 0x26;
char16 char16_array_at_0x38[0x01] @ 0x38;
char16 char16_array_at_0x3A[0x09] @ 0x3A;
char16 char16_array_at_0x4C[0x01] @ 0x4C;
char16 char16_array_at_0x4E[0x09] @ 0x4E;