# Copyright (C) 2026  FREIA Laboratory

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.


# The following lines are required
where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(E3_REQUIRE_TOOLS)/driver.makefile

# Most modules only need to be built for x86_64
EXCLUDE_ARCHS += linux-ppc64e6500
EXCLUDE_ARCHS += linux-corei7-poky

# Since this file (ecmccfg.Makefile) is copied into
# the module directory at build-time, these paths have to be relative
# to that path
APP := .
APPDB := $(APP)/db
APPSRC := $(APP)/src

ECMC_SUBDIRS = scripts general hardware motion naming

# If you have files to include, you will generally want to include these, e.g.
#
#     SOURCES += $(APPSRC)/ecmccfgMain.cpp
#     SOURCES += $(APPSRC)/library.c
#     HEADERS += $(APPSRC)/library.h
#     USR_INCLUDES += -I$(where_am_I)$(APPSRC)

TEMPLATES += $(wildcard $(APPDB)/*.db)
TEMPLATES += $(wildcard $(APPDB)/*.proto)
TEMPLATES += $(wildcard $(APPDB)/*.template)
TEMPLATES += $(wildcard $(APP)/protocol/*.proto)
TEMPLATES += $(wildcard $(APP)/core/*.db)
TEMPLATES += $(foreach path, $(ECMC_HW_TYPES), $(wildcard $(APPDB)/$(path)/*.db) $(wildcard $(APPDB)/$(path)/*.template) $(wildcard $(APPDB)/$(path)/*.substitutions))

SCRIPTS += $(APP)/startup.cmd
SCRIPTS += $(foreach path, $(ECMC_SUBDIRS), $(wildcard $(APP)/$(path)/*.cmd) $(wildcard $(APP)/$(path)/*/*.cmd) $(wildcard $(APP)/$(path)/*/*/*.cmd))
SCRIPTS += $(wildcard ../iocsh/*.iocsh)
SCRIPTS += $(wildcard $(APP)/scripts/jinja2/*.*)

ECMC_HW_TYPES += Beckhoff_1XXX
ECMC_HW_TYPES += Beckhoff_2XXX
ECMC_HW_TYPES += Beckhoff_3XXX
ECMC_HW_TYPES += Beckhoff_4XXX
ECMC_HW_TYPES += Beckhoff_5XXX
ECMC_HW_TYPES += Beckhoff_6XXX
ECMC_HW_TYPES += Beckhoff_7XXX
ECMC_HW_TYPES += Beckhoff_9XXX
ECMC_HW_TYPES += Beckhoff_AMI
ECMC_HW_TYPES += Beckhoff_KL
ECMC_HW_TYPES += Beckhoff_couplers
ECMC_HW_TYPES += Beckhoff_generic
ECMC_HW_TYPES += Beckhoff_slaves
ECMC_HW_TYPES += Encoders
ECMC_HW_TYPES += ESS_crates
ECMC_HW_TYPES += Festo
ECMC_HW_TYPES += Sensors
ECMC_HW_TYPES += SmarAct
ECMC_HW_TYPES += Kuhnke_slaves
ECMC_HW_TYPES += Kuhnke
ECMC_HW_TYPES += MicroEpsilon_slaves
ECMC_HW_TYPES += MicroEpsilon
ECMC_HW_TYPES += Technosoft_slaves
ECMC_HW_TYPES += Technosoft
ECMC_HW_TYPES += Keyence
ECMC_HW_TYPES += generic
ECMC_HW_TYPES += Baumer
ECMC_HW_TYPES += core
ECMC_HW_TYPES += legacy
ECMC_HW_TYPES += MonoDAQ
ECMC_HW_TYPES += PSI
ECMC_HW_TYPES += Bernecker


# Note that architecture-specific source files can be specified:
#
#     SOURCES_linux-x86_64 += ...
#     SOURCES_linux
#
# These are also valid for many of the compile flags specified by e.g.
#     CFLAGS CXXFLAGS CPPFLAGS
# i.e.
#     USR_CFLAGS_linux-ppc64e6500 += ...

SOURCES += $(wildcard ./src/*.cpp)
DBDS    += $(wildcard ./dbd/*.dbd)

# Same as with any source or header files, you can also use $SUBS and $TMPS to define
# database files to be inflated (using MSI), e.g.
#
#     SUBS = $(wildcard $(APPDB)/*.substitutions)
#     TMPS = $(wildcard $(APPDB)/*.template)

USR_DBFLAGS += -I . -I ..
USR_DBFLAGS += -I $(EPICS_BASE)/db
USR_DBFLAGS += -I $(APPDB)

.PHONY: vlibs
vlibs:
