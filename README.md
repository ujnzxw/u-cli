# u-cli
A Ubuntu command line tool for developers!
With this tool you will no longer need to remember the weird commands in Linux to configure! When you run a function, the executed command is displayed and that helps you memorize each of the Utilities for future usage.



## The difference

**u-cli** differs from other mac command line tools in that:

* Its main purpose is to manage administrative tasks and do it easier
* It doesn't install 3rd party tools because it doesn't have dependencies
* Tools need: bash, sed, awk, grep, apt, gsettings-desktop-schemas.
  They are normally pre-installed in almost all desktop distros.
* The installation is very easy and doesn't require intervention
* It only uses Linux shell commands.



## Installation

To **install** or **update** u-cli you can run this command:

`curl -fsSL https://raw.githubusercontent.com/ujnzxw/u-cli/master/install.sh | sh`

You can also install it in a different path

`INSTALL_DIR=$HOME/.u-cli sh <(curl -fsSL https://raw.githubusercontent.com/ujnzxw/u-cli/master/install.sh)`


_Note: You should reload your shell in both cases_

## Usage

```
Uage:  u [OPTIONS] COMMAND [help]

    OPTIONS
        --update        update u-cli to the latest version
        --uninstall     uninstall u-cli

    COMMANDS:
        help
        app
        battery
        bluetooth
        dir
        disk
        firewall
        group
        hostname
        info
        ip
        lock
        panel
        proxy
        reboot
        restart
        service
        shutdown
        sleep
        trash
        volume
        wallpaper
        wifi
```

#### List:
```
    Usage: u list

    Examples:
        u list h[elp]    # show this help
        u list           # list all the availible commands
```

#### App:
```
    Usage: u app [ chrome | win7 | help ]

    Examples:
      u app help         # show this help
      u app chrome       # setup chrome
      u app win7         # setup win7 in Virtual Box

```

#### Battery:
```
    Usage: u battery [ status | help | cmd ]

    Examples:
      u battery status    # get the battery status
      u battery cmd       # get the battery command
```


####  Bluetooth:
```
    Usage: u bluetooth [ status | enable | disable | restart | force-reload | help ]

    Examples:
      u bluetooth status         # bluetooth status
      u bluetooth enable         # turn on bluetooth
      u bluetooth disable        # turn off bluetooth
      u bluetooth restart        # restart bluetooth
      u bluetooth force-reload   # force reload bluetooth


```

#### Dir:
```
    usage: u dir [ tree | tree-size | delete | help ]

    Examples:
      u dir tree                  # tree view of folders in the current path
      u dir tree-size             # tree view of folders in the current path with size
      u dir tree /path            # tree view of folders in a specific path

      u dir delete empty          # delete empty folders recursively in the current path
      u dir delete empty /path    # delete empty folders recursively in a specific path

```

#### Disk:
```
    Usage: u disk [ ls | list | info | help ]

    Examples:
      u disk ls                                 # list disks
      u disk list                               # list disks
      u disk list /dev/disk0                    # list a specific disk
      u disk info /dev/disk0                    # print info for a specific disk
```

#### Firewall:
```
    Usage: u firewall [ status | enable | disable | help ]

    Examples:
       u firewall status                # Show status
       u firewall enable                # Enable firewall
       u firewall disable               # Disable firewall

```

#### Group:
```
    Usage: u group [ list | ls | info | adduser | removeuser | ismember | help ]

    Examples:
      u group list                          # get list of groups
      u group info mygroup                  # display group information

      u group adduser myuser mygroup        # add an user to a specific group
      u group removeuser myuser mygroup     # remove an user from a specific group

      u group ismember myuser mygroup       # show if the user is a member of a specific group

```

#### Hostname:
```
    Usage: u hostname [ help ]

    Examples:
      u hostname ls|list                 # get the current hostname information
      u hostname changeto                # set a new hostname
      u hostname help                    # Show this help

```

#### Info:
```
    Usage: u info [ help ]

    Examples:
      u info                     # print Operating System infomation
      u info cpu                 # print CPU infomation
      u info pci                 # print PCI infomation
      u info usb                 # print USB infomation
      u info disk                # print disk all the disk infomation
      u info diskinfo /my/disk   # print more about specific disk
      u info bios                # print BIOS infomation
      u info dmi                 # print DMI infomation
      u info hw|hardware         # Extract detailed information on the hardware configuration of the machine
      u info sw|os               # print Operating System infomation
      u info mem[ory]            # print memory infomation

```

#### IP:
```
    Usage:  u ip [ all | help ]

    Examples:
      u ip h[elp]                # show this help
      u ip                       # show your ip
      u ip a[all]                # list all your ip addr connected to remote server
```

#### Lock:
```
    Usage: u lock [ help ]

    Examples:
      u lock h[elp]       # show this help info
      u lock              # lock the ubuntu

```

#### Panel:
```
    Usage: u panel [ hide | help ]

    Examples:
      u panel help         # show this help
      u panel hide on      # auto hiding the Unity launcher
      u panel hide off     # unhiding the Unity launcher

```

```

#### Proxy:
```
    Usage:  u proxy [ ls | list | none | man | auto | help ]

    Examples:
      u proxy ls                    # list network proxy
      u proxy help                  # show this help

      u proxy model none            # set proxy mode none
      u proxy model man             # set proxy mode manual
      u proxy model auto            # set proxy mode automatic
      u proxy set                   # set a proxy

```

#### Reboot:
```
    Usage:  u  reboot [ f | force | help ]

    Examples:
      u reboot h[elp]    # show this help
      u reboot f[orce]   # reboot computer (without confirmation)
      u reboot           # reboot computer (needs confirmation)
```

#### Restart:
```
    Usage:  u restart [ -f | --force | help ]

    Examples:
      u restart h[elp]    # show this help
      u restart           # restart computer (needs confirmation)
      u restart -f[orce]  # restart computer (without confirmation)
```

#### Service:
```
    Usage: u service [ --status-all | list | ls | start | stop | restart | help ]


    Examples:
      u service h[elp]                              # show this help

      u service --status-all                        # list all services
      u service list                                # list all services
      u service ls                                  # list all services
      u service ls myservice                        # show status about a specific service

      u service start myservice                     # start a service
      u service stop myservice                      # stop a service

      u service restart myservice                   # start a service

```

#### Shutdown:
```
    Usage:  u  shutdown [ f | force | help ]

    Examples:
      u shutdown h[elp]         # show this help
      u shutdown [--]f[orce]    # shutdown computer (without confirmation)
      u shutdown                # shutdown computer (needs confirmation)
```

#### Sleep:
```
    Usage: u sleep [ help ]

    Examples:
      u sleep h[elp]      #  show this help
      u sleep             #  put the ubuntu to sleep/suspend

```

#### Trash:
```
    Usage: u trash [ status | mv | clean | help ]

    Examples:
      u trash h[elp]         # show this help
      u trash status         # get trash info
      u trash put filename   # move file to trash
      u trash list           # list file in trash
      u trash rm  filename   # remove one file in trash
      u trash restore        # restore file from trash for current path
      u trash clean[empty]   # clean trash

```

#### Volume:
```
    Usage: u volume [ + | - | mute | unmute ]

    Examples:
      u volume +              # increase volume by 5%
      u volume -              # decrease volume by 5%
      u volume mute           # volume mute
      u volume unmute         # volume unmute
```

#### Wallpaper:
```
    Usage: u wallpaper [ /path/to/file.jpg | help ]

    Examples:
      u wallpaper h[elp]                   # show this help
      u wallpaper ./wallpapers/tree.jpg    # set wallpaper
```

#### Wifi:
```
    Usage:  u wifi [ status | scan | off | on | connect | disconnect | passwd | help ]

    Examples:
      u wifi status                   # wifi status
      u wifi scan                     # scan wifi
      u wifi off                      # turn off your wifi
      u wifi on                       # turn on your wifi
      u wifi connect SSID PASSWORD    # connect a wifi network
      u wifi disconnect [SSID]        # disconnect current wifi network
      u wifi [show]passw[or]d [SSID]  # show wifi network password
```

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :metal:

## TODO:
* Add more plugins
* Improve the help
* Improve the installation script
* Auto input the command prifix (when print help info)
* Make the application name (u) customizable during installation

## Thanks
[guarinogabriel/Mac-CLI](https://github.com/guarinogabriel/Mac-CLI) and [rgcr/m-cli](https://github.com/rgcr/m-cli) are great sources of inspiration.


## Reference
[Wifi password](http://askubuntu.com/questions/156861/find-the-password-for-the-currently-connected-wireless-network)
[hostnamectl, timedatectl, localectl](http://askubuntu.com/a/516898)
[Volume Settings](http://askubuntu.com/a/97945)
[Randomly changes the wallpaper from a given directory](http://askubuntu.com/a/510135)
[trash-cli](https://github.com/andreafrancia/trash-cli)
[List all IP addresses connected to your Server](https://www.mkyong.com/linux/list-all-ip-addresses-connected-to-your-server/)


---
[MIT License](LICENSE.md) © Steven ZHAO
