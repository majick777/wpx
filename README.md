
# WPX 

![WPX Logo](https://wpmedic.tech/downloads/assets/wpx/icon-128x128.png)

## WP CLI Multiplied!

> *You'll see your commands multiplied, if you continually decide,*
> *to faithfully pursue, the policy of root.*

### Brought to you by WP Medic

![WP Medic Logo](https://wpmedic.tech/downloads/assets/wpmedic-icon.png)

Love this tool? [Become a WP Medic Patron](https://patreon.com/wpmedic)

[WPX Home](http://wpmedic.tech/wpx/) - [WPX GitHub](https://github.com/majick777/wpx/)

[WP CLI Home](http://wp-cli.org/) - [WP CLI Command Reference](https://developer.wordpress.org/cli/commands/)

***


### Introduction


WPX is shell script wrapper for running commands on multiple sites via ([WP CLI](http://wp-cli.org/)) 
(the WordPress Command Line Interface.)

This allows you to streamline repetitive tasks for Core, Plugin or Themes (and more):

* Installations, Reinstallations and Uninstallations
* Updates, Activations and Deactivations
* Combined Install/Activate or Deactivate/Uninstall

So that any action can process multiple resources and sites with a single command line! :-D

eg. `wpx installactivateplugin site1,site2,site3 plugin-1,plugin-2,plugin-3`

If you are involved in managing multiple WordPress installs, your eyes are probably lighting up right now. 8-)

As you can imagine, `WPX` takes the existing timesaving coolness of `WP CLI` to the next level.

#### Features

Another main feature of WPX is **File Syncing**, giving you the ability to easily synchronize (via `rsync`) 
a local core, plugin, theme, must-use plugin or dropin source to any site(s) specified. 

This allows for much easier version control as well as faster distribution of bugfixes and other updates 
on a server with independent sites, giving you the ability to have a more unified codebase without needing 
to use Multisite. It also makes it easy to say, sync a cloned GitHub repo to a multiple Staging sites.

`WPX` also includes some nifty extra features:

* **Language Commmands** - to also install, uninstall, activate or update any locale language pack
* **Colourful Lists** - list core info, plugins and themes in a colourful (and filterable) display table.
* **Check Permissions** - find and fix rogue file permissions that do not match with the site owner:group.
* **Core Locking** - to make core files unwriteable to hackers (see Core Lock section for more details.)

#### Limitations

Certain commands will not work with Multisite yet (network plugin activation/deactivation,
and theme or plugin activation for a specific Blog Site ID.)

WPX works to manage local sites on any single server, with limited YML config support. It is intended that 
WPX will support running of all WPX commands to remote sites also (via SSH and rsync.) This will include 
handling of YML configs which may specify the use of a local path, SSH and/or site Aliases.

The next phase of development will focus on these two features (See the Roadmap section.)


### Installation

0. (Install [WP CLI](http://wp-cli.org/) if not already installed. Or maybe time to update it!)
1. Download the `WPX` ZIP file and extract it locally.
  * then upload `wpx` via FTP to `/usr/local/bin` (or other environment path used)
  * (if your FTP user is not root, login as root and `chown root:root /usr/local/bin/wpx`)
2. Or simply change to the environment path in shell and download it directly:
  * `cd /usr/local/bin` (making sure you are logged in as `root`)
  * `wget https://raw.githubusercontent.com/majick777/wpx/master/wpx`
3. Make `WPX` Executable: `chmod +x /usr/local/bin/wpx` (or other environment path used)
4. Create a `wpx.conf` config file in the same directory (or alternatively in `~/.wp-cli/`)
  * (or you can just rename `wpx.sample.conf` to `wpx.conf` and edit then upload it)
5. For the SYNC commands you need `rsync` installed (you probably already do):
  * [On Red Hat based systems]# yum install rsync 
  * [On Debian based systems]# apt-get install rsync
6. For CentOS users, you may need to edit your `/etc/sudoers` file to include the following:
`Defaults secure_path="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin/"`

One line `WPX` install:

  `cd /usr/local/bin && wget https://raw.githubusercontent.com/majick777/wpx/master/wpx && chmod +x wpx`

One line config file install and edit (with nano):

  `cd /usr/local/bin && wget https://raw.githubusercontent.com/majick777/wpx/master/wpx.sample.conf && mv wpx.sample.conf wpx.conf && nano wpx.conf`


##### Required

You must set WordPress site paths in `wpx.conf` so that it knows where your WordPress installs are.
See `wpx.sample.conf` for more complete examples. Set the site configs (one per line) in the format:

```
site site-slug /full/path/to/wordpress/install/ user:group
```

* note: all `WP CLI` commands will run prefixed with 'sudo -u user' for the user specified!
* providing :group is optional (it is used with check/fix file owner/group commands)
* site paths prefixed with ! will use immutable core locking (see Core Lock section)

See `wpx.sample.conf` for more complete examples.

##### Optional

You can define source paths for use with file [**SYNC**] action commands (listed below.)
Set the source paths (one per line) in the format:

```
type source-slug /full/source/path/
```

* `type` can be either: plugin, theme, core, muplugin or dropin
* `source-slug` is a reference slug but is also used for the plugin/theme directory
  * advanced slug usage note: for plugins and themes, `source-slug` can be `dev-slug:real-slug`
  * (this means you can still sync an alternative development copy to its correct destination)
* muplugins type note: these are synced directly to the sites `/wp-content/mu-plugins/` directory
* dropins type note: these are synced *relative to the base install directory*
  * eg. to sync db-error.php to `/wp-content/` you would set the source to `/full/source/path/`
  * and then place the source file at `/full/source/path/wp-content/db-error.php`

See `wpx.sample.conf` for more complete examples.

##### Updating

Running `wpx updatecheck` will output the current version and check for an updated version of `WPX` on Github.
You can run `wpx updatescript` to update to the latest version of the script (you will need to confirm.)
Alternatively you can download the latest version manually and overwrite the existing file via FTP.

Also, here is a one-liner to update the script manually from shell (check your script path):

`cd /usr/local/bin && wget -Owpx https://raw.githubusercontent.com/majick777/wpx/master/wpx`

Note the contents and format of your `wpx.conf` configuration can remain unchanged between versions.
None of the other files in the package are required to be updated, just the main script.


### Usage 


**Important**: Since WPX attempts to run WP CLI commands as the user specified in your wpx.conf (via sudo),
so you will need to be logged in with `root` access to use WPX (to be able to `sudo -u user`)

```
wpx COMMAND SITE(S) SLUG(S)
```

* `COMMAND` is a command from the command action list below
* `SITE(S)` is a site reference slug defined in wpx.conf (may be a comma-separated list)
  * (note: if a site value of "all" is specified, the COMMAND will be run on EVERY site in wpx.conf)
* `SLUG(S)` is an optional reference to theme or plugin slugs (may be a comma-separated list)

For example, to install plugin with slug 'forcefield' on sites with slugs 'my-site' and 'my-other-site':

```
wpx installplugin my-site,my-other-site forcefield
```

or to install plugin with slugs 'forcefield' and 'wp-simple-firewall' on site with slug 'my-site':

```
wpx installplugin my-site forcefield,wp-simple-firewall
```

or to install and activate the plugin 'wp-simple-firewall' on all your sites:

```
wpx installactivateplugin all wp-simple-firewall
```

###### Careful with Commas

One of the main purposes and advantages of WPX is to be able to apply to multiple sites.
But remember, command line comma-separated lists are treated as *single arguments* and must contain *NO SPACES*.
For example, the space after comma here will break this list and attempt to install plugin 'my-other-site':

```
wpx installplugin my-site, my-other-site forcefield
``` 


### Commands


*Note*: [**SYNC**] commands use sources defined in your `wpx.conf`, all others use WordPress repository sources.

##### [**WPX**]

| `updatecheck`			| Check current version with latest updated version of `WPX` |
| `updatescript`		| Update to the latest updated version of `WPX` (confirmation prompted) |
| `showconfig`			| Table of matching SITES(s) or SOURCE(s) from wpx.conf (default: all) |
| `showsites`			| Table of matching SITE(S) from wpx.conf (default: all) |
| `showsources`			| Table of matching SOURCES(S) from wpx.conf (default: all) |
| `debuginfo`			| Run `wp --debug --info` on matching SITE(s) |
| `updatelist`			| Checks and lists core/theme/plugin updates on matching SITE(s) |

##### [**CORE**]

| `checkversion`		| Check installed WP Core version(s) on the SITE(s) specified |
| `verifycore`			| Verify WP Core(s) Checksums on SITE(s) (requires no WP errors) |
| `updatecore`			| Update to latest WP Core(s) on SITE(s) (version argument optional) |
| `installcore`			| Install WP Core(s) to SITE(s) (version and locale optional) |
| `reinstallcore`		| Reinstall WP Core(s) on SITE(s) (auto-matches version and locale) |
| `lockcore`			| Add the immutable lock to WP Core(s) files on SITE(s) |
| `unlockcore`			| Removes immutable lock from WP Core(s) files on SITE(s) |
| `checklock`			| Checks immutable switch on all WP Core files on SITE(s) |
| `checkowners`			| Checks all file owner/group match those in wpx.conf on SITE(s) |
| `fixowners`			| Change all file owner/group to those in wpx.conf on SITE(s) |

##### [**PLUGIN**]

| `listplugins`			| Check plugin(s) SLUG(s) for SITE(s) - status, version, updates |
| `verifyplugin`		| Verify checksums for plugin(s) SLUG(s) for SITE(s)
| `activateplugin`		| Activate plugin(s) SLUG(s) for SITE(s) |
| `deactivateplugin`		| Deactivate plugin(s) SLUG(s) for SITE(s) |
| `installplugin`		| Install plugin(s) SLUG(s) for SITE(s) |
| `installactivateplugin`	| Install and Activate plugin(s) SLUG(s) for SITE(s) |
| `reinstallplugin`     	| Reinstall plugin(s) SLUG(s) for SITE(s) |
| `updateplugin`		| Update plugin(s) SLUG(s) for SITE(s) |
| `updateallplugins`		| Update ALL plugins for SITE(s) |
| `rollbackplugin`		| Rollback plugin for SITE(s) (specify plugin-slug:version) |
| `deleteplugin`		| Deletes plugin(s) SLUG(s) for SITE(s) |
| `uninstallplugin`     	| Uninstall (deactivate/delete) plugins(s) SLUG(s) for SITES(s) |

##### [**THEME**]

| `listthemes`			| List installed themes on SITE(s) |
| `checktheme`			| Check active child and parent themes on SITE(s) |
| `activatetheme`		| Activate theme SLUG for SITE(s) |
| `installtheme`		| Install theme SLUG(s) for SITE(s) |
| `installactivatetheme`	| Install and Activate theme SLUG for SITE(s) |
| `reinstalltheme`		| Reinstall theme SLUG(s) for SITE(s) |
| `updatetheme`			| Update theme SLUG(s) for SITE(s) |
| `rollbacktheme`		| Rollback theme theme-slug:version for SITE(s) |


##### [**SYNC**]

| `synccore`			| Sync core SLUG for SITE(s) using wpx.conf |
| `syncplugin`			| Sync plugin SLUG(s) for SITE(s) using wpx.conf |
| `syncactivateplugin`		| Sync and activate plugin SLUG(s) for SITE(s) using wpx.conf |
| `synctheme`			| Sync theme SLUG for SITE(s) using wpx.conf |
| `syncactivatetheme`		| Sync and activate theme SLUG for SITE(s) wpx.conf |
| `syncmuplugin`		| Sync must-use plugin SLUG(s) for SITE(s) wpx.conf |
| `deletemuplugin`		| Delete matching must-use plugin SLUG(s) files for SITE(s) using wpx.conf |
| `syncdropin`			| Sync dropin (relative files) SLUG(s) for SITE(s) using wpx.conf |
| `deletedropin`		| Delete matching dropin SLUG(s) files for SITE(s) using wpx.conf |

##### [**LANGUAGE**]

| `installlanguage`		| Install language locale SLUG(s) on SITE(s) |
| `activatelanguage`		| Activate language locale SLUG on SITE(s) |
| `updatelanguage`		| Update language locale SLUG(s) on SITE(s) |
| `uninstalllanguage`		| Uninstall language locale SLUG(s) on SITE(s) |


##### Additional Arguments

The `updatecore`, `updateplugin` and `updatetheme` commands can take an additional version argument of either:
a specific version (must be an exact version), minor, patch, or major (default.)

The `listplugins` command will take plugin slugs and/or additional filters if specified *in the comma-separated plugin list*:
`plugin-slug`, `all` (default when nothing specified), `updates`, `actives`, `inactives`, `mustuses`, `dropins`

The `listthemes` command will take theme slugs and/or additional filters if specified *in the comma-separated theme list*:
`theme-slug`, `all` (default when nothing specified), `updates`, `actives`, `inactives`, `parents`, `childs`

###### Command Name Variations Okay!


**Plural Commands** Also For ease of use when typing on the command line (to prevent retyping), 
*most* singular plugin and theme action commands will also work in *plural* form, ie:

[**CORE**] `checkversions`, `verifycores`, `installcores`, `reinstallcores`, `updatecores`, `lockcores`, `unlockcores`, `checklocks`, `updatelists`

[**PLUGIN**] `checkplugins`, `verifyplugins`, `activateplugins`, `deactivateplugins`, `installplugins`, `installactivateplugins`, `reinstallplugins`, `updateplugins`

[**THEME**] `checkthemes`, `installthemes`, `reinstallthemes`, `updatethemes` (but *NOT* `activatethemes` or `installactivatethemes`)

[**SYNC**] `synccores`, `syncplugins`, `syncactivateplugins`, `syncthemes`, `syncmuplugins`, `deletemuplugins, `syncdropins`, `deletedropins` (but *NOT* `syncactivatethemes`)

[**LANGUAGE**] `installlanguages`, `updatelanguages`, `uninstalllanguages` (but *NOT* `activatelanguage`)


**Dashed and Underscored Commands** Also for ease of use, all command action variations work, whether without 
a space as listed in the command table above, *or* with command words separated with a dash or underscore:

```
updateplugin = update-plugin = update_plugin = updateplugins = update-plugins = update_plugins
```



### Core Lock


This is an optional extra security feature to help prevent hackers from rewriting any core WordPress files,
as this is a common place to hide injected code after a hack. Making these files immutable (read-only) means
that NO users can write to them (and only the root user can remove the immutable flags.) Be aware this approach has both advantages and disadvantages.

###### Advantage
Making your WordPress core files immutable is two steps beyond simple file monitoring or integrity checking, 
which require action *after the fact* and are often too late to prevent damage. As your core files simply 
*cannot* be changed and thus infected by malware, this gives one less attack vector for hackers to use. 

###### Disadvantage
If you decide to make your WordPress core files read-only this way, **you cannot run standard updates from 
the WordPress admin interface or with standard WP CLI or any other standard update method.** 
This will mean you will need to run core updates via WPX also - logged in as root user.
(Alternatively, unlock with WPX (as root), then update via whatever process, then relock with WPX.)

###### Usage
To use this feature, simply prefix a sitepath column in `wpx.conf` with `!` and run this to lock the files:

```
wpx lockcore my-site-slug
```

`WPX` will know to unlock before and then relock after ANY core commands that it runs. 
So for example, to update a site to the latest version, you can do simply:

```
wpx updatecore my-site-slug
```

###### What is Locked?
Specifically, all base files (`wp-config.php` etc.), and all files recursively in both `/wp-admin/` and 
`/wp-includes/` directories. `/wp-content/` and any of its subdirectories or files are *not* locked. So if you 
have dropins in `/wp-content/` (eg. `wp-cache.php` or `db-error.php`), or other static plugin or theme files,
you may want to lock these down manually (eg. `chattr +i db-error.php`.)

###### Alternative
If for whatever reason you decide not to use this feature, a similar but not *quite* as effective method
would be to use the `synccore` command via a regular cron job to overwrite any core file changes IF they 
happen. (This would instead mean keeping a core version source directory up-to-date to sync from.)


### FAQ

#### Why is the written in Shell and not a PHP Phar package or WP CLI extension?

A few reasons. First, it started as a simple Shell script wrapper to do some simple WP CLI management tasks...
I didn't have any intention of making it in any way a larger project. But as I added a few bits and it grew,
it became more of an exercise for me to learn more of the (so weird) Shell scripting syntax. I mostly write in 
PHP, and partly regret not just writing it all in that, but have learnt a lot in the process. So if it's a 
little clunky in places that's why - it's come from a trial and error learning process of writing easily 
understandable and well commented code (for myself first!) rather than coding for efficiency.

#### Couldn't you just use site @aliases for doing these kind of tasks?

To some extent, yes. But I wasn't even aware of site @alias support existed when I first started this project!
Ah silly me. But that aside, there are some advantages to having this available at the root level. Not having
to type `sudo -u user wp ...` to run as the correct user is one. Not having to be in the correct WordPress 
install directory or provide a `--path=` is another. Also saves time not having to look up the WPI CLI command
syntax and switches over and over knowing they are already in place.

But also, the Core Locking security feature requires root access to make files immutable. And having the 
`user(:group)` available allows for file permission checking/fixing, as well as for writing files with the 
correct permissions with the Source Syncing feature. As all of this grew out of this rather unique approach
to a different kind of development process, which provided the opportunity to add some cool little features
already - and to add more into the future - so I'm happy with where it went and what it can do. :-)


### Roadmap

The next phase of development for WPX will focus on supporting remote commands:

1. Run commands on sites remotely (via installed SSH keys) instead of just for local WordPress paths.

2. Similarly, allow for file syncing to remote sites from specified local sources via SSH.

3. Polish the handling of `wp-cli.yml` config files for use with `@alias` command line arguments.

(Limited experimental support for some of these is already in place but requires further development.)


### Contributing

Development for this project will be via GitHub Issues and Projects, and probably remain that way.

If you have any bugfixes, feature suggestions, you can [Submit an Issue](https://github.com/majick777/wpx/issues)

Help appreciated and code contributions are welcome, please [Submit a Pull Request](https://github.com/majick777/wpx/pulls)

Enjoy!


### Changelog

#### = 1.0.5 =
* added deletemuplugin command for removing synced mu-plugins
* added deletedropin command for removing synced dropins
* added verifyplugin command to check plugin and source plugin checksums
* added updatelist command for checking core/theme/plugin updates
* added theme list filtering capability
* added locale detection for verify core checksums command
* added --no-color switch to wp command for output success matching
* fix incorrect nesting on invalid source messages
* fix to set permissions for exact files for muplugins/dropins
* fix to add extra space suffix to YML ENV prefix
* fix to incorrect syncdropin command syntax

#### = 1.0.4 = 

* added updatecheck and updatescript commands for WPX updates
* added rollbackplugin and rollbacktheme commands
* added deletetheme command (with check for active parent/child)
* added single getoption command (with JSON format output)
* added support for syncing from zip and http zip sources
* fix missing installactivatetheme command trigger check
* fix missing showconfig and debuginfo to valid command help
* fix split commands to avoid Too many positional arguments error
* fix for split slugs in syncactivateplugin and syncactivatetheme
* fix to add missing wp-load.php to base file permission list
* fix to reinstall plugin to reactivate if it was active
* improve site config table listing and validate paths
* improve get script path (symlink compatible version)

#### = 1.0.3 =

* added plugin list filtering capability
* group active plugins/theme at top of lists
* output extra info for core version check
* check for core updates with core version check
* fix to plugin update command string

#### = 1.0.2 =

* set command string once (for DRY command reattempt usage)
* check commands against array list of possibile combinations
* change directory to site path instead of using wp --path=
* changed updateallplugins to use updateplugins all
* expand source data lines with read instead of ()
* allow splitting of theme/plugin source slugs (for dev versions)
* added show config command (output column formatted wpx.conf)
* added site@alias argument splitting (needs wp-cli.yml config)
* added setting wp-cli.yml path via wpx.conf (prototype)
* added reading of wp-cli.yml with aliases fix (prototype)
* added patch core updates by setting version argument to patch

#### = 1.0.1 =

* use single wpx.conf config instead of sources.conf and sites.conf
* added code comment lines to all functions and sections
* added column formatting for plugin and theme list output
* added core language commands (install/uninstall/activate/update)
* removed duplicate code for processing multiple/singular sources
* quoted all variables (and other minor fixes) to pass ShellCheck
* use exact array check function for actions instead of quick matching
* use exact slug match for theme column in theme check function
* allow minor core updates by setting version argument to minor

#### = 1.0.0 =

* added syncmuplugin and syncdropin commands
