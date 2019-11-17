Pod::Spec.new do |s|
  s.name             = 'rocksdb.swift'
  s.version          = 'v6.4.6'
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

  s.module_name = 'RocksDB'

  s.pod_target_xcconfig = {
    'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/Sources/librocksdb/upstream"\n"${PODS_ROOT}/Sources/librocksdb/upstream/include"\n"${PODS_ROOT}/Sources/librocksdb/upstream/util"'
  }

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

  s.source_files = 'Sources/librocksdb/upstream/{cache,db,env,file,include,logging,memory,memtable,monitoring,options,port,table,test_util,trace_replay,util,utilities}/*.*',
                   'Sources/librocksdb/upstream/patches/build_version.cc'
  s.public_header_files = 'secp256k1/Classes/secp256k1/include/*.h'
  s.private_header_files = 'secp256k1/Classes/secp256k1_ec_mult_static_context.h', 'secp256k1/Classes/secp256k1/*.h', 'secp256k1/Classes/secp256k1/{contrib,src}/*.h', 'secp256k1/Classes/secp256k1/src/modules/{recovery, ecdh}/*.h'
  s.exclude_files = 'secp256k1/Classes/secp256k1/src/test*.{c,h}', 'secp256k1/Classes/secp256k1/src/gen_context.c', 'secp256k1/Classes/secp256k1/src/*bench*.{c,h}', 'secp256k1/Classes/secp256k1/src/modules/{recovery,ecdh}/*test*.{c,h}'
end
