# Docker-Real-ESRGAN

CUDA enabled Dockerfile and compose.yaml for local, containerised image enhancement with Real-ESRGAN.

## Upstream

[Real-ESRGAN](https://github.com/xinntao/Real-ESRGAN)

## Usage

1. Clone the repository to a your working directory and change directory into it.

    `$ git clone https://github.com/jonathan-hunter/Docker-Real-ESRGAN.git`

    `$ cd Docker-Real-ESRGAN`

2. Place input image(s) in `./sync/input`.

3. Modify permissions to allow the container write only access to `./sync/output`.

      `$ chmod 753 ./sync/output`

4. Build the docker image, remove any prexisting container, [re]create the 'esrgan' container and run it in the background.

    `# docker-compose up -d --build`

5. Access the 'esrgan' container and open an interactive Bash shell.

    `# docker exec -it esrgan bash`

6. Run the inference [enhancement] on all files in `./sync/input` with `esrgan.sh`. Inference parameters are the upstream defaults and can be modified herein.

    `./esrgan.sh`
