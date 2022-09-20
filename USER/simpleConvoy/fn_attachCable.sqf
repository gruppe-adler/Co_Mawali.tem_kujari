params ["_truck_kamaz"];

private _cable = "PowerCable_01_StraightLong_F" createvehicle [0,0,0];

_cable attachTo [_truck_kamaz, [0.0481567,-1.25977,-1.00435]];
_cable setVectorDirAndUp  [[0.03222,-0.999352,-0.0160729],[-0.0415269,-0.0174059,0.998986]];
_cable animateSource ['Cap_1_hide', 1, true];
_cable animateSource ['Cap_2_hide', 1, true];