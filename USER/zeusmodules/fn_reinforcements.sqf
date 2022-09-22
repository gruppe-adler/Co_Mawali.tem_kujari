params ["_type", "_cloaked", "_origin"];


private _vehicleClassname = [_type, _cloaked] call GRAD_zeusmodules_fnc_getReinforcementVehicle;

private _vehicle = createVehicle [_vehicleClassname, _origin, [], 20, "NONE"];
private _dir = _origin getDir [worldSize/2, worldsize/2];

_vehicle setDir _dir;


private _units = [_type] call GRAD_zeusmodules_fnc_getReinforcementUnits;

private _group = createGroup east;

{
    private _unit = _group createUnit [_x, [0,0,0], [], 0, "NONE"];
    _unit moveInAny _vehicle;
    private _face = selectRandom ["AfricanHead_01", "AfricanHead_02", "AfricanHead_03", "AfricanHead_01_sick", "AfricanHead_02_sick", "AfricanHead_03_sick"];
    [_unit, _face] remoteExec ["setFace", 0, _unit];
} forEach _units;

