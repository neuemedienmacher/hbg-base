require 'json'

# Check security
def brakeman
  puts "\n\n[Brakeman] Security Audit:\n"
  output = %x( bundle exec rake app:test:brakeman )
  result = JSON.parse output

  warnings = result['warnings'].length
  errors = result['errors'].length

  result['warnings'].each do |w|
    puts "Warning: #{brakeman_format(w)}"
  end unless warnings == 0
  result['errors'].each do |e|
    puts "Error: #{brakeman_format(e)}"
  end unless errors == 0

  puts "Warnings: #{warnings}"
  puts "Errors: #{errors}"

  if warnings == 0 && errors == 0
    puts 'Basic security is ensured.'
  else
    puts 'Security issues exist.'
    $suite_failing = true
  end
end

def brakeman_format obj
  if obj['line']
    "#{obj['message']} near line #{obj['line']}: #{obj['code']}\n#{obj['file']}\nConfidence: #{obj['confidence']}"
  else
    "#{obj['message']}.\n#{obj['file']}\nConfidence: #{obj['confidence']}"
  end
end
