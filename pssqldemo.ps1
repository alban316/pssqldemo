<#
Note to self: See also: ps copy between sql servers.ps1 on my Google drive

0. "Dot sourcing" - specify command line e.g.: . ./untited.ps1
0...the preceding . scopes the variables inside the script back to the shell and persists them afterward!
1. TEST of BASIC dataflow between SQL instances...e.g. on-prem to Azure
2. Same, but now Azure SQL to SQL DW

#>

$query = "SELECT * FROM dbo.SomeTable"
$conn_src = "Server=<instance>.database.windows.net;Database=<catalog>;Uid=<user>;Pwd=<password>;"
$conn_dest = "Server=localhost;Database=<catalog>;Trusted_Connection=yes;"


$conn_src = New-Object System.Data.SqlClient.SqlDataAdapter $query, $conn_src

$dataset = New-Object System.Data.DataSet

$src.Fill($dataset)


$bulk_copy = New-Object System.Data.SqlClient.SqlBulkCopy $conn_dest
$bulk_copy.DestinationTableName = "dbo.SomeTable"
$bulk_copy.ColumnMappings.Add((New-Object System.Data.SqlClient.SqlBulkCopyColumnMapping(0,0)))
$bulk_copy.ColumnMappings.Add((New-Object System.Data.SqlClient.SqlBulkCopyColumnMapping(1,1)))
$bulk_copy.ColumnMappings.Add((New-Object System.Data.SqlClient.SqlBulkCopyColumnMapping(2,2)))
$bulk_copy.ColumnMappings.Add((New-Object System.Data.SqlClient.SqlBulkCopyColumnMapping(3,3)))
$bulk_copy.ColumnMappings.Add((New-Object System.Data.SqlClient.SqlBulkCopyColumnMapping(4,4)))

$bulk_copy.BatchSize = 500;

$bulk_copy.WriteToServer($dataset.Tables[0])
$bulk_copy.Close()




