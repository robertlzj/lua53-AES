local AES=require'AES'
local util=require'util'

local aes = AES:new()

local i , cipher_ByteList , plain_ByteList

-- 使用 Crypto++ Library 8.2 的部分用例
local AES_Key = {0x2B , 0x7E , 0x15 , 0x16 , 0x28 , 0xAE , 0xD2 , 0xA6 , 0xAB , 0xF7 , 0x15 , 0x88 , 0x09 , 0xCF , 0x4F , 0x3C}
local Plain_ByteList = {0x6B , 0xC1 , 0xBE , 0xE2 , 0x2E , 0x40 , 0x9F , 0x96 , 0xE9 , 0x3D , 0x7E , 0x11 , 0x73 , 0x93 , 0x17 , 0x2A , 0xAE , 0x2D , 0x8A , 0x57 , 0x1E , 0x03 , 0xAC , 0x9C , 0x9E , 0xB7 , 0x6F , 0xAC , 0x45 , 0xAF , 0x8E , 0x51 , 0x30 , 0xC8 , 0x1C , 0x46 , 0xA3 , 0x5C , 0xE4 , 0x11 , 0xE5 , 0xFB , 0xC1 , 0x19 , 0x1A , 0x0A , 0x52 , 0xEF , 0xF6 , 0x9F , 0x24 , 0x45 , 0xDF , 0x4F , 0x9B , 0x17 , 0xAD , 0x2B , 0x41 , 0x7B , 0xE6 , 0x6C , 0x37 , 0x10}
local Cipher_ByteList = {0x3A , 0xD7 , 0x7B , 0xB4 , 0x0D , 0x7A , 0x36 , 0x60 , 0xA8 , 0x9E , 0xCA , 0xF3 , 0x24 , 0x66 , 0xEF , 0x97 , 0xF5 , 0xD3 , 0xD5 , 0x85 , 0x03 , 0xB9 , 0x69 , 0x9D , 0xE7 , 0x85 , 0x89 , 0x5A , 0x96 , 0xFD , 0xBA , 0xAF , 0x43 , 0xB1 , 0xCD , 0x7F , 0x59 , 0x8E , 0xCE , 0x23 , 0x88 , 0x1B , 0x00 , 0xE3 , 0xED , 0x03 , 0x06 , 0x88 , 0x7B , 0x0C , 0x78 , 0x5E , 0x27 , 0xE8 , 0xAD , 0x3F , 0x82 , 0x23 , 0x20 , 0x71 , 0x04 , 0x72 , 0x5D , 0xD4}

print("Basic Test:")
aes:set_key(AES_Key , 16)
cipher_ByteList = {}
for i = 1 , 64 , 16 do
	aes:encrypt(Plain_ByteList , i , cipher_ByteList , i)
end 
assert(#Plain_ByteList == #cipher_ByteList,
	string.format("dl:%d bl:%d" , #Plain_ByteList , #cipher_ByteList))

for i = 1 , 64 do
	assert(Cipher_ByteList[i] == cipher_ByteList[i],
		string.format("encrypt err: %d , %02x , %02x\n cipher_ByteList: %s" , i , Cipher_ByteList[i] , cipher_ByteList[i] , util.toHexString(cipher_ByteList)))
end
print("encrypt complet")
----------------

plain_ByteList = {}
for i = 1 , 64 , 16 do
	aes:decrypt(Cipher_ByteList , i , plain_ByteList , i)
end
for i = 1 , 64 do
	assert(Plain_ByteList[i] == plain_ByteList[i],
		string.format("decrypt err: %d , %02x , %02x\n plain_ByteList: %s" , i , Plain_ByteList[i] , plain_ByteList[i] , util.toHexString(plain_ByteList)))
end
print("decrypt complet")
----------------
print''

print"Advance Test:"
local ciyher_Str,plain_Str
print("Test ecb:")
ciyher_Str = aes:ecb_EncryptDecrypt(util.byteListToString(Plain_ByteList) , util.byteListToString(AES_Key) , true)
assert(ciyher_Str == util.byteListToString(Cipher_ByteList), string.format('ciyher_str in byte list: %s', util.toHexString(ciyher_Str)))
print("encrypt complet")

plain_Str = aes:ecb_EncryptDecrypt(ciyher_Str , util.byteListToString(AES_Key) , false)
assert(plain_Str == util.byteListToString(Plain_ByteList), string.format('plain_str in byte list: %s', util.toHexString(plain_Str)))
print("decrypt complet")

local AES_IV =  {0x01 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x01 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00}
print("Test cbc:")
ciyher_Str = aes:cbc_EncryptDecrypt(util.byteListToString(Plain_ByteList) , util.byteListToString(AES_Key) , util.byteListToString(AES_IV) , true)
plain_Str = aes:cbc_EncryptDecrypt(ciyher_Str , util.byteListToString(AES_Key) , util.byteListToString(AES_IV) , false)
assert(plain_Str == util.byteListToString(Plain_ByteList), string.format('plain_str in byte list: %s', util.toHexString(plain_Str)))
print'encrypt & decrypt complet'


print("Test cbc2:")
local AES_IV =  {0x00 , 0x01 , 0x02 , 0x03 , 0x04 , 0x05 , 0x06 , 0x07 , 0x08 , 0x09 , 0x0A , 0x0B , 0x0C , 0x0D , 0x0E , 0x0F}
local Cipher_ByteList = {0x76 , 0x49 , 0xAB , 0xAC , 0x81 , 0x19 , 0xB2 , 0x46 , 0xCE , 0xE9 , 0x8E , 0x9B , 0x12 , 0xE9 , 0x19 , 0x7D , 0x50 , 0x86 , 0xCB , 0x9B , 0x50 , 0x72 , 0x19 , 0xEE , 0x95 , 0xDB , 0x11 , 0x3A , 0x91 , 0x76 , 0x78 , 0xB2 , 0x73 , 0xBE , 0xD6 , 0xB8 , 0xE3 , 0xC1 , 0x74 , 0x3B , 0x71 , 0x16 , 0xE6 , 0x9E , 0x22 , 0x22 , 0x95 , 0x16 , 0x3F , 0xF1 , 0xCA , 0xA1 , 0x68 , 0x1F , 0xAC , 0x09 , 0x12 , 0x0E , 0xCA , 0x30 , 0x75 , 0x86 , 0xE1 , 0xA7}

ciyher_Str = aes:cbc_EncryptDecrypt(util.byteListToString(Plain_ByteList) , util.byteListToString(AES_Key) , util.byteListToString(AES_IV) , true)
assert(ciyher_Str == util.byteListToString(Cipher_ByteList), string.format('ciyher_str in byte list: %s', util.toHexString(ciyher_Str)))
plain_Str = aes:cbc_EncryptDecrypt(ciyher_Str , util.byteListToString(AES_Key) , util.byteListToString(AES_IV) , false)
assert(plain_Str == util.byteListToString(Plain_ByteList), string.format('plain_str in byte list: %s', util.toHexString(plain_Str)))
print'encrypt & decrypt complet'
----------------
print''

print'finished'