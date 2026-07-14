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
SUPABASE_WORKDIR ?= backend
SUPABASE_MIGRATION_NAME ?=
SUPABASE_SEED_FILE ?= backend/supabase/seed.sql
SUPABASE_TEST_DB_PATH ?= backend/supabase/tests/database
SUPABASE_GEN_SCHEMA ?= public
SUPABASE_SWIFT_TYPES ?= backend/supabase/types/swift/Database.generated.swift

.PHONY: help doctor build build-release run test clean supabase-doctor supabase-start supabase-stop supabase-status supabase-db-reset supabase-validate-reset-seed supabase-migration-new supabase-migration-up supabase-test-db supabase-gen-types-swift supabase-check-types-swift

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
	@printf "  make supabase-validate-reset-seed Reset local database and validate seed loading\n"
	@printf "  make supabase-migration-new SUPABASE_MIGRATION_NAME=INFRA-123_short_name\n"
	@printf "  make supabase-migration-up  Apply pending local migrations\n"
	@printf "  make supabase-test-db       Run local pgTAP database tests\n"
	@printf "  make supabase-gen-types-swift Generate Swift Supabase types locally\n"
	@printf "  make supabase-check-types-swift Check committed Swift Supabase types are fresh\n"
	@printf "\nOverrides:\n"
	@printf "  CONFIGURATION=Debug|Release\n"
	@printf "  DESTINATION='generic/platform=iOS Simulator'\n"
	@printf "  TEST_DESTINATION='platform=iOS Simulator,name=iPhone 17 Pro'\n"
	@printf "  RUN_DESTINATION='platform=iOS Simulator,name=iPhone 17 Pro'\n"
	@printf "  SIM_DEVICE='iPhone 17 Pro'\n"
	@printf "  DERIVED_DATA=.build/DerivedData\n"
	@printf "  SUPABASE_WORKDIR=backend\n"
	@printf "  SUPABASE_MIGRATION_NAME=INFRA-123_short_name\n"
	@printf "  SUPABASE_SEED_FILE=backend/supabase/seed.sql\n"
	@printf "  SUPABASE_TEST_DB_PATH=backend/supabase/tests/database\n"
	@printf "  SUPABASE_GEN_SCHEMA=public\n"
	@printf "  SUPABASE_SWIFT_TYPES=backend/supabase/types/swift/Database.generated.swift\n"

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
	@test -d "$(SUPABASE_WORKDIR)/supabase/migrations"
	@test -d "$(SUPABASE_WORKDIR)/supabase/seed"
	@test -d "$(SUPABASE_WORKDIR)/supabase/types"
	@test -d "$(SUPABASE_WORKDIR)/supabase/config"
	@test -d "$(SUPABASE_TEST_DB_PATH)"
	@test -f "$(SUPABASE_SEED_FILE)"
	@if command -v docker >/dev/null 2>&1; then \
		if docker info >/dev/null 2>&1; then \
			printf "docker: available\n"; \
		else \
			printf "docker: unavailable or not running\n"; \
		fi; \
	else \
		printf "docker: not installed\n"; \
	fi
	@if [ -f "$(SUPABASE_WORKDIR)/supabase/config.toml" ]; then \
		printf "supabase config: present\n"; \
	else \
		printf "supabase config: not present; run supabase init --workdir $(SUPABASE_WORKDIR) only when an approved story requires local stack activation\n"; \
	fi

supabase-start:
	$(SUPABASE) start --workdir "$(SUPABASE_WORKDIR)"

supabase-stop:
	$(SUPABASE) stop --workdir "$(SUPABASE_WORKDIR)"

supabase-status:
	$(SUPABASE) status --workdir "$(SUPABASE_WORKDIR)"

supabase-db-reset:
	$(SUPABASE) db reset --workdir "$(SUPABASE_WORKDIR)"

supabase-validate-reset-seed:
	@test -f "$(SUPABASE_SEED_FILE)" || (printf "Missing seed file: $(SUPABASE_SEED_FILE)\n"; exit 2)
	$(SUPABASE) db reset --workdir "$(SUPABASE_WORKDIR)"

supabase-migration-new:
	@test -n "$(SUPABASE_MIGRATION_NAME)" || (printf "Set SUPABASE_MIGRATION_NAME=INFRA-123_short_name\n"; exit 2)
	$(SUPABASE) migration new "$(SUPABASE_MIGRATION_NAME)" --workdir "$(SUPABASE_WORKDIR)"

supabase-migration-up:
	$(SUPABASE) migration up --workdir "$(SUPABASE_WORKDIR)"

supabase-test-db:
	$(SUPABASE) test db "$(SUPABASE_TEST_DB_PATH)" --workdir "$(SUPABASE_WORKDIR)"

supabase-gen-types-swift:
	$(SUPABASE) gen types --local --lang swift --schema "$(SUPABASE_GEN_SCHEMA)" --swift-access-control internal --workdir "$(SUPABASE_WORKDIR)" > "$(SUPABASE_SWIFT_TYPES)"

supabase-check-types-swift:
	@test -f "$(SUPABASE_SWIFT_TYPES)" || (printf "Missing generated Swift types: $(SUPABASE_SWIFT_TYPES)\n"; exit 2)
	@tmp_file=$$(mktemp); \
	trap 'rm -f "$$tmp_file"' EXIT; \
	$(SUPABASE) gen types --local --lang swift --schema "$(SUPABASE_GEN_SCHEMA)" --swift-access-control internal --workdir "$(SUPABASE_WORKDIR)" > "$$tmp_file"; \
	if diff -u "$(SUPABASE_SWIFT_TYPES)" "$$tmp_file" >/dev/null; then \
		printf "Swift Supabase generated types are fresh: $(SUPABASE_SWIFT_TYPES)\n"; \
	else \
		printf "Swift Supabase generated types are stale. Run make supabase-gen-types-swift after resetting the local database.\n"; \
		diff -u "$(SUPABASE_SWIFT_TYPES)" "$$tmp_file"; \
		exit 1; \
	fi
