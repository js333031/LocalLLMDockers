# LocalLLMDockers
Various docker for local LLM running on A770
git clone https://github.com/intel/ipex-llm.git


docker build -t ipex_llm_portable:v1 -f Dockerfile_portable_ipex .
docker build -t llamacpp_portable:v1 -f Dockerfile_portable_llamacpp .
docker build -t ipex-arc-comfy:latest -f Dockerfile_comfyui .



docker run -d --network=host -v open-webui:/app/backend/data -e OLLAMA_BASE_URL=http://192.168.2.169:11434 --name open-webui-ov1 --restart always ghcr.io/open-webui/open-webui:main
docker run -d --network=host -v open-webui:/app/backend/data -e OLLAMA_BASE_URL=http://192.168.2.169:11434 --name open-webui-ov2 --restart always ghcr.io/open-webui/open-webui:main
docker run -d --network=host -v open-webui:/app/backend/data -e OLLAMA_BASE_URL=http://192.168.2.169:11434 --name open-webui-ov --restart always ghcr.io/open-webui/open-webui:main
docker run -d --network=host -v open-webui:/app/backend/data -e OLLAMA_BASE_URL=http://192.168.2.169:11434 --name open-webui --restart always ghcr.io/open-webui/open-webui:main
docker run -d -p 3000:8080 -e WEBUI_AUTH=False -v open-webui:/app/backend/data --name open-webui ghcr.io/open-webui/open-webui:main
docker run -d -p 3000:8080 -e WEBUI_AUTH=False -v open-webui:/app/backend/data --name open-webui-su ghcr.io/open-webui/open-webui:main
docker run -d -p 3000:8080 -v open-webui:/app/backend/data --name open-webui ghcr.io/open-webui/open-webui:main
docker run -itd            --net=host            --device=/dev/dri            --memory="32G"            --name=$CONTAINER_NAME            --shm-size="16g"            -v $MODEL_PATH:/llm/models            --entrypoint /bin/bash            $DOCKER_IMAGE
docker run -it --rm --device=/dev/dri --entrypoint /bin/bash ollama_openvino_ubuntu24:v1
docker run -it --rm --entrypoint /bin/bash ollama_openvino_ubuntu24:v1
docker run -it --rm   --name comfyui-cu124   --device=/dev/dri --ipc=host   -p 8188:8188   -v "$(pwd)"/storage:/root   -e CLI_ARGS=""   yanwk/comfyui-boot:xpu
docker run -it --rm   --name comfyui-cu124   --gpus all --device=/dev/dri --ipc=host   -p 8188:8188   -v "$(pwd)"/storage:/root   -e CLI_ARGS=""   yanwk/comfyui-boot:xpu
docker run -it --rm   --name comfyui-cu124   --gpus all   -p 8188:8188   -v "$(pwd)"/storage:/root   -e CLI_ARGS=""   yanwk/comfyui-boot:xpu
docker run -it --rm   --name comfyui-cu124   --gpus xpu --device=/dev/dri --ipc=host   -p 8188:8188   -v "$(pwd)"/storage:/root   -e CLI_ARGS=""   yanwk/comfyui-boot:xpu
docker run -it --rm --net=host --user root --device /dev/dri --group-add=$(stat -c "%g" /dev/dri/render*) --group-add=video  --entrypoint /bin/bash ipex_llm_portable:v1
docker run -it --rm --net=host --user root --device /dev/dri --group-add=$(stat -c "%g" /dev/dri/render*) --group-add=video  --entrypoint /bin/bash ollama_openvino_ubuntu24:v1
docker run -it --rm --net=host --user root --device /dev/dri -v $MODEL_PATH:/home/openvino/models --group-add=$(stat -c "%g" /dev/dri/render*) --group-add=video  --entrypoint /bin/bash ollama_openvino_ubuntu24:v1
docker run -it --rm --net=host --user root --device /dev/dri -v $MODEL_PATH:/llm/models --group-add=$(stat -c "%g" /dev/dri/render*) --group-add=video  --entrypoint /bin/bash ipex_llm_portable:v1
docker run -it --rm --net=host --user root --device /dev/dri -v $MODEL_PATH:/llm/models --group-add=$(stat -c "%g" /dev/dri/render*) --group-add=video  --entrypoint /bin/bash ollama_openvino_ubuntu24:v1
docker run -it --rm --net=host --user root --device /dev/dri -v $MODEL_PATH:/llms/models --group-add=$(stat -c "%g" /dev/dri/render*) --group-add=video  --entrypoint /bin/bash ipex_llm_portable:v1
docker run -it --rm --net=host --user root --device /dev/dri -v $MODEL_PATH:/llms/models --group-add=$(stat -c "%g" /dev/dri/render*) --group-add=video  --entrypoint /bin/bash llamacpp_portable:v1
docker run -it --rm --net=host --user root --device /dev/dri -v $MODEL_PATH:/llms/models --group-add=$(stat -c "%g" /dev/dri/render*) --group-add=video  --entrypoint /bin/bash llamacpp_portable:v1
docker run -it --rm --user root --device /dev/dri --entrypoint /bin/bash ollama_openvino_ubuntu24:v1
docker run -it --rm --user root --device /dev/dri --group-add=$(stat -c "%g" /dev/dri/render*) --entrypoint /bin/bash ollama_openvino_ubuntu24:v1
docker run -it --rm --user root --device /dev/dri --group-add=$(stat -c "%g" /dev/dri/render*) --group-add=video  --entrypoint /bin/bash ipex_llm_portable:v1
docker run -it --rm --user root --device /dev/dri --group-add=$(stat -c "%g" /dev/dri/render*) --group-add=video  --entrypoint /bin/bash ipex_llm:v1
docker run -it --rm --user root --device /dev/dri --group-add=$(stat -c "%g" /dev/dri/render*) --group-add=video  --entrypoint /bin/bash ollama_ipex:v1
docker run -it --rm --user root --device /dev/dri --group-add=$(stat -c "%g" /dev/dri/render*) --group-add=video  --entrypoint /bin/bash ollama_openvino_ubuntu24:v1
docker run -it --rm --user root --device /dev/dri --group-add=$(stat -c "%g" /dev/dri/render*) --group-add=video  --entrypoint /bin/bash ollama_openvino_ubuntu24:v1