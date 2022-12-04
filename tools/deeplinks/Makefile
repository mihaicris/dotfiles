default: build

.PHONY: build
build:
	swift build -c release

.PHONY: formatter-swift
formatter-swift:
	~/cloned/swift-format/.build/release/swift-format --in-place --parallel --recursive Sources

.PHONY: pretty
pretty: formatter-swift
