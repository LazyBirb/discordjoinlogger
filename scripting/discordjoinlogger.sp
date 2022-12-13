#include <sdkhooks>
#include <sdktools>
#include <sourcemod>
#pragma newdecls required
#pragma semicolon 1


public Plugin myinfo =
{
	name = "Discord Join Logger",
	author = "LazyBirb",
	description = "A basic plugin to send a message to a discord webhook when someone joins or leaves.",
	version = "1.0.0",
	url = "https://github.com/LazyBirb/discordjoinlogger"
};

ConVar g_cvWebhookURL;
ConVar g_cvHostname;
ConVar g_cvIP;
ConVar g_cvPort;

char g_szHostname[256];
char g_szIP[32];
char g_szPort[32];


public void OnPluginStart()
{
	g_cvWebhookURL = CreateConVar("discordlogger_webhook", "", "Set the Discord Webhook link to make this plugin work at all", FCVAR_PROTECTED);
	g_cvIP = CreateConVar("calladmin_discord_ip", "0.0.0.0", "Set your server IP here when auto detection is not working for you. (Use 0.0.0.0 to disable manually override)");
	g_cvHostname = FindConVar("hostname");
	g_cvHostname.GetString(g_szHostname, sizeof g_szHostname);

	char szIP[32];
	g_cvIP.GetString(szIP, sizeof szIP);

	g_cvIP = FindConVar("ip");
	g_cvIP.GetString(g_szIP, sizeof g_szIP);
	if (StrEqual("0.0.0.0", g_szIP))
	{
		strcopy(g_szIP, sizeof g_szIP, szIP);
	}
	// g_cvIP.AddChangeHook(OnConVarChanged);
	g_cvPort = FindConVar("hostport");
	g_cvPort.GetString(g_szPort, sizeof g_szPort);

	RegAdminCmd("sm_test_joinlogger", TestWebhookConnector, ADMFLAG_RCON, "Test the current connection of the Webhook channle");
	AutoExecConfig(true, "DiscordWebhook-JoinLogger");
	PrintToServer("Discord Webhook Looger loaded!");
}

public Action TestWebhookConnector(int client, int args)
{
	PrintToChat(client, "Test!");

	return Plugin_Handled;
}

