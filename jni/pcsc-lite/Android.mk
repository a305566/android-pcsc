# Android.mk.  Manually derived by running 'configure' using options
#     --disable-libhal --disable-libusb
# on Ubuntu 9.10 and capturing the actions taken by make.
#

# Copyright (C) 2010  Free Software Foundation, Inc.
# This Android.mk is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY, to the extent permitted by law; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.


LOCAL_PATH := $(call my-dir)

PCSCD_PATH :=/system/pcsc

common_cflags := \
	-DANDROID \
	-DDISABLE_SYSTEMD \
	-DPCSCD_PATH='"$(PCSCD_PATH)"' \
	-DHAVE_CONFIG_H \

common_c_includes := \
	$(LOCAL_PATH) \
	$(LOCAL_PATH)/src/PCSC \
	$(LOCAL_PATH)/src \
	external/libusb/libusb

# ============ build libpcsclite.a ====================================

#include $(CLEAR_VARS)

#LOCAL_SRC_FILES := \
#	src/debug.c \
#	src/error.c \
#	src/simclist.c \
#	src/strlcat.c \
#	src/strlcpy.c \
#	src/sys_unix.c \
#	src/utils.c \
#	src/winscard_msg.c \
#	src/winscard_clnt.c \
#	src/spy/libpcscspy.c

#LOCAL_CFLAGS		:= $(common_cflags) \
#	-DLIBPCSCLITE

#LOCAL_C_INCLUDES	:= $(common_c_includes)
#LOCAL_PRELINK_MODULE	:= false
#LOCAL_MODULE		:= libpcsclite

#include $(BUILD_STATIC_LIBRARY)

# ============ build libpcsclite.so ====================================

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	src/debug.c \
	src/error.c \
	src/simclist.c \
	src/strlcat.c \
	src/strlcpy.c \
	src/sys_unix.c \
	src/utils.c \
	src/winscard_msg.c \
	src/winscard_clnt.c

LOCAL_CFLAGS		:= $(common_cflags) \
	-DLIBPCSCLITE

LOCAL_C_INCLUDES	:= $(common_c_includes)
LOCAL_PRELINK_MODULE	:= false
LOCAL_MODULE		:= libpcsclite
LOCAL_MODULE_TAGS	:= eng
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/src/PCSC

include $(BUILD_SHARED_LIBRARY)

# ============ build pcscd =============================================

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	src/auth.c \
	src/debuglog.c \
	src/atrhandler.c \
	src/configfile.c \
	src/dyn_hpux.c \
	src/dyn_macosx.c \
	src/dyn_unix.c \
	src/eventhandler.c \
	src/hotplug_generic.c \
	src/hotplug_libusb.c \
	src/hotplug_linux.c \
	src/hotplug_macosx.c \
	src/ifdwrapper.c \
	src/pcscdaemon.c \
	src/powermgt_generic.c \
	src/prothandler.c \
	src/readerfactory.c \
	src/sd-daemon.c \
	src/simclist.c \
	src/strlcat.c \
	src/strlcpy.c \
	src/sys_unix.c \
	src/tokenparser.c \
	src/utils.c \
	src/winscard.c \
	src/winscard_msg.c \
	src/winscard_msg_srv.c \
	src/winscard_svc.c

LOCAL_C_INCLUDES	:= $(common_c_includes)
LOCAL_CFLAGS		:= $(common_cflags) \
	-DPCSCD \
	-DSIMCLIST_NO_DUMPRESTORE
LOCAL_LDLIBS		:= -llog -ldl
LOCAL_SHARED_LIBRARIES := libcrypto libusb liblog libdl
LOCAL_PRELINK_MODULE	:= false
LOCAL_MODULE		:= pcscd
LOCAL_MODULE_TAGS	:= eng
include $(BUILD_EXECUTABLE)

# ============ build pcsc_jni ==========================================
include $(CLEAR_VARS)
LOCAL_LDLIBS		:= -L$(SYSROOT)/usr/lib -llog -ldl
LOCAL_PRELINK_MODULE	:= false
LOCAL_SRC_FILES		:= src/pcsc_jni.cpp
LOCAL_C_INCLUDES	:= \
	$(LOCAL_PATH) \
	$(LOCAL_PATH)/src/PCSC \
	$(LOCAL_PATH)/src 
LOCAL_CFLAGS		:= $(common_cflags)
LOCAL_SHARED_LIBRARIES	:= libpcsclite liblog libcrypto
LOCAL_MODULE_TAGS      := optional
LOCAL_MODULE		:= libpcscjni

include $(BUILD_SHARED_LIBRARY)

# ============ build testpcsc ==========================================
include $(CLEAR_VARS)
LOCAL_LDLIBS		:= -ldl
LOCAL_PRELINK_MODULE	:= false
LOCAL_SRC_FILES		:= src/testpcsc.c
LOCAL_C_INCLUDES	:= \
	$(LOCAL_PATH) \
	$(LOCAL_PATH)/src/PCSC \
	$(LOCAL_PATH)/src 
LOCAL_CFLAGS		:= $(common_cflags)
LOCAL_SHARED_LIBRARIES	:= libpcsclite liblog libcrypto
LOCAL_MODULE_TAGS       := eng
LOCAL_MODULE		:= testpcsc

include $(BUILD_EXECUTABLE)

# =========== copy reader.conf =========================================
include $(CLEAR_VARS)
LOCAL_MODULE := reader.conf
LOCAL_SRC_FILES := etc/$(LOCAL_MODULE)
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT)/pcsc/etc
include $(BUILD_PREBUILT)

