 #!/bin/bash
set -e
# Update all packages
dnf update -y
sudo dnf install epel-release -y # repo for lua and Lmod packages
sudo dnf install lua lua-json lua-lpeg lua-posix lua-term tcl tcl-devel Lmod -y # Installing Lmod
sudo yum update # update for installing anaconda
# Installing anaconda pre-reqs
sudo yum install libXcomposite libXcursor libXi libXtst libXrandr alsa-lib mesa-libEGL libXdamage mesa-libGL -ylibXScrnSaver
sudo yum install conda # installing conda
echo "Custom AMI build complete"
