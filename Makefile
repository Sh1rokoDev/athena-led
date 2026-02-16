BINARY_NAME = athena-led
VERSION = 0.8.0
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
	cp target/$(1)/release/$(BINARY_NAME) $(OUTPUT_DIR)/$(BINARY_NAME)-$(2)-$(VERSION)
	@echo "📦 Packaging $(2)..."
	cd $(OUTPUT_DIR) && tar -czf $(BINARY_NAME)-$(2)-$(VERSION).tar.gz $(BINARY_NAME)-$(2)-$(VERSION)
	cd $(OUTPUT_DIR) && sha256sum $(BINARY_NAME)-$(2)-$(VERSION).tar.gz > $(BINARY_NAME)-$(2)-$(VERSION).tar.gz.sha256
	@echo "✅ Package: $(OUTPUT_DIR)/$(BINARY_NAME)-$(2)-$(VERSION).tar.gz"
	@echo "✅ SHA256: $(OUTPUT_DIR)/$(BINARY_NAME)-$(2)-$(VERSION).tar.gz.sha256"
endef

build-arm:
	$(call do_build,$(ARM_TARGET),aarch64-musl)

build-x64:
	$(call do_build,$(X64_TARGET),x86_64-gnu)

check:
	@echo "📋 Testing generated files:"
	@file $(OUTPUT_DIR)/* 2>/dev/null || true

clean:
	cargo clean
	rm -rf $(OUTPUT_DIR)