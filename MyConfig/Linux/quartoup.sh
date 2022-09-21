if [ ! -d "$HOME/quarto-cli" ]; then
  echo "Downloading latest quarto"
  cd
  git clone https://github.com/quarto-dev/quarto-cli
  cd quarto-cli
  echo "Installing quarto"
  ./configure.sh
  cd
else
  cd ~/quarto-cli
  echo "Updating quarto"
  git pull
  cd
fi



#echo "Downloading latest quarto"
#sudo curl -LO https://quarto.org/download/latest/quarto-linux-amd64.deb
#cd
#echo "Installing quarto"
#sudo gdebi quarto-linux-amd64.deb
#echo "Deleting deb file"
#rm -rf quarto-linux-amd64.deb


