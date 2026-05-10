SHELL := /bin/sh

HOST ?= $(shell hostname -s)
SETUP := ./install.sh
ARGS ?=

.PHONY: help install dry-run packages dotfiles upgrade cleanup

help:
	@echo "Targets (HOST=$(HOST)):"
	@echo "  make install        # diff preview + apply (install missing only, no cleanup)"
	@echo "  make dry-run        # show planned changes, do nothing"
	@echo "  make packages       # only packages step"
	@echo "  make dotfiles       # only dotfiles step"
	@echo "  make upgrade        # install + also upgrade outdated brew packages"
	@echo "  make cleanup        # install + also remove unlisted brew formulae/casks (DESTRUCTIVE)"
	@echo ""
	@echo "Pass extra flags via ARGS, e.g. 'make install ARGS=\"--yes\"'."

install:
	$(SETUP) $(HOST) $(ARGS)

dry-run:
	$(SETUP) $(HOST) --dry-run $(ARGS)

packages:
	$(SETUP) $(HOST) --only packages $(ARGS)

dotfiles:
	$(SETUP) $(HOST) --only dotfiles $(ARGS)

upgrade:
	$(SETUP) $(HOST) --upgrade $(ARGS)

cleanup:
	$(SETUP) $(HOST) --cleanup $(ARGS)
