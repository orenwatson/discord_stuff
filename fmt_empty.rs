use std::mem::size_of;
use std::mem::transmute;
extern {
  static feed_char : i64; 
  static check_end : i64; 
  static get_desc : i64; 
  static destroy : i64;
  fn malloc(len:usize)->*mut u8;
  fn free(x:*mut u8);
}
#[repr(C)]union Funclocs {
	feed_char:unsafe extern "C" fn(v:*mut FormatVerifier,c:u8)->i32,
	check_end:unsafe extern "C" fn(v:*mut FormatVerifier)->i32,
	get_desc:unsafe extern "C" fn(v:*mut FormatVerifier)->*const u8,
	destroy:unsafe extern "C" fn(v:*mut FormatVerifier)
}
#[repr(C)]struct FormatVerifier {
	funloc:extern "C" fn(f:*const i64)->Funclocs
}

extern "C" fn my_do_nothing(f:*mut FormatVerifier)->i32{
	return 1;
}

extern "C" fn my_success(f:*mut FormatVerifier)->i32{
	return 0;
}

extern "C" fn my_make_fail(f:*mut FormatVerifier,c:u8)->i32{unsafe{
	(*f).funloc = funloc_failure;
	return 1;
}}

extern "C" fn my_get_desc(f:*mut FormatVerifier)->*const u8{
	return b"empty\0" as *const u8;
}

extern "C" fn funloc_failure(f:*const i64)->Funclocs{unsafe{
	if(f==&get_desc){return Funclocs{get_desc:my_get_desc};}
	if(f==&destroy){return Funclocs{destroy:transmute(free as unsafe extern "C" fn(*mut u8))};}
	return Funclocs{check_end:my_do_nothing};
}}

extern "C" fn funloc_waiting(f:*const i64)->Funclocs{unsafe{
	if(f==&get_desc){return Funclocs{get_desc:my_get_desc};}
	if(f==&destroy){return Funclocs{destroy:transmute(free as unsafe extern "C" fn(*mut u8))};}
	if(f==&check_end){return Funclocs{check_end:my_success};}
	return Funclocs{feed_char:my_make_fail};
}}

#[no_mangle]
pub extern "C" fn new_empty()->*mut u8 {unsafe{
	let mut fv = malloc(size_of::<FormatVerifier>())as *mut FormatVerifier;
	(*fv).funloc = funloc_waiting;
	return fv as *mut u8;
}}



