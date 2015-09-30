pod 'MagicalRecord'

post_install do | installer |
require 'fileutils'
FileUtils.cp_r('Pods/Target Support Files/Pods/Pods-Acknowledgements.plist', 'MealReport/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
