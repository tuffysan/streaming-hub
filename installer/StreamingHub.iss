#define MyAppName "Streaming Hub"
#define MyAppVersion "0.2.0"
#define MyAppExeName "streaming_hub.exe"

[Setup]
AppId={{B38F6D15-AF0E-4C57-BD78-6280D982A67E}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
DefaultDirName={autopf}\Streaming Hub
DefaultGroupName={#MyAppName}
OutputDir=output
OutputBaseFilename=StreamingHub-Setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
UninstallDisplayIcon={app}\{#MyAppExeName}

[Files]
Source: "..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\Streaming Hub"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\Streaming Hub"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Skapa genväg på skrivbordet"; GroupDescription: "Genvägar:"

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "Starta Streaming Hub"; Flags: nowait postinstall skipifsilent
