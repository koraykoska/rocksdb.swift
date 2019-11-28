Pod::Spec.new do |s|
  s.name             = 'rocksdb.swift'
  s.version          = '6.4.11'
  s.summary          = 'rocksdb Wrapper for Swift. Cocoapods and SPM support. Linux support.'

  s.description      = <<-DESC
This pod wraps the awesome rocksdb key-value database from facebook to awesome Swifty Syntax.
Works on iOS, macOS, tvOS, watchOS and Linux. Major and Minor Version numbers are kept in sync with
the upstream rocksdb library. Patch version varies.
                       DESC

  s.homepage         = 'https://github.com/Ybrin/rocksdb.swift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Koray Koska' => 'koray@koska.at' }
  s.source           = { :git => 'https://github.com/Ybrin/rocksdb.swift.git', :tag => "v#{s.version.to_s}" }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.dependency 'librocksdb', '~> 6.4.8'

  s.swift_versions = '5.1.2', '5.0', '5.1'

  s.module_name = 'RocksDB'

  s.pod_target_xcconfig = {
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES'
  }

  s.source_files = 'Sources/RocksDB/**/*.swift'
end
