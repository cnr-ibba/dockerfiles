# Tensorflow-Jupyterlab

Jupyterlab and Tensorflow with GPU support. Start with:

```bash
docker run --gpus all -it --rm -u $(id -u):$(id -g) -v $(realpath $PWD):/tf/notebooks -p 8888:8888 bunop/tensorflow-jupyterlab:latest
```
