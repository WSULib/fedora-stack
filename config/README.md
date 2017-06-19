# Build Profiles for fedora-stack

Fedora stack, when operating at full capacity, is 3-4 servers working in unison.  Though we have a single GitHub repository for the build, we do have 3-4 "profiles" that represent each machine.

To build, you must create an `evnvars` (no file extension) by copying one of these build profiles: `envvars.dataslice`, `envvars.workdev`, `envvars.public`, or `envvars.local`.  

The build profiles come with development credentials included, roughly pointing at the correct remote repository where necessary.  However, when building in production the fedora credentials (and perhaps hostnames) will be changed.  It is important when building to pay special attention to the variables `REMOTE_HOST`, `REMOTE_FEDORA_USERNAME`, and `REMOTE_FEDORA_PASSWORD`, as these are used to point at the correct Fedora repository, with the right privileges.


