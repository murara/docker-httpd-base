#!/bin/bash


# THANKS https://github.com/SocialEngine/docker-php-apache :)


randname() {
    local LC_ALL=C
    tr -dc '[:lower:]' < /dev/urandom |
        dd count=1 bs=16 2>/dev/null
}

create_user_from_directory_owner() {
    if [ $# -ne 1 ]; then
        echo "Creates a user (and group) from the owner of a given directory, if it doesn't exist."
        echo "Usage: create_user_from_directory_owner <path>"

        return 1
    fi

    local owner group owner_id group_id path
    path=$1

    owner=$(stat -c '%U' $path)
    group=$(stat -c '%G' $path)
    owner_id=$(stat -c '%u' $path)
    group_id=$(stat -c '%g' $path)
    
    if [ $owner = "UNKNOWN" ]; then
        owner=$(randname)
        if [ $group = "UNKNOWN" ]; then
            group=$owner
            addgroup --system --gid "$group_id" "$group" > /dev/null
        fi
        adduser --no-create-home --system --uid=$owner_id --gid=$group_id "$owner" > /dev/null
        echo "[Apache User] Created user for uid ($owner_id), and named it '$owner'"
    fi

    export APACHE_RUN_USER=$owner
    export APACHE_RUN_GROUP=$group
    echo "[Apache User] Set APACHE_RUN_USER to $owner and APACHE_RUN_GROUP to $group"

    return 0
}


create_user_from_directory_owner "/usr/local/apache2/htdocs"


exec "$@"
