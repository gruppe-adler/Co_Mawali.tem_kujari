params ["_unit", "_moving"];

if (_moving) then {
	[{
		[_unit,(selectRandom ["convoy_moving1", "convoy_moving2", "convoy_moving3", "convoy_moving4"])] remoteexec ["say3d"];
		["Convoy moving", [0,1,0,1]] call grad_zeusmodules_fnc_curatorShowFeedbackMessage;
	}, [], (random 3 max 1)] call CBA_fnc_waitAndExecute;
} else {
	[{
		[_unit,(selectRandom ["convoy_stopping1", "convoy_stopping2", "convoy_stopping3", "convoy_stopping4"])] remoteexec ["say3d"];
		["Convoy stopping", [1,0,0,1]] call grad_zeusmodules_fnc_curatorShowFeedbackMessage;
	}, [], (random 3 max 1)] call CBA_fnc_waitAndExecute;
};