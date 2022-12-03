# Basic setup
sudo apt-get install software-properties-common
sudo apt install aptitude
sudo apt install vim
curl -sLf https://spacevim.org/install.sh | bash # spacevim
sudo apt install zsh
chsh -s $(which zsh)
sudo apt install tmux
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt install python3
sudo apt install python3-dev
sudo add-apt-repository ppa:christian-boxdoerfer/fsearch-stable
sudo apt update
sudo apt install fsearch -y

# Install zotero
wget -qO- https://raw.githubusercontent.com/retorquere/zotero-deb/master/install.sh | sudo bash
sudo apt update
#sudo apt install zotero

# Install develop environment
sudo apt install build-essential
sudo apt -y install clang
sudo apt -y install clang lldb lld
sudo apt-get -y install ninja-build
sudo apt install cmake

# Install R
sudo apt update -qq
sudo apt install --no-install-recommends software-properties-common dirmngr
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
sudo apt install --no-install-recommends r-base
sudo add-apt-repository ppa:c2d4u.team/c2d4u4.0+

# Install texlive
# sudo apt install texlive-full -y


# Install petsc
git clone -b release https://gitlab.com/petsc/petsc.git petsc
cd petsc
./configure --with-cc=gcc --with-cxx=g++ --with-fc=gfortran --download-mpich --download-fblaslapack
make all check
cd

# Fenics fenicsx
sudo add-apt-repository ppa:fenics-packages/fenics
sudo apt-get update
sudo apt-get install fenics
sudo apt-get install fenicsx
pip install git+https://github.com/dolfin-adjoint/pyadjoint.git@master
pip install git+https://github.com/funsim/moola.git@master
pip install git+https://github.com/IvanYashchuk/fecr@master
pip install git+https://github.com/IvanYashchuk/jax-fenics-adjoint.git@master
pip install git+https://github.com/barkm/torch-fenics.git@master
pip install --upgrade gmsh
sudo apt -y install gmsh paraview
