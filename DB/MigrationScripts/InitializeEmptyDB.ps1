#$RootDir = "D:\DBSpace\DB\MigrationScripts\Tested\"
$RootDir = "C:\temp\lCCHP\TestedMigrationScripts\"
$RootOutputDir = $RootDir + "Output\"

write-Host "Enumerating all files in $RootDir"


exit;

SQLCMD.EXE -i D:\DBSpace\DB\MigrationScripts\Tested\01-CreateDB.sql -o D:\DBSpace\DB\MigrationScripts\Tested\Output\01-CreateDB.txt -E
SQLCMD.EXE -i D:\DBSpace\DB\MigrationScripts\Tested\02-CreateDBObjects.sql -o D:\DBSpace\DB\MigrationScripts\Tested\Output\02-CreateDBObjects.txt -E
SQLCMD.EXE -i D:\DBSpace\DB\MigrationScripts\Tested\03-CreateDBTriggers.sql -o D:\DBSpace\DB\MigrationScripts\Tested\Output\03-CreateDBTriggers.txt -E