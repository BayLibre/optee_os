PLATFORM_FLAVOR ?= mx6ulevk

# Get SoC associated with the PLATFORM_FLAVOR
mx6ul-flavorlist = mx6ulevk
mx6ull-flavorlist = mx6ullevk
mx6q-flavorlist = mx6qsabrelite mx6qsabresd
mx6sx-flavorlist = mx6sxsabreauto
mx6d-flavorlist =
mx6dl-flavorlist = mx6dlsabresd
mx6s-flavorlist =
mx7-flavorlist = mx7dsabresd mx7swarp7

ifneq (,$(filter $(PLATFORM_FLAVOR),$(mx6ul-flavorlist)))
$(call force,CFG_MX6UL,y)
else ifneq (,$(filter $(PLATFORM_FLAVOR),$(mx6ull-flavorlist)))
$(call force,CFG_MX6ULL,y)
else ifneq (,$(filter $(PLATFORM_FLAVOR),$(mx6q-flavorlist)))
$(call force,CFG_MX6Q,y)
else ifneq (,$(filter $(PLATFORM_FLAVOR),$(mx6d-flavorlist)))
$(call force,CFG_MX6D,y)
else ifneq (,$(filter $(PLATFORM_FLAVOR),$(mx6dl-flavorlist)))
$(call force,CFG_MX6DL,y)
else ifneq (,$(filter $(PLATFORM_FLAVOR),$(mx6s-flavorlist)))
$(call force,CFG_MX6S,y)
else ifneq (,$(filter $(PLATFORM_FLAVOR),$(mx6sx-flavorlist)))
$(call force,CFG_MX6,y)
$(call force,CFG_MX6SX,y)
$(call force,CFG_IMX_UART,y)
else ifneq (,$(filter $(PLATFORM_FLAVOR),$(mx7-flavorlist)))
$(call force,CFG_MX7,y)
else
$(error Unsupported PLATFORM_FLAVOR "$(PLATFORM_FLAVOR)")
endif

ifneq (,$(filter $(PLATFORM_FLAVOR),mx7dsabresd))
CFG_DDR_SIZE ?= 0x40000000
CFG_DT ?= y
CFG_NS_ENTRY_ADDR ?= 0x80800000
CFG_PSCI_ARM32 ?= y
CFG_TEE_CORE_NB_CORE ?= 2
endif

ifneq (,$(filter $(PLATFORM_FLAVOR),mx7swarp7))
CFG_DDR_SIZE ?= 0x20000000
CFG_DT ?= y
CFG_NS_ENTRY_ADDR ?= 0x80800000
CFG_PSCI_ARM32 ?= y
CFG_TEE_CORE_NB_CORE ?= 1
endif

# Common i.MX6 config
$(call force,CFG_GENERIC_BOOT,y)
$(call force,CFG_GIC,y)
$(call force,CFG_IMX_UART,y)
$(call force,CFG_PM_STUBS,y)
$(call force,CFG_WITH_SOFTWARE_PRNG,y)

CFG_CRYPTO_SIZE_OPTIMIZATION ?= n
CFG_WITH_STACK_CANARIES ?= y


# i.MX6UL/ULL specific config
ifneq (,$(filter y, $(CFG_MX6UL) $(CFG_MX6ULL)))
include core/arch/arm/cpu/cortex-a7.mk

$(call force,CFG_MX6,y)
$(call force,CFG_SECURE_TIME_SOURCE_REE,y)
endif


# i.MX6 Solo/DualLite/Dual/Quad specific config
ifeq ($(filter y, $(CFG_MX6Q) $(CFG_MX6D) $(CFG_MX6DL) $(CFG_MX6S) \
      $(CFG_MX6SX)), y)
include core/arch/arm/cpu/cortex-a9.mk

$(call force,CFG_MX6,y)
$(call force,CFG_PL310,y)
$(call force,CFG_PL310_LOCKED,y)
$(call force,CFG_SECURE_TIME_SOURCE_REE,y)

CFG_BOOT_SYNC_CPU ?= y
CFG_BOOT_SECONDARY_REQUEST ?= y
CFG_ENABLE_SCTLR_RR ?= y
endif

ifeq ($(filter y, $(CFG_MX7)), y)
include core/arch/arm/cpu/cortex-a7.mk

$(call force,CFG_SECURE_TIME_SOURCE_REE,y)
CFG_BOOT_SECONDARY_REQUEST ?= y
CFG_INIT_CNTVOFF ?= y
endif

ifneq (,$(filter $(PLATFORM_FLAVOR),mx6sxsabreauto))
CFG_PAGEABLE_ADDR ?= 0
CFG_DDR_SIZE ?= 0x80000000
CFG_DT ?= y
CFG_NS_ENTRY_ADDR ?= 0x80800000
CFG_PSCI_ARM32 ?= y
CFG_BOOT_SYNC_CPU = n
CFG_BOOT_SECONDARY_REQUEST = n
CFG_TEE_CORE_NB_CORE ?= 1
endif

ifeq ($(filter y, $(CFG_PSCI_ARM32)), y)
CFG_HWSUPP_MEM_PERM_WXN = n
CFG_IMX_WDOG ?= y
endif

CFG_MMAP_REGIONS ?= 24

ta-targets = ta_arm32
