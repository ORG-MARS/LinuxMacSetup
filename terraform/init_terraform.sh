BASE_DIR="$HOME/.xiaomo"

sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

ln -sf "$BASE_DIR/source/terraform/terrmaformrc" "$HOME/.terrmaformrc"
echo "$BASE_DIR/source/terraform/terrmaformrc" link to "$HOME/.terrmaformrc"
terraform -install-autocomplete
terraform --version
