use std::ffi::CStr;
use std::os::raw::c_char;

// Echo inspired by Nim
#[no_mangle]
pub unsafe extern "C" fn echo(s: *const c_char) {
    if s.is_null() {
        return;
    }

    let s = CStr::from_ptr(s).to_string_lossy();
    print!("{s}");
}

// Say inspired by Perl
#[no_mangle]
pub unsafe extern "C" fn say(s: *const c_char) {
    if s.is_null() {
        return;
    }

    let s = CStr::from_ptr(s).to_string_lossy();
    println!("{s}");
}

#[no_mangle]
pub extern "C" fn argCount() -> usize {
    std::env::args_os().count()
}

#[no_mangle]
pub extern "C" fn arg(index: usize) -> *mut c_char {
    match std::env::args_os().nth(index) {
        Some(arg) => {
            let arg = arg.to_string_lossy();

            match CString::new(arg.as_bytes()) {
                Ok(s) => s.into_raw(),
                Err(_) => ptr::null_mut(),
            }
        }
        None => ptr::null_mut(),
    }
}