#
# Podspec usato quando l'app ospite integra i plugin con CocoaPods.
# Con Swift Package Manager viene usato invece appinio_social_share/Package.swift:
# tenere allineati sorgenti e versione minima di iOS.
#
Pod::Spec.new do |s|
  s.name             = 'appinio_social_share'
  s.version          = '0.5.0'
  s.summary          = 'Condivisione tramite il foglio di sistema di iOS.'
  s.description      = <<-DESC
Condivisione di testo e file tramite il foglio di sistema di iOS (UIActivityViewController).
                       DESC
  s.homepage         = 'https://github.com/riccardo-rusca/flutter_social_share'
  s.license          = { :file => '../LICENSE' }
  s.author           = 'PinVision'
  s.source           = { :path => '.' }
  s.source_files     = 'appinio_social_share/Sources/appinio_social_share/**/*.swift'
  s.dependency 'Flutter'
  s.platform         = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version    = '5.0'
end
