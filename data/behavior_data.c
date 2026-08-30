// Checkpoint (Kickable Board replacement behavior)

const BehaviorScript bhvKickableBoard[] = {  
BEGIN(OBJ_LIST_GENACTOR),
ID(id_bhvKickableBoard),  
OR_INT(oFlags,1),
SET_INT(oIntangibleTimer,0),
SET_INT(oInteractStatus,0),
SET_HITBOX(80,100),
BEGIN_LOOP(),
CALL_NATIVE( bhv_checkpoint_loop),
END_LOOP(),
};

//Active Checkpoint

const BehaviorScript bhvThiBowlingBallSpawner[] = {
BEGIN(OBJ_LIST_GENACTOR),
ID(id_bhvThiBowlingBallSpawner),
OR_INT(oFlags,1),
BEGIN_LOOP(),
CALL_NATIVE( bhv_mario_height_update),
END_LOOP(),
};

//Gravity Switch

const BehaviorScript bhvRecoveryHeart[] = {
BEGIN(OBJ_LIST_GENACTOR),
ID(id_bhvRecoveryHeart),
OR_INT(oFlags,1),
BEGIN_LOOP(),
CALL_NATIVE( bhv_checkpoint_marker),
END_LOOP(),
};

//Spike Wall

const BehaviorScript bhvAnimatesOnFloorSwitchPress[] = {
BEGIN(OBJ_LIST_SURFACE),
ID(id_bhvAnimatesOnFloorSwitchPress),
OR_INT(oFlags,65),
SET_FLOAT(oCollisionDistance,8000),
//LOAD_COLLISION_DATA(col_rr_geo_000958_0xfb03e0),
BEGIN_LOOP(),
//CALL_NATIVE( Func_Custom_0x802aa4e8),
CALL_NATIVE( load_object_collision_model),
END_LOOP(),
};