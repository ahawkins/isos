.DEFAULT_GOAL:=dist

IMAGES:=$(addprefix dist/,$(wildcard images/*.jpg))
DIST:=$(IMAGES) dist/index.html

.PHONY: check
check:
	convert --version
	cat entries.json | jq . > /dev/null

dist/images/%.jpg: images/%.jpg
	mkdir -p $(@D)
	convert $< -resize 576x432! $@

dist/index.html: entries.json generate.rb template.erb
	mkdir -p $(@D)
	cat $< | ./generate.rb > $@

.PHONY: dist
dist: $(DIST)

.PHONY: deploy
deploy: $(DIST)
	aws --profile ahawkins s3 sync dist/ s3://isos.hawkins.io

.PHONY: clean
clean:
	rm -rf dist
