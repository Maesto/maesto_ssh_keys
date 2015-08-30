#!/bin/sh

# generates all authorized_keys for the servers as defined in the data directory

# chdir to the directory our script lies in
cd  $(dirname $(readlink -f $0))
# chdir one up since it is easyer to access everything from this point
cd ..

# set up some vars to access needed dirs
base="$(pwd)"
groups="$base/data/groups"
servers="$base/data/servers"
keys="$base/data/userkeys"
vardir="$base/vars"

tmp=$(mktemp -d)

# find all group directorys
find $groups -mindepth 1 -maxdepth 1 -type d -print0 | while read -d '' -r groupitem; do

	#save the groupname
	groupname=${groupitem##*/}
	#for each file in the groupdir append it into the group key
	find -L "$groupitem" -type f -print0 | while read -d '' key; do
		keycontents=$(cat "$key")
		printf "%s\\\n" "$keycontents" >> "$tmp/$groupname" 
	done
done


#copy all userkeys into our tmp dir
cp "$keys/"* "$tmp"

# at this point we have all keys inside the tmp directory
rm -f "$vardir/"maesto_*

#creating a file for each server
find "$servers" -type f -print0 | while read -d '' -r serverentry; do

	#save the servername
	serversub=${serverentry##*/}
	servername=${serversub##*@}
	
	printf "maesto_ssh_keys:\n" > "$vardir/maesto_$servername"

done

# insert the user/key pairs into each file
find "$servers" -type f -print0 | while read -d '' -r serverentry; do
	#save the servername
	serversub=${serverentry##*/}
	servername=${serversub##*@}
	username=${serversub%%@*}

	#default to root if no name given
	if [ $servername == $username ] ; then
		username="root"
	fi

	while read item; do
		#contating the key from tmpdir to file/keys/servername
		itemcontent=$(cat "$tmp/$item")
		printf -v keycontent "%s \\\n %s" "$keycontent" "$itemcontent"
	done < "$serverentry"
	printf "  - { user: '%s', key: \"%s\"}\n" "$username" "$keycontent" >> "$vardir/maesto_$servername"
	
	
done

#cleaning up after ourselfs
#rm -rf "$tmp"
