MODEL_PATH="${MODEL_PATH:-default}"
#MODEL_NAME="${MODEL_NAME:-DeepSeek-R1-Distill-Qwen-7B-IQ3_M.gguf}"
MODEL_NAME="Llama-3.1-8B-Ultra-Instruct-IQ2_M.gguf"
SYCL_CACHE_DIR="${SYCL_CACHE_DIR:-${PWD}/.syclcache}"
SYCL_CACHE_PERSISTENT="${SYCL_CACHE_PERSISTENT:-1}"
echo "Using model path: $MODEL_PATH"
echo "Using model name: $MODEL_NAME"
echo "Using sycl cache dir: $SYCL_CACHE_DIR"

ERROR_OCCURRED=0

if [ -e "$MODEL_PATH/$MODEL_NAME" ]; then
	echo "Success: The model path '$MODEL_PATH/$MODEL_NAME' exists."
else
	echo "Error: The model path '$MODEL_PATH/$MODEL_NAME' does not exist."
	ERROR_OCCURRED=1
	FOUND_FILE_PATH=$(cd "$MODEL_PATH" && find -L . -name "$MODEL_NAME" -print -quit 2>/dev/null | head -n 1 || true)
	if [ -z "$FOUND_FILE_PATH" ]; then
		echo "Warning: File '$MODEL_NAME' not found in '$MODEL_PATH' or its subdirectories."
		ERROR_OCCURRED=1 # Set error variable if file is not found
	else
		echo "Success: File found at '$FOUND_FILE_PATH'."
		# The FOUND_FILE_PATH variable is already set by the command substitution above.
		ERROR_OCCURRED=0
		MODEL_NAME=$FOUND_FILE_PATH
	fi
fi

if [ -e "$SYCL_CACHE_DIR" ]; then
	echo "Success: The sycl cache path '$SYCL_CACHE_DIR' exists."
else
	echo "Warning: The sycl cache path '$SYCL_CACHE_DIR' does not exist."
	ERROR_OCCURRED=1 # Set error variable if path does not exist
fi

function interactive_shell() {
	docker run -it --rm --net=host --user root --device /dev/dri \
		--group-add=$(stat -c "%g" /dev/dri/render*) --group-add=video  \
		-v $MODEL_PATH:/llms/models \
		-v $SYCL_CACHE_DIR:/syclcache \
		-e "MODEL=/llms/models/${MODEL_NAME}" \
		-e "SYCL_CACHE_DIR=/syclcache" \
		-e "SYCL_CACHE_PERSISTENT=${SYCL_CACHE_PERSISTENT}" \
		-e "LLAMA_ARG_HOST=0.0.0.0" \
		-e "LLAMA_ARG_PORT=8000" \
		-e "LLAMA_ARG_MODEL=/llms/models/${MODEL_NAME}" \
		--entrypoint /bin/bash \
		llamacpp_portable:v1
	}

function interactive_shell_cpu_only() {
	docker run -it --rm --net=host --user root \
		-v $MODEL_PATH:/llms/models \
		-v $SYCL_CACHE_DIR:/syclcache \
		-e "MODEL=/llms/models/${MODEL_NAME}" \
		-e "LLAMA_ARG_HOST=0.0.0.0" \
		-e "LLAMA_ARG_PORT=8000" \
		-e "LLAMA_ARG_MODEL=/llms/models/${MODEL_NAME}" \
		--entrypoint /bin/bash \
		llamacpp_portable:v1
	}

function llamacpp_server() {
	docker run --rm --net=host --user root --device /dev/dri \
		--group-add=$(stat -c "%g" /dev/dri/render*) --group-add=video  \
		-v $MODEL_PATH:/llms/models \
                -v $SYCL_CACHE_DIR:/syclcache \
                -e "MODEL=/llms/models/${MODEL_NAME}" \
                -e "SYCL_CACHE_DIR=/syclcache" \
                -e "SYCL_CACHE_PERSISTENT=${SYCL_CACHE_PERSISTENT}" \
		-e "LLAMA_ARG_HOST=0.0.0.0" \
		-e "LLAMA_ARG_PORT=8000" \
		-e "LLAMA_ARG_MODEL=/llms/models/${MODEL_NAME}" \
		--entrypoint /home/llamacpp_server/llama-cpp/llama-server llamacpp_portable:v1 
}

if [ "$ERROR_OCCURRED" -eq 0 ]; then
	interactive_shell
#	llamacpp_server
else
	echo "Not running container due to errors."
fi
