params ["_type", "_cloaked"];


private _classname = switch (_type) do { 
    case "squad" : {
        if (_cloaked) then {
            selectRandom [
                   "UK3CB_ADC_C_Ikarus",
                   "UK3CB_ADC_C_V3S_Closed",
                   "UK3CB_ADC_C_Ural",
                   "UK3CB_ADG_O_Kamaz_Covered"
            ]
        } else {
            selectRandom [
                    "UK3CB_ADG_O_V3S_Open_ISL",
                    "UK3CB_ADG_O_Ural_Open_ISL",
                    "UK3CB_ADG_O_Kamaz_Open"
            ]
        };
    }; 
    case "fireteam" : {
        if (_cloaked) then {
            selectRandom [
                    "UK3CB_ADC_C_Datsun_Civ_Closed",
                    "UK3CB_ADC_C_Hatchback",
                    "UK3CB_ADC_C_Lada_Taxi",
                    "UK3CB_ADC_C_LR_Closed",
                    "UK3CB_ADC_C_Landcruiser",
                    "UK3CB_ADC_C_Skoda",
                    "UK3CB_ADC_C_Sedan",
                    "UK3CB_ADC_C_SUV",
                    "UK3CB_ADC_C_Gaz24"
            ]
        } else {
            selectRandom [
                    "UK3CB_ADG_O_Datsun_Pkm_ISL",
                    "UK3CB_ADG_O_Hilux_Dshkm_ISL",
                    "UK3CB_ADG_O_LR_M2_ISL",
                    "UK3CB_ADG_O_Pickup_DSHKM_ISL"
            ]
        };
    }; 
    case "specialteam" : {
        if (_cloaked) then {
            selectRandom [
                    "UK3CB_TKC_C_TT650",
                    "UK3CB_TKC_C_YAVA"
            ]
        } else {
            selectRandom [
                    "UK3CB_TKC_C_TT650",
                    "UK3CB_TKC_C_YAVA"
            ]
        };
    };
    case "heavy" : {
        if (_cloaked) then {
            selectRandom [
                   "UK3CB_ADC_C_Ikarus",
                   "UK3CB_ADC_C_V3S_Closed",
                   "UK3CB_ADC_C_Ural",
                   "UK3CB_ADG_O_Kamaz_Covered"
            ]
        } else {
            selectRandom [
                    "UK3CB_ADE_O_MTLB_PKT",
                    "UK3CB_ADE_O_BTR40_MG",
                    "UK3CB_ADE_O_T34"
            ]
        };
    };

    default {"UK3CB_TKC_C_Lada"}; 
};

_classname