#
# Copyright (C) 2026 The TWRP Recovery Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Coolpad DaGuan3 (CP3NV1) - Unisoc UMS9620 / agn2262SG
#
# Prebuilt kernel modules for the recovery ramdisk.
#
# Provenance
#   Every file here (163 .ko + 5 tables) was pulled verbatim out of this
#   device's own vendor_boot_a vendor_ramdisk /lib/modules. Oddly, that
#   "vendor" ramdisk is actually the stock Unisoc recovery ramdisk (it contains
#   system/bin/recovery, init.recovery.common.rc and res/images), which is why
#   BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT is the right model here.
#   All 163 modules were verified byte-identical by md5 against the live
#   partition, so vermagic matches the 5.4.210 kernel exactly.
#
#   Shipping the full set is not optional: modules.load.recovery lists 164
#   entries covering UFS, clk, GPIO, PMIC, USB and the whole display stack.
#   A display-only subset leaves recovery without UFS, so /data never mounts.
#
# Why not PRODUCT_COPY_FILES
#   build/make/core/definitions.mk:2658 defines copy-non-elf-file-checked,
#   which runs `llvm-readobj -h` on every source and hard-fails on a .ko:
#       error: found ELF prebuilt in PRODUCT_COPY_FILES,
#              use cc_prebuilt_binary / cc_prebuilt_library_shared instead.
#
# Why modules go into TARGET_VENDOR_RAMDISK_OUT, not the recovery root
#   core/Makefile:1096 packs the vendor ramdisk with
#       $(MKBOOTFS) -d $(TARGET_OUT) $(TARGET_VENDOR_RAMDISK_OUT) $(PRIVATE_ADDITIONAL_DIR)
#   mkbootfs requires that first directory to EXIST. When every module was
#   installed into recovery/root/lib/modules nothing created
#   $(PRODUCT_OUT)/vendor_ramdisk, so the recipe died with:
#       error: cannot open directory 'out/target/product/agn2262SG/vendor_ramdisk'
#   and vendor_boot.img came out as a 168 KB stub containing only the header
#   and the dtb - no ramdisk at all.
#
#   Putting modules in the vendor ramdisk is also what the stock image does:
#   unpacking vendor_boot_a shows lib/modules inside the vendor ramdisk, not in
#   the recovery root. With BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT the
#   packer concatenates both trees into one cpio, so /lib/modules still lands
#   where init.recovery.*.rc expects it.
#
#   TARGET_VENDOR_RAMDISK_OUT is core/envsetup.mk:929's
#   $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR_RAMDISK), i.e. an absolute path
#   under PRODUCT_OUT - a bare relative path would make kati refuse:
#       build/make/core/base_rules.mk:525: error: writing to readonly directory
#
# Naming
#   LOCAL_MODULE may not contain dots or dashes, so the on-disk name is
#   sanitised and given a _recovery suffix; LOCAL_MODULE_STEM restores the real
#   filename. Table files keep their stock names (modules.dep, modules.alias,
#   modules.load, modules.load.recovery, modules.softdep) because init looks
#   them up by exact name - renaming them would silently break module loading.
#

LOCAL_PATH := $(call my-dir)

define add-recovery-module
include $(CLEAR_VARS)
LOCAL_MODULE        := $(1)
LOCAL_MODULE_STEM   := $(2)
LOCAL_MODULE_CLASS  := ETC
LOCAL_MODULE_PATH   := $(TARGET_VENDOR_RAMDISK_OUT)/lib/modules
LOCAL_SRC_FILES     := modules_recovery/$(2)
LOCAL_MODULE_TAGS   := optional
include $(BUILD_PREBUILT)
endef

# ---------------------------------------------------------------------------
# 163 kernel modules
# ---------------------------------------------------------------------------
$(eval $(call add-recovery-module,aes_ce_ccm_recovery,aes-ce-ccm.ko))
$(eval $(call add-recovery-module,aes_neon_blk_recovery,aes-neon-blk.ko))
$(eval $(call add-recovery-module,agdsp_access_recovery,agdsp_access.ko))
$(eval $(call add-recovery-module,agn_ump9620_fast_charger_recovery,agn_ump9620_fast_charger.ko))
$(eval $(call add-recovery-module,apsys_dvfs_recovery,apsys-dvfs.ko))
$(eval $(call add-recovery-module,arc4_recovery,arc4.ko))
$(eval $(call add-recovery-module,asix_recovery,asix.ko))
$(eval $(call add-recovery-module,audio_dsp_dump_recovery,audio-dsp-dump.ko))
$(eval $(call add-recovery-module,audio_pipe_recovery,audio-pipe.ko))
$(eval $(call add-recovery-module,audio_mem_recovery,audio_mem.ko))
$(eval $(call add-recovery-module,audio_sipc_recovery,audio_sipc.ko))
$(eval $(call add-recovery-module,ax88179_178a_recovery,ax88179_178a.ko))
$(eval $(call add-recovery-module,bq2560x_charger_recovery,bq2560x-charger.ko))
$(eval $(call add-recovery-module,bq2597x_charger_recovery,bq2597x-charger.ko))
$(eval $(call add-recovery-module,chipone_tddi_icnl9916_recovery,chipone-tddi-icnl9916.ko))
$(eval $(call add-recovery-module,clk_sprd_recovery,clk-sprd.ko))
$(eval $(call add-recovery-module,core_recovery,core.ko))
$(eval $(call add-recovery-module,dwc3_sprd_core_recovery,dwc3-sprd-core.ko))
$(eval $(call add-recovery-module,dwc3_sprd_recovery,dwc3-sprd.ko))
$(eval $(call add-recovery-module,eta6937_charger_recovery,eta6937-charger.ko))
$(eval $(call add-recovery-module,extcon_usb_gpio_recovery,extcon-usb-gpio.ko))
$(eval $(call add-recovery-module,flash_ic_ocp8137_recovery,flash_ic_ocp8137.ko))
$(eval $(call add-recovery-module,flash_ic_sgm37891_recovery,flash_ic_sgm37891.ko))
$(eval $(call add-recovery-module,focaltech_ft8756_spi_ts_recovery,focaltech_ft8756_spi_ts.ko))
$(eval $(call add-recovery-module,fts_ts_recovery,fts_ts.ko))
$(eval $(call add-recovery-module,ghash_ce_recovery,ghash-ce.ko))
$(eval $(call add-recovery-module,gpio_eic_sprd_recovery,gpio-eic-sprd.ko))
$(eval $(call add-recovery-module,gpio_pmic_eic_sprd_recovery,gpio-pmic-eic-sprd.ko))
$(eval $(call add-recovery-module,gpio_sprd_recovery,gpio-sprd.ko))
$(eval $(call add-recovery-module,gpio_recovery,gpio.ko))
$(eval $(call add-recovery-module,i2c_sprd_hw_recovery,i2c-sprd-hw.ko))
$(eval $(call add-recovery-module,i2c_sprd_recovery,i2c-sprd.ko))
$(eval $(call add-recovery-module,ion_cma_heap_recovery,ion_cma_heap.ko))
$(eval $(call add-recovery-module,ion_ipc_trusty_recovery,ion_ipc_trusty.ko))
$(eval $(call add-recovery-module,jpg_recovery,jpg.ko))
$(eval $(call add-recovery-module,kfifo_buf_recovery,kfifo_buf.ko))
$(eval $(call add-recovery-module,leds_sc27xx_bltc_recovery,leds-sc27xx-bltc.ko))
$(eval $(call add-recovery-module,ledtrig_pattern_recovery,ledtrig-pattern.ko))
$(eval $(call add-recovery-module,mcdt_hw_r2p0_recovery,mcdt_hw_r2p0.ko))
$(eval $(call add-recovery-module,microarray_fp_recovery,microarray_fp.ko))
$(eval $(call add-recovery-module,mipi_driver_recovery,mipi_driver.ko))
$(eval $(call add-recovery-module,misc_sprd_uid_recovery,misc_sprd_uid.ko))
$(eval $(call add-recovery-module,mmc_hsq_recovery,mmc_hsq.ko))
$(eval $(call add-recovery-module,mmc_swcq_recovery,mmc_swcq.ko))
$(eval $(call add-recovery-module,modem_frequency_band_recovery,modem_frequency_band.ko))
$(eval $(call add-recovery-module,nvmem_sc27xx_efuse_recovery,nvmem-sc27xx-efuse.ko))
$(eval $(call add-recovery-module,nvmem_sprd_efuse_recovery,nvmem_sprd_efuse.ko))
$(eval $(call add-recovery-module,nvt_nt36xxx_spi_ts_recovery,nvt_nt36xxx_spi_ts.ko))
$(eval $(call add-recovery-module,phy_sprd_commonphy_recovery,phy-sprd-commonphy.ko))
$(eval $(call add-recovery-module,phy_sprd_usb31_qogirn6pro_recovery,phy-sprd-usb31-qogirn6pro.ko))
$(eval $(call add-recovery-module,pinctrl_sprd_qogirn6pro_recovery,pinctrl-sprd-qogirn6pro.ko))
$(eval $(call add-recovery-module,pinctrl_sprd_recovery,pinctrl-sprd.ko))
$(eval $(call add-recovery-module,pinctrl_recovery,pinctrl.ko))
$(eval $(call add-recovery-module,ptn38003a_i2c_recovery,ptn38003a-i2c.ko))
$(eval $(call add-recovery-module,pwm_sprd_recovery,pwm-sprd.ko))
$(eval $(call add-recovery-module,rpmb_recovery,rpmb.ko))
$(eval $(call add-recovery-module,rtc_sc27xx_recovery,rtc-sc27xx.ko))
$(eval $(call add-recovery-module,sblock_bridge_recovery,sblock_bridge.ko))
$(eval $(call add-recovery-module,sbuf_bridge_recovery,sbuf_bridge.ko))
$(eval $(call add-recovery-module,sc27xx_poweroff_recovery,sc27xx-poweroff.ko))
$(eval $(call add-recovery-module,sc27xx_vibra_recovery,sc27xx-vibra.ko))
$(eval $(call add-recovery-module,sc27xx_adc_recovery,sc27xx_adc.ko))
$(eval $(call add-recovery-module,sc27xx_fuel_gauge_recovery,sc27xx_fuel_gauge.ko))
$(eval $(call add-recovery-module,sc27xx_pd_recovery,sc27xx_pd.ko))
$(eval $(call add-recovery-module,sc27xx_typec_recovery,sc27xx_typec.ko))
$(eval $(call add-recovery-module,sdhci_sprd_recovery,sdhci-sprd.ko))
$(eval $(call add-recovery-module,sensorhub_recovery,sensorhub.ko))
$(eval $(call add-recovery-module,seth_recovery,seth.ko))
$(eval $(call add-recovery-module,sfp_core_recovery,sfp_core.ko))
$(eval $(call add-recovery-module,sgm41513_charger_recovery,sgm41513-charger.ko))
$(eval $(call add-recovery-module,sha1_ce_recovery,sha1-ce.ko))
$(eval $(call add-recovery-module,silead_fp_recovery,silead_fp.ko))
$(eval $(call add-recovery-module,sipa_core_recovery,sipa-core.ko))
$(eval $(call add-recovery-module,sipa_dele_recovery,sipa-dele.ko))
$(eval $(call add-recovery-module,sipa_sys_recovery,sipa-sys.ko))
$(eval $(call add-recovery-module,sipa_eth_recovery,sipa_eth.ko))
$(eval $(call add-recovery-module,sipa_usb_recovery,sipa_usb.ko))
$(eval $(call add-recovery-module,sipc_core_recovery,sipc-core.ko))
$(eval $(call add-recovery-module,sipx_recovery,sipx.ko))
$(eval $(call add-recovery-module,slog_bridge_recovery,slog_bridge.ko))
$(eval $(call add-recovery-module,snd_soc_sprd_card_recovery,snd-soc-sprd-card.ko))
$(eval $(call add-recovery-module,snd_soc_sprd_codec_aw87xxx_recovery,snd-soc-sprd-codec-aw87xxx.ko))
$(eval $(call add-recovery-module,snd_soc_sprd_codec_ump9620_power_dev_recovery,snd-soc-sprd-codec-ump9620-power-dev.ko))
$(eval $(call add-recovery-module,snd_soc_sprd_codec_ump9620_power_recovery,snd-soc-sprd-codec-ump9620-power.ko))
$(eval $(call add-recovery-module,snd_soc_sprd_codec_ump9620_recovery,snd-soc-sprd-codec-ump9620.ko))
$(eval $(call add-recovery-module,snd_soc_sprd_dai_recovery,snd-soc-sprd-dai.ko))
$(eval $(call add-recovery-module,snd_soc_sprd_dummy_codec_recovery,snd-soc-sprd-dummy-codec.ko))
$(eval $(call add-recovery-module,snd_soc_sprd_pa_ucp1301_recovery,snd-soc-sprd-pa-ucp1301.ko))
$(eval $(call add-recovery-module,snd_soc_sprd_pdm_r2p0_recovery,snd-soc-sprd-pdm-r2p0.ko))
$(eval $(call add-recovery-module,snd_soc_sprd_tdm_recovery,snd-soc-sprd-tdm.ko))
$(eval $(call add-recovery-module,snd_soc_sprd_vbc_fe_recovery,snd-soc-sprd-vbc-fe.ko))
$(eval $(call add-recovery-module,snd_soc_sprd_vbc_v4_recovery,snd-soc-sprd-vbc-v4.ko))
$(eval $(call add-recovery-module,snd_soc_unisoc_dp_codec_recovery,snd-soc-unisoc-dp-codec.ko))
$(eval $(call add-recovery-module,spi_sprd_adi_recovery,spi-sprd-adi.ko))
$(eval $(call add-recovery-module,spi_sprd_recovery,spi-sprd.ko))
$(eval $(call add-recovery-module,spipe_recovery,spipe.ko))
$(eval $(call add-recovery-module,spool_recovery,spool.ko))
$(eval $(call add-recovery-module,sprd_bc1p2_recovery,sprd-bc1p2.ko))
$(eval $(call add-recovery-module,sprd_charger_manager_recovery,sprd-charger-manager.ko))
$(eval $(call add-recovery-module,sprd_compr_2stage_dma_recovery,sprd-compr-2stage-dma.ko))
$(eval $(call add-recovery-module,sprd_cpufreq_public_recovery,sprd-cpufreq-public.ko))
$(eval $(call add-recovery-module,sprd_cpufreq_v2_recovery,sprd-cpufreq-v2.ko))
$(eval $(call add-recovery-module,sprd_dma_recovery,sprd-dma.ko))
$(eval $(call add-recovery-module,sprd_dmaengine_pcm_recovery,sprd-dmaengine-pcm.ko))
$(eval $(call add-recovery-module,sprd_drm_recovery,sprd-drm.ko))
$(eval $(call add-recovery-module,sprd_gsp_recovery,sprd-gsp.ko))
$(eval $(call add-recovery-module,sprd_ion_recovery,sprd-ion.ko))
$(eval $(call add-recovery-module,sprd_pamu3_recovery,sprd-pamu3.ko))
$(eval $(call add-recovery-module,sprd_platform_pcm_routing_recovery,sprd-platform-pcm-routing.ko))
$(eval $(call add-recovery-module,sprd_sipc_virt_bus_recovery,sprd-sipc-virt-bus.ko))
$(eval $(call add-recovery-module,sprd_ump96xx_spi_recovery,sprd-ump96xx-spi.ko))
$(eval $(call add-recovery-module,sprd_vpu_pw_domain_recovery,sprd-vpu-pw-domain.ko))
$(eval $(call add-recovery-module,sprd_7sreset_recovery,sprd_7sreset.ko))
$(eval $(call add-recovery-module,sprd_apipe_recovery,sprd_apipe.ko))
$(eval $(call add-recovery-module,sprd_audcp_boot_recovery,sprd_audcp_boot.ko))
$(eval $(call add-recovery-module,sprd_audcp_dvfs_recovery,sprd_audcp_dvfs.ko))
$(eval $(call add-recovery-module,sprd_battery_info_recovery,sprd_battery_info.ko))
$(eval $(call add-recovery-module,sprd_camera_recovery,sprd_camera.ko))
$(eval $(call add-recovery-module,sprd_camsys_pw_domain_recovery,sprd_camsys_pw_domain.ko))
$(eval $(call add-recovery-module,sprd_cpp_recovery,sprd_cpp.ko))
$(eval $(call add-recovery-module,sprd_flash_drv_recovery,sprd_flash_drv.ko))
$(eval $(call add-recovery-module,sprd_hwspinlock_recovery,sprd_hwspinlock.ko))
$(eval $(call add-recovery-module,sprd_manufacturer_model_recovery,sprd_manufacturer_model.ko))
$(eval $(call add-recovery-module,sprd_mipi_recovery,sprd_mipi.ko))
$(eval $(call add-recovery-module,sprd_modem_loader_recovery,sprd_modem_loader.ko))
$(eval $(call add-recovery-module,sprd_pdbg_recovery,sprd_pdbg.ko))
$(eval $(call add-recovery-module,sprd_pmic_syscon_recovery,sprd_pmic_syscon.ko))
$(eval $(call add-recovery-module,sprd_power_manager_recovery,sprd_power_manager.ko))
$(eval $(call add-recovery-module,sprd_power_stat_recovery,sprd_power_stat.ko))
$(eval $(call add-recovery-module,sprd_sensor_recovery,sprd_sensor.ko))
$(eval $(call add-recovery-module,sprd_shm_recovery,sprd_shm.ko))
$(eval $(call add-recovery-module,sprd_sip_svc_recovery,sprd_sip_svc.ko))
$(eval $(call add-recovery-module,sprd_soc_id_recovery,sprd_soc_id.ko))
$(eval $(call add-recovery-module,sprd_systimer_recovery,sprd_systimer.ko))
$(eval $(call add-recovery-module,sprd_tcpm_recovery,sprd_tcpm.ko))
$(eval $(call add-recovery-module,sprd_time_sync_recovery,sprd_time_sync.ko))
$(eval $(call add-recovery-module,sprd_time_sync_cp_recovery,sprd_time_sync_cp.ko))
$(eval $(call add-recovery-module,sprd_typec_displayport_recovery,sprd_typec_displayport.ko))
$(eval $(call add-recovery-module,sprd_usbm_recovery,sprd_usbm.ko))
$(eval $(call add-recovery-module,sprd_wdt_fiq_recovery,sprd_wdt_fiq.ko))
$(eval $(call add-recovery-module,sy65153_wireless_charger_recovery,sy65153_wireless_charger.ko))
$(eval $(call add-recovery-module,synaptics_td4320_spi_ts_recovery,synaptics_td4320_spi_ts.ko))
$(eval $(call add-recovery-module,trusty_ipc_recovery,trusty-ipc.ko))
$(eval $(call add-recovery-module,trusty_irq_recovery,trusty-irq.ko))
$(eval $(call add-recovery-module,trusty_log_recovery,trusty-log.ko))
$(eval $(call add-recovery-module,trusty_pm_recovery,trusty-pm.ko))
$(eval $(call add-recovery-module,trusty_tui_recovery,trusty-tui.ko))
$(eval $(call add-recovery-module,trusty_virtio_recovery,trusty-virtio.ko))
$(eval $(call add-recovery-module,trusty_recovery,trusty.ko))
$(eval $(call add-recovery-module,twofish_common_recovery,twofish_common.ko))
$(eval $(call add-recovery-module,twofish_generic_recovery,twofish_generic.ko))
$(eval $(call add-recovery-module,ufs_sprd_qogirn6pro_recovery,ufs-sprd-qogirn6pro.ko))
$(eval $(call add-recovery-module,ump9620_regulator_recovery,ump9620-regulator.ko))
$(eval $(call add-recovery-module,ump9621_regulator_recovery,ump9621-regulator.ko))
$(eval $(call add-recovery-module,ums9620_clk_recovery,ums9620-clk.ko))
$(eval $(call add-recovery-module,unisoc_iommu_recovery,unisoc-iommu.ko))
$(eval $(call add-recovery-module,unisoc_mailbox_recovery,unisoc-mailbox.ko))
$(eval $(call add-recovery-module,usb_f_vser_recovery,usb_f_vser.ko))
$(eval $(call add-recovery-module,virt_dma_recovery,virt-dma.ko))
$(eval $(call add-recovery-module,voice_trigger_irq_recovery,voice_trigger_irq.ko))
$(eval $(call add-recovery-module,vpu_recovery,vpu.ko))
$(eval $(call add-recovery-module,zram_recovery,zram.ko))
$(eval $(call add-recovery-module,zsmalloc_recovery,zsmalloc.ko))

# ---------------------------------------------------------------------------
# Module dependency / alias tables, stock names preserved
# ---------------------------------------------------------------------------
$(eval $(call add-recovery-module,modules_alias_recovery,modules.alias))
$(eval $(call add-recovery-module,modules_dep_recovery,modules.dep))
$(eval $(call add-recovery-module,modules_load_recovery,modules.load))
$(eval $(call add-recovery-module,modules_load_recovery_recovery,modules.load.recovery))
$(eval $(call add-recovery-module,modules_softdep_recovery,modules.softdep))
