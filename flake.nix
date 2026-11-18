# vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
{
  description = "Libreboot";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

  outputs = { self, nixpkgs }:
  # {{{ Variables
  let
    supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
    forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f { pkgs = import nixpkgs { inherit system; }; });
  in
  # }}}
  {
    devShells = forEachSupportedSystem ({ pkgs }:
    {
      default = (pkgs.buildFHSEnv
      {
        name      = "libreboot-fhsenv";
        runScript = pkgs.lib.getExe pkgs.zsh;

        # {{{ Packages
        targetPkgs = pkgs: with pkgs;
        let
          c99        = writeShellScriptBin "c99"        ''${lib.getExe gcc_multi} -std=c99 "$@"'';
          gcc-ar     = writeShellScriptBin "gcc-ar"     ''${gnat.cc}/bin/gcc-ar "$@"'';
          gcc-nm     = writeShellScriptBin "gcc-nm"     ''${gnat.cc}/bin/gcc-nm "$@"'';
          gcc-ranlib = writeShellScriptBin "gcc-ranlib" ''${gnat.cc}/bin/gcc-ranlib "$@"'';
        in
        [
          #libuuid
          (lib.hiPrio gnat)
          acpica-tools
          autoconf
          autogen
          automake
          binutils
          bison
          c99
          cdrtools
          cmake
          cpio
          curl
          debugedit
          dejavu_fonts
          diffutils
          doxygen
          dtc
          e2fsprogs
          fakeroot
          file
          findutils
          flashrom
          flex
          freetype
          fuse
          gawk
          gcc-ar
          gcc_multi
          gdb
          gettext
          git
          glibc_multi
          glibc_multi.dev
          gnugrep
          gnumake
          gnused
          groff
          gzip
          help2man
          imagemagick
          innoextract
          less
          libftdi
          libgpiod
          libjaylink
          libpciaccess
          libtool
          libusb1
          libx86
          m4
          mtools
          nasm
          ncurses
          newlib
          openssl
          p7zip
          pandoc
          parted
          patch
          pciutils
          perl
          perlPackages.libwwwperl
          pkgconf
          python3
          python314Packages.setuptools
          rsync
          sharutils
          subversion
          swig
          texinfo
          ubootTools
          unzip
          util-linux.dev
          util-linux.lib
          vim
          wget
          which
          xz
          zlib
          zlib-ng
        ];
        # }}}

        # {{{ Profile
        profile =
        ''
          export XBMK_THREADS=$(( $(nproc)/4 *3 )) # use 75% of cpu

          export CMAKE_INCLUDE_PATH=/usr/include bash
          export CMAKE_LIBRARY_PATH=/usr/lib
          export CONFIG_SHELL=/bin/sh
          export CPLUS_INCLUDE_PATH=/usr/include
          export C_INCLUDE_PATH=/usr/include
          export LIBRARY_PATH=/usr/lib:$(dirname "$(${pkgs.gcc_multi}/bin/gcc -m32 -print-libgcc-file-name)")
        '';
        # }}}
      }).env;
    });
  };
}

/* {{{ Commands
./mk -m coreboot lenovo_thinkpad_x280_16mb
./mk -b coreboot lenovo_thinkpad_x280_16mb
./mk inject "bin/libreboot-26.11_lenovo_thinkpad_x280_16mb.tar.xz" setmac de:ad:be:ef:31:53
   }}} */
