#
# TWRP common device config for Coolpad CP3NV1 (酷派大观3)
# Unisoc UMS9620 (qogirn6pro) / board: agn2262SG
#
# Product identity lives in twrp_agn2262SG.mk (registered via AndroidProducts.mk).
#
# IMPORTANT — do NOT use $(LOCAL_PATH) or $(DEVICE_PATH) in this file.
#
#   * $(DEVICE_PATH) is only defined while BoardConfig.mk is being evaluated.
#   * $(LOCAL_PATH) is *reset by the build system* around the product-makefile
#     eval (build/make/core/product.mk clears it), and because this file is
#     pulled in through inherit-product it is empty here too.
#
# Either one silently turns "device/Coolpad/agn2262SG/recovery.fstab" into
# "/recovery.fstab", and ninja dies with:
#   FAILED: ninja: '/recovery.fstab', needed by
#     'out/target/product/agn2262SG/obj/PACKAGING/recovery_intermediates/ramdisk_files-timestamp',
#     missing and no known rule to make it
#
# So every source path below is spelled out literally.
#

# Inherit from vendor
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, vendor/twrp/config/common.mk)

# This is a recovery-only build: never try to assemble a replacement super image.
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION := false

# Recovery fstab & init
#
# IMPORTANT — destination must be root/system/etc/, NOT root/etc/.
#
# In the recovery root, "root/etc" is a SYMLINK to /system/etc. The
# ramdisk_files rule does:
#     rsync -a ... $(PRODUCT_OUT)/root $(PRODUCT_OUT)/recovery
# and $(PRODUCT_OUT)/root/etc is that symlink. If anything installs a real file
# into recovery/root/etc/ first, the directory becomes a non-empty real dir and
# rsync refuses to replace it with the symlink:
#     could not make way for new symlink: root/etc
#     cannot delete non-empty directory: root/etc
#     rsync error: some files/attrs were not transferred (code 23)
#
# The build system already writes recovery.fstab through the real path itself
# (BoardConfig's TARGET_RECOVERY_FSTAB lands in recovery/root/system/etc/), and
# /etc resolves to /system/etc at runtime, so both paths are equivalent.
# recovery.fstab is therefore not listed here at all - TARGET_RECOVERY_FSTAB
# handles it.
PRODUCT_COPY_FILES += \
    device/Coolpad/agn2262SG/init.recovery.agn2262SG.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.agn2262SG.rc \
    device/Coolpad/agn2262SG/twrp.fstab:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/twrp.fstab

# ---------------------------------------------------------------------------
# Recovery 内核模块（完整恢复环境）
# 原厂 vendor_boot 的 vendor_ramdisk 其实就是 stock recovery ramdisk，
# 其中 /lib/modules 共 163 个 .ko + 5 个描述表，已逐一 md5 比对，字节一致。
#
# 必须全量：modules.load.recovery 列了 164 项，含 UFS / clk / GPIO / PMIC / USB，
# 只带显示栈会导致 recovery 挂不上 /data。
#
# 不用 PRODUCT_COPY_FILES：.ko 是 ELF，会被 definitions.mk:2658 的
# copy-non-elf-file-checked 拦下。改由 Android.mk 的 BUILD_PREBUILT 安装。
# 描述表保持原厂文件名，init 是按名字精确查找的，改名会静默失效。
# ---------------------------------------------------------------------------
PRODUCT_PACKAGES += \
    aes_ce_ccm_recovery \
    aes_neon_blk_recovery \
    agdsp_access_recovery \
    agn_ump9620_fast_charger_recovery \
    apsys_dvfs_recovery \
    arc4_recovery \
    asix_recovery \
    audio_dsp_dump_recovery \
    audio_pipe_recovery \
    audio_mem_recovery \
    audio_sipc_recovery \
    ax88179_178a_recovery \
    bq2560x_charger_recovery \
    bq2597x_charger_recovery \
    chipone_tddi_icnl9916_recovery \
    clk_sprd_recovery \
    core_recovery \
    dwc3_sprd_core_recovery \
    dwc3_sprd_recovery \
    eta6937_charger_recovery \
    extcon_usb_gpio_recovery \
    flash_ic_ocp8137_recovery \
    flash_ic_sgm37891_recovery \
    focaltech_ft8756_spi_ts_recovery \
    fts_ts_recovery \
    ghash_ce_recovery \
    gpio_eic_sprd_recovery \
    gpio_pmic_eic_sprd_recovery \
    gpio_sprd_recovery \
    gpio_recovery \
    i2c_sprd_hw_recovery \
    i2c_sprd_recovery \
    ion_cma_heap_recovery \
    ion_ipc_trusty_recovery \
    jpg_recovery \
    kfifo_buf_recovery \
    leds_sc27xx_bltc_recovery \
    ledtrig_pattern_recovery \
    mcdt_hw_r2p0_recovery \
    microarray_fp_recovery \
    mipi_driver_recovery \
    misc_sprd_uid_recovery \
    mmc_hsq_recovery \
    mmc_swcq_recovery \
    modem_frequency_band_recovery \
    nvmem_sc27xx_efuse_recovery \
    nvmem_sprd_efuse_recovery \
    nvt_nt36xxx_spi_ts_recovery \
    phy_sprd_commonphy_recovery \
    phy_sprd_usb31_qogirn6pro_recovery \
    pinctrl_sprd_qogirn6pro_recovery \
    pinctrl_sprd_recovery \
    pinctrl_recovery \
    ptn38003a_i2c_recovery \
    pwm_sprd_recovery \
    rpmb_recovery \
    rtc_sc27xx_recovery \
    sblock_bridge_recovery \
    sbuf_bridge_recovery \
    sc27xx_poweroff_recovery \
    sc27xx_vibra_recovery \
    sc27xx_adc_recovery \
    sc27xx_fuel_gauge_recovery \
    sc27xx_pd_recovery \
    sc27xx_typec_recovery \
    sdhci_sprd_recovery \
    sensorhub_recovery \
    seth_recovery \
    sfp_core_recovery \
    sgm41513_charger_recovery \
    sha1_ce_recovery \
    silead_fp_recovery \
    sipa_core_recovery \
    sipa_dele_recovery \
    sipa_sys_recovery \
    sipa_eth_recovery \
    sipa_usb_recovery \
    sipc_core_recovery \
    sipx_recovery \
    slog_bridge_recovery \
    snd_soc_sprd_card_recovery \
    snd_soc_sprd_codec_aw87xxx_recovery \
    snd_soc_sprd_codec_ump9620_power_dev_recovery \
    snd_soc_sprd_codec_ump9620_power_recovery \
    snd_soc_sprd_codec_ump9620_recovery \
    snd_soc_sprd_dai_recovery \
    snd_soc_sprd_dummy_codec_recovery \
    snd_soc_sprd_pa_ucp1301_recovery \
    snd_soc_sprd_pdm_r2p0_recovery \
    snd_soc_sprd_tdm_recovery \
    snd_soc_sprd_vbc_fe_recovery \
    snd_soc_sprd_vbc_v4_recovery \
    snd_soc_unisoc_dp_codec_recovery \
    spi_sprd_adi_recovery \
    spi_sprd_recovery \
    spipe_recovery \
    spool_recovery \
    sprd_bc1p2_recovery \
    sprd_charger_manager_recovery \
    sprd_compr_2stage_dma_recovery \
    sprd_cpufreq_public_recovery \
    sprd_cpufreq_v2_recovery \
    sprd_dma_recovery \
    sprd_dmaengine_pcm_recovery \
    sprd_drm_recovery \
    sprd_gsp_recovery \
    sprd_ion_recovery \
    sprd_pamu3_recovery \
    sprd_platform_pcm_routing_recovery \
    sprd_sipc_virt_bus_recovery \
    sprd_ump96xx_spi_recovery \
    sprd_vpu_pw_domain_recovery \
    sprd_7sreset_recovery \
    sprd_apipe_recovery \
    sprd_audcp_boot_recovery \
    sprd_audcp_dvfs_recovery \
    sprd_battery_info_recovery \
    sprd_camera_recovery \
    sprd_camsys_pw_domain_recovery \
    sprd_cpp_recovery \
    sprd_flash_drv_recovery \
    sprd_hwspinlock_recovery \
    sprd_manufacturer_model_recovery \
    sprd_mipi_recovery \
    sprd_modem_loader_recovery \
    sprd_pdbg_recovery \
    sprd_pmic_syscon_recovery \
    sprd_power_manager_recovery \
    sprd_power_stat_recovery \
    sprd_sensor_recovery \
    sprd_shm_recovery \
    sprd_sip_svc_recovery \
    sprd_soc_id_recovery \
    sprd_systimer_recovery \
    sprd_tcpm_recovery \
    sprd_time_sync_recovery \
    sprd_time_sync_cp_recovery \
    sprd_typec_displayport_recovery \
    sprd_usbm_recovery \
    sprd_wdt_fiq_recovery \
    sy65153_wireless_charger_recovery \
    synaptics_td4320_spi_ts_recovery \
    trusty_ipc_recovery \
    trusty_irq_recovery \
    trusty_log_recovery \
    trusty_pm_recovery \
    trusty_tui_recovery \
    trusty_virtio_recovery \
    trusty_recovery \
    twofish_common_recovery \
    twofish_generic_recovery \
    ufs_sprd_qogirn6pro_recovery \
    ump9620_regulator_recovery \
    ump9621_regulator_recovery \
    ums9620_clk_recovery \
    unisoc_iommu_recovery \
    unisoc_mailbox_recovery \
    usb_f_vser_recovery \
    virt_dma_recovery \
    voice_trigger_irq_recovery \
    vpu_recovery \
    zram_recovery \
    zsmalloc_recovery \
    modules_alias_recovery \
    modules_dep_recovery \
    modules_load_recovery \
    modules_load_recovery_recovery \
    modules_softdep_recovery
