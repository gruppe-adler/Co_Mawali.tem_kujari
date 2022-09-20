params ["_truck_kamaz"];

_truck_kamaz lockCargo true;

private _sackPositions = [["Land_FoodSacks_01_large_brown_idap_F",[-0.567108,-2.86523,-0.294038],[[0.999668,-0.0257582,0],[0,0,1]]],["Land_FoodSacks_01_large_brown_idap_F",[0.560394,-2.93262,-0.282798],[[0.999668,-0.0257582,0],[0,0,1]]],["Land_FoodSacks_01_large_brown_idap_F",[0.536713,-1.52051,-0.345777],[[-0.999651,-0.0264275,0],[0,0,1]]],["Land_FoodSacks_01_large_brown_idap_F",[-0.587402,-1.39355,-0.339693],[[-0.999651,-0.0264275,0],[0,0,1]]],["Land_FoodSacks_01_large_brown_idap_F",[0.647095,-0.00292969,-0.329546],[[-0.999651,-0.0264275,0],[0,0,1]]],["Land_FoodSacks_01_large_brown_idap_F",[-0.47702,0.124023,-0.339851],[[-0.999651,-0.0264275,0],[0,0,1]]]];
private _arrayOfCargo = [];

{
    _x params ["_classname", "_position", "_vectorDirAndUp"];
    private _sack = _classname createVehicle [0,0,0];
    _sack attachTo [_truck_kamaz, _position];
    _sack setVectorDirAndUp _vectorDirAndUp;
    _arrayOfCargo pushBackUnique _sack;

} forEach _sackPositions;

_truck_kamaz setVariable ["Mawali_arrayOfCargo", _arrayOfCargo, true];