#!/usr/bin/env bash
# Download and configure wordmove

## Script from https://github.com/welaika/wordmove/wiki/Getting-Wordmove-installed-in-VVV-(or-any-Vagrant)
# Rubygems update
if [ $(/root/.rbenv/shims/gem -v|grep '^2.') ]; then
	echo "gem installed"
else
	apt install git-core autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev -y
	echo "installing rbenv"
	git clone https://github.com/rbenv/rbenv.git ~/.rbenv
	echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
	echo 'eval "$(rbenv init -)"' >> ~/.bashrc
	/root/.rbenv/bin/rbenv init -
	git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
	echo "installing last ruby"
	/root/.rbenv/bin/rbenv install $(/root/.rbenv/bin/rbenv install -l | grep -v - | tail -1)
	/root/.rbenv/bin/rbenv global $(/root/.rbenv/bin/rbenv install -l | grep -v - | tail -1)
	echo "gem: --no-document" > ~/.gemrc
fi

# wordmove install
wordmove_install="$(/root/.rbenv/shims/gem list wordmove -i)"
if [ "$wordmove_install" = true ]; then
  echo "wordmove installed"
else
  echo "installing wordmove"
  /root/.rbenv/shims/gem install wordmove
fi
