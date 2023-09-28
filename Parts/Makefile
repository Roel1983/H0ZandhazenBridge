PARTS                   ?= $(basename $(wildcard *$(PART_SOURCE_EXTENSION)))
PRINTABLE_PARTS         ?= $(basename $(wildcard *$(SLICE_PROJECT_FILE)))

# Paths
DEPDIR                  ?= ./.deps
PARTSDIR                ?= ./stl
GCODEDIR                ?= ./gcode

# Extensions
PART_SOURCE_EXTENSION       ?= .scad
PART_DESTINATION_EXTENSION  ?= .stl
IMAGE_SOURCE_EXTENSION      ?= .scad
SLICE_PROJECT_FILE          ?= .3mf
GCODE_EXTENSION             ?= .gcode

# Applications
OPENSCAD                ?= openscad
SLICER                  ?= PrusaSlicer

# Targets
.PHONY: all
all: all_gcodes all_parts

test:
	@if [ ArchPart4.scad -nt ArchTenonPart.3mf ]; then\
	  echo "Hello world";\
	else \
	  echo "Good bye";\
	fi
 
.PHONY: all_gcodes
all_gcodes: $(PRINTABLE_PARTS:%=$(GCODEDIR)/%$(GCODE_EXTENSION))

.PHONY: all_parts
all_parts: $(PARTS:%=$(PARTSDIR)/%$(PART_DESTINATION_EXTENSION))

.PHONY: clean_deps
clean_deps:
	rm -r $(DEPDIR)

.PHONY: clean_parts
clean_parts:
	rm -r $(PARTSDIR)
	rm -r $(GCODEDIR)

clean: clean_deps clean_parts

$(PARTSDIR)/%$(PART_DESTINATION_EXTENSION): %$(PART_SOURCE_EXTENSION)
$(PARTSDIR)/%$(PART_DESTINATION_EXTENSION): %$(PART_SOURCE_EXTENSION) | $(DEPDIR)/%.d
	mkdir -p $(DEPDIR)/$(dir $*)
	mkdir -p $(PARTSDIR)/$(dir $*)
	$(OPENSCAD) -d $(DEPDIR)/$*.d $(OPENSCAD_ARGS) -D "IS_PART=1" $(OPENSCAD_ADDITION_ARGS) -o $(PARTSDIR)/$*$(PART_DESTINATION_EXTENSION) $*$(PART_SOURCE_EXTENSION)
	rm $(GCODEDIR)/$*$(GCODE_EXTENSION) # make sure we do not fall in to the trap of using outdated gcode!!!

$(GCODEDIR)/%$(GCODE_EXTENSION): %$(SLICE_PROJECT_FILE) $(PARTSDIR)/%$(PART_DESTINATION_EXTENSION) 
	@if [ $*$(SLICE_PROJECT_FILE) -nt $(PARTSDIR)/$*$(PART_DESTINATION_EXTENSION) ]; then\
	  mkdir -p $(GCODEDIR)/$(dir $*); \
	  $(SLICER) $< --export-gcode -o $@; \
	else \
	  echo "Skipped slicing $*, project was not updated";\
	fi

DEPFILES := $(PARTS:%=$(DEPDIR)/%.d) $(IMAGES:%=$(DEPDIR)/%.d)
$(DEPFILES):
include $(wildcard $(DEPFILES))
