params ["_vehicle", "_count"];



{
			_x disableAI "FSM";
			_x disableAI "AUTOCOMBAT";
			_x setVariable ["lambs_danger_disableAI", true, true];   

} forEach (crew _vehicle);

private _convoyPath = [];

for "_i" from 1 to 21 do { 
	_convoyPath pushBack (getMarkerPos ("mrk_bossConvoy_" + str _i));
};

[{
	MissionNameSpace getVariable ["Mawali_bossConvoy", false]
}, {
	params ["_vehicle", "_count", "_convoyPath"];

	private _speed = 120;
	["Boss Convoy starting", [1,0,0,1]] remoteExec ["grad_zeusmodules_fnc_curatorShowFeedbackMessage"];


	(_vehicle) setUnloadInCombat [false, false];
	(_vehicle) allowCrewInImmobile [true, true];
	[_vehicle] call grad_simpleConvoy_fnc_handleDamage;
	_vehicle forceSpeed _convoySpeed;

	
	[{
		params ["_vehicle", "_convoyPath"];
		_vehicle setDriveOnPath _convoyPath;
	}, [_vehicle, _convoyPath], _count*1.5] call CBA_fnc_waitAndExecute;

}, [_vehicle, _count, _convoyPath]] call CBA_fnc_waitUntilAndExecute;
