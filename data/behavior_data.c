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
CALL_NATIVE( bhv_checkpoint_marker),
END_LOOP(),
};