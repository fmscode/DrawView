Pod::Spec.new do |s|
  s.name             = "DrawView"
  s.version          = "0.1.0"
  s.summary          = "Subclass of UIView that supports drawing."
  s.description      = <<-DESC
                        Subclass of UIView that supports drawing by the user.
                       DESC
  s.homepage         = "https://github.com/fmscode/DrawView"
  s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Frank Michael Sanchez" => "orion1701@me.com" }
  s.source           = { :git => "https://github.com/fmscode/DrawView.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Classes'

end
