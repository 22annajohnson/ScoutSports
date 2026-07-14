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
SUPABASE ?= supabase
SUPABASE_WORKDIR ?= backend/supabase
SUPABASE_MIGRATION_NAME ?=

.PHONY: help doctor build build-release run test clean supabase-doctor supabase-start supabase-stop supabase-status supabase-db-reset supabase-migration-new

help:
	@printf "Targets:\n"
	@printf "  make               Build, install, and launch the app in Simulator\n"
	@printf "  make doctor        Show active developer directory and xcodebuild path\n"
	@printf "  make build         Build the app for the configured destination\n"
	@printf "  make build-release Build the app in Release configuration\n"
	@printf "  make run           Build, install, and launch the app in Simulator\n"
	@printf "  make test          Run unit/UI tests on the configured simulator\n"
	@printf "  make clean         Remove local build artifacts\n"
	@printf "  make supabase-doctor        Check local Supabase CLI prerequisites\n"
	@printf "  make supabase-start         Start local Supabase stack\n"
	@printf "  make supabase-stop          Stop local Supabase stack\n"
	@printf "  make supabase-status        Show local Supabase stack status\n"
	@printf "  make supabase-db-reset      Reset local Supabase database\n"
	@printf "  make supabase-migration-new SUPABASE_MIGRATION_NAME=INFRA-123_short_name\n"
	@printf "\nOverrides:\n"
	@printf "  CONFIGURATION=Debug|Release\n"
	@printf "  DESTINATION='generic/platform=iOS Simulator'\n"
	@printf "  TEST_DESTINATION='platform=iOS Simulator,name=iPhone 17 Pro'\n"
	@printf "  RUN_DESTINATION='platform=iOS Simulator,name=iPhone 17 Pro'\n"
	@printf "  SIM_DEVICE='iPhone 17 Pro'\n"
	@printf "  DERIVED_DATA=.build/DerivedData\n"
	@printf "  SUPABASE_WORKDIR=backend/supabase\n"
	@printf "  SUPABASE_MIGRATION_NAME=INFRA-123_short_name\n"

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

supabase-doctor:
	@printf "supabase: "
	@command -v $(SUPABASE)
	@$(SUPABASE) --version
	@test -d "$(SUPABASE_WORKDIR)/migrations"
	@test -d "$(SUPABASE_WORKDIR)/seed"
	@test -d "$(SUPABASE_WORKDIR)/types"
	@test -d "$(SUPABASE_WORKDIR)/config"
	@if command -v docker >/dev/null 2>&1; then \
		if docker info >/dev/null 2>&1; then \
			printf "docker: available\n"; \
		else \
			printf "docker: unavailable or not running\n"; \
		fi; \
	else \
		printf "docker: not installed\n"; \
	fi
	@if [ -f "$(SUPABASE_WORKDIR)/config.toml" ]; then \
		printf "supabase config: present\n"; \
	else \
		printf "supabase config: not present; run supabase init only when an approved story requires local stack activation\n"; \
	fi

supabase-start:
	$(SUPABASE) start --workdir "$(SUPABASE_WORKDIR)"

supabase-stop:
	$(SUPABASE) stop --workdir "$(SUPABASE_WORKDIR)"

supabase-status:
	$(SUPABASE) status --workdir "$(SUPABASE_WORKDIR)"

supabase-db-reset:
	$(SUPABASE) db reset --workdir "$(SUPABASE_WORKDIR)"

supabase-migration-new:
	@test -n "$(SUPABASE_MIGRATION_NAME)" || (printf "Set SUPABASE_MIGRATION_NAME=INFRA-123_short_name\n"; exit 2)
	$(SUPABASE) migration new "$(SUPABASE_MIGRATION_NAME)" --workdir "$(SUPABASE_WORKDIR)"
