extern feed_char alias "feed_char" as const integer
extern check_end alias "check_end" as const integer
extern get_desc alias "get_desc" as const integer
extern destroy alias "destroy" as const integer
type format_verifier as format_verifier_fwd
union format_verifier_meth
    feed_char as function cdecl (fv as format_verifier pointer,c as ubyte) as integer
    check_end as function cdecl (fv as format_verifier pointer) as integer
    get_desc as function cdecl (fv as format_verifier pointer) as zstring ptr
    destroy as function cdecl (fv as format_verifier pointer) as integer
end union
type format_verifier_fwd
   funloc as function cdecl (fid as integer const pointer) as format_verifier_meth
end type

const utf_8_descs = "UTF-8" 
private function utf_8_desc cdecl (fv as format_verifier pointer) as zstring ptr
	return @utf_8_descs
end function

private function utf_8_end_ok cdecl (fv as format_verifier pointer) as integer
	return 0
end function

private function utf_8_destroy cdecl (fv as format_verifier pointer) as integer
	deallocate(fv)
	return 0
end function

private function utf_8_end_bad cdecl (fv as format_verifier pointer) as integer
	return 1
end function

private function utf_8_feed_char_err cdecl (fv as format_verifier pointer,c as ubyte) as integer
	return 1
end function

private function utf_8_funloc_err cdecl (fid as integer const ptr) as format_verifier_meth
	dim f as format_verifier_meth
	if fid = @feed_char then f.feed_char = procptr(utf_8_feed_char_err) 
	if fid = @check_end then f.check_end = procptr(utf_8_end_bad) 
	if fid = @get_desc then f.get_desc = procptr(utf_8_desc)
	if fid = @destroy then f.destroy = procptr(utf_8_destroy) 
	return f
end function

declare function utf_8_funloc_3 cdecl (fid as integer const ptr) as format_verifier_meth
declare function utf_8_funloc_2 cdecl (fid as integer const ptr) as format_verifier_meth
declare function utf_8_funloc_1 cdecl (fid as integer const ptr) as format_verifier_meth
declare function utf_8_funloc_0 cdecl (fid as integer const ptr) as format_verifier_meth

private function utf_8_feed_char_3 cdecl (fv as format_verifier pointer,c as ubyte) as integer
        if c >= &O200 and c < &O300 then
		fv->funloc = procptr(utf_8_funloc_2)
		return 0
	end if
	fv->funloc = procptr(utf_8_funloc_err)
	return 1
end function

private function utf_8_feed_char_2 cdecl (fv as format_verifier pointer,c as ubyte) as integer
        if c >= &O200 and c < &O300 then
		fv->funloc = procptr(utf_8_funloc_1)
		return 0
	end if
	fv->funloc = procptr(utf_8_funloc_err)
	return 1
end function

private function utf_8_feed_char_1 cdecl (fv as format_verifier pointer,c as ubyte) as integer
        if c >= &O200 and c < &O300 then
		fv->funloc = procptr(utf_8_funloc_0)
		return 0
	end if
	fv->funloc = procptr(utf_8_funloc_err)
	return 1
end function

private function utf_8_feed_char_0 cdecl (fv as format_verifier pointer,c as ubyte) as integer
        if c < &O200 then
		return 0
	end if
        if c < &O300 then
		fv->funloc = procptr(utf_8_funloc_err)
		return 1
	end if
        if c < &O340 then
		fv->funloc = procptr(utf_8_funloc_1)
		return 0
	end if
        if c < &O360 then
		fv->funloc = procptr(utf_8_funloc_2)
		return 0
	end if
        if c <= &O364 then
		fv->funloc = procptr(utf_8_funloc_3)
		return 0
	end if
	fv->funloc = procptr(utf_8_funloc_err)
	return 1
end function

private function utf_8_funloc_3 cdecl (fid as integer const ptr) as format_verifier_meth
	dim f as format_verifier_meth
	if fid = @feed_char then f.feed_char = procptr(utf_8_feed_char_3) 
	if fid = @check_end then f.check_end = procptr(utf_8_end_ok) 
	if fid = @get_desc then f.get_desc = procptr(utf_8_desc) 
	if fid = @destroy then f.destroy = procptr(utf_8_destroy) 
	return f
end function

private function utf_8_funloc_2 cdecl (fid as integer const ptr) as format_verifier_meth
	dim f as format_verifier_meth
	if fid = @feed_char then f.feed_char = procptr(utf_8_feed_char_2) 
	if fid = @check_end then f.check_end = procptr(utf_8_end_ok) 
	if fid = @get_desc then f.get_desc = procptr(utf_8_desc) 
	if fid = @destroy then f.destroy = procptr(utf_8_destroy) 
	return f
end function

private function utf_8_funloc_1 cdecl (fid as integer const ptr) as format_verifier_meth
	dim f as format_verifier_meth
	if fid = @feed_char then f.feed_char = procptr(utf_8_feed_char_1) 
	if fid = @check_end then f.check_end = procptr(utf_8_end_ok) 
	if fid = @get_desc then f.get_desc = procptr(utf_8_desc) 
	if fid = @destroy then f.destroy = procptr(utf_8_destroy) 
	return f
end function

private function utf_8_funloc_0 cdecl (fid as integer const ptr) as format_verifier_meth
	dim f as format_verifier_meth
	if fid = @feed_char then f.feed_char = procptr(utf_8_feed_char_0) 
	if fid = @check_end then f.check_end = procptr(utf_8_end_ok) 
	if fid = @get_desc then f.get_desc = procptr(utf_8_desc) 
	if fid = @destroy then f.destroy = procptr(utf_8_destroy) 
	return f
end function

public function new_utf_8 cdecl alias "new_utf_8" () as format_verifier ptr
     dim as format_verifier ptr fv = allocate(sizeof(format_verifier))
     fv->funloc = procptr(utf_8_funloc_0)
     return fv
end function
