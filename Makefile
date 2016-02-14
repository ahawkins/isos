.DEFAULT_GOAL:=dist

FOLDERS:=$(addprefix dist/,$(wildcard images/*/*.jpg))
IMAGES:=$(addprefix dist/,$(wildcard images/*.jpg))
DIST:=$(IMAGES) $(FOLDERS) dist/index.html

.PHONY: fixup
fixup:
	rename -s .jpeg .jpg images/*.jpeg

.PHONY: check
check:
	convert --version
	cat entries.json | jq . > /dev/null

dist/images/%/%.jpg: images/%/%.jpg
	mkdir -p $(@D)
	convert $< -resize 576 $@

dist/images/%.jpg: images/%.jpg
	mkdir -p $(@D)
	convert $< -resize 576 $@

dist/index.html: entries.json generate.rb template.erb
	mkdir -p $(@D)
	cat $< | ./generate.rb > $@

.PHONY: dist
dist: $(DIST)

.PHONY: deploy
deploy: $(DIST)
	aws --profile ahawkins --region eu-west-1 s3 sync dist/ s3://isos.hawkins.io

.PHONY: clean
clean:
	rm -rf dist
