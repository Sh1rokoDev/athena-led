BINARY_NAME = athena-led
OUTPUT_DIR = ./dist
CARGO_FLAGS = --release

ARM_TARGET = aarch64-unknown-linux-musl
X64_TARGET = x86_64-unknown-linux-gnu

.PHONY: all build-arm build-x64 clean check

all: build-arm build-x64 check

define do_build
	@echo "🚀 Building $(1)..."
	mkdir -p $(OUTPUT_DIR)
	cargo zigbuild $(CARGO_FLAGS) --target $(1) || \
	(echo "⚠️ <cargo zigbuild> failed, trying <cargo build>" && cargo build $(CARGO_FLAGS) --target $(1))
	cp target/$(1)/release/$(BINARY_NAME) $(OUTPUT_DIR)/$(BINARY_NAME)-$(2)
endef

build-arm:
	$(call do_build,$(ARM_TARGET),aarch64-musl)

build-x64:
	$(call do_build,$(X64_TARGET),x86_64-gnu)

check:
	@echo "📋 Testing generated files:"
	@ls -lh $(OUTPUT_DIR)
	@file $(OUTPUT_DIR)/* 2>/dev/null || true

clean:
	cargo clean
	rm -rf $(OUTPUT_DIR)