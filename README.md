# Count.ly Server Backup Script

Countly is an innovative, real-time, open source mobile analytics application. It collects data from mobile phones, and visualizes this information to analyze mobile application usage and end-user behavior. There are two parts of Countly: the server that collects and analyzes data, and mobile SDK that sends this data (for iOS & Android).

Countly:

- [Countly (Countly)](https://count.ly)

Countly Server;

- [Countly Server (countly-server)](https://github.com/Countly/countly-server)

Appcelerator Titanium Hyperloop Countly Modules

- https://github.com/dieskim/Appcelerator.Hyperloop.Countly

Other Countly SDK repositories;

- [Countly Android SDK (countly-sdk-android)](https://github.com/Countly/countly-sdk-android)
- [Countly iOS SDK (countly-sdk-ios)](https://github.com/Countly/countly-sdk-ios)

Countly SDK Guides;
- [Countly Android Messaging Guide](http://resources.count.ly/v1.0/docs/countly-push-for-android)
- [Countly iOS Messaging Guide](http://resources.count.ly/v1.0/docs/countly-push-for-ios)

Countly Backup Guide;
- [Countly Backing up Countly server Guide](http://resources.count.ly/v1.0/docs/backing-up-countly-server)

# This is a Linux Backup Script to Backup all the nessasary Count.ly Settings and Databases of your Count.ly Server
# It supports both Local and Remote Backups as well as backup Rotation
# Please note that this is still a beta script
# Any pull requests and suggestion welcome!
# Author: Dieskim

## Installation

1. Log in to you server via SSH as root

2. Create a folder where you would like to place the script and move into the folder

``mkdir countly-backup-script``

``cd countly-backup-script``

3. wget the backup script

``wget https://github.com/dieskim/countly-server-backup-script/blob/master/countly-backup.sh``

4. Set the script to be executable

``chmod a+x countly-backup.sh``

5. For remote backups set up [Linux SSH KEY Password Free Automatic Config Authentication](http://kiteplans.info/2015/05/13/how-to-linux-ssh-key-password-free-automatic-config-authentication-backup-sftp-scp/)

6. Edit all the setting in the top of the script.

7. Test the script via
``sh -x countly-backup.sh 2>&1 | tee debug.txt``

7. Add Script to Crontab to run daily

``crontab -e``

- Choose your editor and add the below to the crontab to run script every night at midnight - save file
	
``00 00 * * * /path/to/countly-backup-script/countly-backup.sh``

## Author

Author: Dieskim

## License
MIT
