#!/bin/bash
# ------------------------------------------------------------------
# dbraley cyber-dojo-import.sh 
#          Import cyber-dojo.org export zips as into local git repo
#
# Script template provided by: 
#          https://github.com/RenatGilmanov/shell-script-template
# ------------------------------------------------------------------

SUBJECT=cyber-dojo-import
VERSION=0.1.0
USAGE="Usage: command -hv -z zipFile -d directory -e exercise_name"

# --- Option processing --------------------------------------------
if [ $# == 0 ] ; then
    echo $USAGE
    exit 1;
fi

while getopts ":vhz:d:e:" optname
  do
    case "$optname" in
      "v")
        echo "Version $VERSION"
        exit 0;
        ;;
      "h")
        echo $USAGE
        exit 0;
        ;;
      "z")
	zip=$OPTARG
	echo "using zip ${zip}" >&2
	;;
      "d")
	directory=$OPTARG
	echo "using directory ${directory}" >&2
	;;
      "e")
	actual_exercise=$OPTARG
	echo "renaming exercise as ${actual_exercise}" >&2
	;;
      "?")
        echo "Unknown option $OPTARG"
        exit 0;
        ;;
      ":")
        echo "No argument value for option $OPTARG"
        exit 0;
        ;;
      *)
        echo "Unknown error while processing options"
        exit 0;
        ;;
    esac
  done

shift $(($OPTIND - 1))

# -----------------------------------------------------------------

LOCK_FILE=/tmp/${SUBJECT}.lock

if [ -f "$LOCK_FILE" ]; then
echo "Script is already running"
exit
fi

# -----------------------------------------------------------------
trap "rm -f $LOCK_FILE" EXIT
touch $LOCK_FILE 

if [ ! -z ${zip+x} ]
then
	echo "Script can't currently take zips, sorry. Unzip manually and provide the top level directory to script with -d"
	exit 0
fi

if [ -z ${directory+x} ]
then
	echo "Need a directory to function"
	exit 1
fi

if [ ! -e $directory ]
then
	echo "provided directory $directory does not exist"
	exit 1
fi
if [ ! -d $directory ]
then
        echo "provided directory $directory is not actually a directory"
        exit 1
fi

parent_dirname=`dirname $directory`
top_dirname=`basename $directory`

sub_dirname=$(basename `ls -d $parent_dirname/$top_dirname/*/`)


if (( $(echo $sub_dirname | wc -w) > 1 ))
then
	echo "we got a problem, expected one subdirectory under $top_dirname, found: $sub_dirname"
	exit 1
fi

echo "Using $parent_dirname / $top_dirname / $sub_dirname"

language=`jq -Mr ".language" ${parent_dirname}/${top_dirname}/${sub_dirname}/manifest.json`
exercise=`jq -Mr ".exercise" ${parent_dirname}/${top_dirname}/${sub_dirname}/manifest.json`

echo "Identified kata $exercise in $language"

animals=$(basename `ls -d $parent_dirname/$top_dirname/$sub_dirname/*/`)
echo "I found $(echo $animals | wc -w) animals:"

if [[ "${actual_exercise}x" = "x" ]]
then
	dest=~/source/katas/$language/$exercise
else
	dest=~/source/katas/$language/$actual_exercise
fi
mkdir -p $dest

echo $animals
for animal in $animals
do
	echo
	echo "starting processing $animal"

	cyber_dojo_dir=$parent_dirname/$top_dirname/$sub_dirname/$animal
	cd $cyber_dojo_dir

	git checkout -q master
	last_commit=`jq '. | length' increments.json`
	if (( last_commit == 0 ))
	then
		echo "Skipping ${animal}, no commits"
		continue
	fi

	git checkout -q 0
	if [[ "${actual_exercise}x" = "x" ]]
	then
		branch=${language}-${exercise}-${top_dirname}${sub_dirname}-${animal}
	else
		branch=${language}-${actual_exercise}-${top_dirname}${sub_dirname}-${animal}
	fi
	cp -r sandbox/ $dest
	
	pushd $dest
	git checkout master
	git checkout -b "$branch"
	git add .
	git commit -m "init"
	popd
	
	old_date_in_sec=0
	last_color='RED'

	for i in $(seq 1 $last_commit) 
	do 
		offset=$(($i-1))
		git checkout -q $i

		color=`jq -r ".[$offset].colour" increments.json | tr "[:lower:]" "[:upper:]"`
		new_date=`date -j -f %Y,%m,%d,%H,%M,%S $(jq -r ".[$offset].time | @csv" increments.json)`
		new_date_in_sec=`date -j -f %Y,%m,%d,%H,%M,%S $(jq -r ".[$offset].time | @csv" increments.json) +%s`
		time_diff=$(($new_date_in_sec - $old_date_in_sec))

		if (( $offset == 0 ))
		then
			tdiff='+0s'
		elif (( $time_diff > 300 ))
		then
			tdiff='+too_long'
		elif (( $time_diff > 60))
		then
			mdiff=$(($time_diff / 60))
			sdiff=$(($time_diff % 60))
			tdiff="+${mdiff}m${sdiff}s"
		else
			tdiff="+${time_diff}s"
		fi

		cp -r sandbox/ $dest
		pushd $dest

		echo
		echo "diffing $i to $offset"
		files_changed=`git diff -w --name-only | grep -v 'output'`
		echo "$files_changed"

		desc="?"
		num_changed=(`echo "${files_changed}" | wc -w `)
		if (( ${num_changed} == 0 ))
		then
			desc="Reran previous commit"
		elif (( ${num_changed} == 1 ))
		then
			files_changed=$(basename ${files_changed})
			if (( $(basename ${files_changed} | grep 'test' | wc -w) == 1 ))
			then
				if [ "${color}" = "RED" ]
				then
					desc="Added tests to ${files_changed}"
				elif [ "$color" = "AMBER" ]
				then
					desc="Working through some stuff..."
				else
					desc="Refactored test file ${files_changed}"
				fi
			else
                                if [ "${color}" = "GREEN" ]
                                then
					if ["${last_color}" = "GREEN" ]
					then
						desc="Doing some refactorring in ${files_changed}"
					else
                                        	desc="Making tests pass by modifying ${files_changed}"
					fi
                                elif [ "$color" = "AMBER" ]
                                then
                                        desc="Working through some stuff..."
                                else
                                        desc="Well that didn't work..."
                                fi
			fi
		else
			desc="Changed $num_changed files"
		fi
		echo

		git add .
		git commit --allow-empty --date "${new_date}" -m "${color} ${tdiff} ${desc}"

		old_date_in_sec=$new_date_in_sec
		last_color="${color}"

		popd
	done

	#first_commit=`git rev-list --max-parents=0 HEAD`
	#echo "first commit: $first_commit"
	
	echo "finished processing $animal"
	echo
done

cd $dest
git checkout master
