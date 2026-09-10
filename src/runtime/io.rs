use std::ffi::CStr;
use std::os::raw::c_char;

// Echo inspired by Nim
#[no_mangle]
pub unsafe extern "C" fn rs_echo(s: *const c_char) {
    if s.is_null() {
        return;
    }

    let s = CStr::from_ptr(s).to_string_lossy();
    print!("{s}");
}

// Say inspired by Perl
#[no_mangle]
pub unsafe extern "C" fn rs_say(s: *const c_char) {
    if s.is_null() {
        return;
    }

    let s = CStr::from_ptr(s).to_string_lossy();
    println!("{s}");
}