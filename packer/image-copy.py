#!/usr/bin/env python

from b2sdk.v1 import *
import sys
import time

realm = 'production'
info = InMemoryAccountInfo()
b2_api = B2Api(info)

application_key_id = input ("App key id:")
application_key = input ("App key:")

b2_api.authorize_account("production", application_key_id, application_key)

source = './image-build'
destination = 'b2://air-production-templates'

source = parse_sync_folder(source, b2_api)
destination = parse_sync_folder(destination, b2_api)

policies_manager = ScanPoliciesManager(exclude_all_symlinks=True)

synchronizer = Synchronizer(max_workers=10, policies_manager=policies_manager, dry_run=False, allow_empty_source=True,)

no_progress = False

with SyncReport(sys.stdout, no_progress) as reporter:
        synchronizer.sync_folders(
            source_folder=source,
            dest_folder=destination,
            now_millis=int(round(time.time() * 1000)),
            reporter=reporter,
        )
