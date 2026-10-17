#
# Copyright (C) 2026 The TWRP Recovery Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#

LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),agn2262SG)
include $(call all-makefiles-under,$(LOCAL_PATH))
endif
