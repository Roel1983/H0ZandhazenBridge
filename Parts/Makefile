PARTS                   ?= $(basename $(wildcard *$(PART_SOURCE_EXTENSION)))

# Paths
DEPDIR                  ?= ./.deps
PARTSDIR                ?= ./stl

# Extensions
PART_SOURCE_EXTENSION       ?= .scad
PART_DESTINATION_EXTENSION  ?= .stl
IMAGE_SOURCE_EXTENSION      ?= .scad

# Applications
OPENSCAD                ?= openscad

# Targets
.PHONY: all
all:

.PHONY: all_parts
all_parts: $(PARTS:%=$(PARTSDIR)/%.stl)
all: all_parts

.PHONY: clean_deps
clean_deps:
	rm -r $(DEPDIR)

.PHONY: clean_parts
clean_parts:
	rm -r $(PARTSDIR)

clean: clean_deps clean_parts

$(PARTSDIR)/%.stl: %$(PART_SOURCE_EXTENSION)
$(PARTSDIR)/%.stl: %$(PART_SOURCE_EXTENSION) | $(DEPDIR)/%.d
	mkdir -p $(DEPDIR)/$(dir $*)
	mkdir -p $(PARTSDIR)/$(dir $*)
	$(OPENSCAD) -d $(DEPDIR)/$*.d $(OPENSCAD_ARGS) -D "IS_PART=1" $(OPENSCAD_ADDITION_ARGS) -o $(PARTSDIR)/$*$(PART_DESTINATION_EXTENSION) $*$(PART_SOURCE_EXTENSION)

DEPFILES := $(PARTS:%=$(DEPDIR)/%.d) $(IMAGES:%=$(DEPDIR)/%.d)
$(DEPFILES):
include $(wildcard $(DEPFILES))
