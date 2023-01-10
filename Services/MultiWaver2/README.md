# MultiWaver2.0 docker image

[MultiWaver2.0](https://github.com/Shuhua-Group/MultiWaver2.0) docker image with *OpenMP* library support. Call this image with

```bash
docker run -ti bunop/multiwaver2:0.1 /bin/bash
```

Or

```bash
docker run -ti bunop/multiwaver2:0.1 MultiWaver2
```

## Call Multiwaver2 with singularity

```bash
singularity pull docker://bunop/multiwaver2:0.1
singularity run multiwaver2_0.1.sif MultiWaver2
```
