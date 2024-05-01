#!/bin/bash

# Certainly! Here's a step-by-step guide to building a bullseye-backport package of Emacs 28 for Debian 11:

# 1. Set up the build environment:
#    - Install the necessary build tools and dependencies:
#      ```
sudo apt install build-essential devscripts debhelper dpkg-dev fakeroot
#      ```

# 2. Create a working directory and obtain the Emacs source code:
#    - Create a directory for the backport package:
#      ```
mkdir emacs28-backport
cd emacs28-backport
#      ```
#    - Download the Emacs source code tarball from the official website. For example:
#      ```
wget https://ftp.gnu.org/gnu/emacs/emacs-28.2.tar.xz
#      ```
#    - Extract the tarball:
#      ```
tar xvf emacs-28.2.tar.xz
#      ```

# 3. Prepare the Debian packaging files:
#    - Download the Debian packaging files for Emacs from the Debian source package repository:
#      ```
apt source emacs
#      ```
#    - Copy the debian directory from the downloaded Emacs package to the Emacs 28 source directory:
#      ```
cp -r emacs-*/debian emacs-28.2/
#      ```

# 4. Update the Debian packaging files:
#    - Change to the Emacs 28 source directory:
#      ```
cd emacs-28.2
#      ```
#    - Update the `debian/changelog` file to reflect the new version and backport changes. For example:
#      ```
dch --newversion 28.2-1~bpo11+1 --distribution bullseye-backports "Backport to Bullseye"
#      ```
#    - Modify any other necessary files in the `debian` directory to accommodate the new version.

# 5. Build the Debian package:
#    - Build the package using the `dpkg-buildpackage` command:
#      ```
dpkg-buildpackage -us -uc -rfakeroot
#      ```
#    - The built package will be created in the parent directory.

# 6. Install the backported package:
#    - Change to the parent directory:
#      ```
cd ..
#      ```
#    - Install the newly built package using `dpkg`:
#      ```
sudo dpkg -i emacs_28.2-1~bpo11+1_amd64.deb
#      ```
#    - Resolve any dependencies, if needed:
#      ```
sudo apt install -f
#      ```

# That's it! You have now built and installed a bullseye-backport package of Emacs 28 on Debian 11.

# Please note that building packages from source requires careful attention to dependencies and packaging rules. It's essential to review and test the package thoroughly before using it in a production environment.

# Additionally, keep in mind that backporting packages may introduce incompatibilities or stability issues, so it's recommended to use backports with caution and only when necessary.
