Pod::Spec.new do |s|
  s.name             = 'rocksdb.swift'
  s.version          = '6.4.6'
  s.summary          = 'rocksdb Wrapper for Swift. Cocoapods and SPM support. Linux support.'

  s.description      = <<-DESC
This pod wraps the awesome rocksdb key-value database from facebook to awesome Swifty Syntax.
Works on iOS, macOS, tvOS, watchOS and Linux. Major and Minor Version numbers are kept in sync with
the upstream rocksdb library. Patch version varies.
                       DESC

  s.homepage         = 'https://github.com/Ybrin/rocksdb.swift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Koray Koska' => 'koray@koska.at' }
  s.source           = { :git => 'https://github.com/Ybrin/rocksdb.swift.git', :tag => s.version.to_s, :submodules => true }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.swift_versions = '5.1.2', '5.0', '5.1'

  s.module_name = 'RocksDB'

  s.pod_target_xcconfig = {
    'GCC_PREPROCESSOR_DEFINITIONS' => 'ROCKSDB_PLATFORM_POSIX=1 ROCKSDB_LIB_IO_POSIX=1 PORTABLE=1 OS_MACOSX=1 ROCKSDB_BUILD_GIT_SHA_ENV=e3169e3ea8762d2f34880742106858a23c8dc8b7 ROCKSDB_BUILD_GIT_DATE_ENV="Mon Oct 21 12:07:58 2019 -0700"',
    'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/rocksdb.swift/Sources/librocksdb/upstream" "${PODS_ROOT}/rocksdb.swift/Sources/librocksdb/upstream/include" "${PODS_ROOT}/rocksdb.swift/Sources/librocksdb/upstream/util"',
    'WARNING_CFLAGS' => '-Wno-shorten-64-to-32 -Wno-comma -Wno-unreachable-code -Wno-conditional-uninitialized -Wno-deprecated-declarations',
    'USE_HEADERMAP' => 'No'
  }
  #  "${PODS_ROOT}/rocksdb.swift/librocksdb/upstream/include" "${PODS_ROOT}/rocksdb.swift/librocksdb/upstream/util"

  # s.header_dir = 'rocksdb'
  s.header_mappings_dir = 'Sources/librocksdb'

  s.libraries = 'c++'

  s.source_files = 'Sources/librocksdb/upstream/cache/**/*.{cc,c,h}',
                   'Sources/librocksdb/upstream/db/**/*.{cc,c,h}',
                   'Sources/librocksdb/upstream/env/**/*.{cc,c,h}',
                   'Sources/librocksdb/upstream/file/**/*.{cc,c,h}',
                   'Sources/librocksdb/upstream/include/**/*.{cc,c,h}',
                   'Sources/librocksdb/upstream/logging/**/*.{cc,c,h}',
                   'Sources/librocksdb/upstream/memory/**/*.{cc,c,h}',
                   'Sources/librocksdb/upstream/memtable/**/*.{cc,c,h}',
                   'Sources/librocksdb/upstream/monitoring/**/*.{cc,c,h}',
                   'Sources/librocksdb/upstream/options/**/*.{cc,c,h}',
                   'Sources/librocksdb/upstream/port/**/*.{cc,c,h}',
                   'Sources/librocksdb/upstream/table/**/*.{cc,c,h}',
                   'Sources/librocksdb/upstream/test_util/**/*.{cc,c,h}',
                   'Sources/librocksdb/upstream/trace_replay/**/*.{cc,c,h}',
                   'Sources/librocksdb/upstream/util/**/*.{cc,c,h}',
                   'Sources/librocksdb/upstream/utilities/**/*.{cc,c,h}',
                   'Sources/librocksdb/upstream/tools/sst_dump_tool_imp.h',
                   'Sources/librocksdb/patches/build_version.cc',
                   'Sources/librocksdb/public_headers/librocksdb.h'
                   # 'Sources/RocksDB/**/*.swift'
  s.public_header_files = 'Sources/librocksdb/public_headers/librocksdb.h'
  s.private_header_files = 'Sources/librocksdb/upstream/**/*.h'
  s.exclude_files = '**/*_test.{cc,c}',
                    '**/*_bench.cc',
                    'Sources/librocksdb/upstream/db/db_test2.cc',
                    'Sources/librocksdb/upstream/db/db_test_util.cc',
                    'Sources/librocksdb/upstream/port/win',
                    'Sources/librocksdb/upstream/table/mock_table.h',
                    'Sources/librocksdb/upstream/table/mock_table.cc',
                    'Sources/librocksdb/upstream/test_util/testharness.cc',
                    'Sources/librocksdb/upstream/test_util/testharness.h',
                    'Sources/librocksdb/upstream/util/crc32c_ppc_asm.S',
                    'Sources/librocksdb/upstream/utilities/env_librados.cc',
                    'Sources/librocksdb/upstream/utilities/cassandra/test_utils.cc',
                    'Sources/librocksdb/upstream/utilities/cassandra/test_utils.h',
                    'Sources/librocksdb/upstream/utilities/cassandra/merge_operator.cc',
                    'Sources/librocksdb/upstream/utilities/cassandra/merge_operator.h',
                    'Sources/librocksdb/upstream/utilities/cassandra/format.cc',
                    'Sources/librocksdb/upstream/utilities/cassandra/format.h',
                    'Sources/librocksdb/upstream/utilities/cassandra/cassandra_compaction_filter.cc',
                    'Sources/librocksdb/upstream/utilities/cassandra/cassandra_compaction_filter.h',
                    'Sources/librocksdb/upstream/env/env_hdfs.cc'
end
