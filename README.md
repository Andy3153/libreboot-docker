<!-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:  -->

# libreboot-docker
Docker image to compile Libreboot

# Setup
Fill `.env` with variables you want to change:
- Change the `$GID`/`$UID` variables accordingly so you have permission over the files this Docker container creates in the folder it is in
- You must set `$GIT_*`
- Set `$XBMK_THREADS` to the number of cores you want to be used during the LBMK build process
```
# .env

UID=3153
GID=3153

GIT_USER_EMAIL="user@email.tld"
GIT_USER_NAME="user"

XBMK_THREADS=12
```

Then create the docker container:
```console
docker compose up -d
```

Then open an interactive shell inside it:
```console
docker exec -it lbmk bash
```

The `entrypoint.sh` automatically clones LBMK in the folder where `docker-compose.yml` is located if not already present:
```console
cd lbmk
```

# Configuration
Example:
```console
./mk -m coreboot lenovo_thinkpad_x280_16mb
```
```
Chipset/Enable Hyper-Threading
Chipset/Swap Fn and Ctrl keys
```

# Building
Example:
```console
./mk -b coreboot lenovo_thinkpad_x280_16mb
./mk inject "bin/libreboot-*" setmac de:ad:be:ef:31:53
```

# Other info
- `copy_to_lbmk` are the extra files I need when compiling for myself
- The Nix flake is a failed attempt before I went for the Docker image approach
- It'll take some time to build the Docker image, it cross-builds stuff from the AUR (dependencies of lbmk)
- This was made for personal use mostly, I'll provide help if asked but I don't think I'll be going out of my way to make this user friendly, at least not for now
