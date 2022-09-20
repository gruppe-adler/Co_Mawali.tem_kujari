params ["_unit"];

private _riceSacks = "Land_FoodSacks_01_small_brown_idap_F" createVehicle [0,0,0];
_riceSacks attachTo [_unit, [0, 0, 0], "head", true];


if (random 2 > 1) then {
    private _riceSackDestroyed = createSimpleObject ["Land_FoodSack_01_dmg_brown_idap_F", [0,0,0], false];
    _riceSackDestroyed setDir (random 360);
    _riceSackDestroyed setPos (getPos _unit);
    playSound3D ["a3\animals_f_beta\sheep\data\sound\sheep_falldown1.wss", _unit];
};

{ _x disableCollisionWith _riceSacks; } forEach allplayers; // todo broadcast
_unit disableCollisionWith _riceSacks; 

_unit playMoveNow "AcinPercMrunSnonWnonDf";

_unit addEventHandler ["AnimDone", {
    params ["_unit", "_anim"];

    [{
        _this playmove "AcinPercMrunSnonWnonDf";
    }, _unit, 0.5] call CBA_fnc_waitAndExecute;
    
}];


[{
    params ["_args", "_handle"];
    _args params ["_unit", "_riceSacks"];

    if (!alive _unit) then {
    
        detach _riceSacks;
        [_unit, "", 2] call ace_common_fnc_doAnimation;
        [_handle] call CBA_fnc_removePerFrameHandler;
    };

    if (isNull _unit) then {
        deleteVehicle _riceSacks;
    };    
}, 0, [_unit, _riceSacks]] call CBA_fnc_addPerFramehandler;
