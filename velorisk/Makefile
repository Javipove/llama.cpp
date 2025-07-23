BUILDDIR := build
SRCDIR := src
SRCEXT_C := c
SRCEXT_ASM := S
OBJEXT := o
BASE_CC_PATH := /scratch/tools/compilers/xuantie_gcc
CC := riscv64-unknown-linux-gnu-gcc
WCFLAGS :=	-Wall -Wextra -Wpedantic -Wcast-qual -Wno-unused-function -Wshadow \
			-Wstrict-prototypes -Wpointer-arith -Wmissing-prototypes -Werror=implicit-int \
			-Werror=implicit-function-declaration -pthread  -Wdouble-promotion
INCDIR :=	-I. -Icommon -I./include \
			-I$(BASE_CC_PATH)/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include \
			-I$(BASE_CC_PATH)/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed
OTHERCFLAGS := -O3 -fPIC
ARCHCFLAGS := -mcpu=c920
#-ftree-vectorize -fopt-info-vec-all -ftree-slp-vectorize
ifndef VELORISK_USE_API
VELORISK_USE_API = 0
endif
CFLAGS := $(ARCHCFLAGS) $(OTHERCFLAGS) $(WCFLAGS) -DVELORISK_USE_API=$(VELORISK_USE_API)
LDFLAGS := -L$(BASE_CC_PATH)/lib/ -L$(BASE_CC_PATH)/lib64/
# C
SOURCES_C := $(shell find $(SRCDIR) -type f -name *.$(SRCEXT_C))
OBJECTS_C := $(SOURCES_C:$(SRCDIR)/%.$(SRCEXT_C)=$(BUILDDIR)/c/%.$(OBJEXT))
# ASSEMBLY
SOURCES_ASM := $(shell find $(SRCDIR) -type f -name *.$(SRCEXT_ASM))
OBJECTS_ASM := $(SOURCES_ASM:$(SRCDIR)/%.$(SRCEXT_ASM)=$(BUILDDIR)/asm/%.$(OBJEXT))
# BOTH
SOURCES := $(SOURCES_C) $(SOURCES_ASM)
OBJECTS := $(OBJECTS_C) $(OBJECTS_ASM)
OBJS = $(shell find $(BUILDDIR) -type f -name *.$(OBJEXT))


$(BUILDDIR)/asm/%.$(OBJEXT): $(SRCDIR)/%.$(SRCEXT_ASM)
	@echo "Compiling source $< into object $@"
	@mkdir -p '$(@D)'
	$(BASE_CC_PATH)/bin/$(CC) $(CFLAGS) $(INCDIR) -c $< -o $@

$(BUILDDIR)/c/%.$(OBJEXT): $(SRCDIR)/%.$(SRCEXT_C)
	@echo "Compiling source $< into object $@"
	@mkdir -p '$(@D)'
	$(BASE_CC_PATH)/bin/$(CC) $(CFLAGS) $(INCDIR) -c $< -o $@

all:	$(OBJECTS)
		mkdir lib
		$(BASE_CC_PATH)/bin/$(CC) $(CFLAGS) $(INCDIR) $(OBJS) -shared -o lib/libvelorisk.so $(LDFLAGS)

clean:
	rm -rf lib $(BUILDDIR)
