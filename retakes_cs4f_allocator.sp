#include <sourcemod>
#include <cstrike>
#include <clientprefs>
#include <multicolors>
#include "include/retakes.inc"
#include "retakes/generic.sp"

#pragma semicolon 1
#pragma newdecls required

#define MENU_TIME_LENGTH 15


char g_CTPistol[MAXPLAYERS+1][WEAPON_STRING_LENGTH];
char g_TPistol[MAXPLAYERS+1][WEAPON_STRING_LENGTH];
Handle g_hCTPistol;
Handle g_hTPistol;

public Plugin myinfo = {
    name = "CS-4Frags.pl Pistol Allocator by F4mouS",
    author = "F4mouS",
    description = "CS4Frags Pistol Allocator by F4mouS for splewis retakes",
    version = PLUGIN_VERSION,
    url = "https://forum.cs-4frags.pl"
};

public void OnPluginStart() {
    g_hTPistol = RegClientCookie("retakes_tpistol", "", CookieAccess_Private);
    g_hCTPistol = RegClientCookie("retakes_ctpistol", "", CookieAccess_Private);
    
    
}
 
public void OnClientConnected(int client) {
    g_CTPistol[client] = "USP-S";
    g_TPistol[client] = "Glock";
}

public void Retakes_OnGunsCommand(int client) {
    GiveWeaponsMenu(client);
}
 

public void Retakes_OnWeaponsAllocated(ArrayList tPlayers, ArrayList ctPlayers, Bombsite bombsite) {
    WeaponAllocator(tPlayers, ctPlayers, bombsite);
}

/**
 * Updates client weapon settings according to their cookies.
 */
public void OnClientCookiesCached(int client) {
    if (IsFakeClient(client))
        return;
    char ctpistol[WEAPON_STRING_LENGTH];
    char tpistol[WEAPON_STRING_LENGTH];
    GetClientCookie(client, g_hCTPistol, ctpistol, sizeof(ctpistol));
    GetClientCookie(client, g_hTPistol, tpistol, sizeof(tpistol));
    g_CTPistol[client] = ctpistol;
    g_TPistol[client] = tpistol;

}


//Jak to wyjebie to sie nie kompiluje 
static void SetNades(char nades[NADE_STRING_LENGTH]) {
    int rand = GetRandomInt(0, 3);
    switch(rand) {
        case 0: nades = "";
        case 1: nades = "s";
        case 2: nades = "f";
        case 3: nades = "h";
    }
}
//nie nawidze tego
public void WeaponAllocator(ArrayList tPlayers, ArrayList ctPlayers, Bombsite bombsite) {
    int tCount = tPlayers.Length;
    int ctCount = ctPlayers.Length;

    char primary[WEAPON_STRING_LENGTH];
    char secondary[WEAPON_STRING_LENGTH];
    char nades[NADE_STRING_LENGTH];
    
    int health = 100;
    int kevlar = 100;
    bool helmet = true;
    bool kit = true;



    for (int i = 0; i < tCount; i++) {
        int client = tPlayers.Get(i);
        
        
//Primary ma nie byc bo to pistol 
      primary = "";
      
      
//To żeby dało pistolet 
      if (StrEqual(g_TPistol[client], "Glock", true)){
     secondary = "weapon_glock";
	} else if (StrEqual(g_TPistol[client], "P250", true)){
     secondary = "weapon_p250";
	} else if (StrEqual(g_TPistol[client], "Tec-9", true) && (GetUserFlagBits(client) & ADMFLAG_CUSTOM6)){
     secondary = "weapon_tec9";
	} else if (StrEqual(g_TPistol[client], "Tec-9", true) && (GetUserFlagBits(client) & ADMFLAG_ROOT)){
     secondary = "weapon_tec9";
	} else if (StrEqual(g_TPistol[client], "CZ-75", true) && (GetUserFlagBits(client) & ADMFLAG_CUSTOM6)){
     secondary = "weapon_cz75a";
	} else if (StrEqual(g_TPistol[client], "CZ-75", true) && (GetUserFlagBits(client) & ADMFLAG_ROOT)){
     secondary = "weapon_cz75a";
	} else if (StrEqual(g_TPistol[client], "Deagle", true)){
     secondary = "weapon_deagle";
    } else {
	 secondary = "weapon_glock"; 
  }
  
  
  
 //Wszystko inne 
	health = 100;        
	if (StrEqual(g_TPistol[client], "Glock", true)){
	kevlar = 100;
	}
	else { 
	kevlar = 0;
	}
        helmet = false;
        kit = false;
        if (GetUserFlagBits(client) & ADMFLAG_CUSTOM6){
       	SetNades("");
       	} else if (GetUserFlagBits(client) & ADMFLAG_ROOT){
       	SetNades("");
       	} else {
		SetNades(nades);
       	}
        Retakes_SetPlayerInfo(client, primary, secondary, nades, health, kevlar, helmet, kit);
    }

    for (int i = 0; i < ctCount; i++) {
        int client = ctPlayers.Get(i);

//Primary ma nie byc bo to pistol 
		primary = "";
		
		
        if (StrEqual(g_CTPistol[client], "USP-S", true)){
     secondary = "weapon_usp_silencer";
       }  else if (StrEqual(g_CTPistol[client], "P2000", true)){
     secondary = "weapon_hkp2000";
       } else if (StrEqual(g_CTPistol[client], "P250", true)){
     secondary = "weapon_p250";
       } else if (StrEqual(g_CTPistol[client], "Five-Seven", true) && (GetUserFlagBits(client) & ADMFLAG_CUSTOM6)){
     secondary = "weapon_fiveseven";
	   } else if (StrEqual(g_CTPistol[client], "Five-Seven", true) && (GetUserFlagBits(client) & ADMFLAG_ROOT)){
     secondary = "weapon_fiveseven";
	   } else if (StrEqual(g_CTPistol[client], "CZ-75", true) && (GetUserFlagBits(client) & ADMFLAG_CUSTOM6)){
     secondary = "weapon_cz75a";
	   } else if (StrEqual(g_CTPistol[client], "CZ-75", true) && (GetUserFlagBits(client) & ADMFLAG_ROOT)){
     secondary = "weapon_cz75a";
	   } else if (StrEqual(g_CTPistol[client], "Deagle", true)){
     secondary = "weapon_deagle";
    } else {
   secondary = "weapon_usp_silencer"; 
  }

    health = 100;
    //VIP powinien dostać keva zawsze nawet jeśli ma deagla
	if (StrEqual(g_CTPistol[client], "USP-S", true)){
	kevlar = 100;
	} else if (StrEqual(g_CTPistol[client], "P2000", true)){
	kevlar = 100;
	} else { 
	kevlar = 0;
	}
        helmet = false;
        kit = true;
        if (GetUserFlagBits(client) & ADMFLAG_CUSTOM6){
       	SetNades("");
       	} else if (GetUserFlagBits(client) & ADMFLAG_ROOT){
       	SetNades("");
       	} else {
		SetNades(nades);
       	}
        Retakes_SetPlayerInfo(client, primary, secondary, nades, health, kevlar, helmet, kit);
    }
}


public void GiveWeaponsMenu(int client) {
Menu menu = new Menu(MenuHandler_CTPistol);
menu.SetTitle("[CS4F] ➫ Wyierz Pistolet CT:");
menu.AddItem("USP-S", "USP-S");
menu.AddItem("P2000", "P2000");
menu.AddItem("P250", "P250");
menu.AddItem("Deagle", "Deagle");
if (GetUserFlagBits(client) & ADMFLAG_CUSTOM6){
menu.AddItem("Five-Seven", "Five-Seven");
}
else if (GetUserFlagBits(client) & ADMFLAG_ROOT){
menu.AddItem("Five-Seven", "Five-Seven");
}
else {
menu.AddItem("", "Five-Seven(PREMIUM)", ITEMDRAW_DISABLED);	
}
if (GetUserFlagBits(client) & ADMFLAG_CUSTOM6){
menu.AddItem("CZ-75", "CZ-75");
}
else if (GetUserFlagBits(client) & ADMFLAG_ROOT){
menu.AddItem("CZ-75", "CZ-75");
}
else {
menu.AddItem("", "CZ-75(PREMIUM)", ITEMDRAW_DISABLED);	
}
menu.Display(client, 30);   
}

public void TPistolMenu(int client) {
Menu menu = new Menu(MenuHandler_TPistol);
menu.SetTitle("[CS4F] ➫ Wyierz Pistolet T" );
menu.AddItem("Glock", "Glock");
menu.AddItem("P250", "P250");
menu.AddItem("Deagle", "Deagle");
if (GetUserFlagBits(client) & ADMFLAG_CUSTOM6){
menu.AddItem("Tec-9", "Tec-9");
}
else if (GetUserFlagBits(client) & ADMFLAG_ROOT){
menu.AddItem("Tec-9", "Tec-9");
}
else {
menu.AddItem("", "Tec-9(PREMIUM)", ITEMDRAW_DISABLED);	
}
if (GetUserFlagBits(client) & ADMFLAG_CUSTOM6){
menu.AddItem("CZ-75", "CZ-75");
}
else if (GetUserFlagBits(client) & ADMFLAG_ROOT){
menu.AddItem("CZ-75", "CZ-75");
}
else {
menu.AddItem("", "CZ-75(PREMIUM)", ITEMDRAW_DISABLED);	
menu.AddItem("", "Aby kupić PREMIUM i wpisz na czacie !sklepsms", ITEMDRAW_DISABLED);
}
menu.Display(client, 35);
}




//Zapisanie wyboru z menu do cookie oraz otworzenie nastepnego
public int MenuHandler_CTPistol(Menu menu, MenuAction action, int param1, int param2) {
    if (action == MenuAction_Select) {
        int client = param1;
        char choice[WEAPON_STRING_LENGTH];
        menu.GetItem(param2, choice, sizeof(choice));
        g_CTPistol[client] = choice;
        SetClientCookie(client, g_hCTPistol, choice);
        TPistolMenu(client);
    } else if (action == MenuAction_End) {
        delete menu;
    }
}

public int MenuHandler_TPistol(Menu menu, MenuAction action, int param1, int param2) {
    if (action == MenuAction_Select) {
        int client = param1;
        char choice[WEAPON_STRING_LENGTH];
        menu.GetItem(param2, choice, sizeof(choice));
        g_TPistol[client] = choice;
        SetClientCookie(client, g_hTPistol, choice);
    } else if (action == MenuAction_End) {
        delete menu;
    }
}



