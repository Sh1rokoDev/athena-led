BINARY_NAME = athena-led
VERSION = 0.8.0
OUTPUT_DIR = ./dist
CARGO_FLAGS = --release

ARM_TARGET = aarch64-unknown-linux-musl
X64_TARGET = x86_64-unknown-linux-musl

.PHONY: all arm x64 check clean dirclean

all: arm x64 check

define do_build
	@echo "============================================="
	@echo "🚀 Building $(1)..."
	@echo "============================================="

	@cross build --target $(1) $(CARGO_FLAGS)

	@echo "============================================="
	@echo "📦 Packaging $(1)..."
	@echo "============================================="
	
	@mkdir -p $(OUTPUT_DIR)

	@SOURCE_FILE="target/$(1)/release/$(BINARY_NAME)"; \
	SHORT_TARGET=$$(echo $(1) | cut -d'-' -f1,4); \
	TARGET_FILE_NAME="$(BINARY_NAME)-$${SHORT_TARGET}-$(VERSION)"; \
	TARGET_FILE_PATH="$(OUTPUT_DIR)/$${TARGET_FILE_NAME}"; \
	cp $$SOURCE_FILE $$TARGET_FILE_PATH; \
	cd $(OUTPUT_DIR); \
	tar -czf $${TARGET_FILE_NAME}.tar.gz $${TARGET_FILE_NAME}; \
	sha256sum $${TARGET_FILE_NAME}.tar.gz > $${TARGET_FILE_NAME}.tar.gz.sha256; \
	cd ..;\
	printf "    \033[32mPackage:\033[0m $(OUTPUT_DIR)/$${TARGET_FILE_NAME}.tar.gz\n"; \
	printf "    \033[32mSHA256:\033[0m %s\n" "$$(cut -d' ' -f1 < $(OUTPUT_DIR)/$${TARGET_FILE_NAME}.tar.gz.sha256)"
endef

arm:
	$(call do_build,$(ARM_TARGET))

x64:
	$(call do_build,$(X64_TARGET))

check:
	@echo "============================================="
	@echo "📋 Testing generated files:"
	@echo "============================================="
	@file $(OUTPUT_DIR)/* 2>/dev/null | grep -v '\.tar\.gz' | grep -v '\.sha256' || true

clean:
	@cargo clean

dirclean:
	@cargo clean
	@rm -rfv $(OUTPUT_DIR)