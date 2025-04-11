# FoxDOS
![Screenshot of the FoxDOS UI](screenshot.png "FoxDOS")
A very simple 32-bit OS\
When you first start FoxDOS, the shell starts. You can view the version using VER.\
You can start a program by entering its index.\
Note that the program index starts at 0, so the 3rd program would be launched by entering 2.\
The program 1 is the shell, the program 2 is VER, the program 3... The third program, and the program 4 an error handling testing app. 

# Build
To build FoxDOS, simply run
```sh
make
```
To run it with QEMU, run
```sh
make run
```

# TODO
- Support for multiple disks
- Other drivers: Sound, USB, ...
- Custom executable format
- Maybe a GUI?\
I'm pretty sure there are a lot of other things to do but... eh, forgot them
