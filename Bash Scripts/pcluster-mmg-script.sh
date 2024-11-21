 #!/bin/bash
set -e
# Update all packages
sudo dnf update -y
sudo dnf install epel-release -y # repo for lua and Lmod packages
sudo dnf install lua lua-json lua-lpeg lua-posix lua-term tcl tcl-devel Lmod -y # Installing Lmod
sudo yum update -y # update for installing anaconda
# Installing anaconda pre-reqs
sudo yum install libXcomposite libXcursor libXi libXtst libXrandr alsa-lib mesa-libEGL libXdamage mesa-libGL libXScrnSaver -y
sudo yum install conda -y # installing conda
# Installing SSM agent
sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm

echo "Custom AMI build complete"
