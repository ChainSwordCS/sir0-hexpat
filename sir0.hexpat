/** SIR0 / SIRO (Pokemon Mystery Dungeon: Gates to Infinity, specifically)
 * 
 * see also:
 * https://projectpokemon.org/home/docs/mystery-dungeon-nds/sir0siro-format-r46/
 * https://projectpokemon.org/home/docs/mystery-dungeon-3ds/fixed_pokemonbin-r18/
 * https://aluigi.altervista.org/bms/pokemon_farc.bms ( and https://aluigi.altervista.org/quickbms.htm )
 * https://web.archive.org/web/20220115115649/http://wiki.xentax.com/index.php/MexScript
 */

#pragma endian little

import std.io;
import std.mem;
import std.string;


struct sir0_header_t {
    u32 magic; // SIR0
    u32 content_header_addr;
    u32 pointer_offset_list_addr;
    padding[4];
};

/**
 * This struct definition is incomplete,
 * in some cases it's fine and in some cases it's wrong.
 * And I don't know how to tell when it's fine and when it's wrong.
 * So currently not relying on these values to be accurate.
 */
struct content_header_t {
    u32 entries;
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
            /*  here's an alternate way to calculate offset, which is easier to understand:
                u8 byte1 = std::mem::read_unsigned($, 1);
                u8 byte2 = std::mem::read_unsigned($+1, 1);
                u32 offset = ((byte1&0x7F)<<7) | (byte2&0x7F);
                the code below is difficult to understand because s is not the endianness we want.
            */
            u16 s;
            u32 offset = ((s&0x007F)<<7) | ((s&0x7F00)>>8);
        } else {
            if (std::mem::read_unsigned($+2, 1) < 0x80) {
                u24 s;
                // hopefully this works
                u32 offset = ((s&0x00007F)<<14) | ((s&0x007F00)>>1) | ((s&0x7F0000)>>16);
            } else {
                u32 s;
                // hopefully this works
                u32 offset = ((s&0x0000007F)<<21) | ((s&0x007F0000)>>9) | ((s&0x00007F00)<<6) | ((s&0x7F000000)>>24);
            }
        }
    }
};

fn string_auto_func() {
    u32 j = 0;
    u16 a = std::mem::read_unsigned($+(j*2), 2);
    while (a != 0x0000) {
        j = j + 1;
        a = std::mem::read_unsigned($+(j*2), 2);
    }
    return j+1;
};

struct string_auto_t {
    char16 string[string_auto_func()];
};

/**
 * doesn't work... yet(TM)
 */
fn sort_u32_array(auto arr, u32 arr_len) {
    u32 sorted_arr[arr_len];
    u32 taken_indices[arr_len];
    u32 i = 0;
    u32 j;
    u32 k;
    u32 new_value;
    u32 new_value_index;
    while (i < arr_len) {
        j = 0;
        new_value = 0xFFFFFFFF;
        new_value_index = 0xFFFFFFFF;
        while (j < arr_len) {
            k = 0;
            bool istaken = false;
            while (k < i) {
                if (j == taken_indices[k]) {
                   istaken = true;
                   k = i-1;
                }
                k = k + 1;
            }
            if (!istaken) {
                if(arr[j] <= new_value) {
                    new_value = arr[j];
                    new_value_index = j;
                }
            }
            j = j + 1;
        }
        taken_indices[i] = new_value_index;
        sorted_arr[i] = new_value;
        i = i + 1;
    }
    //return;
    return sorted_arr;
};


sir0_header_t header @ 0x00;

content_header_t content_hdr @ header.content_header_addr;

$ = header.pointer_offset_list_addr;
pointer_offset_t ptr_offs[while(std::mem::read_unsigned($, 1) != 0x00)] @ $;

u32 ii = 0;
u32 temp = 0;
try {
    while (true) {
        temp = ptr_offs[ii].offset;
        ii = ii + 1;
    }
} catch {
    
}
u32 ptr_offs_len = ii;
//std::print("ptr_offs_len=");
//std::print(ptr_offs_len);

u32 pointers[ptr_offs_len];
u32 i = 0;
u32 currentpos = 0;
while (i < ptr_offs_len) {
    currentpos = currentpos + ptr_offs[i].offset;
    u32 ptr @ currentpos;
    pointers[i] = ptr;
    i = i + 1;
}

/*
std::print("pointers=");
u32 iii = 0;
while (iii < ptr_offs_len) {
    std::print(pointers[iii]);
    iii = iii + 1;
}
*/

u32 sorted_ptrs[ptr_offs_len];
//sorted_pointers = sort_u32_array(pointers, ptr_offs_len);

// not a real loop; will only run once.
while (true) {
    u32 taken_indices[ptr_offs_len];
    u32 l = 0;
    u32 j;
    u32 k;
    u32 new_value;
    u32 new_value_index;
    while (l < ptr_offs_len) {
        j = 0;
        new_value = 0xFFFFFFFF;
        new_value_index = 0xFFFFFFFF;
        while (j < ptr_offs_len) {
            k = 0;
            bool istaken = false;
            while (k < l) {
                if (j == taken_indices[k]) {
                   istaken = true;
                   k = l-1;
                }
                k = k + 1;
            }
            if (!istaken) {
                if(pointers[j] <= new_value) {
                    new_value = pointers[j];
                    new_value_index = j;
                }
            }
            j = j + 1;
        }
        taken_indices[l] = new_value_index;
        sorted_ptrs[l] = new_value;
        l = l + 1;
    }
    break;
}


std::print("sorted_pointers=");
u32 iv = 0;
while (iv < ptr_offs_len) {
    std::print(sorted_ptrs[iv]);
    iv = iv + 1;
}


$ = 0x10;
u32 j = 0;

/**
 * Note: the size/length (in bytes) of each entry is not explicitly specified.
 * That is a fundamental shortcoming of the format. And one which makes it
 * more awkward to decode and parse for reverse-engineering.
 * 
 * This code is basically just making an educated guess at the size of each entry.
 * It assumes that, for any given entry, it ends where the next listed entry begins
 * (which seems to hold true in all examples i've seen).
 * 
 * An observed consequence of this is that the final entry's size
 * just extends to the end of the data.
 */
struct content_entry_t {
    u32 size = 0;
    if (j < ptr_offs_len-1) {
        size = sorted_ptrs[j+1] - sorted_ptrs[j];
    } else {
        size = std::mem::size() - sorted_ptrs[j];
    }
    //u32 data[size/4];
    //u8 data[size];
    char data[size];
    //char16 data[size/2];
    j = j + 1;
};

content_entry_t contents[ptr_offs_len] @ $;

/*
 *
 */