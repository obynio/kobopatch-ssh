# kobopatch-ssh

This repository contains the tools needed to compile [dropbear](https://matt.ucc.asn.au/dropbear/dropbear.html) for the `arm-kobo-linux-gnueabihf` system (all recent [Kobo](https://www.kobo.com/) products). This binary is used for root shell access on Kobo devices which, in my case, is used to deploy and debug software on e-readers. As of now, this dynamically compiled dropbear has been tested on a Kobo Libra 2.

## Cloning

This repository uses submodules, and must be cloned with the following command

```sh
git clone --recursive git@github.com:obynio/kobopatch-ssh.git
```

## Compiling locally

This project piggy-backs off the toolchain I use for [kolib](https://github.com/Ewpratten/kolib), so everything is done inside a docker container. You must have docker installed on your system to compile dropbear. With docker installed, simply pull the image or grab a book and compile the dockerfile yourself.

```sh
docker pull obynio/kobo-toolchain:crosstools
./compile.sh
```

## Kobo setup

> [!IMPORTANT]  
> This assumes you already have telnet access to the device

Dropbear needs somewhere to go on the system. Since the non-static binary is very light I chose `/usr/local/bin`. The host keys must also be generated with dropbearkey that needs to be compiled separately.

```sh
dropbearkey -t dss -f /etc/dropbear/dropbear_dss_host_key
dropbearkey -t rsa -f /etc/dropbear/dropbear_rsa_host_key
dropbearkey -t ecdsa -f /etc/dropbear/dropbear_ecdsa_host_key
dropbearkey -t ed25119 -f /etc/dropbear/dropbear_ed25519_host_key
```

To start dropbear on boot you need to add the startup script and the corresponding udev rule.

```sh
mkdir /usr/local/dropbear

cp scripts/boot.sh /usr/local/dropbear
chmod +x /usr/local/dropbear/boot.sh

cp script/on-boot.sh /usr/local/dropbear
chmod +x /usr/local/dropbear/on-boot.sh

cp rules/96-dropbear.rules /etc/udev/rules.d
chmod 777 /etc/udev/rules.d/96-dropbear.rules
```

## Improvement ideas

* Add toolchain for dropbearkey
* Add a way to trigger dropbear when wifi is enabled or disabled using udev
* Add continuous integration

## Credits

Many thanks to [ewpratten](https://github.com/ewpratten) for its [original work](https://github.com/Ewpratten/KoboSSH) on the matter.
