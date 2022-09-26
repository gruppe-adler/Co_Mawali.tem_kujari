params ["_vehicle", "_count"];

{
	_x disableAI "FSM";
	_x disableAI "AUTOCOMBAT";
	_x setBehaviour "CARELESS";
	_x setVariable ["lambs_danger_disableAI", true, true];
} forEach (crew _vehicle);

private _targetPosition = getMarkerPos (format ["mrk_bossConvoyTarget_%1", _count]);

private _obj = (calculatePath ["car","careless", [2427.54,4932.85,0], _targetPosition]);

	_obj addEventHandler["PathCalculated", {
		params ["_agent", "_path"];
		/*
		private _randomID = str (random 100000);
		
		{
			private _marker = createMarker ["marker" + str _forEachIndex + "_" + _randomID, _x];
			_marker setMarkerType "mil_dot";
			_marker setMarkerText str _forEachIndex;
		} forEach _path;
		*/

		if (count _path > 2) then{
			_agent setVariable ["Mawali_path", _path, true];
		};
}]; 



[{
	params ["_agent", "_count"];
	count (_agent getVariable ["Mawali_path", []]) > 2
},{
	params ["_agent", "_count"];
	private _path = (_agent getVariable ["Mawali_path", []]);
	private _id = format ["Mawali_convoyPath_%1", _count];
	missionNamespace setVariable [_id, _path, true];

}, [_obj, _count]] call CBA_fnc_waitUntilAndExecute;

[{
	MissionNameSpace getVariable ["Mawali_bossConvoy", false]
}, {
	params ["_vehicle", "_count"];

	private _id = format ["Mawali_convoyPath_%1", _count];
	private _path = missionNamespace getVariable [_id, []];

	[{
		(_this select 0) setDriveOnPath (_this select 1);
	}, [_vehicle, _path], _count*2] call CBA_fnc_waitAndExecute;
	

	private _convoySpeed = 80;
	["Boss Convoy starting", [1, 0, 0, 1]] remoteExec ["grad_zeusmodules_fnc_curatorShowFeedbackMessage"];

	(_vehicle) setUnloadInCombat [false, false];
	(_vehicle) allowCrewInImmobile [true, true];
	[_vehicle] call grad_simpleConvoy_fnc_handleDamage;
	_vehicle forceSpeed _convoySpeed;
	

}, [_vehicle, _count]] call CBA_fnc_waitUntilAndExecute;
