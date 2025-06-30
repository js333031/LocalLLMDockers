MODEL_PATH="${MODEL_PATH:-default}"
SYCL_CACHE_DIR="${SYCL_CACHE_DIR:-${PWD}/.syclcache}"
SYCL_CACHE_PERSISTENT="${SYCL_CACHE_PERSISTENT:-1}"
echo "Using model path: $MODEL_PATH"
echo "Using sycl cache dir: $SYCL_CACHE_DIR"

ERROR_OCCURRED=0

if [ -e "$MODEL_PATH" ]; then
	echo "Success: The model path '$MODEL_PATH' exists."
else
	echo "Error: The model path '$MODEL_PATH' does not exist."
	ERROR_OCCURRED=1
fi

if [ -e "$SYCL_CACHE_DIR" ]; then
	echo "Success: The sycl cache path '$SYCL_CACHE_DIR' exists."
else
	echo "Warning: The sycl cache path '$SYCL_CACHE_DIR' does not exist."
	ERROR_OCCURRED=1 # Set error variable if path does not exist
fi

function interactive_shell() {
	docker run -it --rm --net=host --user root --device /dev/dri \
		--group-add=$(stat -c "%g" /dev/dri/render*) --group-add=video \
		-v $MODEL_PATH:/llms/models \
		-v $SYCL_CACHE_DIR:/syclcache \
		-e "SYCL_CACHE_DIR=/syclcache" \
		-e "SYCL_CACHE_PERSISTENT=${SYCL_CACHE_PERSISTENT}" \
		--entrypoint /bin/bash ipex_llm_portable:v1
	}

function ollama_server() {
	docker run --rm --net=host --user root --device /dev/dri \
		--group-add=$(stat -c "%g" /dev/dri/render*) --group-add=video  \
		-v $MODEL_PATH:/llms/models \
		-v $SYCL_CACHE_DIR:/syclcache \
		-e "SYCL_CACHE_DIR=/syclcache" \
		-e "SYCL_CACHE_PERSISTENT=${SYCL_CACHE_PERSISTENT}" \
		--entrypoint /home/ollama_ipex_server/ollama/ollama ipex_llm_portable:v1 serve 
}

if [ "$ERROR_OCCURRED" -eq 0 ]; then
	#interactive_shell
	ollama_server
else
	echo "Not running container due to errors."
fi
