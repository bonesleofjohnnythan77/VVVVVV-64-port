// level_script_0x108a10 -> level_script_0x269ea0 -> level_script_0x269f18 -> level_script_0x26a0ac -> level_script_0x2a6120 -> level_script_0x2abca0 -> script_exec_level_table -> ending -> ending_script_0x4ac4b0 -> ending_script_0x4ac4f4
const LevelScript ending_script_0x4ac4f4_entry[] = {
    SLEEP(/* frames */ 0x0001),
    JUMP(NULL),
};

// level_script_0x108a10 -> level_script_0x269ea0 -> level_script_0x269f18 -> level_script_0x26a0ac -> level_script_0x2a6120 -> level_script_0x2abca0 -> script_exec_level_table -> ending -> ending_script_0x4ac4b0
const LevelScript level_ending_entry[] = {
    INIT_LEVEL(),
    // LOAD_RAW(/* seg */ 0x0007, /* start */ 0x010ba810, /* end */ 0x010e1b60),
    ALLOC_LEVEL_POOL(),
    AREA(1, ending_area_1_geo_0E000050),
    END_AREA(),
    FREE_LEVEL_POOL(),
    SLEEP(/* frames */ 0x003c),
    BLACKOUT(/* active */ 0x00),
    LOAD_AREA(/* area */ 0x01),
    TRANSITION(/* transType */ 0x00, /* time */ 0x4b, /* colorR */ 0x00, /* colorG */ 0x00, /* colorB */ 0x00),
    SLEEP(/* frames */ 0x0078),
    CALL(/* arg */ 0x0000, lvl_init_or_update),
    SLEEP(/* frames */ 0x0001),
    JUMP(ending_script_0x4ac4f4_entry),
};
