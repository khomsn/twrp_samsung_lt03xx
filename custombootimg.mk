MKBOOTIMG_BIN := out/host/linux-x86/bin/mkbootimg

$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) \
		$(recovery_ramdisk) \
		$(recovery_kernel)
	@echo ----- Replace Font ------
	cp -f device/samsung/lt033g/res/OswaldCondensed-Regular.ttf $(PRODUCT_OUT)/recovery/root/twres/fonts/RobotoCondensed-Regular.ttf
	@echo ----- Replace RU translation ------
	cp -f device/samsung/lt033g/res/ru.xml $(PRODUCT_OUT)/recovery/root/twres/languages/ru.xml
	@echo ----- Creating ramdisk ------
	chmod 750 $(PRODUCT_OUT)/recovery/root/init.rc
	chmod 750 $(PRODUCT_OUT)/recovery/root/init.recovery.$(TARGET_BOOTLOADER_BOARD_NAME).rc
	chmod 750 $(PRODUCT_OUT)/recovery/root/init.recovery.usb.rc
	chmod 644 $(PRODUCT_OUT)/recovery/root/default.prop
	(cd $(PRODUCT_OUT)/recovery/root/ && find * | sort | cpio -o -H newc) | gzip -9 > $(recovery_ramdisk)
	@echo ----- Making recovery image ------
	$(MKBOOTIMG_BIN) --kernel $(PRODUCT_OUT)/kernel --ramdisk $(recovery_ramdisk) --base $(BOARD_KERNEL_BASE) --cmdline "$(BOARD_KERNEL_CMDLINE)" --pagesize $(BOARD_KERNEL_PAGESIZE) $(BOARD_MKBOOTIMG_ARGS) --output $@
	@echo ----- Made recovery image -------- $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)

$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES)
	$(call pretty,"Target boot image: $@")
	$(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_ARGS) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE),raw)
