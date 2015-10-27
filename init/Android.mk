ifeq ($(TARGET_INIT_VENDOR_LIB),libinit_msm_r7)

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE_TAGS := optional
LOCAL_C_INCLUDES := system/core/init
LOCAL_CFLAGS := -Wall -DANDROID_TARGET=\"$(TARGET_BOARD_PLATFORM)\"
LOCAL_SRC_FILES := init_msm.cpp init_msm8916.cpp
LOCAL_MODULE := libinit_msm_r7
include $(BUILD_STATIC_LIBRARY)

endif