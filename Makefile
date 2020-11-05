# Copyright 2019 SiFive, Inc #
# SPDX-License-Identifier: Apache-2.0 #

PROGRAM ?= example-hca-metal

# ----------------------------------------------------------------------
# Common def
# ----------------------------------------------------------------------
override CURRENT_DIR := $(patsubst %/,%, $(dir $(abspath $(firstword $(MAKEFILE_LIST)))))
override BUILD_DIRECTORY = $(CURRENT_DIR)/$(CONFIGURATION)/build
override SOURCE_DIR = $(CURRENT_DIR)

override C_SOURCES = $(wildcard *.c)
override ASM_SOURCES = $(wildcard *.S)
override OBJS := $(C_SOURCES:%.c=$(BUILD_DIRECTORY)/%.o) \
				 $(ASM_SOURCES:%.S=$(BUILD_DIRECTORY)/%.o)

override CFLAGS += -I $(CURRENT_DIR)
override ASFLAGS = $(CFLAGS)

# ----------------------------------------------------------------------
# Macro
# ----------------------------------------------------------------------
ifeq ($(VERBOSE),TRUE)
	HIDE := 
else
	HIDE := @
endif

# ----------------------------------------------------------------------
# Build rules
# ----------------------------------------------------------------------

$(BUILD_DIRECTORY)/%.o: $(SOURCE_DIR)/%.c
	$(HIDE) mkdir -p $(dir $@)
	$(HIDE) $(CC) -c -o $@ $(CFLAGS) $(XCFLAGS) $<

$(BUILD_DIRECTORY)/%.o: $(SOURCE_DIR)/%.S
	$(HIDE) mkdir -p $(dir $@)
	$(HIDE) $(CC) -c -o $@ $(ASFLAGS) $<

$(PROGRAM): \
	$(OBJS)
	$(CC) $(CFLAGS) $(XCFLAGS) $(LDFLAGS) $(OBJS) $(LDLIBS) -o $@
	@echo

clean::
	rm -rf $(BUILD_DIRECTORY)
	rm -f $(PROGRAM) $(PROGRAM).hex
