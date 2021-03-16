#include <sourcemod>
#include <cstrike>
#include <clientprefs>
#include <multicolors>
#include "include/retakes.inc"
#include "retakes/generic.sp"

#pragma semicolon 1
#pragma newdecls required

#define MENU_TIME_LENGTH 15

char g_CTRifleChoice[MAXPLAYERS+1][WEAPON_STRING_LENGTH];
char g_TRifleChoice[MAXPLAYERS+1][WEAPON_STRING_LENGTH];
char g_CTPistol[MAXPLAYERS+1][WEAPON_STRING_LENGTH];
char g_TPistol[MAXPLAYERS+1][WEAPON_STRING_LENGTH];
bool g_AwpChoice[MAXPLAYERS+1];
Handle g_hCTRifleChoiceCookie;
Handle g_hTRifleChoiceCookie;
Handle g_hAwpChoiceCookie;
Handle g_hCTPistol;
Handle g_hTPistol;

public Plugin myinfo = {
    name = "CS:GO Retakes: CS-4Frags.pl Weapon Allocator by F4mouS",
    author = "splewis & F4mouS",
    description = "Allocator for CS4F Retakes",
    version = PLUGIN_VERSION,
    url = "https://github.com/splewis/csgo-retakes"
};

public void OnPluginStart() {
    g_hCTRifleChoiceCookie = RegClientCookie("retakes_ctriflechoice", "", CookieAccess_Private);
    g_hTRifleChoiceCookie = RegClientCookie("retakes_triflechoice", "", CookieAccess_Private);
    g_hAwpChoiceCookie = RegClientCookie("retakes_awpchoice", "", CookieAccess_Private);
    g_hTPistol = RegClientCookie("retakes_tpistol", "", CookieAccess_Private);
    g_hCTPistol = RegClientCookie("retakes_ctpistol", "", CookieAccess_Private);
    
    
}
 
public void OnClientConnected(int client) {
    g_CTRifleChoice[client] = "m4a1";
    g_TRifleChoice[client] = "ak47";
    g_CTPistol[client] = "UPS_S";
    g_TPistol[client] = "Glock";
    g_AwpChoice[client] = false;
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
    char ctrifle[WEAPON_STRING_LENGTH];
    char trifle[WEAPON_STRING_LENGTH];
    char ctpistol[WEAPON_STRING_LENGTH];
    char tpistol[WEAPON_STRING_LENGTH];
    GetClientCookie(client, g_hCTRifleChoiceCookie, ctrifle, sizeof(ctrifle));
    GetClientCookie(client, g_hTRifleChoiceCookie, trifle, sizeof(trifle));
    GetClientCookie(client, g_hCTPistol, ctrifle, sizeof(ctpistol));
    GetClientCookie(client, g_hTPistol, trifle, sizeof(tpistol));
    g_CTRifleChoice[client] = ctrifle;
    g_TRifleChoice[client] = trifle;
    g_CTRifleChoice[client] = ctpistol;
    g_TRifleChoice[client] = tpistol;
    g_AwpChoice[client] = GetCookieBool(client, g_hAwpChoiceCookie);
}

static void SetNades(char nades[NADE_STRING_LENGTH]) {
    int rand = GetRandomInt(0, 3);
    switch(rand) {
        case 0: nades = "";
        case 1: nades = "s";
        case 2: nades = "f";
        case 3: nades = "h";
    }
}

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

    bool giveTAwp = true;
    bool giveCTAwp = true;

    for (int i = 0; i < tCount; i++) {
        int client = tPlayers.Get(i);

        if (giveTAwp && g_AwpChoice[client]) {
            primary = "weapon_awp";
            giveTAwp = false;
        } else if(StrEqual(g_TRifleChoice[client], "sg556", true)) {
            primary = "weapon_sg556";
        } else if(StrEqual(g_TRifleChoice[client], "ak47", true)) {
            primary = "weapon_ak47";
        } else if(StrEqual(g_TRifleChoice[client], "galil", true)) {
        	primary = "weapon_galilar";
        } else {
        primary = "weapon_ak47";
       }
        

      if (StrEqual(g_TPistol[client], "Glock", true)){
     secondary = "weapon_glock";
       } else if (StrEqual(g_TPistol[client], "P250", true)){
     secondary = "weapon_p250";
       } else if (StrEqual(g_TPistol[client], "Tec-9", true)){
     secondary = "weapon_tec9";
            } else if (StrEqual(g_TPistol[client], "CZ-75", true)){
     secondary = "weapon_cz75a";
            } else if (StrEqual(g_TPistol[client], "Deagle", true)){
     secondary = "weapon_deagle";
    } else {
   secondary = "weapon_glock"; 
  }
        health = 100;
        kevlar = 100;
        helmet = true;
        kit = false;
		SetNades("");

        Retakes_SetPlayerInfo(client, primary, secondary, nades, health, kevlar, helmet, kit);
    }

    for (int i = 0; i < ctCount; i++) {
        int client = ctPlayers.Get(i);

        if (giveCTAwp && g_AwpChoice[client]) {
            primary = "weapon_awp";
            giveCTAwp = false;
        } else if (StrEqual(g_CTRifleChoice[client], "m4a1_silencer", true)) {
            primary = "weapon_m4a1_silencer";
        } else if (StrEqual(g_CTRifleChoice[client], "m4a1", true)) {
            primary = "weapon_m4a1";
        } else if (StrEqual(g_CTRifleChoice[client], "aug", true)){
            primary = "weapon_aug";
        } else if (StrEqual(g_CTRifleChoice[client], "famas", true)){
         primary = "weapon_famas"; 
        } else {
       primary = "weapon_m4a1";
      } 
        

        if (StrEqual(g_CTPistol[client], "UPS-S", true)){
     secondary = "weapon_usp_silencer";
       }  else if (StrEqual(g_CTPistol[client], "P2000", true)){
     secondary = "weapon_hkp2000";
       } else if (StrEqual(g_CTPistol[client], "P250", true)){
     secondary = "weapon_p250";
       } else if (StrEqual(g_CTPistol[client], "Five-Seven", true)){
     secondary = "weapon_fiveseven";
            } else if (StrEqual(g_CTPistol[client], "CZ-75", true)){
     secondary = "weapon_cz75a";
            } else if (StrEqual(g_CTPistol[client], "Deagle", true)){
     secondary = "weapon_deagle";
    } else {
   secondary = "weapon_ups_silencer"; 
  }

        health = 100;
        kevlar = 100;
        helmet = true;
        kit = false;
		SetNades("");
        Retakes_SetPlayerInfo(client, primary, secondary, nades, health, kevlar, helmet, kit);
    }
}

public void GiveWeaponsMenu(int client) {
    Menu menu = new Menu(MenuHandler_CTRifle);
    menu.SetTitle("[CS4F] ➫ Wybierz karabin CT:");
    menu.AddItem("m4a1", "M4A4");
    menu.AddItem("m4a1_silencer", "M4A1-S");
    menu.AddItem("aug", "AUG");
    menu.AddItem("famas", "FAMAS");
    menu.Display(client, MENU_TIME_LENGTH);
}

public void CTPistolMenu(int client) {
Menu menu = new Menu(MenuHandler_CTPistol);
menu.SetTitle("[CS4F] ➫ Wyierz Pistolet CT:");
menu.AddItem("USP-S", "UPS-S");
menu.AddItem("P2000", "P2000");
menu.AddItem("Five-Seven", "Five-Seven");
menu.AddItem("CZ-75", "CZ-75");
menu.AddItem("P250", "P250");
menu.AddItem("Deagle", "Deagle");
menu.Display(client, 30);   
}

public void TPistolMenu(int client) {
Menu menu = new Menu(MenuHandler_TPistol);
menu.SetTitle("[CS4F] ➫ Wyierz Pistolet T" );
menu.AddItem("Glock", "Glock");
menu.AddItem("Tec-9", "Tec-9");
menu.AddItem("CZ-75", "CZ-75");
menu.AddItem("P250", "P250");
menu.AddItem("Deagle", "Deagle");
menu.Display(client, 30);

}



//Pojebana pętla menu
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
        GiveAwpMenu(client);
    } else if (action == MenuAction_End) {
        delete menu;
    }
}

public int MenuHandler_CTRifle(Menu menu, MenuAction action, int param1, int param2) {
    if (action == MenuAction_Select) {
        int client = param1;
        char choice[WEAPON_STRING_LENGTH];
        menu.GetItem(param2, choice, sizeof(choice));
        g_CTRifleChoice[client] = choice;
        SetClientCookie(client, g_hCTRifleChoiceCookie, choice);
        TRifleMenu(client);
    } else if (action == MenuAction_End) {
        delete menu;
    }
}

public void TRifleMenu(int client) {
    Menu menu = new Menu(MenuHandler_TRifle);
    menu.SetTitle("[CS4F] ➫ Wyierz Karabin T");
    menu.AddItem("ak47", "AK-47");
    menu.AddItem("sg556", "SG-556");
    menu.AddItem("galil", "Galil");
    menu.Display(client, MENU_TIME_LENGTH);
 
}

public int MenuHandler_TRifle(Menu menu, MenuAction action, int param1, int param2) {
    if (action == MenuAction_Select) {
        int client = param1;
        char choice[WEAPON_STRING_LENGTH];
        menu.GetItem(param2, choice, sizeof(choice));
        g_TRifleChoice[client] = choice;
        SetClientCookie(client, g_hTRifleChoiceCookie, choice);
        CTPistolMenu(client);
    } else if (action == MenuAction_End) {
        delete menu;
    }
}

public void GiveAwpMenu(int client) {
    Menu menu = new Menu(MenuHandler_AWP);
    menu.SetTitle("[CS4F] ➫ Czy chcesz otrzymywać AWP?");
    AddMenuBool(menu, true, "Tak");
    AddMenuBool(menu, false, "Nie");
    menu.Display(client, MENU_TIME_LENGTH);
}

public int MenuHandler_AWP(Menu menu, MenuAction action, int param1, int param2) {
    if (action == MenuAction_Select) {
        int client = param1;
        bool allowAwps = GetMenuBool(menu, param2);
        g_AwpChoice[client] = allowAwps;
        SetCookieBool(client, g_hAwpChoiceCookie, allowAwps);
    } else if (action == MenuAction_End) {
        delete menu;
    }
}