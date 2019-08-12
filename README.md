webserver
===

Simple replacement for XAMPP stack using Arch Linux and systemd-nspawn container. There is no easy to use graphical control panel nor installer. Basic Linux, container and systemd knowledge is required.

What's included?
---

* Apache, PHP-FPM and MariaDB are installed and will start on container boot.
* `127.0.0.1`/`localhost` is served from `/srv/.default` directory.
* `<some-string>.localhost` is served from `/srv/<some-string>` directory.
* There is `root` user with empty password.
* Also, there is `user` user with empty password and with enabled `sudo` command.
* PHP-FPM service is ran as `user` user. `/srv` directory is owned by `user` too.
* MariaDB has `root` user with empty password.
* Useful utilities like composer, git, 7zip, wget, bat are included.
* systemd-nspawn security features like private users and private network are disabled for convenience.

How to install this shit?
---

1. Download container image: `sudo machinectl pull-tar https://github.com/TomaszGasior/webserver/releases/latest/download/webserver.tar.xz webserver --verify checksum`. You can change `webserver` name if you want.
2. Enable container settings file: `sudo ln -s /var/lib/machines/webserver.nspawn /etc/systemd/nspawn/`. It's good idea to read it and optionally adjust directory bindings.
3. Run container: `sudo machinectl start webserver`. If are you going to use it often, you may want to start it automatically on system boot: `sudo machinectl enable webserver`.
4. Login into container: `sudo machinectl shell user@webserver`. Of course you can login as `root` but it's not recommended because files created this way will be read-only for PHP-FPM service.
5. If your UID is different than 1000 it might be good idea to change UID of `user` user inside container to match your own UID: `sudo usermod --uid 1001 user; sudo chown user -R /srv /home/user`.

Usage example — WordPress theme development
---

Let's imagine that you have WordPress theme in `~/projects/some-wp-theme` directory and you want to work on it.

1. Login into container: `sudo machinectl shell user@webserver`.
2. Inside the container, create MariaDB database for WordPress: `sudo mysqladmin create wordpress`.
3. Create directory for WordPress in `/srv`: `mkdir /srv/wordpress`. Go to that directory.
4. Download and extract WordPress files: `wget https://wordpress.org/latest.tar.gz; tar -xf latest.tar.gz --strip-components=1`.
5. Go to `http://wordpress.localhost` and install WordPress.
6. Outside of the container, bind your theme directory to container's file system: `sudo machinectl bind webserver ~/projects/some-wp-theme /srv/wordpress/wp-content/themes/some-wp-theme --mkdir`. You may want to consult container settings file to make this binding persistent.
7. Change theme in WordPress administration panel. Now, you can start your work.

How to build it manually?
---

The easiest way is to build this container on Arch Linux or Arch-based distribution but it might be possible also on different Linux distributions. See: [Using pacman from different OS](https://wiki.archlinux.org/index.php?title=Install_from_existing_Linux&oldid=577222#Using_pacman_from_the_host_system).

Keep in mind that it's unlikely that you will create exactly the same tar archive as mine because Arch Linux is rolling release distribution which means that packages version and contents may be different. (Base OS may be changed in the future.)

1. Install required tools: `sudo`, `systemd-nspawn`, `pacman` (Arch Linux package manager), `pacstrap` (included in `arch-install-scripts` package in Arch Linux), `reflector` (mirrors list generator, available in Arch Linux repositories).
2. Run `./build-container.sh` script. Read it to understand how it works, it's short. Generated files will be placed in newly created `build-*` directory.
3. You can import your tar archive using `machinectl import-tar`. Don't forget to copy `*.nspawn` configuration file to `/etc/systemd/nspawn` directory!
