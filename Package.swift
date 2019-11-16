// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let osEnvRocks: String
#if os(Linux)
osEnvRocks = "OS_GENERIC_LINUX_CUSTOM_ENV"
#else
osEnvRocks = "OS_MACOSX"
#endif

let package = Package(
    name: "rocksdb",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "rocksdb",
            targets: ["rocksdb"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "librocksdb",
            path: "Sources/librocksdb",
            exclude: [
                "db/db_io_failure_test.cc",
                "db/db_universal_compaction_test.cc",
                "db/options_file_test.cc",
                "db/db_encryption_test.cc",
                "db/db_iter_test.cc",
                "db/db_compaction_test.cc",
                "db/column_family_test.cc",
                "db/range_tombstone_fragmenter_test.cc",
                "db/compact_files_test.cc",
                "db/table_properties_collector_test.cc",
                "db/db_basic_test.cc",
                "db/file_indexer_test.cc",
                "db/flush_job_test.cc",
                "db/external_sst_file_test.cc",
                "db/range_del_aggregator_test.cc",
                "db/db_iter_stress_test.cc",
                "db/fault_injection_test.cc",
                "db/wal_manager_test.cc",
                "db/db_inplace_update_test.cc",
                "db/db_flush_test.cc",
                "db/db_log_iter_test.cc",
                "db/error_handler_test.cc",
                "db/prefix_test.cc",
                "db/db_range_del_test.cc",
                "db/db_memtable_test.cc",
                "db/compaction/compaction_iterator_test.cc",
                "db/compaction/compaction_job_stats_test.cc",
                "db/compaction/compaction_picker_test.cc",
                "db/compaction/compaction_job_test.cc",
                "db/perf_context_test.cc",
                "db/comparator_db_test.cc",
                "db/version_builder_test.cc",
                "db/external_sst_file_basic_test.cc",
                "db/db_blob_index_test.cc",
                "db/db_statistics_test.cc",
                "db/import_column_family_test.cc",
                "db/db_compaction_filter_test.cc",
                "db/corruption_test.cc",
                "db/repair_test.cc",
                "db/db_merge_operator_test.cc",
                "db/merge_helper_test.cc",
                "db/filename_test.cc",
                "db/log_test.cc",
                "db/obsolete_files_test.cc",
                "db/db_properties_test.cc",
                "db/version_set_test.cc",
                "db/db_test.cc",
                "db/listener_test.cc",
                "db/db_options_test.cc",
                "db/db_table_properties_test.cc",
                "db/merge_test.cc",
                "db/db_bloom_filter_test.cc",
                "db/cuckoo_table_db_test.cc",
                "db/db_impl/db_secondary_test.cc",
                "db/db_block_cache_test.cc",
                "db/manual_compaction_test.cc",
                "db/db_wal_test.cc",
                "db/memtable_list_test.cc",
                "db/write_batch_test.cc",
                "db/db_iterator_test.cc",
                "db/db_write_test.cc",
                "db/plain_table_db_test.cc",
                "db/db_sst_test.cc",
                "db/version_edit_test.cc",
                "db/db_tailing_iter_test.cc",
                "db/deletefile_test.cc",
                "db/write_controller_test.cc",
                "db/dbformat_test.cc",
                "db/db_dynamic_level_test.cc",
                "db/write_callback_test.cc",

                // inconsistent shit
                "db/db_test2.cc",
                "db/db_test_util.cc"
            ],
            sources: [
                "db",
                "include"
            ],
            publicHeadersPath: "public_headers",
            cxxSettings: [
                .headerSearchPath("."),
                .headerSearchPath("include"),
                .define("ROCKSDB_PLATFORM_POSIX"),
                .define("PORTABLE"),
                .define(osEnvRocks)
            ],
            linkerSettings: [
                .linkedLibrary("stdc++")
            ]),
        .target(
            name: "rocksdb",
            dependencies: [],
            path: "Sources/rocksdb"),
        .testTarget(
            name: "rocksdbTests",
            dependencies: ["rocksdb"]),
    ],
    cxxLanguageStandard: .cxx11
)
