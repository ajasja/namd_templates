proc substify {in_file_name {var OUT}} {
set script ""
set pos 0
set in_file [open $in_file_name r]
set in [read $in_file]
close $in_file
foreach pair [regexp -line -all -inline -indices {^%.*$} $in] {
foreach {from to} $pair break
set s [string range $in $pos [expr {$from-2}]]
if {[string length $s] > 0} {
append script "append $var \[" [list subst $s] "]\n"
}
append script "[string range $in [expr {$from+1}] $to]\n"
set pos [expr {$to+2}]
}
set s [string range $in $pos end]
if {[string length $s] > 0} {
append script "append $var \[" [list subst $s] "]\n"
}
return $script
}



proc fill_template {in_file_name out_file_name} {

#ugly ugly hack to acess the file names
global template_in_file_name
global template_out_file_name
set template_in_file_name $in_file_name
set template_out_file_name $out_file_name

#upleveled  so that we have access to all the varialbe in the calling stack
uplevel 1 { 
    
    set script_data [substify $template_in_file_name "OUT"] 
    #puts $script_data
    #puts "_______________________________"
    set OUT ""
    set template_out_data [eval $script_data]
    #puts $template_out_data
    set out_file [open $template_out_file_name w+]
    puts -nonewline $out_file $template_out_data
    close $out_file
  }
return $out_file_name
}


