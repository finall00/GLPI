$GLPI_SERVER = "http://glpi.finall.space/front/inventory.php"
$LAB_NAME = "LAB-06"

# Instala o GLPI Agent passando a TAG da localização
$installer = "GLPI-Agent-Installer.exe"
Start-Process -FilePath $installer -ArgumentList "/S /server=$GLPI_SERVER /tag=$LAB_NAME" -Wait
