#
# Be sure to run `pod lib lint WGBWaveLayerButton.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WGBSelectPhotoView'
  s.version          = '1.0.1'
  s.summary          = '选择图片或者视频工具类，支持自定义icon，自适应高度，参数灵活设置可高度定制.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
   选择图片或者视频工具类，支持自定义icon，自适应高度，参数灵活设置可高度定制
  DESC

  s.homepage         = 'https://github.com/WangGuibin/WGBSelectPhotoView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Wangguibin' => '864562082@qq.com' }
  s.source           = { :git => 'https://github.com/Wangguibin/WGBSelectPhotoView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'WGBSelectPhotoView/WGBSelectPhotoView/**/*.{h,m}'
  s.resources = "WGBSelectPhotoView/*/*.bundle"
  s.frameworks = 'UIKit', 'Photos'
end
