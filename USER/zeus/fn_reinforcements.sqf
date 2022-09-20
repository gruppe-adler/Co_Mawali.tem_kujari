params ["_type", "_cloaked", "_origin"];


private _vehicleClassname = [_type, _cloaked] call GRAD_zeusmodules_fnc_getReinforcementVehicle;

private _position = switch (_origin) do { 
    case "north" : { [2546.07,5078.17] }; 
    case "south" : { [1820.56,25.6007] };
    case "northwest" : { [21.444,4944.55] }; 
    case "southwest" : { [67.465,637.944] }; 
    default { [0,0,0] }; 
};


private _vehicle = createVehicle [_vehicleClassname, _position, [], 20, "NONE"];
private _dir = _position getDir [worldSize/2, worldsize/2];

_vehicle setDir _dir;


private _units = [_type] call GRAD_zeusmodules_fnc_getReinforcementUnits;

private _group = createGroup east;

{
    private _unit = _group createUnit [_x, [0,0,0], [], 0, "NONE"];
    _unit moveInAny _vehicle;
} forEach _units;

(driver _vehicle) addWaypoint [[worldsize/2, worldsize/2], 0];
