The concept of backup solution based on MultipeerConnectivity framework. The BackupManager app plays a server role and provides funtionality for

- storing backups
- returning the list of stored backups
- sending selected backup to client

The iOS Multipeer Connectivity framework is used as a foundation to implement required functionality. It allows to transfer binary data, files or data streams between iOS devices using Wi-fi or Bluetooth connection. The way of connection is selected by framework (can’t be defined by user) and the Wi-fi is preferable. So if Wi-fi network is available all data will be transferred via Wi-fi and otherwise the Bluetooth connection is used.

Backups is transferred as files (resources). The backup file is a zip archive containing the set of files that are necessary for specific user. The archive can be protected (encrypted) with password.

The rest communication between server and client is implemented as transferring of binary data with commands. Command is represented by JSON with specific format. Currently the following commands are used:

Request for backups list:
```
{
   "name": "BMCommandBackupsListRequest",
   "from": “username”,
   "payload": {}
}
```
Response with list of backups:
```
{
   "name": "BMCommandBackupsListResponse”,
   "from": “BackupManager",
   "payload": {
      "backups": [
         {
            "path": "Backups/username/3D4503DA-7D05-4672-B3BC-0916DEC4C6AA_Backup.zip",
            "date": "2016-10-07 12:06:22",
            "user": "username",
            "name": "Backup.zip",
            "uuid": "3D4503DA-7D05-4672-B3BC-0916DEC4C6AA"
         }
      ]
   },
}
```
Requesting for backup:
```
{
   "name": "BMCommandRequestBackup”,
   "from": “username",
   "payload": {
      "uuid": "3D4503DA-7D05-4672-B3BC-0916DEC4C6AA"
   },
}
```
Success notification:
```
{
   "name": "BMCommandSuccess”,
   "from": "BackupManager"
   "payload": {
      "message": "Backup has been successfully sent."
   },
}
```
Error notification:
```
{
   "name": "BMCommandError”,
   "from": “BackupManager",
   "payload": {
      "code": 5001,
      "message": "Backup hasn't been found.",
      "domain": "NSError_Errors_InternalErrorDomain"
   },
}
```
