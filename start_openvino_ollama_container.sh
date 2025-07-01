MODEL_PATH="${MODEL_PATH:-default}"
SYCL_CACHE_DIR="${SYCL_CACHE_DIR:-${PWD}/.syclcache}"
SYCL_CACHE_PERSISTENT="${SYCL_CACHE_PERSISTENT:-1}"
echo "Using model path: $MODEL_PATH"
echo "Using sycl cache dir: $SYCL_CACHE_DIR"

ERROR_OCCURRED=0

function test1 {
docker run -it --rm \
	--device=/dev/dri \
	-e "HF_TOKEN=${HF_TOKEN}" \
	-e "HF_MODELS_PATH=/llms/models" \
    -v $SYCL_CACHE_DIR:/syclcache \
    -e "SYCL_CACHE_DIR=/syclcache" \
    -e "SYCL_CACHE_PERSISTENT=${SYCL_CACHE_PERSISTENT}" \
	-v $MODEL_PATH:/llms/models \
	--entrypoint /bin/bash \
	ollama_openvino_ubuntu24:v1
}

function test2 {
docker run -it --rm \
    --privileged \
    --shm-size 8G \
    --device=/dev/dri \
    -v /dev/dri:/dev/dri \
    -v $MODEL_PATH:/llms/models \
    -v $SYCL_CACHE_DIR:/syclcache \
    -e "SYCL_CACHE_DIR=/syclcache" \
    -e "SYCL_CACHE_PERSISTENT=${SYCL_CACHE_PERSISTENT}" \
    --name ov-ollama ollama_openvino_ubuntu24:v1
}

function ollama-server {
docker run -it --rm \
    --privileged \
    --shm-size 8G \
    --device=/dev/dri \
    --network=host \
    -v /dev/dri:/dev/dri \
    -v $MODEL_PATH:/llms/models \
    -v $SYCL_CACHE_DIR:/syclcache \
    -e "SYCL_CACHE_DIR=/syclcache" \
    -e "SYCL_CACHE_PERSISTENT=${SYCL_CACHE_PERSISTENT}" \
    --name ov-ollama ollama_openvino_ubuntu24:v1
}

function ollama-client-ov {
docker run -it --rm \
    -v $MODEL_PATH:/llms/models \
    -v $SYCL_CACHE_DIR:/syclcache \
    -e "SYCL_CACHE_DIR=/syclcache" \
    -e "SYCL_CACHE_PERSISTENT=${SYCL_CACHE_PERSISTENT}" \
    --entrypoint /bin/bash \
    --name ov-ollama-client ollama_openvino_ubuntu24:v1
}

function ollama-client-ipex {
docker run -it --rm \
    -v $MODEL_PATH:/llms/models \
    -v $SYCL_CACHE_DIR:/syclcache \
    -e "SYCL_CACHE_DIR=/syclcache" \
    -e "SYCL_CACHE_PERSISTENT=${SYCL_CACHE_PERSISTENT}" \
    --entrypoint /bin/bash \
    --name ov-ollama-client ipex_llm_portable:v1 
}


#ollama-server
ollama-client-ov
#ollama-client-ipex
