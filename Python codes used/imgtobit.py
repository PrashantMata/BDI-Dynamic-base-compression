import cv2
import numpy as np
import binascii

image = cv2.imread('mountain.bmp')
# image = cv2.resize(image,(512,512), interpolation=cv2.INTER_CUBIC)
gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
# cv2.imwrite('gray_image.png',gray_image)
# cv2.imshow('color_image',image)
# cv2.imshow('gray_image',gray_image) 
# cv2.waitKey(0)                 
# cv2.destroyAllWindows()        

print(gray_image.shape)
rows = gray_image.shape[0]
cols = gray_image.shape[1]
bitsarray = []
for i in range(rows):
	for j in range(cols):
		pixel_val = gray_image[i,j]
		# print(pixel_val)
		mod = []
		div = []
		for k in range(0,8):
		    modulus = pixel_val%2
		    pixel_val = int(pixel_val/2)
		    mod.append(modulus)
		    div.append(pixel_val)
		MSBtoLSB = list(reversed(mod))
		# print('mod_val',MSBtoLSB)
		# print('division',div)
		bitsarray.append(MSBtoLSB)
Bitsarray = np.array(bitsarray)

print('BITS_ARRAY',Bitsarray.ravel())

# for (i on range(0,len()))
out = Bitsarray.ravel()
# print(len(gray_image.ravel()))
# print(len(out))
# assert(len(out)==len(gray_image.ravel()))
k = 256
cont = 0
window2 = []
for i in range(0,len(out)-1,k):
	# print(out[i:i+k],len(out[i:i+k]))
	window = out[i:i+k]
	cont+=1
	window2.append(window)


print(len(window2))

hexafile = []
add = 0
for m in range(0,len(window2)):
	window3 = window2[m]
	str1 = ''.join(map(str,window3))
	hexa = hex(int(str1, 2))
	print('Hexa Array',hexa)
	hexafile.append(hexa)
	add +=1
	print(add)
with open('mountain_bits.txt', 'w') as f:
    for item in hexafile:
        f.write("%s\n" % item)