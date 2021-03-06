maesto_ssh_keys
===============

Manages ssh keys on your servers and ensures that only these keys are on your servers.

Requirements
------------

(GNU) bash, (GNU) coreutils, (GNU) findutils Simply not tested on non GNU userspace.
SetUp the data directory.

Role Variables
--------------

None yet

Example Playbook
----------------

You can generate all server keys by running scripts/generate_serverkeys.sh . After this use this like every other role. If the serverkey {{ ansible_hostname }} exists (define it inside the data directory) it will be populated. You may want to populate the data directory via your own git and run the generate_serverkeys.sh via cron to update the keys from time to time.

```
---
- hosts: all
  vars:
  tasks:
  roles:
    - maesto_ssh_keys
```

Licence
-------

MIT opensource.org/licencses/MIT

Setup:
======

Populate the data directory. To see how to do this have a look at the data.example directory. Pay attention to the links! If you don't you have to change the files at multiple points and may oversee one later! if no user@ is present in the filename root gets assumed. 

Author Information
------------------

Lucas Wendel <github@igeh.me>
