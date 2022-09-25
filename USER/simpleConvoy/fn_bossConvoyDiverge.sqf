params ["_leader"];

private _group = group _leader;

private _targetPositions = [
	getMarkerPos "mrk_bossConvoyTarget_1",
	getMarkerPos "mrk_bossConvoyTarget_2",
	getMarkerPos "mrk_bossConvoyTarget_3",
	getMarkerPos "mrk_bossConvoyTarget_4"
];

{
	private _unit = _x;
	private _position = _targetPositions#_forEachIndex;

	_unit doMove _position;
	_unit setSpeedMode "FULL";

} forEach units _group;

_group setVariable ["Mawali_bossConvoyDiverged", true, true];
