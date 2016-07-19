ProxyMan changelog
===============================================================

## v1.7 : Seventh release : March 13, 2016
---------------------------------------------------------------
* unset_environment forced before setting environment / Terminal proxy
* there were multiple variables in environment, fixed
* 'export' was included in one of the case before environment variables, fixed, but it worked fine
* other crucial bug fixes, as spelling mistakes I didn't notice yet

## v1.6 : Sixth release : February 14, 2016
---------------------------------------------------------------
* added support for /etc/environment

## v1.5 : Fifth release : January 23, 2016
---------------------------------------------------------------
* modified the version number which displayed incorrectly on each release
* modified the readme file in case the user does not have sudo privileges, or sudo installed.
* files were not deleted if user quit the script without making any changes to the system. fixed.
* howtouse and tools_required added for help

## v1.4 : Fourth release : January 11, 2016
---------------------------------------------------------------
* unset forced before set to avoid duplicate entries.

## v1.3 : Third release : January 9, 2016
---------------------------------------------------------------
* sudo was missing on the statement that removed apt.conf on unset. Fixed.
* Warning is displayed on toggle to none if any authentication is saved, with option to remove credentials.

## v1.2 : Second release : January 1, 2016
---------------------------------------------------------------
* bashrc and bash_profile changes were not exported, fixed.
* Message to restart terminal session added.
* /etc/environment is not modified to avoid system-wide changes.

## v1.1 : First release : December 31, 2015
---------------------------------------------------------------
* bash_set.conf had no eol, causing warnings from bash on Elementary OS Freya.
* Added semicolon to the end of each line of bash proxy settings
* apt.conf generated had missing semicolon in each line, causing errors. Fixed now.
* gsettings_config.* files are useless, thus removed.
* bash_unset.bak file is useless, thus removed.


## v1.0 : Initial launch (pre-release) : December 30, 2015
---------------------------------------------------------------
* The initial version of the script published.
* Worked fine as tested on Debian Jessie.
