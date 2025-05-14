# Building the game

Step 1. [Install git-scm](https://git-scm.com/downloads) if you don't have it already.

Step 2. [Install Haxe](https://haxe.org/download/)

Step 3. [Install HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/)

Step 4. Run the .bat/.sh file to install the required libraries.

# NOTE:
If a library asks if you would like to switch to a specific version, just say no

Dependencies for compiling:

## Windows Only

Install [Visual Studio](https://visualstudio.microsoft.com/), and while installing instead of selecting the normal options, only select these components in the 'individual components' instead (or the closest equivalents).

```txt
* MSVC v142 - VS 2019 C++ x64/x86 build tools
* Windows 10 SDK (Latest)
```

## Linux Only

In your package manager, install the following packages:

```sh
sudo apt-get install libvlc-dev
sudo apt-get install libvlccore-dev
sudo apt-get install vlc-bin
sudo apt-get install luajit
```

```sh
sudo pacman -S vlc
sudo pacman -S luajit
```

Step 5. Run `lime test [platform]` in the project directory while replacing '[platform]' with your build target (usually `html5`, `windows`, `linux`, `mac`, or whatever platform you are building for).

# NOTE:
If you are having issues when compiling due to a library giving you an error, try removing the library with
```
haxelib remove library
```
replacing library with the name of the library you would like to remove
and then re install it with the commands in step 4

