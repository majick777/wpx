#!/bin/bash

# ================================ #
# === WPX - WP CLI Multiplied! === #
# ================================ #
# ========= Version 1.0.2 ======== #
# ================================ #
#
# "You'll see your commands multiplied, if you continually decide, 
# to faithfully pursue, the policy of root."
#
# WPX Home: http://wpmedic.tech/wpx/
# WPX GitHub: https://github.com/majick777/wpx/
#
# WP CLI Home: http://wp-cli.org/
# WP CLI Command Reference: https://developer.wordpress.org/cli/commands/


# --------------------
# === INSTALLATION ===
# --------------------
# 0. (Install WP CLI if not already installed. http://wp-cli.org/) 
# 1. Copy wpx to /usr/local/bin/ (or other environment path used)
# 2. chmod +x /usr/local/bin/wpx (or other environment path used)
# 3. Create a wpx.conf in ~/.wp-cli/ (or in environment path used)
# (or copy wpx.sample.conf to wpx.conf and edit it)

# [Required] Set WordPress site paths in wpx.conf
# site site-slug /full/path/to/wordpress/install/ user:group
# -- all WP CLI commands will run prefixed with 'sudo -u user' for the user specified!
# -- providing :group is optional (used with check/fix file owners commands)
# -- site paths prefixed with * will use immutable core locking (see below explanation)

# [Optional] Define source directories for file syncing.
# These are for use with all the "SYNC" action commands (listed below.)
# Format is one source per line:
# type source-slug /full/source/path/
# -- where 'type' is either: plugin, theme, core, muplugin or dropin
# -- (dropins can be any file relative to the base install directory)

# ----------------
# === UPDATING ===
# ----------------
# Simply repeat step 1 to copy over the existing wpx file
# (If you deleted wpx you will need to repeat step 2 to ensure it is executable.)


# -------------
# === USAGE ===
# -------------
#
# Important: Since WPX attempts to run WP CLI commands as the user specified in your wpx.conf (via sudo),
# - so you will need to be logged in with root access to use WPX (or as someone who can sudo -u user)
#
# wpx COMMAND SITE(S) SLUG(S)
#
# - COMMAND is a command from the action list below
# - SITE(S) is a site reference slug defined in wpx.conf (may be a comma-separated list)
# (note: if a site value of "all" is specified, the COMMAND will be run on EVERY site in wpx.conf)
# - SLUG(S) is an optional reference to theme or plugin slugs (may be a comma-separated list)
#
# For example, to nstall plugin with slug 'forcefield' on sites with slugs 'my-site' and 'my-other-site':
# wpx installplugin my-site,my-other-site forcefield
#
# or to install plugin with slugs 'forcefield' and 'wp-simple-firewall' on site with slug 'my-site':
# wpx installplugin my-site forcefield,wp-simple-firewall
#
# Remember, one of the main purposes and advantages of WPX is to be able to apply to multiple sites
# (also multiple plugins and themes) - but comma-separated lists must contain no spaces:
# wpx installplugin my-site, my-other-site forcefield
# --------------------------^ space will break site list and attempt to install a plugin 'my-other-site'
#


# ----------------
# === COMMANDS ===
# ----------------
# Note: [SYNC] commands use sources defined in wpx.conf, all others use WordPress repository sources.
#
# [CORE]	checkversion		Check installed WP Core version(s) on the SITE(S) specified
#		verifycore		Verify WP Core(s) Checksums on SITE(S) (requires no WP errors)
#		updatecore		Update to latest WP Core(s) on SITE(S) (version argument optional)
#		installcore		Install WP Core(s) to SITE(S) (version and locale optional)
#		reinstallcore		Reinstall WP Core(s) on SITE(S) (auto-matches version and locale)
#		lockcore		Add the immutable lock to WP Core(s) files on SITE(S)
#		unlockcore		Removes immutable lock from WP Core(s) files on SITE(S)
#		checklock		Checks immutable switch on all WP Core files on SITE(S)
#		checkowners		Checks all file owner/group match those in wpx.conf on SITE(S)
#		fixowners		Change all file owner/group to those in wpx.conf on SITE(S)
#		installlanguage		Install core language LANGUAGE(S) on SITE(S)
#		uninstalllanguage	Uninstall core language LAGUAGE(S) on SITE(S)
#		updatelanguage		Update core language LOCALE(S) on SITE(S)
#		activatelanguage	Activate core language LOCALE on SITE(S)
# [PLUGIN]	listplugins		Now an alias of checkplugin (re-formatted table) - default 'all'
#		checkplugin		Check plugin(s) SLUG(S) for SITE(S) - status, version, updates	
#		activateplugin		Activate plugin(s) SLUG(S) for SITE(S)
#		deactivateplugin	Deactivate plugin(s) SLUG(S) for SITE(S)
#		installplugin		Install plugin(s) SLUG(S) for SITE(S)
#		installactivateplugin	Install and Activate plugin(s) SLUG(S) for SITE(S)
#		reinstallplugin		Reinstall plugin(s) SLUG(S) for SITE(S)
#		updateplugin		Update plugin(s) SLUG(S) for SITE(S)
#		deleteplugin		Deletes plugin(s) SLUG(S) for SITE(S)
#		uninstallplugin		Uninstall plugins(s) SLUG(S) for SITES(S)
#		updateallplugins	Update ALL plugins for SITE(S)
# [THEME]	listthemes		List installed themes on SITE(S)
#		checktheme		Check active child and parent themes on SITE(S)	
#		activatetheme		Activate theme SLUG for SITE(S)
#		installtheme		Install theme SLUG(S) for SITE(S)
#		installactivatetheme	Install and Activate theme SLUG for SITE(S)
#		reinstalltheme		Reinstall theme SLUG(S) for SITE(S)
#		updatetheme		Update theme SLUG(S) for SITE(S)
# [SYNC]	synccore		Sync core SLUG for SITE(S) using wpx.conf
#		syncplugin		Sync plugin SLUG(S) for SITE(S) using wpx.conf
#		syncactivateplugin	Sync and activate plugin SLUG(S) for SITE(S) using wpx.conf
#		synctheme		Sync theme SLUG for SITE(S) using wpx.conf
#		syncactivatetheme	Sync and activate theme SLUG for SITE(S) wpx.conf
#		syncmuplugin		Sync must-use plugin SLUG(S) for SITE(S) wpx.conf
#		syncdropin		Sync dropin (relative files) SLUG(S) for SITE(S) using wpx.conf
# [LANGUAGE]	installlanguage		Install language locale SLUG(S) on SITE(S)
#		activatelanguage	Activate language locale SLUG on SITE(S)
#		updatelanguage		Update language locale SLUG(S) on SITE(S)
#		uninstalllanguage	Uninstall language locale SLUG(S) on SITE(S)
#		
# Note: For ease of use, MOST singular plugin and theme commands will also work in plural form, ie:
# [CORE]	checkversions, verifycores, installcores, reinstallcores, updatecores, lockcores, unlockcores, checklocks
# [PLUGIN]	checkplugins, activateplugins, deactivateplugins, installplugins, installactivateplugins, reinstallplugins, updateplugins
# [THEME]	checkthemes, installthemes, reinstallthemes, updatethemes (but NOT activatethemes or installactivatethemes)
# [SYNC]	synccores, syncplugins, syncactivateplugins, syncthemes, syncmuplugins, syncdropins (but NOT syncactivatethemes)
# [LANGUAGE]	installlanguages, updatelanguages, uninstalllanguages (but NOT activatelanguage)

# ------------------------
# == Core File Locking ===
# ------------------------
# This is an optional extra security feature to help prevent hackers from rewriting any core WordPress files,
# as this is a common place to hide injected code after a hack. Making these files immutable (read-only) means
# that NO users can write to them (and only root user can remove the immutable flags.)
#
# Important Note: this feature does NOT affect plugin or theme files, ONLY WordPress core files.
# (Specifically, locking for all base files (wp-config.php etc.), and recursively for both /wp-admin and 
# /wp-includes directories - but not /wp-content or any of its subdirectories or files. So if you have
# core files in /wp-content/ (eg. wp-cache.php or db-error.php) you may want to lock these manually.)
#
# Of course, if you decide to make your core files read-only this way, you cannot run standard updates from 
# the WordPress admin interface or with standard WP CLI or any other standard way of triggering updates.
# This will mean you will need to run core updates via WPX - logged in as root user to 
# (Alternatively, unlock with WPX (as root), then update via whatever process, then relock with WPX.)
#
# To use this feature, simply prefix any sitepaths in wpx.conf with * and run this lock the files:
# wpx lockcore mysiteslug
#
# WPX will attempt to unlock before and then relock after ANY core commands that it runs. 
# So for example, to update a site to the latest version, you can do simply:
# wpx updatecore mysiteslug
#
# This might seem like a hassle to begin with. BUT, do consider the advantage of not having writeable core 
# files..! It is two steps beyond simple file monitoring or integrity checking, as your core files simply 
# cannot be infected by malware, which is one less attack vector for hackers to use. :-)
# 
# Note: If for whatever reason you cannot use this feature, a similar method - but not *quite* as effective - 
# would be to use the wpx synccore command via a regular Cron job to overwrite any core file changes IF they
# happen. (This would mean keeping a core version source directory up-to-date to sync from.)
#
# Of course in any case, if you are working in a team, best to discuss these options before implementation!

# ----------------
# === EXAMPLES ===
# ----------------
# TODO: more WPX command examples...


# -----------------
# Development TODOs
# -----------------
# Ref: https://make.wordpress.org/cli/handbook/config/
# * allow for use of @alias in combination with site slug
# ** lockcore, unlockcore
# -> updatecore, installcore (->reinstallcore)
# -> checkowners, fixowners
# * allow for SSH site path syncing
# -> installcore (->reinstallcore)
# -> all sync commands
#
# - add updatelist command (list core/plugins/themes updates for site)
# - backup old plugin to restore on install/update failure
# - plugin and theme version paramaters
# ? add plugin and theme rollback functions ?
# ? add downgradecore to WP version function ?
# ? handle alternate zip and http:// sources ? 
#
# ? define SUCCESS value for:
# -- verifycore, installcore, updatecore
# -- updateallplugins
# -- installlanguage, activatelanguage, updatelanguage, uninstalllanguage

# ----- #
# SETUP #
# ----- #

# debug command output
set +x

# declare some globals
CWD=$(pwd)
RESULT=""
INARRAY=""
REINSTALL=""
DEBUG="false"

# ------------------ #
# Valid Command List #
# ------------------ #
function validcommands {
	red "Valid Commands"; echo ":"
	printf "["; yellow "CORE"; echo "] checkversion, verifycore, installcore, reinstallcore, updatecore, lockcore, unlockcore, checklock, checkowners, fixowners"
	printf "["; yellow "PLUGIN"; echo "] listplugin, checkplugin, activateplugin, deactivateplugin, installplugin, installactivateplugin, reinstallplugin, updateplugin, updateallplugins, deleteplugin"
	printf "["; yellow "THEME"; echo "] listthemes, checktheme, activatetheme, installtheme, installactivatetheme, reinstalltheme, updatetheme"
	printf "["; yellow "SYNC"; echo "] syncplugin, syncactivateplugin, syncmuplugin, synctheme, syncactivatetheme, syncmuplugin, syncdropin"
	printf "["; yellow "LANGUAGE"; echo "] installlanguage, activatelanguage, updatelanguage, uninstalllanguage"
}

# ------- #
# Colours #
# ------- #
black() { printf "$(tput setaf 0)$*$(tput setaf 9)"; }
red() { printf "$(tput setaf 1)$*$(tput setaf 9)"; }
green() { printf "$(tput setaf 2)$*$(tput setaf 9)"; }
yellow() { printf "$(tput setaf 3)$*$(tput setaf 9)"; }
blue() { printf "$(tput setaf 4)$*$(tput setaf 9)"; }
magenta() { printf "$(tput setaf 5)$*$(tput setaf 9)"; }
cyan() { printf "$(tput setaf 6)$*$(tput setaf 9)"; }
white() { printf "$(tput setaf 7)$*$(tput setaf 9)"; }

# ------------ #
# Check Result #
# ------------ #
function checkresult {

	local OUTPUT; local SUCCESS; local TYPE
	OUTPUT=$1; SUCCESS=$2; TYPE=$3
	
	# - set already done check strings -
	# TODO: maybe set more "already done" strings ?
	if [ "$TYPE" == 'install' ]; then ALREADY="already installed"; fi
	if [ "$TYPE" == 'activate' ]; then ALREADY="already activated"; fi
	
	# TODO: if [[ "$OUTPUT" == *"Error"* ]]; then
	
		# if [[ "$OUTPUT" == *"PHP Parse Error"* ]]; then
		#	echo "";		
		# fi
	
		if [[ "$OUTPUT" == *"Error establishing a database connection"* ]]; then

			# TODO: check mysql service status ?
			# STATUS=$(netstat -vulntp | grep -i mysql)
			# if [ -z "$STATUS" ]; then
				yellow "**"; echo " Restarted MySQL Server... Redoing..."
				RESTART=$(service mysql restart)
				echo "$RESTART"			
			# fi			
					
			RESULT="failed"
		fi
		
	# fi;
	
	# if [ -z "$SUCCESS ]"; then
		if [[ "$OUTPUT" == *"$SUCCESS"* ]]; then 
			RESULT="success"
		else 
			if [[ "$OUTPUT" == *"$ALREADY"* ]]; then 
				RESULT="success"
			else 
				RESULT="failed"
			fi
		fi
	# fi
	
}

# ---------------------- #
# Create (Command) Array #
# ---------------------- #
function createarray {

	ARRAY=()	
	ARRAY[0]="$1""$2"
	ARRAY[1]="$1""$2""s"
	ARRAY[2]="$1""_""$2"
	ARRAY[3]="$1""_""$2""s"
	ARRAY[4]="$1""-""$2"
	ARRAY[5]="$1""-""$2""s"
	ARRAY[6]="$2""$1"
	ARRAY[7]="$2""s""$2"
	ARRAY[8]="$2""_""$1"
	ARRAY[9]="$2""s_""$1"
	ARRAY[10]="$2""-""$1"
	ARRAY[11]="$2""s-""$2"
	
	if [ -n "$3" ] && [ -n "$4" ]; then
		ARRAY[12]="$3""$4"
		ARRAY[13]="$3""$4""s"
		ARRAY[14]="$3""_""$4"
		ARRAY[15]="$3""_""$4""s"
		ARRAY[16]="$3""-""$4"
		ARRAY[17]="$3""-""$4""s"
		ARRAY[18]="$4""$3"
		ARRAY[19]="$4""s""$3"
		ARRAY[20]="$4""_""$3"
		ARRAY[21]="$4""s_""$4"
		ARRAY[22]="$4""-""$3"
		ARRAY[23]="$4""s-""$3"
	fi
}

# -------------------------- #
# Check for Element in Array # 
# -------------------------- #
function checkarray {
	local MATCH; MATCH=$1; INARRAY=""
	for ELEMENT in "${ARRAY[@]}"; do
		if [[ "$ELEMENT" == "$MATCH" ]]; then 
			INARRAY="1"; echo "1"; return
		fi
	done
}
function checkarraydebug {
	local MATCH; MATCH=$1; INARRAY=""
	for ELEMENT in "${ARRAY[@]}"; do
		white "$ELEMENT"" - ""$MATCH"
		if [[ "$ELEMENT" == "$MATCH" ]]; then 
			white " (MATCHED)"
			INARRAY="1"; return
		fi
		echo ""
	done
}


# -------------------- #
# === YAML HELPERS === #
# -------------------- #

# ------------- #
# Fix YAML File #
# ------------- #
function fix_yaml {
	
	LINES=$(cat "$1")
	while IFS= read -r -a LINE || [ -n "$LINE" ]; do
		TESTLINE=$(echo "$LINE" | awk '{$1=$1;print}')
		CHAR="${TESTLINE:0:1}"
		if [ ! "$CHAR" == "#" ]; then
			if [ "$CHAR" == "@" ] || [ "$CHAR" == "~" ]; then
				echo "alias_""${TESTLINE:1}"
			else
				CHARS="${TESTLINE:0:3}"
				if [ "$CHARS" == "- @" ]; then
					echo " - alias_""${TESTLINE:3}"
				else
					echo "$LINE"
				fi
			fi
		fi
	done <<< "$LINES"
}

# --------------- #
# Parse YAML File #
# --------------- #
# ref: https://stackoverflow.com/a/51789677/5240159
# source: https://github.com/mrbaseman/parse_yaml.git
function parse_yaml {

   local prefix=$2
   local separator=${3:-_}
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=${fs:-$(echo @|tr @ '\034')} i=${i:-  }
     
   cat $1 | \
   awk -F$fs "{multi=0; 
       if(match(\$0,/$s\|$s\$/)){multi=1; sub(/$s\|$s\$/,\"\");}
       if(match(\$0,/$s>$s\$/)){multi=2; sub(/$s>$s\$/,\"\");}
       while(multi>0){
           str=\$0; gsub(/^$s/,\"\", str);
           indent=index(\$0,str);
           indentstr=substr(\$0, 0, indent-1) \"$i\";
           obuf=\$0;
           getline;
           while(index(\$0,indentstr)){
               obuf=obuf substr(\$0, length(indentstr)+1);
               if (multi==1){obuf=obuf \"\\\\n\";}
               if (multi==2){
                   if(match(\$0,/^$s\$/))
                       obuf=obuf \"\\\\n\";
                       else obuf=obuf \" \";
               }
               getline;
           }
           sub(/$s\$/,\"\",obuf);
           multi=0;
           if(match(\$0,/$s\|$s\$/)){multi=1; sub(/$s\|$s\$/,\"\");}
           if(match(\$0,/$s>$s\$/)){multi=2; sub(/$s>$s\$/,\"\");}
       }
   print}" | \
   sed  -e "s|^\($s\)?|\1-|" \
       -ne "s|^$s#.*||;s|$s#[^\"']*$||;s|^\([^\"'#]*\)#.*|\1|;t1;t;:1;s|^$s\$||;t2;p;:2;d" | \
   sed -ne "s|,$s\]$s\$|]|" \
        -e ":1;s|^\($s\)\($w\)$s:$s\(&$w\)\?$s\[$s\(.*\)$s,$s\(.*\)$s\]|\1\2: \3[\4]\n\1$i- \5|;t1" \
        -e "s|^\($s\)\($w\)$s:$s\(&$w\)\?$s\[$s\(.*\)$s\]|\1\2: \3\n\1$i- \4|;" \
        -e ":2;s|^\($s\)-$s\[$s\(.*\)$s,$s\(.*\)$s\]|\1- [\2]\n\1$i- \3|;t2" \
        -e "s|^\($s\)-$s\[$s\(.*\)$s\]|\1-\n\1$i- \2|;p" | \
   sed -ne "s|,$s}$s\$|}|" \
        -e ":1;s|^\($s\)-$s{$s\(.*\)$s,$s\($w\)$s:$s\(.*\)$s}|\1- {\2}\n\1$i\3: \4|;t1" \
        -e "s|^\($s\)-$s{$s\(.*\)$s}|\1-\n\1$i\2|;" \
        -e ":2;s|^\($s\)\($w\)$s:$s\(&$w\)\?$s{$s\(.*\)$s,$s\($w\)$s:$s\(.*\)$s}|\1\2: \3 {\4}\n\1$i\5: \6|;t2" \
        -e "s|^\($s\)\($w\)$s:$s\(&$w\)\?$s{$s\(.*\)$s}|\1\2: \3\n\1$i\4|;p" | \
   sed  -e "s|^\($s\)\($w\)$s:$s\(&$w\)\(.*\)|\1\2:\4\n\3|" \
        -e "s|^\($s\)-$s\(&$w\)\(.*\)|\1- \3\n\2|" | \
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\(---\)\($s\)||" \
        -e "s|^\($s\)\(\.\.\.\)\($s\)||" \
        -e "s|^\($s\)-$s[\"']\(.*\)[\"']$s\$|\1$fs$fs\2|p;t" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p;t" \
        -e "s|^\($s\)-$s\(.*\)$s\$|\1$fs$fs\2|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\?\(.*\)$s\$|\1$fs\2$fs\3|" \
        -e "s|^\($s\)[\"']\?\([^&][^$fs]\+\)[\"']$s\$|\1$fs$fs$fs\2|" \
        -e "s|^\($s\)[\"']\?\([^&][^$fs]\+\)$s\$|\1$fs$fs$fs\2|" \
        -e "s|$s\$||p" | \
   awk -F$fs "{
      gsub(/\t/,\"        \",\$1);
      if(NF>3){if(value!=\"\"){value = value \" \";}value = value  \$4;}
      else {
        if(match(\$1,/^\&/)){anchor[substr(\$1,2)]=full_vn;getline};
        indent = length(\$1)/length(\"$i\");
        vname[indent] = \$2;
        value= \$3;
        for (i in vname) {if (i > indent) {delete vname[i]; idx[i]=0}}
        if(length(\$2)== 0){  vname[indent]= ++idx[indent] };
        vn=\"\"; for (i=0; i<indent; i++) { vn=(vn)(vname[i])(\"$separator\")}
        vn=\"$prefix\" vn;
        full_vn=vn vname[indent];
        if(vn==\"$prefix\")vn=\"$prefix$separator\";
        if(vn==\"_\")vn=\"__\";
      }
      assignment[full_vn]=value;
      if(!match(assignment[vn], full_vn))assignment[vn]=assignment[vn] \" \" full_vn;
      if(match(value,/^\*/)){
         ref=anchor[substr(value,2)];
         for(val in assignment){
            if(index(val, ref)==1){
               tmpval=assignment[val];
               sub(ref,full_vn,val);
               if(match(val,\"$separator\$\")){
                  gsub(ref,full_vn,tmpval);
               } else if (length(tmpval) > 0) {
                  printf(\"%s=\\\"%s\\\"\n\", val, tmpval);
               }
               assignment[val]=tmpval;
            }
         }
      } else if (length(value) > 0) {
         printf(\"%s=\\\"%s\\\"\n\", full_vn, value);
      }
   }END{
      asorti(assignment,sorted);
      for(val in sorted){
         if(match(sorted[val],\"$separator\$\"))
            printf(\"%s=\\\"%s\\\"\n\", sorted[val], assignment[sorted[val]]);
      }
   }"
}

# -------------- #
# Load YAML File #
# -------------- #
function load_yaml {

	# - fix @ symbols (for parsing site aliases) -
	FIXED=$(fix_yaml "$YMLPATH")
	if [ "$DEBUG" == "true" ]; then white "$YMLPATH"; echo " Contents:"; echo "$FIXED"; fi
		
	# - parse the fixed YAML data -
	PARSED=$(parse_yaml <<< "$FIXED")
	if [ "$DEBUG" == "true" ]; then echo ""; echo "Parsed Contents: "; echo "$PARSED"; fi
	
	# - load parsed data as variables -
	eval "$PARSED"
	
	# TODO: load inherited and reload YAML ?
	if [ -n "$___inherit" ]; then
		# if [ "$DEBUG" == "true" ]; then echo "$___inherit"; fi
		echo "Inherit TML Config File: ""$___inherit"
	fi	
}


# --------------------- #
# === CORE COMMANDS === #
# --------------------- #

# ---------- #
# Debug Info #
# ---------- #
function wpdebug {

	OUTPUT=$("$WP" --debug --info)
	echo "$OUTPUT"
}

# ------------- #
# Check Version #
# ------------- #
function checkversion {
	
	# - get core version -
	# local VERSIONPATH; local VERSION
	# VERSIONPATH="$SITEPATH""wp-includes/version.php"
	# VERSION=$(grep -m 1 "wp_version = " "$VERSIONPATH" | cut -d \' -f2)
	VERSION=$("$WP" core version --extra | grep "WordPress version:" | cut -d " " -f3)

	# - output core version -
	green "$SITENAME"; printf " : WordPress version "; yellow "$VERSION"; echo "";
}

# ----------- #
# Verify Core #
# ----------- #
function verifycore {

	# TODO: define SUCCESS for verify checksums?
	# SUCCESS=""

	# - get core version -
	# local VERSIONPATH; local VERSION
	# VERSIONPATH="$SITEPATH""wp-includes/version.php"
	# VERSION=$(grep -m 1 "wp_version = " "$VERSIONPATH" | cut -d \' -f2)
	VERSION=$("$WP" core version --extra | grep "WordPress version:" | cut -d " " -f3)

	# - output verify checksum message -
	yellow "***"; printf " Verifying core checksums for "; green "$SITENAME"; printf " (WP "; yellow "$VERSION"; echo ")"
	
	# - set command and execute -
	COMMAND="sudo -u ""$SITEUSER"" ""$WP"" core verify-checksums --version=""$VERSION"" --skip-plugins"
	OUTPUT=$("$COMMAND")
	
	# - check result and maybe try again -
	checkresult "$OUTPUT"
	if [ "$RESULT" == "failed" ]; then OUTPUT=$("$COMMAND"); fi

	echo "$OUTPUT"
}


# ----------- #
# Update Core #
# ----------- #
function updatecore {
	
	local VERSION=$1

	# TODO: define SUCCESS for core update ?
	SUCCESS=""
	
	# - maybe unlock core -
	if [ "$SITELOCKING" == "true" ]; then unlockcore; fi
	
	# - attempt core update -
	if [ -n "$VERSION" ]; then
		if [ "$VERSION" == "minor" ] || [ "$VERSION" == "patch" ]; then
			# - update to minor/patch version
			yellow "***"; printf " Updating core on "; green "$SITENAME"; printf "("; yellow "$VERSION"; echo " only)..."
			COMMAND="sudo -u ""$SITEUSER"" ""$WP"" core update --skip-plugins --""$VERSION"
		else
			# - force update to specific version -
			yellow "***"; printf " Updating core on "; green "$SITENAME"; printf " to Version "; yellow "$VERSION"; echo "..."
			COMMAND="sudo -u ""$SITEUSER"" ""$WP"" core update --skip-plugins --version=""$VERSION"" --force"
		fi
	else
		# - update to latest version -
		yellow "***"; printf " Updating core on "; green "$SITENAME"; echo "..."
		COMMAND="sudo -u ""$SITEUSER"" ""$WP"" core update --skip-plugins"	
	fi
	
	# - execute command -
	OUTPUT=$("$COMMAND")
	
	# - maybe try again -
	checkresult "$OUTPUT" "$SUCCESS"
	if [ "$RESULT" == "failed" ]; then OUTPUT=$("$COMMAND"); fi
	
	echo "$OUTPUT"
	
	# - maybe relock core -
	if [ "$SITELOCKING" == "true" ]; then lockcore; fi
}
