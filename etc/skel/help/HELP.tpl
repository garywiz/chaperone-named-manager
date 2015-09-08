Help for Image: %(PARENT_IMAGE) Version %(IMAGE_VERSION) 
     Chaperone: %(`chaperone --version | awk '/This is/{print $5}'`)
         Linux: %(`cat /etc/issue | head -1 | sed -e 's/Welcome to //' -e 's/ \\.*$//'`)

This image is an implementation of Jetrho Carr's "Named Manager" and is fully
configurable.  Configuration variables can be found in the Launcher script and you
can easily customize them.  Just extract the launcher like this:

  $ docker run -i --rm %(PARENT_IMAGE) --task get-launcher | sh

Startup scripts have the option of working with attached storage.
Each script is self-documenting and has configuration variables
at the beginning of the script itself.

The initial install database contains a single user called "setup" with
a default password of "setup123".
