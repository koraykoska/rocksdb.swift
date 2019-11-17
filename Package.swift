// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let osEnvRocks: String
#if os(Linux)
osEnvRocks = "OS_LINUX"
#else
osEnvRocks = "OS_MACOSX"
#endif

func shell(_ commands: String...) -> String {
    let task = Process()
    task.launchPath = "/bin/bash"
    task.arguments = ["-c"] + commands

    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String

    return output
}
let rocksDBHash = shell("git --git-dir=Sources/librocksdb/upstream/.git rev-parse HEAD")
    .trimmingCharacters(in: .whitespacesAndNewlines)
let rocksDBCommitDate = String(
    shell("git --git-dir=Sources/librocksdb/upstream/.git show --format='%ci' \(rocksDBHash)"
).split(separator: "\n")[0]).trimmingCharacters(in: .whitespacesAndNewlines)

let package = Package(
    name: "RocksDB",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "RocksDB",
            targets: ["RocksDB"]),
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
                // cache
                "upstream/cache/cache_test.cc",
                "upstream/cache/lru_cache_test.cc",
                // inconsistent shit aka tests with some different naming
                "upstream/cache/cache_bench.cc",

                // db

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
                "upstream/db/db_test_util.cc",
                "upstream/db/c_test.c",
                "upstream/db/forward_iterator_bench.cc",
                "upstream/db/range_del_aggregator_bench.cc",

                // env
                "upstream/env/env_basic_test.cc",
                "upstream/env/env_test.cc",
                "upstream/env/mock_env_test.cc",
                // inconsistent shit
                // "upstream/env/mock_env.h",
                // "upstream/env/mock_env.cc",

                // file
                "upstream/file/delete_scheduler_test.cc",

                // logging
                "upstream/logging/auto_roll_logger_test.cc",
                "upstream/logging/env_logger_test.cc",
                "upstream/logging/event_logger_test.cc",

                // memory
                "upstream/memory/arena_test.cc",

                // memtable
                "upstream/memtable/inlineskiplist_test.cc",
                "upstream/memtable/skiplist_test.cc",
                "upstream/memtable/write_buffer_manager_test.cc",
                // inconsistent shit
                "upstream/memtable/memtablerep_bench.cc",

                // monitoring
                "upstream/monitoring/histogram_test.cc",
                "upstream/monitoring/iostats_context_test.cc",
                "upstream/monitoring/statistics_test.cc",
                "upstream/monitoring/stats_history_test.cc",

                // options
                "upstream/options/options_settable_test.cc",
                "upstream/options/options_test.cc",

                // port
                "upstream/port/win",

                // table
                "upstream/table/sst_file_reader_test.cc",
                "upstream/table/cleanable_test.cc",
                "upstream/table/merger_test.cc",
                "upstream/table/cuckoo/cuckoo_table_builder_test.cc",
                "upstream/table/cuckoo/cuckoo_table_reader_test.cc",
                "upstream/table/block_based/data_block_hash_index_test.cc",
                "upstream/table/block_based/full_filter_block_test.cc",
                "upstream/table/block_based/block_based_filter_block_test.cc",
                "upstream/table/block_based/block_test.cc",
                "upstream/table/block_based/partitioned_filter_block_test.cc",
                "upstream/table/table_test.cc",
                // inconsistent shit
                "upstream/table/mock_table.h",
                "upstream/table/mock_table.cc",
                "upstream/table/table_reader_bench.cc",

                // test_util
                "upstream/test_util/testharness.cc",
                "upstream/test_util/testharness.h",

                // trace_replay
                "upstream/trace_replay/block_cache_tracer_test.cc",

                // util
                "upstream/util/rate_limiter_test.cc",
                "upstream/util/thread_list_test.cc",
                "upstream/util/thread_local_test.cc",
                "upstream/util/file_reader_writer_test.cc",
                "upstream/util/heap_test.cc",
                "upstream/util/autovector_test.cc",
                "upstream/util/crc32c_test.cc",
                "upstream/util/bloom_test.cc",
                "upstream/util/hash_test.cc",
                "upstream/util/filelock_test.cc",
                "upstream/util/coding_test.cc",
                "upstream/util/dynamic_bloom_test.cc",
                "upstream/util/repeatable_thread_test.cc",
                "upstream/util/slice_transform_test.cc",
                "upstream/util/timer_queue_test.cc",
                // inconsistent shit
                "upstream/util/crc32c_ppc_asm.S",
                "upstream/util/log_write_bench.cc",

                // utilities
                "upstream/utilities/simulator_cache/sim_cache_test.cc",
                "upstream/utilities/simulator_cache/cache_simulator_test.cc",
                "upstream/utilities/options/options_util_test.cc",
                "upstream/utilities/util_merge_operators_test.cc",
                "upstream/utilities/checkpoint/checkpoint_test.cc",
                "upstream/utilities/memory/memory_test.cc",
                "upstream/utilities/ttl/ttl_test.cc",
                "upstream/utilities/backupable/backupable_db_test.cc",
                "upstream/utilities/table_properties_collectors/compact_on_deletion_collector_test.cc",
                "upstream/utilities/option_change_migration/option_change_migration_test.cc",
                "upstream/utilities/env_librados_test.cc",
                "upstream/utilities/transactions/write_prepared_transaction_test.cc",
                "upstream/utilities/transactions/write_unprepared_transaction_test.cc",
                "upstream/utilities/transactions/transaction_test.cc",
                "upstream/utilities/transactions/optimistic_transaction_test.cc",
                "upstream/utilities/cassandra/cassandra_serialize_test.cc",
                "upstream/utilities/cassandra/cassandra_row_merge_test.cc",
                "upstream/utilities/cassandra/cassandra_format_test.cc",
                "upstream/utilities/cassandra/cassandra_functional_test.cc",
                "upstream/utilities/write_batch_with_index/write_batch_with_index_test.cc",
                "upstream/utilities/merge_operators/string_append/stringappend_test.cc",
                "upstream/utilities/persistent_cache/persistent_cache_test.cc",
                "upstream/utilities/persistent_cache/hash_table_test.cc",
                "upstream/utilities/object_registry_test.cc",
                "upstream/utilities/env_mirror_test.cc",
                "upstream/utilities/env_timed_test.cc",
                "upstream/utilities/blob_db/blob_db_test.cc",
                // rados
                "upstream/utilities/env_librados.cc",
                // inconsistent shit
                "upstream/utilities/cassandra/test_utils.cc",
                "upstream/utilities/cassandra/test_utils.h",
                "upstream/utilities/cassandra/merge_operator.cc",
                "upstream/utilities/cassandra/merge_operator.h",
                "upstream/utilities/cassandra/format.cc",
                "upstream/utilities/cassandra/format.h",
                "upstream/utilities/cassandra/cassandra_compaction_filter.cc",
                "upstream/utilities/cassandra/cassandra_compaction_filter.h",
                "upstream/utilities/persistent_cache/hash_table_bench.cc",
                "upstream/utilities/persistent_cache/persistent_cache_bench.cc",

                // stuff we may activate later
                "upstream/env/env_hdfs.cc"
            ],
            sources: [
                "upstream/cache",
                "upstream/db",
                "upstream/env",
                "upstream/file",
                "upstream/include",
                "upstream/logging",
                "upstream/memory",
                "upstream/memtable",
                "upstream/monitoring",
                "upstream/options",
                "upstream/port",
                "upstream/table",
                "upstream/test_util",
                "upstream/trace_replay",
                "upstream/util",
                "upstream/utilities",

                // patches
                "patches/build_version.cc"
            ],
            publicHeadersPath: "public_headers",
            cxxSettings: [
                .headerSearchPath("upstream"),
                .headerSearchPath("upstream/include"),
                .headerSearchPath("upstream/util"),
                .define("ROCKSDB_PLATFORM_POSIX"),
                .define("ROCKSDB_LIB_IO_POSIX"),
                .define("PORTABLE"),
                .define(osEnvRocks),

                // patches
                .define("ROCKSDB_BUILD_GIT_SHA_ENV", to: "\"rocksdb_build_git_sha:\(rocksDBHash)\""),
                .define("ROCKSDB_BUILD_GIT_DATE_ENV", to: "\"rocksdb_build_git_date:\(rocksDBCommitDate)\"")
            ]),
        .target(
            name: "RocksDB",
            dependencies: ["librocksdb"],
            path: "Sources/RocksDB"),
        .testTarget(
            name: "RocksDBTests",
            dependencies: ["RocksDB"]),
    ],
    cxxLanguageStandard: .cxx11
)
