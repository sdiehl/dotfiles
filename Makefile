# Bootstrap: installs just (if missing) then delegates to justfile.
# After first run, use `just` directly.

.PHONY: all bootstrap configs macos devenv nvim-plugins

all: bootstrap
	@just all

bootstrap:
	@which just > /dev/null 2>&1 || { \
		echo "Installing just..."; \
		which brew > /dev/null 2>&1 && brew install just || \
		curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin; \
	}

# Pass through any target to just
%:
	@which just > /dev/null 2>&1 || $(MAKE) bootstrap
	@just $@
