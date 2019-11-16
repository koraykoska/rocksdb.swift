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
                "upstream/db/db_io_failure_test.cc",
                "upstream/db/db_universal_compaction_test.cc",
                "upstream/db/options_file_test.cc",
                "upstream/db/db_encryption_test.cc",
                "upstream/db/db_iter_test.cc",
                "upstream/db/db_compaction_test.cc",
                "upstream/db/column_family_test.cc",
                "upstream/db/range_tombstone_fragmenter_test.cc",
                "upstream/db/compact_files_test.cc",
                "upstream/db/table_properties_collector_test.cc",
                "upstream/db/db_basic_test.cc",
                "upstream/db/file_indexer_test.cc",
                "upstream/db/flush_job_test.cc",
                "upstream/db/external_sst_file_test.cc",
                "upstream/db/range_del_aggregator_test.cc",
                "upstream/db/db_iter_stress_test.cc",
                "upstream/db/fault_injection_test.cc",
                "upstream/db/wal_manager_test.cc",
                "upstream/db/db_inplace_update_test.cc",
                "upstream/db/db_flush_test.cc",
                "upstream/db/db_log_iter_test.cc",
                "upstream/db/error_handler_test.cc",
                "upstream/db/prefix_test.cc",
                "upstream/db/db_range_del_test.cc",
                "upstream/db/db_memtable_test.cc",
                "upstream/db/compaction/compaction_iterator_test.cc",
                "upstream/db/compaction/compaction_job_stats_test.cc",
                "upstream/db/compaction/compaction_picker_test.cc",
                "upstream/db/compaction/compaction_job_test.cc",
                "upstream/db/perf_context_test.cc",
                "upstream/db/comparator_db_test.cc",
                "upstream/db/version_builder_test.cc",
                "upstream/db/external_sst_file_basic_test.cc",
                "upstream/db/db_blob_index_test.cc",
                "upstream/db/db_statistics_test.cc",
                "upstream/db/import_column_family_test.cc",
                "upstream/db/db_compaction_filter_test.cc",
                "upstream/db/corruption_test.cc",
                "upstream/db/repair_test.cc",
                "upstream/db/db_merge_operator_test.cc",
                "upstream/db/merge_helper_test.cc",
                "upstream/db/filename_test.cc",
                "upstream/db/log_test.cc",
                "upstream/db/obsolete_files_test.cc",
                "upstream/db/db_properties_test.cc",
                "upstream/db/version_set_test.cc",
                "upstream/db/db_test.cc",
                "upstream/db/listener_test.cc",
                "upstream/db/db_options_test.cc",
                "upstream/db/db_table_properties_test.cc",
                "upstream/db/merge_test.cc",
                "upstream/db/db_bloom_filter_test.cc",
                "upstream/db/cuckoo_table_db_test.cc",
                "upstream/db/db_impl/db_secondary_test.cc",
                "upstream/db/db_block_cache_test.cc",
                "upstream/db/manual_compaction_test.cc",
                "upstream/db/db_wal_test.cc",
                "upstream/db/memtable_list_test.cc",
                "upstream/db/write_batch_test.cc",
                "upstream/db/db_iterator_test.cc",
                "upstream/db/db_write_test.cc",
                "upstream/db/plain_table_db_test.cc",
                "upstream/db/db_sst_test.cc",
                "upstream/db/version_edit_test.cc",
                "upstream/db/db_tailing_iter_test.cc",
                "upstream/db/deletefile_test.cc",
                "upstream/db/write_controller_test.cc",
                "upstream/db/dbformat_test.cc",
                "upstream/db/db_dynamic_level_test.cc",
                "upstream/db/write_callback_test.cc",

                // inconsistent shit
                "upstream/db/db_test2.cc",
                "upstream/db/db_test_util.cc"
            ],
            sources: [
                "upstream/db",
                "upstream/include"
            ],
            publicHeadersPath: "public_headers",
            cxxSettings: [
                .headerSearchPath("upstream"),
                .headerSearchPath("upstream/include"),
                .define("ROCKSDB_PLATFORM_POSIX"),
                .define("PORTABLE"),
                .define(osEnvRocks)
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
