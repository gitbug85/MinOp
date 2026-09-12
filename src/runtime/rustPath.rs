use std::ffi::CStr;
use std::os::raw::c_char;
use std::path::Path;

fn c_path(path: *const c_char) -> Option<&'static Path> {
    if path.is_null() {
        return None;
    }
    let c_str = unsafe { CStr::from_ptr(path) };
    let path_str = c_str.to_str().ok()?;
    Some(Path::new(path_str))
}

#[no_mangle]
pub extern "C" fn iisFile(path: *const c_char) -> bool {
    c_path(path).map_or(false, |p| p.is_file())
}

#[no_mangle]
pub extern "C" fn iisDir(path: *const c_char) -> bool {
    c_path(path).map_or(false, |p| p.is_dir())
}

#[no_mangle]
pub extern "C" fn hhasExtOf(
    path: *const c_char,
    ext: *const c_char,
) -> bool {
    let path = match c_path(path) {
        Some(p) => p,
        None => return false,
    };

    if ext.is_null() {
        return false;
    }

    let ext = unsafe { CStr::from_ptr(ext) };
    let ext = match ext.to_str() {
        Ok(e) => e.trim_start_matches('.'),
        Err(_) => return false,
    };

    path.extension()
        .and_then(|e| e.to_str())
        .map_or(false, |e| e.eq_ignore_ascii_case(ext))
}