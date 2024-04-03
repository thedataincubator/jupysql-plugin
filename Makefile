SHELL := /bin/bash
VENV := venv
ACTIVATE_VENV := source $(VENV)/bin/activate
VERSION := $(shell bin/print-version)
VERSION_UPSTREAM := $(shell jq -r .version package.json)
PACKAGE := jupysql_plugin

.PHONY: all
all: clean install launch

$(VENV)/bin/activate:
	python3 -m venv $(VENV)
	$(ACTIVATE_VENV) && pip install -r requirements.txt
	$(ACTIVATE_VENV) pip install -r requirements.dev.txt
	$(ACTIVATE_VENV) && pip uninstall -y ploomber-extension

.PHONY: install
install: $(VENV)/bin/activate
	$(ACTIVATE_VENV) && jlpm install
	$(ACTIVATE_VENV) && pip install -e .
	$(ACTIVATE_VENV) && jupyter labextension develop . --overwrite
	$(ACTIVATE_VENV) && jlpm build --minimize=false

.PHONY: wheel
wheel: dist/$(PACKAGE)-$(VERSION)-py3-none-any.whl

dist/$(PACKAGE)-$(VERSION)-py3-none-any.whl: $(VENV)/bin/activate
	$(ACTIVATE_VENV) && python3 -m build
	mv dist/$(PACKAGE)-$(VERSION_UPSTREAM)-py3-none-any.whl dist/$(PACKAGE)-$(VERSION)-py3-none-any.whl

.PHONY: launch
launch:
	$(ACTIVATE_VENV) && jupyter-lab

.PHONY: clean
clean:
	rm -rf \
		.yarn \
		dist/ \
		lib \
		$(PACKAGE)/_version.py \
		$(PACKAGE)/labextension \
		node_modules/ \
		tsconfig.tsbuildinfo \
		$(VENV)

