install_julia(){
wget https://julialang-s3.julialang.org/bin/linux/x64/$1/julia-$2-linux-x86_64.tar.gz;
tar -xvzf julia-$2-linux-x86_64.tar.gz;
sudo cp -r julia-$2 /opt/;
sudo ln -sf /opt/julia-$2/bin/julia /usr/local/bin/julia;
cd;
sudo rm -rf julia-$2*}
