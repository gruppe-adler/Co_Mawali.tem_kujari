params ["_vehicle", "_count"];

{
	_x disableAI "FSM";
	_x disableAI "AUTOCOMBAT";
	_x setVariable ["lambs_danger_disableAI", true, true];
} forEach (crew _vehicle);

[{
	MissionNameSpace getVariable ["Mawali_bossConvoy", false]
}, {
	params ["_vehicle", "_count"];
	switch (_count) do {
		case 1: {
			_vehicle setDriveOnPath (call grad_simpleconvoy_fnc_bossConvoyPathE);
		};
		case 2: {
			_vehicle setDriveOnPath (call grad_simpleconvoy_fnc_bossConvoyPathNE);
		};
		case 3: {
			_vehicle setDriveOnPath (call grad_simpleconvoy_fnc_bossConvoyPathN);
		};
		case 4: {
			_vehicle setDriveOnPath (call grad_simpleconvoy_fnc_bossConvoyPathN2);
		};
		default {};
	};

	private _speed = 120;
	["Boss Convoy starting", [1, 0, 0, 1]] remoteExec ["grad_zeusmodules_fnc_curatorShowFeedbackMessage"];

	(_vehicle) setUnloadInCombat [false, false];
	(_vehicle) allowCrewInImmobile [true, true];
	[_vehicle] call grad_simpleConvoy_fnc_handleDamage;
	_vehicle forceSpeed _convoySpeed;
}, [_vehicle, _count]] call CBA_fnc_waitUntilAndExecute;

/*
	private _convoyPathGeneral = [];
	private _convoyPathN = [];
	private _convoyPathNE = [];
	private _convoyPathE = [];
	private _convoyPathSE = [];
	
	for "_i" from 1 to 21 do {
		_convoyPathGeneral pushBack (getMarkerPos ("mrk_bossConvoy_" + str _i));
	};
	
	for "_i" from 1 to 177 do {
		_convoyPathN pushBack (getMarkerPos ("mrk_bossConvoyNorth_" + str _i));
	};
	
	for "_i" from 1 to 177 do {
		_convoyPathNE pushBack (getMarkerPos ("mrk_bossConvoyNorthEast_" + str _i));
	};
	
	[{
		MissionNameSpace getVariable ["Mawali_bossConvoy", false]
	}, {
		params ["_vehicle", "_count", "_convoyPath"];
		
		private _speed = 120;
		["Boss Convoy starting", [1, 0, 0, 1]] remoteExec ["grad_zeusmodules_fnc_curatorShowFeedbackMessage"];
		
		(_vehicle) setUnloadInCombat [false, false];
		(_vehicle) allowCrewInImmobile [true, true];
		[_vehicle] call grad_simpleConvoy_fnc_handleDamage;
		_vehicle forceSpeed _convoySpeed;
		
		[{
			params ["_vehicle", "_convoyPath"];
			_vehicle setDriveOnPath _convoyPath;
		}, [_vehicle, _convoyPath], _count*1.5] call CBA_fnc_waitAndExecute;
	}, [_vehicle, _count, _convoyPathGeneral]] call CBA_fnc_waitUntilAndExecute;
	
	
	
	
	
	[{
		_this inArea trg_bossConvoy
	}, {
		MissionNameSpace setVariable ["Mawali_bossConvoyDiverge", true, true];
	}, _vehicle] call CBA_fnc_waitUntilAndExecute;
	
	if (_count == 1) then {
		[{
			MissionNameSpace getVariable ["Mawali_bossConvoyDiverge", false]
		}, {
			params ["_vehicle", "_count", "_convoyPath"];
			
			
			[{
				params ["_vehicle", "_convoyPath"];
				_vehicle setDriveOnPath _convoyPath;
			}, [_vehicle, _convoyPath], _count*1.5] call CBA_fnc_waitAndExecute;
		}, [_vehicle, _count, _convoyPathN]] call CBA_fnc_waitUntilAndExecute;
	} else {
		if (_count == 2) then {
			[{
				MissionNameSpace getVariable ["Mawali_bossConvoyDiverge", false]
			}, {
				params ["_vehicle", "_count", "_convoyPath"];
				
				
				[{
					params ["_vehicle", "_convoyPath"];
					_vehicle setDriveOnPath _convoyPath;
				}, [_vehicle, _convoyPath], _count*1.5] call CBA_fnc_waitAndExecute;
			}, [_vehicle, _count, _convoyPathNE]] call CBA_fnc_waitUntilAndExecute;
		} else {
			if (_count == 3) then {
				[{
					MissionNameSpace getVariable ["Mawali_bossConvoyDiverge", false]
				}, {
					params ["_vehicle", "_count", "_convoyPath"];
					
					
					[{
						params ["_vehicle", "_convoyPath"];
						_vehicle setDriveOnPath _convoyPath;
					}, [_vehicle, _convoyPath], _count*1.5] call CBA_fnc_waitAndExecute;
				}, [_vehicle, _count, _convoyPathE]] call CBA_fnc_waitUntilAndExecute;
			} else {
				[{
					MissionNameSpace getVariable ["Mawali_bossConvoyDiverge", false]
				}, {
					params ["_vehicle", "_count", "_convoyPath"];
					
					
					[{
						params ["_vehicle", "_convoyPath"];
						_vehicle setDriveOnPath _convoyPath;
					}, [_vehicle, _convoyPath], _count*1.5] call CBA_fnc_waitAndExecute;
				}, [_vehicle, _count, _convoyPathSE]] call CBA_fnc_waitUntilAndExecute;
			};
		};
	};
	
*/