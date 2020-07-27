 
Pod::Spec.new do |s|
  s.name             = 'NPSketchpadView'
  s.version          = '0.0.2'
  s.summary          = '草稿纸'
 
  s.description      = <<-DESC
    草稿纸demo
                       DESC

  s.homepage         = 'https://github.com/iyongjie/NPSketchpadView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '李永杰' => 'iyongjie@yeah.net' }
  s.source           = { :git => 'https://github.com/iyongjie/NPSketchpadView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.framework  = "UIKit"
  s.requires_arc = true

  s.source_files = 'NPSketchpadView/*'
  s.resources = ["NPSketchpadView/NPSketchpadView.bundle", "NPSketchpadView/NPSketchpadView.xib"]
end
