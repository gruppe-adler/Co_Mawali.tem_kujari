private _convoyGroup = missionNameSpace getVariable ["Mawali_bossConvoyGroup", grpNull];
private _convoySpeed = 100;
private _convoySeparation = 70;

(units _convoyGroup) allowGetIn false;
{
		(vehicle _x) forceSpeed _convoySpeed*1.15;
		(vehicle _x) setConvoySeparation _convoySeparation;
		(vehicle _x) setUnloadInCombat [false, false];
		_x disableAI "FSM";
		_x disableAI "AUTOCOMBAT";
		_x setVariable ["lambs_danger_disableAI", true, true];    
		_x forceFollowRoad true;
		[_x] call grad_simpleConvoy_fnc_handleDamage;
		_x forceSpeed _convoySpeed;
		_x dofollow (leader _x);

	} forEach (units _convoyGroup);

[{
	missionNameSpace getVariable ["Mawali_bossConvoy", false]
},{
	params ["_convoyGroup"];

	["Boss Convoy starting", [1,0,0,1]] remoteExec ["grad_zeusmodules_fnc_curatorShowFeedbackMessage"];


	[{
		params ["_args", "_handle"];
		_args params ["_convoyGroup"];

		if (_convoyGroup getVariable ["Mawali_bossConvoyDiverged", false]) exitWith { [_handle] call CBA_fnc_removePerFrameHandler;
		["Boss Convoy diverged", [1,0,0,1]] remoteExec ["grad_zeusmodules_fnc_curatorShowFeedbackMessage"];
		};
		{
			_x dofollow (leader _x);
		} forEach (units _convoyGroup);

	}, 3, [_convoyGroup]] call CBA_fnc_addPerFrameHandler;

}, [_convoyGroup]] call CBA_fnc_waitUntilAndExecute;