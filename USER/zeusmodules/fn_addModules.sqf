[] spawn {
  waitUntil {!isNull player};
  waitUntil {  time > 3 };

  {
    private _curator = _x;
    
      _curator addEventHandler ["CuratorGroupPlaced", {
          params ["", "_group"];

          { 
              _x setSkill ["aimingAccuracy", 0.3];
              _x setSkill ["aimingShake", 0.2]; 
              _x setSkill ["aimingSpeed", 0.9]; 
              _x setSkill ["endurance", 0.6]; 
              _x setSkill ["spotDistance", 1]; 
              _x setSkill ["spotTime", 0.9]; 
              _x setSkill ["courage", 1]; 
              _x setSkill ["reloadSpeed", 1]; 
              _x setSkill ["commanding", 1];
              _x setSkill ["general", 1];

              private _face = selectRandom ["AfricanHead_01", "AfricanHead_02", "AfricanHead_03", "AfricanHead_01_sick", "AfricanHead_02_sick", "AfricanHead_03_sick"];
              [_x, _face] remoteExec ["setFace", 0, _x];
              
          } forEach units _group;

          ["GRAD_missionControl_setServerAsOwner", [_group]] call CBA_fnc_serverEvent;
      }];

      _curator addEventHandler ["CuratorObjectPlaced", {
          params ["", "_object"];
          
          _object setSkill ["aimingAccuracy", 0.3];
          _object setSkill ["aimingShake", 0.2]; 
          _object setSkill ["aimingSpeed", 0.9]; 
          _object setSkill ["endurance", 0.6]; 
          _object setSkill ["spotDistance", 1]; 
          _object setSkill ["spotTime", 0.9]; 
          _object setSkill ["courage", 1]; 
          _object setSkill ["reloadSpeed", 1]; 
          _object setSkill ["commanding", 1];
          _object setSkill ["general", 1];

          if (_object isKindOf "CAManBase") then {
             if (count units _object == 1) then {
                 ["GRAD_missionControl_setServerAsOwner", [group _object]] call CBA_fnc_serverEvent;
             };
          } else {
             if (count crew _object > 1) then {
                 ["GRAD_missionControl_setServerAsOwner", [group (crew _object select 0)]] call CBA_fnc_serverEvent;
             };
         };

      }];

  } forEach allCurators;
};


//////////////

["MAWALI Enemies Cloaked", "Reinforcements Squad", {
     params ["_position", "_object"];
     
     ["squad", true, ASLtoAGL _position] remoteExec ["grad_zeusmodules_fnc_reinforcements", 2];
     
}] call zen_custom_modules_fnc_register;

["MAWALI Enemies Open", "Reinforcements Squad", {
     params ["_position", "_object"];
     
     ["squad", false, ASLtoAGL _position] remoteExec ["grad_zeusmodules_fnc_reinforcements", 2];
     
}] call zen_custom_modules_fnc_register;


["MAWALI Enemies Cloaked", "Reinforcements Fireteam", {
     params ["_position", "_object"];
     
     ["fireteam", true, ASLtoAGL _position] remoteExec ["grad_zeusmodules_fnc_reinforcements", 2];
     
}] call zen_custom_modules_fnc_register;

["MAWALI Enemies Open", "Reinforcements Fireteam", {
     params ["_position", "_object"];
     
     ["fireteam", false, ASLtoAGL _position] remoteExec ["grad_zeusmodules_fnc_reinforcements", 2];
     
}] call zen_custom_modules_fnc_register;


["MAWALI Enemies Cloaked", "Reinforcements specialteam", {
     params ["_position", "_object"];
     
     ["specialteam", true, ASLtoAGL _position] remoteExec ["grad_zeusmodules_fnc_reinforcements", 2];
     
}] call zen_custom_modules_fnc_register;

["MAWALI Enemies Open", "Reinforcements specialteam", {
     params ["_position", "_object"];
     
     ["specialteam", false, ASLtoAGL _position] remoteExec ["grad_zeusmodules_fnc_reinforcements", 2];
     
}] call zen_custom_modules_fnc_register;


["MAWALI Enemies Cloaked", "Reinforcements heavy", {
     params ["_position", "_object"];
     
     ["heavy", true, ASLtoAGL _position] remoteExec ["grad_zeusmodules_fnc_reinforcements", 2];
     
}] call zen_custom_modules_fnc_register;

["MAWALI Enemies Open", "Reinforcements heavy", {
     params ["_position", "_object"];
     
     ["heavy", false, ASLtoAGL _position] remoteExec ["grad_zeusmodules_fnc_reinforcements", 2];
     
}] call zen_custom_modules_fnc_register;



["MAWALI Convoy Control", "Start Convoy",
    {
      params ["_position", "_object"];
      
		  ["Mawali_convoyState",[true, true]] call CBA_fnc_serverEvent;

}] call zen_custom_modules_fnc_register;

["MAWALI Convoy Control", "Stop Convoy",
    {
      params ["_position", "_object"];
      
		  ["Mawali_convoyState",[false, true]] call CBA_fnc_serverEvent;

}] call zen_custom_modules_fnc_register;

["MAWALI Convoy Control", "Unload Convoy",
    {
      params ["_position", "_object"];
      
		  [missionNameSpace getVariable ["Mawali_convoyGroup", grpNull], 50] remoteExec ["grad_civilianBehaviour_fnc_civilianUnloadMain", 2];

}] call zen_custom_modules_fnc_register;


["MAWALI Convoy Control", "Convoy 40 kmh",
    {
      params ["_position", "_object"];
      
		  ["Mawali_convoySpeed",[40]] call CBA_fnc_serverEvent;

}] call zen_custom_modules_fnc_register;

["MAWALI Convoy Control", "Convoy 50 kmh",
    {
      params ["_position", "_object"];
      
		  ["Mawali_convoySpeed",[50]] call CBA_fnc_serverEvent;

}] call zen_custom_modules_fnc_register;

["MAWALI Convoy Control", "Convoy 65 kmh",
    {
      params ["_position", "_object"];
      
		  ["Mawali_convoySpeed",[65]] call CBA_fnc_serverEvent;

}] call zen_custom_modules_fnc_register;

["MAWALI Convoy Control", "Convoy 80 kmh",
    {
      params ["_position", "_object"];
      
		  ["Mawali_convoySpeed",[80]] call CBA_fnc_serverEvent;

}] call zen_custom_modules_fnc_register;


["MAWALI Convoy Control", "Convoy Unload Duration 30",
    {
      params ["_position", "_object"];
      
		  missionNamespace setVariable ["Mawali_convoyDurationUnload", 30, true];

}] call zen_custom_modules_fnc_register;

["MAWALI Convoy Control", "Convoy Unload Duration 60",
    {
      params ["_position", "_object"];
      
		  missionNamespace setVariable ["Mawali_convoyDurationUnload", 60, true];

}] call zen_custom_modules_fnc_register;

["MAWALI Convoy Control", "Convoy Unload Duration 120",
    {
      params ["_position", "_object"];
      
		  missionNamespace setVariable ["Mawali_convoyDurationUnload", 120, true];

}] call zen_custom_modules_fnc_register;

["MAWALI Convoy Control", "Convoy Unload Duration 240",
    {
      params ["_position", "_object"];
      
		  missionNamespace setVariable ["Mawali_convoyDurationUnload", 240, true];

}] call zen_custom_modules_fnc_register;



["MAWALI Convoy Control", "Convoy Unload Civ Count 10",
    {
      params ["_position", "_object"];
      
		  missionNamespace setVariable ["mawali_convoyUnloadCivCount", 10, true];

}] call zen_custom_modules_fnc_register;

["MAWALI Convoy Control", "Convoy Unload Civ Count 20",
    {
      params ["_position", "_object"];
      
		  missionNamespace setVariable ["mawali_convoyUnloadCivCount", 20, true];

}] call zen_custom_modules_fnc_register;

["MAWALI Convoy Control", "Convoy Unload Civ Count 30",
    {
      params ["_position", "_object"];
      
		  missionNamespace setVariable ["mawali_convoyUnloadCivCount", 30, true];

}] call zen_custom_modules_fnc_register;




["MAWALI Convoy Control", "Boss Convoy Start",
    {
      params ["_position", "_object"];
      
		  missionNameSpace setVariable ["Mawali_bossConvoy", true, true];

}] call zen_custom_modules_fnc_register;


["MAWALI Ambient", "Music Radio",
    {
      // Get all the passed parameters
      params ["_position", "_object"];
      _position = ASLToAGL _position;

      private _radio = (selectRandom ["land_gm_euro_furniture_radio_01", "jbad_radio_b", "Land_FMradio_F"]) createVehicle [0,0,0];
      _radio setPos _position;
      _radio setDir (random 360);

      private _source = createSoundSource [(selectRandom ["bongo_01", "bongo_02", "bongo_03"]), _position, [], 0];
      [_source, _radio, false] call grad_ambient_fnc_soundSourceHelper;
      
      {
        _x addCuratorEditableObjects [[_radio], false];
      } forEach allCurators;

    }] call zen_custom_modules_fnc_register;

["MAWALI Ambient", "Radio Carrier",
    {
      // Get all the passed parameters
      params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];
      _position = ASLToAGL _position;

      [_position] remoteExecCall ["grad_ambient_fnc_createMusicCarrier", 2];

    }] call zen_custom_modules_fnc_register;

    

["MAWALI End", "Create Chair Circle",
{
  params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];

  _position = ASLToAGL _position;
  ["Land_CampingChair_V1_F", _position, count (PlayableUnits + switchableUnits)] call grad_zeusmodules_fnc_createChairCircle;

}] call zen_custom_modules_fnc_register;