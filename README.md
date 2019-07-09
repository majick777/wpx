
# WPX 

## WP CLI Multiplied!

> *You'll see your commands multiplied, if you continually decide,*
> *to faithfully pursue, the policy of root.*

### brought to you by WP Medic
Love this tool? [Become a WP Medic Patron](https://patreon.com/wpmedic)

[WPX Home](http://wpmedic.tech/wpx/) - [WPX GitHub](https://github.com/majick777/wpx/)

[WP CLI Home](http://wp-cli.org/) - [WP CLI Command Reference](https://developer.wordpress.org/cli/commands/)

***


### Introduction


WPX is shell script wrapper for running commands on multiple sites via the WordPress Command Line Interface ([WP CLI](http://wp-cli.org/)) 

This allows you to streamline repetitive tasks for core, plugin or themes:

* Installations, Reinstallations and Uninstallations
* Updates, Activations and Deactivations
* Combined Install/Activate or Deactivate/Uninstall

So that any action can process multiple resources and sites with a single command! :-D

Another main feature of WPX is **File Syncing**, giving you the ability to easily synchronize (via `rsync`) 
a local core, plugin, theme, must-use plugin or dropin source to any site(s) specified. 

This allows for much easier version control as well as faster distribution of bugfixes and other updates across 
a network of independent sites, giving for a better unified codebase without needing to use Multisite.

WPX also includes some nifty extra features:

* **Colourful Lists** - list core info, plugins and themes in a colourful (and filterable) display table.
* **Check Permissions** - find and fix rogue file permissions that do not match with the site owner:group.
* **Core Locking** - to make core files unwriteable to hackers (see Core Lock section for more details.)
* **Language Commmands** - to also install, uninstall, activate or update any locale language pack

##### Limitations

Currently WPX works to manage local sites on any single server, but not remote servers. 

The next phase of development will focus on allowing for running WP CLI commands to remote sites also (via SSH.)

See the Roadmap section for more details.



### Installation


0. (Install [WP CLI](http://wp-cli.org/) if not already installed. Or update it.)
1. Download the WPX ZIP file and extract it locally.
  * then upload `wpx` via FTP to `/usr/local/bin` (or other environment path used)
  * (if your FTP user is not root, login as root and `chown root:root /usr/local/bin/wpx`)
2. Or simply change to the environment path and then download it directly:
  * `cd /usr/local/bin` (making sure you are logged in as `root`)
  * `wget 'https://raw.githubusercontent.com/majick777/wpx/master/wpx'`
3. Create a `wpx.conf` config file in `~/.wp-cli/` (or in the environment path used)
  * (or just rename `wpx.sample.conf` to `wpx.conf` and then edit it)
4. Make it Executable: `chmod +x /usr/local/bin/wpx` (or other environment path used)
5. For the SYNC commands you need `rsync` installed (you probably already do):
  * [On Red Hat based systems]# yum install rsync 
  * [On Debian based systems]# apt-get install rsync 

##### Required

You must set WordPress site paths in wpx.conf (one per line) in the format:

```
site site-slug /full/path/to/wordpress/install/ user:group
```

* note: all WP CLI commands will run prefixed with 'sudo -u user' for the user specified!
* providing :group is optional (it is used with check/fix file owner/group commands)
* site paths prefixed with * will use immutable core locking (see Core Lock section)

##### Optional

You can define source paths for use with file [**SYNC**] action commands (listed below.)
Set the source paths (one per line) in the format:

```
type source-slug /full/source/path/
```

* `type` can be either: plugin, theme, core, muplugin or dropin
* `source-slug` is a reference slug but is also used for the plugin/theme directory
  * advanced slug usage note: for plugins and themes, `source-slug` can be `dev-slug:actual-slug`
  * (this means you can still sync an alternative development copy to its correct destination)
* muplugins type note: these are synced directly to the sites /wp-content/mu-plugins/ directory
* dropins type note: these are synced *relative to the base install directory*
  * eg. to sync db-error.php to /wp-content/ you would set the source to /full/source/path/
  * and then place the source file at /full/source/path/wp-content/db-error.php

##### Updating

Simply repeat installation step 1 to copy over the existing `wpx` file


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

###### Careful with Commas

One of the main purposes and advantages of WPX is to be able to apply to multiple sites.
But remember, command line comma-separated lists are single arguments and must contain *NO SPACES*.
For example, the space after comma here will break this list and attempt to install plugin 'my-other-site':

```
wpx installplugin my-site, my-other-site forcefield
``` 


### Commands


*Note*: [**SYNC**] commands use sources defined in `wpx.conf`, all others use WordPress repository sources.

##### [**CORE**]
| `checkversion`    | Check installed WP Core version(s) on the SITE(S) specified |
| `verifycore`		| Verify WP Core(s) Checksums on SITE(S) (requires no WP errors) |
| `updatecore`		| Update to latest WP Core(s) on SITE(S) (version argument optional) |
| `installcore`		| Install WP Core(s) to SITE(S) (version and locale optional) |
| `reinstallcore`	| Reinstall WP Core(s) on SITE(S) (auto-matches version and locale) |
| `lockcore`		| Add the immutable lock to WP Core(s) files on SITE(S) |
| `unlockcore`		| Removes immutable lock from WP Core(s) files on SITE(S) |
| `checklock`		| Checks immutable switch on all WP Core files on SITE(S) |
| `checkowners`		| Checks all file owner/group match those in wpx.conf on SITE(S) |
| `fixowners`		| Change all file owner/group to those in wpx.conf on SITE(S) |

##### [**PLUGIN**]
| `listplugins`		    | Check plugin(s) SLUG(S) for SITE(S) - status, version, updates |
| `activateplugin`	    | Activate plugin(s) SLUG(S) for SITE(S) |
| `deactivateplugin`	| Deactivate plugin(s) SLUG(S) for SITE(S) |
| `installplugin`		| Install plugin(s) SLUG(S) for SITE(S) |
| `installactivateplugin`	| Install and Activate plugin(s) SLUG(S) for SITE(S) |
| `reinstallplugin`     | Reinstall plugin(s) SLUG(S) for SITE(S |)
| `updateplugin`		| Update plugin(s) SLUG(S) for SITE(S) |
| `deleteplugin`		| Deletes plugin(s) SLUG(S) for SITE(S) |
| `uninstallplugin`     | Uninstall plugins(s) SLUG(S) for SITES(S) |
| `updateallplugins`	| Update ALL plugins for SITE(S) |

##### [**THEME**]
| `listthemes`		| List installed themes on SITE(S) |
| `checktheme`		| Check active child and parent themes on SITE(S) |
| `activatetheme`	| Activate theme SLUG for SITE(S) |
| `installtheme`	| Install theme SLUG(S) for SITE(S) |
| `installactivatetheme`	| Install and Activate theme SLUG for SITE(S) |
| `reinstalltheme`	| Reinstall theme SLUG(S) for SITE(S) |
| `updatetheme`		| Update theme SLUG(S) for SITE(S) |

##### [**SYNC**]
| `synccore`		| Sync core SLUG for SITE(S) using wpx.conf |
| `syncplugin`		| Sync plugin SLUG(S) for SITE(S) using wpx.conf |
| `syncactivateplugin`	| Sync and activate plugin SLUG(S) for SITE(S) using wpx.conf |
| `synctheme`		| Sync theme SLUG for SITE(S) using wpx.conf |
| `syncactivatetheme`	| Sync and activate theme SLUG for SITE(S) wpx.conf |
| `syncmuplugin`	| Sync must-use plugin SLUG(S) for SITE(S) wpx.conf |
| `syncdropin`		| Sync dropin (relative files) SLUG(S) for SITE(S) using wpx.conf |

##### [**LANGUAGE**]
| `installlanguage`		| Install language locale SLUG(S) on SITE(S) |
| `activatelanguage`	| Activate language locale SLUG on SITE(S) |
| `updatelanguage`		| Update language locale SLUG(S) on SITE(S) |
| `uninstalllanguage`	| Uninstall language locale SLUG(S) on SITE(S) |


##### Additional Arguments

The `updatecore`, `updateplugin` and `updatetheme` commands can take an additional version argument of either:
a specific version (must be exact), minor, patch, or major (default.)

The `listplugins` command will take additional filters if specified *in the comma-separated plugin list*:
`all` (default when no list specified), `updates`, `actives`, `inactives`, `mustuses`, `dropins`


###### Command Name Variations Okay!


**Plural Commands** Also For ease of use when typing on the command line (to prevent retyping), 
*most* singular plugin and theme action commands will also work in *plural* form, ie:

[**CORE**] `checkversions`, `verifycores`, `installcores`, `reinstallcores`, `updatecores`, `lockcores`, `unlockcores`, `checklocks`

[**PLUGIN**] `checkplugins`, `activateplugins`, `deactivateplugins`, `installplugins`, `installactivateplugins`, `reinstallplugins`, `updateplugins`

[**THEME**] `checkthemes`, `installthemes`, `reinstallthemes`, `updatethemes` (but *NOT* `activatethemes` or `installactivatethemes`)

[**SYNC**] `synccores`, `syncplugins`, `syncactivateplugins`, `syncthemes`, `syncmuplugins`, `syncdropins` (but *NOT* `syncactivatethemes`)

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
To use this feature, simply prefix any sitepath(s) in wpx.conf with * and run this to lock the files:

```
wpx lockcore my-site-slug
```

WPX will attempt to unlock before and then relock after ANY core commands that it runs. 
So for example, to update a site to the latest version, you can do simply:

```
wpx updatecore my-site-slug
```

###### What is Locked?
Specifically, all base files (`wp-config.php` etc.), and all files recursively in both `/wp-admin` and 
`/wp-includes` directories. `/wp-content` and any of its subdirectories or files are *not* locked. So if you 
have dropins in `/wp-content/` (eg. `wp-cache.php` or `db-error.php`), or other static plugin or theme files,
you may want to lock these down manually (eg. `chattr +i db-error.php`.)

###### Alternative
If for whatever reason you decide not to use this feature, a similar but not *quite* as effective method
would be to use the `synccore` command via a regular cron job to overwrite any core file changes IF they 
happen. (This would instead mean keeping a core version source directory up-to-date to sync from.)


### Roadmap


The next phase of development for WPX will focus on implementing remote commands:

1. Run commands on sites remotely (via installed SSH keys) instead of just for local WordPress paths.

2. Similarly, allow for file syncing to remote sites from specified local sources via SSH.

3. Polish the handling of `wp-cli.yml` config files for use with `@alias` command line arguments.

A more detailed list of Development TODOs is at the top of the main `wpx` file (for ease of development.)

If you have any suggestions for future features, or code contributions, you can [Submit an Issue or Pull Request on Github](https://github.com/majick777/wpx/)

Bug reports and support requests can be submitted via the [WPX Support Forum](http://wordquest.org/support/wpx/)
