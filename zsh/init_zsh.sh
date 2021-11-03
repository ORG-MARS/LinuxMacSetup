sudo apt install zsh -y
chsh -s /bin/zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
# p10k configure 可以重新配置
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting

# 删除原来的.zsh文件并将配置好的代码链接到zsh
ln -sf "$BASE_DIR/source/zshrc" "$HOME/.zshrc"
echo "$BASE_DIR/source/zshrc" link to "$HOME/.zshrc"
# shellcheck source=/Users/xiaomo/.zshrc
source ~/.zshrc
