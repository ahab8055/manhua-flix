import sys
from PIL import Image
dev=sys.argv[1]; d=int(sys.argv[2]) if len(sys.argv)>2 else 3
ims=[Image.open(f'shots/raw/{dev}_{i}.png') for i in range(1,9)]
w,h=ims[0].size; cols=4 if h>w else 2
sw,sh=w//d,h//d
sheet=Image.new('RGB',(sw*cols,sh*(8//cols)))
for i,im in enumerate(ims): sheet.paste(im.convert('RGB').resize((sw,sh)),((i%cols)*sw,(i//cols)*sh))
sheet.save(f'shots/sheet_{dev}.jpg',quality=85)
