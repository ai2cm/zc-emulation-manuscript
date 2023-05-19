TRAIN_IMAGE ?= gcr.io/vcm-ml/fv3fit:zc-manuscript-submission
RUN_IMAGE ?= gcr.io/vcm-ml/prognostic-run:zc-manuscript-submission

DOCKER_INTERACTIVE_ARGS = \
	--tty \
	--interactive \
	-v $(shell pwd)/data:/data \
	-v $(shell pwd)/outputs:/outputs \
	-v $(shell pwd)/models:/models \
	-v $(shell pwd)/code:/code 

enter_training:
	docker run $(DOCKER_INTERACTIVE_ARGS) -w /code $(TRAIN_IMAGE) bash