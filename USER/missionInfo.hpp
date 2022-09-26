/*
*   Legt allgemeine Information über die Mission fest.
*/

author = "nomisum für Gruppe Adler";                                               // Missionsersteller
onLoadName = "Co Muwali";                                                   // Name der Mission
onLoadMission = "";                                                             // Beschreibung der Mission (wird im Ladebildschirm unterhalb des Ladebildes angezeigt)
loadScreen = "data\loadpic.paa";                                                // Ladebild
overviewPicture = "";                                                           // Bild, das in der Missionsauswahl angezeigt wird
overviewText = "";                                                              // Text, der in der Missionsauswahl angezeigt wird


class CfgSFX
{
    sounds[] = {};
        
    class bongo_01
    {
        name = "bongo_01_name";
        sounds[]={sfxsound};
        sfxsound[]={"USER\sounds\bongo_01.ogg",35,1,150,1,1,1,0};
        empty[]= {"",0,0,0,0,0,0,0};
    };

	class bongo_02
    {
        name = "bongo_02_name";
        sounds[]={sfxsound};
        sfxsound[]={"USER\sounds\bongo_02.ogg",35,1,150,1,1,1,0};
        empty[]= {"",0,0,0,0,0,0,0};
    };

	class bongo_03
    {
        name = "bongo_03_name";
        sounds[]={sfxsound};
        sfxsound[]={"USER\sounds\bongo_03.ogg",35,1,150,1,1,1,0};
        empty[]= {"",0,0,0,0,0,0,0};
    };

};

class CfgVehicles
{
    class bongo_01 // class name to be used with createSoundSource
    {
        sound = "bongo_01"; // reference to CfgSFX class
    };

	 class bongo_02 // class name to be used with createSoundSource
    {
        sound = "bongo_02"; // reference to CfgSFX class
    };

	 class bongo_03 // class name to be used with createSoundSource
    {
        sound = "bongo_03"; // reference to CfgSFX class
    };

};