#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


-::[
=::]

q::'
w::,
e::.
r::p
t::y
y::f
u::g
i::c
o::r
p::l
[::/
]::=

;a::a
s::o
d::e
f::u
g::i
h::d
j::h
k::t
l::n
`;::s
'::-

z::`;
x::q
c::j
v::k
b::x
n::b
;m::m
,::w
.::v
/::z


Capslock::
		Send {LControl Down}
		KeyWait, CapsLock
		Send {LControl Up}
		if ( A_PriorKey = "CapsLock" )
		{
			Send {Esc}
		}
	return

LControl::
		Send {LControl Down}
		KeyWait, LControl
		Send {LControl Up}
		if ( A_PriorKey = "LControl" )
		{
			Send {Esc}
		}
	return
