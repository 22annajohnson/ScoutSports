.DEFAULT_GOAL := run

SHELL := /bin/zsh
.SHELLFLAGS := -o pipefail -c

PROJECT := Scout.xcodeproj
SCHEME := Scout
CONFIGURATION ?= Debug
DESTINATION ?= generic/platform=iOS Simulator
TEST_DESTINATION ?= platform=iOS Simulator,name=iPhone 17 Pro
RUN_DESTINATION ?= platform=iOS Simulator,name=iPhone 17 Pro
SIM_DEVICE ?= iPhone 17 Pro
DERIVED_DATA ?= .build/DerivedData
RESULT_BUNDLE ?= .build/TestResults.xcresult
APP_BUNDLE_ID ?= RCL.Scout
APP_PATH := $(DERIVED_DATA)/Build/Products/$(CONFIGURATION)-iphonesimulator/Scout.app
XCODEBUILD := xcodebuild
XCPRETTY := $(shell command -v xcbeautify >/dev/null 2>&1 && printf "xcbeautify" || printf "cat")

.PHONY: help doctor build build-release run test clean

help:
	@printf "Targets:\n"
	@printf "  make               Build, install, and launch the app in Simulator\n"
	@printf "  make doctor        Show active developer directory and xcodebuild path\n"
	@printf "  make build         Build the app for the configured destination\n"
	@printf "  make build-release Build the app in Release configuration\n"
	@printf "  make run           Build, install, and launch the app in Simulator\n"
	@printf "  make test          Run unit/UI tests on the configured simulator\n"
	@printf "  make clean         Remove local build artifacts\n"
	@printf "\nOverrides:\n"
	@printf "  CONFIGURATION=Debug|Release\n"
	@printf "  DESTINATION='generic/platform=iOS Simulator'\n"
	@printf "  TEST_DESTINATION='platform=iOS Simulator,name=iPhone 17 Pro'\n"
	@printf "  RUN_DESTINATION='platform=iOS Simulator,name=iPhone 17 Pro'\n"
	@printf "  SIM_DEVICE='iPhone 17 Pro'\n"
	@printf "  DERIVED_DATA=.build/DerivedData\n"

doctor:
	@printf "Developer dir: "
	@xcode-select -p
	@printf "xcodebuild: "
	@command -v $(XCODEBUILD) || true

build:
	$(XCODEBUILD) \
		-project $(PROJECT) \
		-scheme $(SCHEME) \
		-configuration $(CONFIGURATION) \
		-destination "$(DESTINATION)" \
		-derivedDataPath $(DERIVED_DATA) \
		build | $(XCPRETTY)

build-release:
	$(MAKE) build CONFIGURATION=Release

run:
	$(XCODEBUILD) \
		-project $(PROJECT) \
		-scheme $(SCHEME) \
		-configuration $(CONFIGURATION) \
		-destination "$(RUN_DESTINATION)" \
		-derivedDataPath $(DERIVED_DATA) \
		build | $(XCPRETTY)
	xcrun simctl boot "$(SIM_DEVICE)" || true
	xcrun simctl bootstatus "$(SIM_DEVICE)" -b
	xcrun simctl install "$(SIM_DEVICE)" "$(APP_PATH)"
	xcrun simctl launch "$(SIM_DEVICE)" $(APP_BUNDLE_ID)

test:
	rm -rf $(RESULT_BUNDLE)
	$(XCODEBUILD) \
		-project $(PROJECT) \
		-scheme $(SCHEME) \
		-configuration $(CONFIGURATION) \
		-destination "$(TEST_DESTINATION)" \
		-derivedDataPath $(DERIVED_DATA) \
		-resultBundlePath $(RESULT_BUNDLE) \
		test | $(XCPRETTY)

clean:
	@if [ -d .build ]; then chmod -R +w .build 2>/dev/null || true; fi
	rm -rf .build
