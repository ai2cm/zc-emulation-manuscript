TRAIN_IMAGE ?= gcr.io/vcm-ml/fv3fit:zc-manuscript-submission
RUN_IMAGE ?= gcr.io/vcm-ml/prognostic-run:zc-manuscript-submission

DOCKER_ARGS = \
	-v $(shell pwd)/data:/data \
	-v $(shell pwd)/outputs:/outputs \
	-v $(shell pwd)/models:/models \
	-v $(shell pwd)/code:/code \
	-w /code

enter_training:
	docker run $(DOCKER_ARGS) --interactive --tty $(TRAIN_IMAGE) bash

train_%:
	docker run $(DOCKER_ARGS) -w /code $(TRAIN_IMAGE) \
		python3 -m fv3fit.train_microphysics \
			--config-path /code/training/$*.yaml

train_models: train_gscond_classifier train_gscond train_precpd

enter_prognostic:
	docker run $(DOCKER_ARGS) --interactive --tty $(RUN_IMAGE) bash