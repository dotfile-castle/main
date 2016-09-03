.PHONY: init install-chruby
.DEFAULT_GOAL = init

init:
	@[ -d $(shell readlink --canonicalize --no-newline ~/bin) ] || mkdir --parents ~/bin || exit 1
	@[ -e $(shell readlink --canonicalize --no-newline ~/bin/mr) ] || (cd $(HOME)/bin && curl --location --remote-name --silent --show-error https://github.com/joeyh/myrepos/raw/master/mr && chmod +x mr) || exit 1
	@git --version 1>/dev/null && ([ -d $(shell readlink --canonicalize --no-newline ./repos/homeshick) ] || git clone --depth 1 https://github.com/andsens/homeshick.git ./repos/homeshick) || exit 1
	@[ -e $(shell readlink --canonicalize --no-newline ~/.mrconfig) ] || echo >> ~/.mrconfig
	@grep --quiet \.homesick ~/.mrconfig || (\
	echo "[$(HOME)/.homesick]" >> ~/.mrconfig;\
	echo "checkout = git clone --depth 1 'git@github.com:dotfile-castle/.homesick.git' '.homesick'" >> ~/.mrconfig;\
	echo 'chain = true' >> ~/.mrconfig)
	@echo '~/.homesick/.mrconfig' >> ~/.mrtrust
	@$(HOME)/bin/mr checkout
	@mkdir -p ~/.fonts && cd ~/.fonts;\
	curl -LO https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf;\
	curl -LO https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf;\
	fc-cache -vf ~/.fonts/
	@vim +PlugInstall +qall

install-chruby:
	@git --version 1>/dev/null && git clone -depth 1 https://github.com/postmodern/chruby.git /tmp/chruby || exit 1
	@sudo dnf install --assumeyes gcc automake bison zlib-devel libyaml-devel openssl-devel gdbm-devel readline-devel ncurses-devel libffi-devel
	#@sudo apt-get install -y build-essential bison zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev libncurses5-dev libffi-dev
	@sudo make --directory=/tmp/chruby install
	@rm --recursive --force /tmp/chruby
