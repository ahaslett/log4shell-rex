#!/bin/bash

#   _                _  _  ____  _          _ _       ____
#  | |    ___   __ _| || |/ ___|| |__   ___| | |     |  _ \ _____  __
#  | |   / _ \ / _` | || |\___ \| '_ \ / _ \ | |_____| |_) / _ \ \/ /
#  | |__| (_) | (_| |__   _|__) | | | |  __/ | |_____|  _ <  __/>  <
#  |_____\___/ \__, |  |_||____/|_| |_|\___|_|_|     |_| \_\___/_/\_\
#              |___/
#
#  2021-12-13 @back2root

base64 -d <<< "IF8gICAgICAgICAgICAgICAgXyAgXyAgX19fXyAgXyAgICAgICAgICBfIF8gICAgICAgX19fXwp8IHwgICAgX19fICAgX18gX3wgfHwgfC8gX19ffHwgfF9fICAgX19ffCB8IHwgICAgIHwgIF8gXCBfX19fXyAgX18KfCB8ICAgLyBfIFwgLyBfYCB8IHx8IHxcX19fIFx8ICdfIFwgLyBfIFwgfCB8X19fX198IHxfKSAvIF8gXCBcLyAvCnwgfF9ffCAoXykgfCAoX3wgfF9fICAgX3xfXykgfCB8IHwgfCAgX18vIHwgfF9fX19ffCAgXyA8ICBfXy8+ICA8CnxfX19fX1xfX18vIFxfXywgfCAgfF98fF9fX18vfF98IHxffFxfX198X3xffCAgICAgfF98IFxfXF9fXy9fL1xfXAogICAgICAgICAgICB8X19fLwoK" >&2

# Basic signs
dollar='(?:\$|%(?:25)*24|\\(?:0024|0{0,2}44))'
curly_open='(?:{|%(?:25)*7[Bb]|\\(?:007[Bb]|0{0,2}173))'
colon='(?::|%(?:25)*3[Aa]|\\(?:003[Aa]|0{0,2}72))'
# shellcheck disable=SC2016
slash='(?:\/|%(?:25)*2[Ff]|\\(?:002[Ff]|0{0,2}57)|\${)'
sp='.{0,30}?'

# Basic Alphabet (some letters are prepared but not yet used)
#Upper|Lower|URL-Encoded&Unicode|Octal
a='(?:[Aa]|%(?:25)*[46]1|\\(?:00[46]1|0{0,2}1[04]1))'
b='(?:[Bb]|%(?:25)*[46]2|\\(?:00[46]2|0{0,2}1[04]2))'
c='(?:[Cc]|%(?:25)*[46]3|\\(?:00[46]3|0{0,2}1[04]3))'
d='(?:[Dd]|%(?:25)*[46]4|\\(?:00[46]4|0{0,2}1[04]4))'
e='(?:[Ee]|%(?:25)*[46]5|\\(?:00[46]5|0{0,2}1[04]5))'
f='(?:[Ff]|%(?:25)*[46]6|\\(?:00[46]6|0{0,2}1[04]6))'
g='(?:[Gg]|%(?:25)*[46]7|\\(?:00[46]7|0{0,2}1[04]7))'
h='(?:[Hh]|%(?:25)*[46]8|\\(?:00[46]8|0{0,2}1[15]0))'
i='(?:[Ii]|%(?:25)*[46]9|\\(?:00[46]9|0{0,2}1[15]1)|ı)'
j='(?:[Jj]|%(?:25)*[46][Aa]|\\(?:00[46][Aa]|0{0,2}1[15]2))'
k='(?:[Kk]|%(?:25)*[46][Bb]|\\(?:00[46][Bb]|0{0,2}1[15]3))'
l='(?:[Ll]|%(?:25)*[46][Cc]|\\(?:00[46][Cc]|0{0,2}1[15]4))'
m='(?:[Mm]|%(?:25)*[46][Dd]|\\(?:00[46][Dd]|0{0,2}1[15]5))'
n='(?:[Nn]|%(?:25)*[46][Ee]|\\(?:00[46][Ee]|0{0,2}1[15]6))'
o='(?:[Oo]|%(?:25)*[46][Ff]|\\(?:00[46][Ff]|0{0,2}1[15]7))'
p='(?:[Pp]|%(?:25)*[57]0|\\(?:00[57]0|0{0,2}1[26]0))'
q='(?:[Qq]|%(?:25)*[57]1|\\(?:00[57]1|0{0,2}1[26]1))'
r='(?:[Rr]|%(?:25)*[57]2|\\(?:00[57]2|0{0,2}1[26]2))'
s='(?:[Ss]|%(?:25)*[57]3|\\(?:00[57]3|0{0,2}1[26]3))'
t='(?:[Tt]|%(?:25)*[57]4|\\(?:00[57]4|0{0,2}1[26]4))'
u='(?:[Uu]|%(?:25)*[57]5|\\(?:00[57]5|0{0,2}1[26]5))'
v='(?:[Vv]|%(?:25)*[57]6|\\(?:00[57]6|0{0,2}1[26]6))'
w='(?:[Ww]|%(?:25)*[57]7|\\(?:00[57]7|0{0,2}1[26]7))'
x='(?:[Xx]|%(?:25)*[57]8|\\(?:00[57]8|0{0,2}1[37]0))'
y='(?:[Yy]|%(?:25)*[57]9|\\(?:00[57]9|0{0,2}1[37]1))'
z='(?:[Zz]|%(?:25)*[57][Aa]|\\(?:00[57][Aa]|0{0,2}1[37]2))'

# String groups
jndi="${j}${sp}${n}${sp}${d}${sp}${i}"

ldaps="${l}${sp}${d}${sp}${a}${sp}${p}(?:${sp}${s})?"
rmi="${r}${sp}${m}${sp}${i}"
dns="${d}${sp}${n}${sp}${s}"
nis="${n}${sp}${i}${sp}${s}"
iiop="(?:${sp}${i}){2}${sp}${o}${sp}${p}"
corba="${c}${sp}${o}${sp}${r}${sp}${b}${sp}${a}"
nds="${n}${sp}${d}${sp}${s}"
https="${h}(?:${sp}${t}){2}${sp}${p}(?:${sp}${s})?"

# Target RegEx
# ${jndi:(ldap[s]?|rmi|dns|nis|iiop|corba|nds|http):

protocols="(${ldaps}|${rmi}|${dns}|${nis}|${iiop}|${corba}|${nds}|${https})"

b64_enc='(JH[s-v]|[\x2b\x2f-9A-Za-z][CSiy]R7|[\x2b\x2f-9A-Za-z]{2}[048AEIMQUYcgkosw]ke[\x2b\x2f-9w-z])'
b64="${b}${sp}${a}${sp}${s}${sp}${e}.{2,60}?${colon}${b64_enc}"

plain="${jndi}${sp}${colon}${sp}${protocols}${sp}${colon}${sp}${slash}"

Log4ShellRex="${dollar}${curly_open}${sp}(${plain}|${b64})"

echo "Log4ShellRex='${Log4ShellRex}'"
