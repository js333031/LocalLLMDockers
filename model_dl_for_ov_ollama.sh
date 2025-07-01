HF_MODELS_PATH=$HOME/models
#model=Llama-3.1-8B-Instruct

repo=microsoft
model=Phi-4-mini-instruct
huggingface-cli download $repo/$model --local-dir $HF_MODELS_PATH/$model

dtype=int8
optimum-cli export openvino --model $HF_MODELS_PATH/$model --task text-generation-with-past --weight-format $dtype --trust-remote-code $HF_MODELS_PATH/$model-ov-$dtype
pushd $HF_MODELS_PATH
tar -cvzf $model-ov-$dtype.tgz $model-ov-$dtype
cat << EOF > Modelfile.$model-ov-$dtype
FROM $model-ov-$dtype.tgz
ModelType "OpenVINO"
InferDevice "GPU"
PARAMETER repeat_penalty 1.0
PARAMETER top_p 1.0
PARAMETER temperature 1.0
EOF
popd
echo "Now use ollama capable system and run: ollama create $model-ov-$dtype:v1 -f Modelfile.$model-ov-$dtype"
