$GLPI_SERVER = "https://glpi.finall.space/marketplace/glpiinventory"
$LAB_NAME = "LAB-06"

$installer = "GLPI-Agent-Installer.exe"
Start-Process -FilePath $installer -ArgumentList "/quiet SERVER=$GLPI_SERVER TAG=$LAB_NAME" -Wait
