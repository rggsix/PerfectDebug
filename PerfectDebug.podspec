#
# Be sure to run `pod lib lint PerfectDebug.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PerfectDebug'
  s.version          = '3.5.0.0'
  s.summary          = 'PerfectDebug'
  s.description      = <<-DESC
    Debug tool for iOS🚀, Custom log, Network monitoring, CPU/FPS/MEM monitoring, log dashboard...
                       DESC
  s.homepage         = 'https://github.com/rggsix/PerfectDebug'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.source           = { :git => 'git@github.com:rggsix/PerfectDebug.git'}
  s.authors          = {'PerfectDebug' => 'songhengdsg@icloud.com'}
  
  s.ios.deployment_target = '9.0'
    
  s.subspec 'Core' do |core|
    core.source_files = 'Source/Core/**/*'
    core.resource_bundles = {
        'PerfectDebug' => ['Source/Resource/*']
    }
    core.dependency 'FMDB'
  end
  
  s.subspec 'CrashMonitor' do |crash|
    crash.source_files = 'Source/CrashMonitor/**/*'
    crash.dependency 'PerfectDebug/Core'
  end
  
  s.subspec 'NetworkMonitor' do |network|
    network.source_files = 'Source/NetworkMonitor/**/*'
    network.dependency 'PerfectDebug/Core'
  end
  
  s.subspec 'Performance' do |performance|
    performance.source_files = 'Source/Performance/**/*'
    performance.dependency 'PerfectDebug/Core'
  end
  
  s.subspec 'DebugShortcutKey' do |debugshortcutkey|
    debugshortcutkey.source_files = 'Source/DebugShortcutKey/**/*'
    debugshortcutkey.dependency 'PerfectDebug/Core'
    debugshortcutkey.dependency 'Aspects'
  end
  
end
