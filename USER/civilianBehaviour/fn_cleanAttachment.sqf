params ["_unit", "_object"];

[{
	params ["_unit", "_object"];
	(isNull _unit) 
},
{
	params ["_unit", "_object"];

	deleteVehicle _object;
}, [_unit, _object]] call CBA_fnc_waitUntilAndExecute;