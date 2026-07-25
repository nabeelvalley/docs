def do_it [] {
fd -tf
| lines
| par-each {|p|
  try {
  $p
  | path basename 
  | parse "{date} - {camera} - {country} - {title}"
  | get 0
  | insert valid true
  } catch {
    ({valid: false, path: $p})      
  }
}
| where valid == false
| reject valid
| print
}

do_it
watch . {|| do_it}


# fd -tf
# | lines
# | par-each {|p|
#   try {
#   $p
#   | path basename 
#   | parse "{date} - {camera} - {country} - {title}"
#   | get 0
#   | insert valid true
#   } catch {
#     let tried = $p | path basename | parse "{d}_{_}" | get d.0 -o
#       | node -e $"console.log\(new Date\(($in)\).toDateString\(\)\)"
#     ({valid: false, path: $p, tried: $tried})      
#   }
# }
# | where valid == false
# | reject valid
# | each {|f|
# try {
#   mv $f.path $"($f.path | path dirname)/($f.tried | format date "%Y-%m-%d") ($f.path | path basename)"
#   }
# }
# | to yaml
