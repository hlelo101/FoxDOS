# Apps
As FoxDOS has been made to be simple, it doesn't use any filesystem like FAT12/FAT32/EXT4/etc. Instead, it uses a table located at the 10rd sector.\
That table is called the app directory, and can be seen in `appdir.asm`.

# The app directory
A comment describes it in `appdir.asm`, but here's another explanation of how it works:
- The first byte of the app directory is an i8 value holding the total number of entries.\
Then, there are the entries themselves. Each entry is 32-bit in size and contain two i16 values: 
    - The first one holds the app's location (in sectors)
    - The second one the app's size (also in sectors).
